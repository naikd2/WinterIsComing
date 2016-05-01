
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


/*
    Inode Structure 
    Contatins: 
        type:           the type (file or folder)
        numberBlocks:   number of datablocks it points to
        blocks:         array of pointers to data blocks
        name:           name of file
*/
typedef struct 
{
    char     type;                          
    char     numberBlocks;               
    int16_t  blocks[MAX_FILE_SIZE];
    char     name[MAX_FILE_NAME];       
} iNode;

/*
    File Structure 
    Contatins: 
        data:           file data
*/

typedef struct 
{
    char data[DATA_SIZE];
} file;

/*
    Directory Structure 
    Contatins: 
        parent:           points to parent's inode
        numberElements:   the number of elements in directory
        nodes:            array of elements' inode
*/

typedef struct 
{
    unsigned char parent;            //2 bytes 
    unsigned char numberElements; 
    unsigned char nodes[4000];        //iNodeNum
} directory;


/*
    Boot Block 
    Contatins: 
        init:               check for disk has been initilized 
        bTop:               stack pointer for data blocks
        iTop:               stack pointer for inode blocks 
        fblock:             stack of free data blocks 
        finode:             stack of free inodes
*/

typedef struct 
{
    char init; 
    int16_t bTop;            
    int16_t iTop; 
    int16_t fblock[900];
    int16_t finode[100];
} boot;

/*
    Stack  
    Contatins: 
        s:              stack elements
        top:            pointer to the top
*/
typedef struct 
{
    int s[NUM_BLOCKS];
    int top;
} stack; 


/* used to store data read */
static char rBlock[4096];
/* holds current inode # of directory */
static int currentDir;

/* free data block stack */
stack fBlocks;
/* free inode block stack */
stack fINodes;

/*
    push
    ----------------------------
    push element on stack

    block: element to push
    Stack: which stack
*/
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
/*
    pop
    ----------------------------
    pop element on stack

    block: element to pop
    Stack: which stack
*/
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


/*
    displayInodeStack
    ----------------------------
    Displays the Free Inodes
*/

void displayInodeStack()
{
    int i;
    printf ("\n The status of the stack is \n");
    for (i = fINodes.top; i >= 50; i--)
    {   
        printf ("i:%d -> ", i);
        printf ("%d\n", fINodes.s[i]);
    }
    
    printf("\n");
}

/*
    bootBlock
    ----------------------------
    reads boot block 
    - updates stacks and stack pointer 
    - if disk is opened for the first time
        it will populate stacks 

    disk: fd of open disk

    returns: if first opened or not
*/
int bootBlock(int disk)
{
    readBlock(disk,0, rBlock);
    unsigned char init = rBlock[0];
    /* Disk has been already initilized */
    if(init == 0xFF)
    {
        printf("booting up disk...........................\n");

        /* this is to get two bytes into a 16bit integer value */
        unsigned char msb;
        unsigned char lsb;
        msb = rBlock[3];
        lsb = rBlock[2];
        printf("rBlock2: %hhu\n", msb);
        printf("rBlock1: %hhu\n", lsb);
        fBlocks.top = (msb << 8) | lsb;
        printf("STACK POINTER DATA: %d\n", fBlocks.top);
        msb = rBlock[5];
        lsb = rBlock[4];
        fINodes.top = (msb << 8) | lsb;
        printf("STACK POINTER - Inode: %d\n", fINodes.top);

        int i;
        int m_idx = 7;
        int l_idx = 6;
        printf("GETTING DATA STACK\n");
        for (i = 0; i < 900; i++)
        {
            msb = rBlock[m_idx];
            lsb = rBlock[l_idx];
            fBlocks.s[i] = (msb << 8) | lsb;
            //printf("BOOTING DATA %d\n", fBlocks.s[i]);
            m_idx = m_idx + 2;
            l_idx = l_idx + 2; 
        }
        printf("GETTING INODE STACK\n");
        for (i = 0; i < 100; i++)
        {   
            msb = rBlock[m_idx];
            lsb = rBlock[l_idx];
            fINodes.s[i] = (msb << 8) | lsb;
            m_idx = m_idx + 2;
            l_idx = l_idx + 2; 
            //printf("BOOTING IndoeBLCOK %d\n", fINodes.s[i]);
        }
        return 0;
    }
    /* Setting up disk for the 1st time */
    else
    {
        printf("initilizing disk...........................\n");
        boot b = {0};
        b.init = 0xFF;
        fBlocks.top = -1;
        fINodes.top = -1;
        b.bTop = fBlocks.top;
        b.iTop = fINodes.top;
        printf("disk initilized...........................\n");
        writeBlock(disk,0,&b);
        return 1;
    }
}

/*
    freeBlocks
    ----------------------------
    populates data stacks of free blocks
    disk: fd of open disk
*/
void freeBlocks(int disk)
{
    int i; 
    char check[4096] = {0};
    for(i = MAX_INODES; i<NUM_BLOCKS; i++)
    {
        readBlock(disk,i,rBlock);
        int Free = strcmp(rBlock,check);
        if(Free == 0)
        {
            push(i,BLOCK_STACK);
        }
    }
}

/*
    freeINodes
    ----------------------------
    populates inode stacks of free blocks
    disk: fd of open disk
*/
void freeINodes(int disk)
{
    int i; 
    char check[4096] = {0};
    for(i = 0; i<MAX_INODES; i++)
    {
        readBlock(disk,i,rBlock);
        int Free = strcmp(rBlock,check);
        if(Free == 0)
        {
            push(i,INODE_STACK);
        }
    }
}


/*
    hibernate
    ----------------------------
    saves the current status of stacks and pointers 
        to the boot block
    and closes the disk
    disk: fd of open disk
*/

void hibernate(int disk)
{
    printf("hibernating disk...........................\n");

    //freeBlocks(disk);
    //freeINodes(disk);

    // int16_t fblock[NUM_BLOCKS];
    // int16_t finode[MAX_INODES];
    int i;
    boot b = {0};
    b.init = 0xFF;
    b.bTop = fBlocks.top;
    b.iTop = fINodes.top;
    printf("CLOSING STACK POINTER DATA: %d\n", fBlocks.top);
    printf("CLOSING STACK POINTER INODE: %d\n", fINodes.top);
    printf("SAVING STACK\n");
    for (i = 0; i < 900; i++)
    {
        b.fblock[i] = fBlocks.s[i];
    }
    for (i = 0; i < 100; i++)
    {
        //printf("stack  %d\n", fINodes.s[i]);
        b.finode[i] = fINodes.s[i];
    }
    printf("disk closed...........................\n");
    writeBlock(disk, 0, &b);
    syncDisk();
    close(disk);
}


/*
    getInode
    ----------------------------
    returns Inode struct for given inode block number 

    disk: fd of open disk
    inode: pointer to inode block

    return: inode structure 
*/

iNode getInode (int disk, int inode)
{
    iNode i = {0};
    unsigned char msb;
    unsigned char lsb;
    char name[MAX_FILE_NAME] = {0};
    int c;
    readBlock(disk, inode, rBlock);
    /* reads data from disk and places into structure for easy use */
    i.type = rBlock[0];
    i.numberBlocks = rBlock[1];
    int m_idx = 3;
    int l_idx = 2;
    for (c = 0; c < MAX_FILE_SIZE; c++)
    {   
        /* this is to get two bytes into a 16bit integer value */
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
    return i;
}


/*
    parseDirectory
    ----------------------------
    returns directory struct for given directory inode number

    disk: fd of open disk
    inode: pointer to inode block

    return: directory structure 
*/

directory parseDirectory(int disk, int dir) 
{   
    // Get Directory Inode Info
    directory d = {0};
    iNode i = getInode(disk, dir);
    // Assuming that Directory will only hold 1 data block
    int dblock = i.blocks[0];
    readBlock(disk, dblock, rBlock);
    /* reads data from disk and places into structure for easy use */
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

/*
    updateDirectory
    ----------------------------
    updates directory when folder or file is created

    disk: fd of open disk
    iBlock: pointer to inode block of new folder or file
*/
void updateDirectory(int disk, int iBlock)
{
    directory d = parseDirectory(disk, currentDir);
    d.nodes[d.numberElements] = iBlock;
    d.numberElements++;
    iNode i = getInode(disk, currentDir);
    printf("Number of Elements in Directory %d\n",d.numberElements);
    writeBlock(disk, i.blocks[0], &d);
    syncDisk();
}

/*
    createiNode
    ----------------------------
    creates an iNode for new file/folder

    disk: fd of open disk
    type: is it a folder or file
    name: name of the new element
    returns: the data block the iNode points to 
*/
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
    syncDisk();
    updateDirectory(disk, iBlock);
    return dBlock; 
}

/*
    createFile
    ----------------------------
    creates a empty File

    disk: fd of open disk
    filename: name of file
*/

void createFile(int disk, void *filename)
{
    int datablock = createiNode(disk, FILE, filename);
    char initBuffer[4096];
    memset(initBuffer, 0x0 , sizeof(initBuffer));
    writeBlock(disk, datablock, initBuffer);
    syncDisk();
    //printf("File Data Location%d\n",datablock );
}

/*
    createFile
    ----------------------------
    creates a folder, links it with the parent folder

    disk: fd of open disk
    filename: name of file
*/

void createFolder(int disk, void *foldername)
{
    int datablock = createiNode(disk, FOLDER, foldername);
    directory d = {0};
    d.parent = currentDir;
    d.numberElements = 0;
    memset(d.nodes, 0x00, sizeof(d.nodes));
    writeBlock(disk, datablock, &d);
    syncDisk();
}

/*
    createRoot
    ----------------------------
    creates a root directory for a fresh disk

    disk: fd of open disk
    name: ROOT 
*/
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
    syncDisk();
    // Create Data for ROOT
    directory root = {0};
    root.parent = ROOT;
    root.numberElements = 0;
    memset(root.nodes, 0x00, sizeof(root.nodes));
    writeBlock(disk, node.blocks[0], &root);
    syncDisk();
    return iBlock;
}

/*
    delete
    ----------------------------
    deletes a file or folder,
    folders need to be empty before deletion 

    disk: fd of open disk
    name: file to be deleted  
*/
int delete(int disk, void *name)
{
    directory d = parseDirectory(disk, currentDir);
    int listings[d.numberElements];
    int c;
    //printf("Number of elements before delete: %d \n", d.numberElements);
    for(c = 0; c < d.numberElements; c++)
    {
        iNode i = getInode(disk, d.nodes[c]);
        if(strcmp(i.name, name) == 0)
            {   
                if(i.type == FOLDER)
                {
                    directory deleteDir = parseDirectory(disk, d.nodes[c]);
                        if(deleteDir.numberElements != 0)
                        {
                            printf("Delete Files/Folders in Directory before Deleting: %d", deleteDir.numberElements);
                            return 0;
                        }
                    printf("Deleting Folder.............\n");
                    printf("Clearing Folder Data Block: %d\n", i.blocks[0]);

                    char initBuffer[4096];
                    memset(initBuffer, 0x0 , sizeof(initBuffer));
                    writeBlock(disk, i.blocks[0], initBuffer);
                    push(i.blocks[0],BLOCK_STACK);
                    printf("Clearing Folder Inode: %d\n", d.nodes[c]);
                    writeBlock(disk, d.nodes[c], initBuffer);
                    push(d.nodes[c],INODE_STACK);
                    syncDisk();
                    int k;
                    /* compacting elements in array after deletion, fill in empty space*/
                    for (int k = c; k < d.numberElements; k++) 
                    {   
                        d.nodes[k]= d.nodes[k+1];
                    }
                    d.numberElements--;
                    iNode Idir = getInode(disk, currentDir);
                    printf("Saving Changes in %s\n", Idir.name);
                    // printf("Saving AFter delete elements in %d\n", d.numberElements);
                    // printf("Saving AFter delete node 0 in %d\n", d.nodes[0]);
                    // printf("Saving AFter delete node 1 in %d\n", d.nodes[1]);
                    // printf("Saving AFter delete node 2 in %d\n", d.nodes[2]);
                    writeBlock(disk, Idir.blocks[0], &d);
                    syncDisk();
                }
                else
                {
                    printf("Deleting File.............\n");
                    int j;
                    char initBuffer[4096];
                    memset(initBuffer, 0x0 , sizeof(initBuffer));

                    for(j=0; j<i.numberBlocks; j++)
                    {
                        printf("Clearing File Data Blocks: %d\n", i.blocks[j]);
                        // We dont have to clear becuase it gets cleared when creating, only push
                        writeBlock(disk, i.blocks[j], initBuffer);
                        push(i.blocks[j],BLOCK_STACK);
                    }    

                    printf("Clearing File Inode: %d\n", d.nodes[c]);
                    writeBlock(disk, d.nodes[c], initBuffer);
                    push(d.nodes[c],INODE_STACK);
                    syncDisk();
                    /* compacting elements in array after deletion, fill in empty space*/
                    int k;
                    for (int k = c; k < d.numberElements; k++) 
                    {   
                        d.nodes[k]= d.nodes[k+1];
                    }
                    d.numberElements--;
                    iNode Idir = getInode(disk, currentDir);
                    printf("Saving Changes in %s\n", Idir.name);
                    // printf("Saving AFter delete elements in %d\n", d.numberElements);
                    // printf("Saving AFter delete node 0 in %d\n", d.nodes[0]);
                    // printf("Saving AFter delete node 1 in %d\n", d.nodes[1]);
                    // printf("Saving AFter delete node 2 in %d\n", d.nodes[2]);
                    writeBlock(disk, Idir.blocks[0], &d);
                    syncDisk();
                }
            }
        }
    return -1;
}

/*
    listDirectory
    ----------------------------
    lists the current directory contents  

    disk: fd of open disk
*/
int listDirectory(int disk)
{
    directory d = parseDirectory(disk, currentDir);
    int listings[d.numberElements];
    int c;
    for (c = 0; c < d.numberElements; c++)
    {
        //printf("List directory Inode--%hhu\n", d.nodes[c]);
        iNode i = getInode(disk, d.nodes[c]);

        if(i.type == FOLDER)
        {
            printf("Inode: %hhu..", d.nodes[c]);
            printf("Folder Name -- %s\n", i.name);
        }
        else
        {
            printf("Inode: %hhu..", d.nodes[c]);
            printf("File Name -- %s\n", i.name);
        }
    }
    return 0;
}


/*
    changeDirectory
    ----------------------------
    change directory, traverse tree 
    use ".." to go back a directory

    disk: fd of open disk
    name: directory to move to
*/
int changeDirectory(int disk, void *name)
{

    directory d = parseDirectory(disk, currentDir);
    if (strcmp("..", name)==0)
    {
        currentDir = d.parent;
        printf("Going Back to Directory: %d\n", currentDir);
        return 1;
    }

    int listings[d.numberElements];
    int c;

    for (c = 0; c < d.numberElements; c++)
    {
        iNode i = getInode(disk, d.nodes[c]);
        if(i.type == FOLDER)
        {
            if(strcmp(i.name, name) == 0)
            {
                
                currentDir = d.nodes[c];
                printf("Going up to Directory: %d\n", currentDir);
                return 1;
            }
        }
        
    }
    printf("Not a Folder\n");
    return -1;
}

/*
    openFile
    ----------------------------
    open a file

    disk: fd of open disk
    name: directory to move to

    return: the file descriptor of open file (iNode number)
*/
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
                printf("opening file: %s\n", i.name);
                return d.nodes[c];
            }
        }
    }
    return 0;
}


/*
    appendFile
    ----------------------------
    util for writeFile function, adds a data block to a file
        - everytime you want to write into a 
        file a new fresh data block is created 
        - max file is 5 blocks
    disk: fd of open disk
    ofile: open file

    return: new data block for file
*/

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

/*
    readFile
    ----------------------------
    reads all the datablocks of a file

    disk: fd of open disk
    ofile: open file
*/
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

/*
    writeFile
    ----------------------------
    write into a file, user input

    disk: fd of open disk
    ofile: open file
*/
void writeFile(int disk, int ofile)
{
    iNode i = getInode(disk,ofile);
    int b = i.numberBlocks;
    int c;
        char buf[4096] = "";
        printf("Write Data: \n");
        scanf("%4096s", buf);
        //printf("Write From Block: %d\n", i.blocks[b-1]);
        writeBlock(disk, i.blocks[b-1], buf);
        syncDisk();

        int dBlock = appendFile(disk, ofile);
    

}

/*
    main
    ----------------------------
    interactive disk program
*/
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

    while(1)
     {
       int i = 0;
       printf("commands:1)ls, 2)cd, 3)vi 4)mk, 5)mkdir, 6)rm 7)close 8)Inode stack\n");
       scanf("%d", &i);
       
       if(i==7)
	       break;

       if(i==1)
	 {
	   listDirectory(disk);
	 }
       else if(i==2)
	 {
	   char buf[1024]= "";
	   printf("Enter Name\n");
	   scanf("%1024s",buf);
	   changeDirectory(disk,buf);
	   
	 }  
        else if(i==3)
     {
       char buf[1024]= "";
       printf("Enter Name\n");
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
	   printf("Enter Name\n");
	   scanf("%1024s",buf);
	   createFile(disk,buf);
	   
	 }     
       else if(i==5)
	 {
	   char buf[1024]= "";
	   printf("Enter Name\n");
	   scanf("%1024s",buf);
	   createFolder(disk,buf);
	   
	 }
        else if(i==6)
     {
       char buf[1024]= "";
       printf("Enter Name\n");
       scanf("%1024s",buf);
       delete(disk,buf);
       
     }
    else if(i==8)
        displayInodeStack();
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








