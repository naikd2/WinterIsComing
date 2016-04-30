
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> 
#include "disk.h"

// MACROS FOR DISK
#define DISK_NAME "DISK_0"
#define NUM_BLOCKS 1000
#define BLOCK_SIZE 4096
#define DISK_SIZE (NUM_BLOCKS * BLOCK_SIZE)

// MACROS FOR iNODE
#define MAX_FILE_NAME 50
#define MAX_INODES 100

// MACROS FOR file
#define DATA_SIZE 4096
#define MAX_FILE_SIZE 10

#define FILE 45
#define FOLDER 54
#define INODE_STACK 76
#define BLOCK_STACK 67

#define ROOT 1
/*
    Class 31: File System
    Kevin Cao and Dhruvit Naik
*/


// single iNode struct
typedef struct 
{
    char     type;                      // 1 byte
    char     numberBlocks;               // 1 bytes pointer to block number
    int16_t  blocks[MAX_FILE_SIZE];
    char     name[MAX_FILE_NAME];       // 1023 byte 
} iNode;

typedef struct 
{
    char data[DATA_SIZE];
} file;

typedef struct 
{
    unsigned char parent;            //2 bytes 
    unsigned char numberElements; 
    unsigned char nodes[4000];        //iNodeNum
} directory;

typedef struct 
{
    char init; 
    int16_t bTop;            
    int16_t iTop; 
} boot;


typedef struct 
{
    int s[NUM_BLOCKS];
    int top;
} stack; 


static char rBlock[4096];
static int currentDir;
static int previousDir;

stack fBlocks;
stack fINodes;

void push(int block, int Stack)
{

    if (Stack == BLOCK_STACK)
    {
        if(fBlocks.top == (NUM_BLOCKS-1))
        {
            // FULL
            perror("Stack Full");
            exit(EXIT_FAILURE); 
        }
        else
        {
            fBlocks.top = fBlocks.top + 1;
            fBlocks.s[fBlocks.top] = block;
        }
    }

    else if(Stack == INODE_STACK)
    {
        if(fINodes.top == (MAX_INODES-1))
        {
            // FULL
            perror("Stack Full");
            exit(EXIT_FAILURE); 
        }
        else
        {
            fINodes.top = fINodes.top + 1;
            fINodes.s[fINodes.top] = block;
        }
    }

    else
    {
        perror("Undefined Stack");
        exit(EXIT_FAILURE);
    }
}

int pop(int Stack)
{
    int block;

    if (Stack == BLOCK_STACK)
    {
        if(fBlocks.top == -1)
        {
            perror("Stack Empty");
            exit(EXIT_FAILURE); 
        }
        else
        {
            block = fBlocks.s[fBlocks.top];
            fBlocks.top = fBlocks.top - 1;
        }
        return block;
    }

    else if(Stack == INODE_STACK)
    {
        if(fINodes.top == -1)
        {
            perror("Stack Empty");
            exit(EXIT_FAILURE); 
        }
        else
        {
            block = fINodes.s[fINodes.top];
            fINodes.top = fINodes.top - 1;
        }
        return block;       
    }

    else
    {
        perror("Undefined Stack");
        exit(EXIT_FAILURE);
    }
}

// Checks the Boot Block to check if initilized, if not it will 
// Gets the stack pointers from the boot block as well

int bootBlock(int disk)
{
    readBlock(disk,0, rBlock);
    unsigned char init = rBlock[0];
    printf("%hhu\n", init);
    if(init == 0xFF)    //Disk has been initilized 
    {
        printf("booting up disk......\n");
        unsigned char msb;
        unsigned char lsb;
        msb = rBlock[3];
        lsb = rBlock[2];
        printf("rBlock2: %hhu\n", msb);
        printf("rBlock1: %hhu\n", lsb);
        fBlocks.top = (msb << 8) | lsb;
        printf("STACK POINTER DATA BLOCKS: %d\n", fBlocks.top);
        msb = rBlock[5];
        lsb = rBlock[4];
        fINodes.top = (msb << 8) | lsb;
        printf("STACK POINTER Inode BLOCKS: %d\n", fINodes.top);
        return 0;
    }
    else
    {
        printf("initilizing disk......\n");
        boot b = {0};
        b.init = 0xFF;
        fBlocks.top = -1;
        fINodes.top = -1;
        b.bTop = fBlocks.top;
        b.iTop = fINodes.top;
        printf("disk initilized......\n");
        writeBlock(disk,0,&b);

        return 1;
    }
}

// Checks all blocks to check if free

void freeBlocks(int disk)
{
    // check all blocks 
    int i; 
    char check[4096] = {0};
    for(i = MAX_INODES; i<NUM_BLOCKS; i++)
    {
        readBlock(disk,i,rBlock);
        int Free = strcmp(rBlock,check);
        if(Free == 0)
        {
            push(i,BLOCK_STACK);
            //printf("Pushed-%d\n",i);
        }
    }
}


void freeINodes(int disk)
{
    // check all blocks 
    int i; 
    char check[4096] = {0};
    for(i = 0; i<MAX_INODES; i++)
    {
        readBlock(disk,i,rBlock);
        int Free = strcmp(rBlock,check);
        if(Free == 0)
        {
            push(i,INODE_STACK);
            //printf("Pushed-%d\n",i);
        }
    }
}


// Closes disk, and saves stack pointers when opened next

void hibernate(int disk)
{
    printf("hibernating disk......\n");

    //freeBlocks(disk);
    //freeINodes(disk);

    boot b = {0};
    b.init = 0xFF;
    b.bTop = fBlocks.top;
    b.iTop = fINodes.top;
            printf("CLOSING STACK POINTER DATA BLOCKS: %d\n", fBlocks.top);
        
        printf("CLosing STACK POINTER Inode BLOCKS: %d\n", fINodes.top);
    writeBlock(disk, 0, &b);
    syncDisk();
    close(disk);
}

/*
    returns Inode struct for given inode block number 
*/

iNode getInode (int disk, int inode)
{
    iNode i = {0};
    unsigned char msb;
    unsigned char lsb;
    char name[MAX_FILE_NAME] = {0};
    int c;
    readBlock(disk, inode, rBlock);

    i.type = rBlock[0];
    i.numberBlocks = rBlock[1];
    int m_idx = 3;
    int l_idx = 2;
    for (c = 0; c < MAX_FILE_SIZE; c++)
    {   
        
        msb = rBlock[m_idx];
        lsb = rBlock[l_idx];
        i.blocks[c] = (msb << 8) | lsb;
        m_idx = m_idx + 2;
        l_idx = l_idx + 2; 
    }

    for (c = 0; c < MAX_FILE_NAME; c++)
    {
        name[c] = rBlock[c+22];
    }
    strcpy(i.name, name);
    // printf("INODE| Name: %s\n",name);
    // printf("INODE| Number of Blocks: %hhu\n",i.numberBlocks);
    // printf("INODE| block-0: %d\n",i.blocks[0]);
    // printf("INODE| block-1: %d\n",i.blocks[1]);
    // printf("INODE| block-2: %d\n",i.blocks[2]);
    // printf("INODE| block-3: %d\n",i.blocks[3]);
    // printf("INODE| block-4: %d\n",i.blocks[4]);
    return i;
}


// returns directory struct for given directory inode number

directory parseDirectory(int disk, int dir) 
{   
    // Get Directory Inode Info
    directory d = {0};
    iNode i = getInode(disk, dir);
    // Assuming that Directory will only hold 1 data block
    int dblock = i.blocks[0];
    readBlock(disk, dblock, rBlock);
    char parent = rBlock[0];
    d.parent = parent;
    char numberElements = rBlock[1]; 
    d.numberElements = numberElements;
    int c;
    for(c=0;c<40;c++)
    {
        d.nodes[c] = rBlock[c+2];
    }
    return d;
}


// updates directory when folder or file is created 

int updateDirectory(int disk, int iBlock)
{
    directory d = parseDirectory(disk, currentDir);
    d.nodes[d.numberElements] = iBlock;
    d.numberElements++;
    iNode i = getInode(disk, currentDir);
    writeBlock(disk, i.blocks[0], &d);
    return 0;
}


// Creates inode when user wants to create a folder or file

int createiNode(int disk, char type, void *name)
{
    iNode node = {0}; 
    node.type = type;
    node.numberBlocks = 1;
    int dBlock = pop(BLOCK_STACK);
    strcpy(node.name,name);
    int iBlock = pop(INODE_STACK);
    memset(node.blocks, 0x0 , sizeof(node.blocks));
    node.blocks[0] = dBlock; 
    writeBlock(disk, iBlock, &node);
    updateDirectory(disk, iBlock);
    return dBlock; 
}

// create a empty file 

int createFile(int disk, void *filename)
{
    int datablock = createiNode(disk, FILE, filename);
    char initBuffer[4096];
    memset(initBuffer, 0x0 , sizeof(initBuffer));
    writeBlock(disk, datablock, initBuffer);
    //printf("File Data Location%d\n",datablock );
    return 0;
}


// create a empty folder
int createFolder(int disk, void *foldername)
{
    int datablock = createiNode(disk, FOLDER, foldername);
    char initBuffer[4096] = {0};
    memset(initBuffer, 0x0 , sizeof(initBuffer));
    writeBlock(disk, datablock, initBuffer);
    return 0;
}


// creates root directory for a fresh disk 
int createRoot(int disk, void *name)
{
    // Create iNode For Root
    iNode node;
    node.type = FOLDER;
    node.numberBlocks = 1;
    int dBlock = pop(BLOCK_STACK);
    memset(node.blocks, 0, sizeof(node.blocks));
    node.blocks[0] = dBlock;
    strcpy(node.name,name);
    int iBlock = ROOT;
    writeBlock(disk, ROOT, &node);
    // Create Data for ROOT
    directory root = {0};
    root.parent = ROOT;
    root.numberElements = 0;
    memset(root.nodes, 0x00, sizeof(root.nodes));
    writeBlock(disk, node.blocks[0], &root);
    return iBlock;
}

// ls

int listDirectory(int disk)
{
    directory d = parseDirectory(disk, currentDir);

    int listings[d.numberElements];
    int c;
    for (c = 0; c < d.numberElements; c++)
    {
        printf("List directory Inode--%hhu\n", d.nodes[c]);
        iNode i = getInode(disk, d.nodes[c]);
        if(i.type == FOLDER)
            printf("List directory Folder Name--%s\n", i.name);
        else
            printf("List directory File Name--%s\n", i.name);
    }

    printf("LISTING Directory\n");
    return 0;
}


// cd
int changeDirectory(int disk, void *name)
{



    directory d = parseDirectory(disk, currentDir);

    int listings[d.numberElements];
    int c;

    for (c = 0; c < d.numberElements; c++)
    {
        iNode i = getInode(disk, d.nodes[c]);
        if(i.type == FOLDER)
        {
            if(strcmp(i.name, name) == 0)
            {
                previousDir = currentDir;
                currentDir = d.nodes[c];
                printf("Match\n");
                return 1;
            }
        }
        
    }
    printf("Not a Folder\n");
    return -1;
}

// open file for reading and writing 

int openFile(int disk, void *name)
{
    directory d = parseDirectory(disk, currentDir);
    int listings[d.numberElements];
    int c;

    for(c = 0; c < d.numberElements; c++)
    {
        iNode i = getInode(disk, d.nodes[c]);
        if(i.type == FILE)
        {
            if(strcmp(i.name, name) == 0)
            {
                printf("Match\n");
                return d.nodes[c];
            }
        }
    }
    return 0;
}



// util for write file 
// everytime you want to write into a file a new fresh data block is created 
// max file is 5 blocks

int appendFile(int disk, int ofile)
{
    iNode i = getInode(disk, ofile);
    int b = i.numberBlocks;
    b++;
    int dBlock = pop(BLOCK_STACK);
    i.blocks[b-1] = dBlock;
    i.numberBlocks = b;
    writeBlock(disk,ofile,&i);
    getInode(disk,ofile);
    return dBlock;
}

// read the file

void readFile(int disk, int ofile)
{
    iNode i = getInode(disk,ofile);
    int b = i.numberBlocks;
    int c;
    printf("Data:");
    for (c = 0; c <(b-1); c++)
        {   
            //printf("Read From Block: %d\n", i.blocks[c]);
            readBlock(disk, i.blocks[c], rBlock);
            printf("%s ",rBlock);
           // readFile();
        }
    printf("\n");
}

// write into file

void writeFile(int disk, int ofile)
{
    iNode i = getInode(disk,ofile);
    int b = i.numberBlocks;
    int c;
    //printf("Write in File Block: %d\n", b);
    // if(b == 1)
    // {
    //     char buf[4096] = "";
    //     printf("Write Data1st: \n");
    //     scanf("%4096s", buf);
    //     writeBlock(disk, i.blocks[0], buf);
    //     b++;
    //     i.numberBlocks = b; 
    //     writeBlock(disk, ofile, &i);
    //     printf("WRITE AND READ INODE--WRITE\n");
    //     getInode(disk,ofile);
    // }
    // else
    // {
    // if(b != 1)
    // {
    //     printf("Data:");
    //     for (c = 0; c <(b-1); c++)
    //     {   
    //         //printf("Read From Block: %d\n", i.blocks[c]);
    //         readBlock(disk, i.blocks[c], rBlock);
    //         printf("%s ",rBlock);
    //        // readFile();
    //     }
    //     printf("\n");
    // }
        char buf[4096] = "";
        printf("Write Data: \n");
        scanf("%4096s", buf);
        //printf("Write From Block: %d\n", i.blocks[b-1]);
        writeBlock(disk, i.blocks[b-1], buf);
        syncDisk();

        int dBlock = appendFile(disk, ofile);
    


    // readBlock(disk, i, rBlock);
    // readData();
    // char buf[4096] = "";
    // scanf("%s",buf);
    // writeBlock(disk, i.datablock, buf);

}

int main()
{


    int disk = 0;
    char buffer[4096] = "root";

    disk = openDisk(DISK_NAME, DISK_SIZE);
    printf("Opening Disk........\n");
    int init = bootBlock(disk);
    if(init == 1)
    {
        freeBlocks(disk);
        freeINodes(disk);
        printf("Create Root........\n");
        currentDir = createRoot(disk, &buffer);
    }
    else
    {
        currentDir = ROOT;
    }
    // getInode(disk, currentDir);
    // char buf[1024]= "File1";
    // createFile(disk,buf);

    // int ofile = openFile(disk, "File1");
    // printf("OFILE: %d\n", ofile);
    // for (int i = 0; i < 3; ++i)
    // {
    //     writeFile(disk, ofile);
    //     // syncDisk();
    // }

    while(1)
     {
       int i = 0;
       printf("commands:1)ls, 2)cd, 3)vi 4)mk, 5)mkdir, 6)close\n");
       scanf("%d", &i);
       
       if(i==6)
	       break;

       if(i==1)
	 {
	   listDirectory(disk);
	 }
       else if(i==2)
	 {
	   char buf[1024]= "";
	   printf("Enter Name");
	   scanf("%1024s",buf);
	   changeDirectory(disk,buf);
	   
	 }  
        else if(i==3)
     {
       char buf[1024]= "";
       printf("Enter Name");
       scanf("%1024s",buf);
       int ofile = openFile(disk, buf);

       while(1)
       {
        int j=0;
        printf("commands:1)write 2)read 3)close\n");
        scanf("%d", &j);
            if(j==3)
                break;
            else if(j==1)
            {
                writeFile(disk, ofile);
            }
            else if(j==2)
            {
                readFile(disk, ofile);
            }
       }
     }  

       else if(i==4)
	 {
	   char buf[1024]= "";
	   printf("Enter Name");
	   scanf("%1024s",buf);
	   createFile(disk,buf);
	   
	 }     
       else if(i==5)
	 {
	   char buf[1024]= "";
	   printf("Enter Name");
	   scanf("%1024s",buf);
	   createFolder(disk,buf);
	   
	 }
        else
        {
            printf("Invalid\n");
            break;
        }

     syncDisk();
    }
   


    hibernate(disk);
    return 0;  
}








