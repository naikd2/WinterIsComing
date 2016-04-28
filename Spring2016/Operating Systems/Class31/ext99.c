
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
#define DATA_SIZE (4096 - 2)

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
  
    int datablock;                  // 4 bytes pointer to block number
    char type;                      // 1 byte
    char name[MAX_FILE_NAME];       // 1023 byte 
} iNode;


typedef struct 
{
    int nextBlock;
    char data[DATA_SIZE];
} file;

// typedef struct // 1025
// {
//     //char name[MAX_FILE_NAME]; // 1023
//     int iNodeNum;             // 2
// } dirNode;

typedef struct 
{
    unsigned char inode;
    unsigned char parent;             //2 bytes 
    unsigned char numberElements; 
    unsigned char nodes[40];      //iNodeNum
} directory;


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

    // int datablock;                  // 4 bytes pointer to block number
    // char type;                      // 1 byte
    // char name[MAX_FILE_NAME];       // 1023 byte 

iNode getInode(int disk, int inode)
{
    iNode i;
    readBlock(disk, inode, rBlock);
    unsigned char msb = rBlock[1];
    unsigned char lsb = rBlock[0];
    char name[MAX_FILE_NAME];
    int c;
    for (c = 0; c < MAX_FILE_NAME; c++)
    {
        name[c] = rBlock[c+5];
    }
    i.datablock = (msb << 8) | lsb;
    i.type = rBlock[4];
    strcpy(i.name, name);
    return i;
}
/*
    TODO: DELETE
*/
int getDataBlock(int disk, int inode)
{
    iNode i;
    readBlock(disk, inode, rBlock);
    unsigned char msb = rBlock[1];
    unsigned char lsb = rBlock[0];
    i.datablock = (msb << 8) | lsb;
   // printf("1.datablock: %d\n",i.datablock);
    return i.datablock;
}

directory parseDirectory(int disk, int dir) 
{   
    // Get Directory Inode Info
    directory d;
    iNode i = getInode(disk, dir);
    int dblock = i.datablock;
    printf("Dblock of directory: %d\n", dblock);
    readBlock(disk, dblock, rBlock);
    char inode = rBlock[0];
    d.inode = inode;
    char parent = rBlock[1];
    d.parent = parent;
    char numberElements = rBlock[2]; 
    d.numberElements = numberElements;
    int c;
    for(c=0;c<40;c++)
    {
        d.nodes[c] = rBlock[c+3];
    }
    return d;
}



int updateDirectory(int disk, int iBlock)
{
    directory d = parseDirectory(disk, currentDir);
    d.nodes[d.numberElements] = iBlock;
    d.numberElements++;



    printf("This is node 0: %hhu\n", d.nodes[0]);
    printf("This is node 1: %hhu\n", d.nodes[1]);
    printf("This is node 2: %hhu\n", d.nodes[2]);
    printf("iNode %d\n", currentDir);
    iNode i = getInode(disk, currentDir);
    printf("Data Block for Update: %d\n", currentDir);
    writeBlock(disk, i.datablock, &d);
    return 0;
}

int createiNode(int disk, char type, void *name)
{
    iNode node; 
    node.type = type;
    node.datablock = pop(BLOCK_STACK);
    strcpy(node.name,name);
    printf("datablock:%d\n",node.datablock);
    int iBlock = pop(INODE_STACK);
    writeBlock(disk, iBlock, &node);
    printf("iBlock:%d\n",iBlock);
    updateDirectory(disk, iBlock);
    return node.datablock; 
}

int createFile(int disk, void *filename)
{
    int datablock = createiNode(disk, FILE, filename);
    char initBuffer[4096] = {0};
    writeBlock(disk, datablock, initBuffer);
    //printf("File Data Location%d\n",datablock );
    return 0;
}



int createFolder(int disk, void *foldername)
{
    int datablock = createiNode(disk, FOLDER, foldername);
    char initBuffer[4096] = {0};
    writeBlock(disk, datablock, initBuffer);
    return 0;
}

int createRoot(int disk, void *name)
{
    // Create iNode For Root
    iNode node;
    //memset(&node, 0, sizeof(node));
    node.type = FOLDER;
    //printf("%s\n",node.name);
    node.datablock = pop(BLOCK_STACK);
    strcpy(node.name,name);
    printf("root Data Block:%d\n",node.datablock);
    int iBlock = ROOT;
    writeBlock(disk, ROOT, &node);
    // Create Data for ROOT
    directory root;
    root.inode = iBlock;
    root.parent = ROOT;
    root.numberElements = 0;
    int i;
    for(i=0;i<40;i++)
    {
        root.nodes[i] = 0;
    }
    writeBlock(disk, node.datablock, &root);
    return iBlock;
}

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

int main()
{
    fBlocks.top = -1;
    fINodes.top = -1;

    int disk = 0;
    char buffer[4096] = "root";

    
    disk = openDisk(DISK_NAME, DISK_SIZE);
    printf("Opening Disk........\n");
    freeBlocks(disk);
    printf("Finding Free iNodes........\n");
    freeINodes(disk);
    printf("Create Root........\n");
    currentDir = createRoot(disk, &buffer);
    printf("Current Directory: %d\n", currentDir);
    parseDirectory(disk, 1);

    printf("Root iBlock: %d\n", currentDir);
    strcpy(buffer,"File 1");
    printf("Create File 1 in Root........\n");
    createFile(disk,buffer);


    strcpy(buffer,"Folder 1");
    printf("Create Folder 1 in Root........\n");
    createFolder(disk,buffer);
    //directory dir = parseDirectory(disk);
    listDirectory(disk);
    changeDirectory(disk, "Folder 1");
    printf("Current Directory: %d\n", currentDir);
    strcpy(buffer,"File 2");
    printf("Create File 2 in Folder........\n");
    createFile(disk,buffer);
    listDirectory(disk);
    int ofile = openFile(disk, "File 2");

    printf("open file: %d\n", ofile);





    close(disk);
    return 0;  
}








