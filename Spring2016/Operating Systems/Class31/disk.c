
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> 

// MACROS FOR DISK
#define DISK_NAME "DISK_0"
#define NUM_BLOCKS 1000
#define BLOCK_SIZE 4096
#define DISK_SIZE (NUM_BLOCKS * BLOCK_SIZE)

// MACROS FOR iNODE
#define MAX_FILE_NAME 1023
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
	char type; 						// 1 byte
	char name[MAX_FILE_NAME]; 		// 1023 byte 
	int datablock; 					// 2 bytes pointer to block number 
} iNode;

// iList
iNode iList[MAX_INODES];


typedef struct 
{
	int nextBlock;
	char data[DATA_SIZE];
} file;

typedef struct // 1025
{
	//char name[MAX_FILE_NAME]; // 1023
	int iNodeNum;			  // 2
} dirNode;

typedef struct 
{
	int parent; 			//2 bytes 
	int numberElements; 
	dirNode nodes[40];  
} directory;


typedef struct 
{
	int s[NUM_BLOCKS];
	int top;
} stack; 


static char rBlock[4096];
static int currentDir;

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



/*
	openDisk
	----------------------------
	opens or creates a disk with nbytes

	filename: the file to be opened or created
	nbytes: size of disk in bytes

	returns: file descriptor of disk
*/


int openDisk(char *filename, int nbytes)
{
	/*
		open and possible create a file
		returns: a file descriptor 
		filename: the given pathname for a file
		flags: 
			O_CREAT - if file doesn't exist, it will be created
			O_RDWD - read and write access 
	*/
	int fd = open(filename, O_CREAT | O_RDWR );
	if(fd < 0) 
	{
		perror("open failed");
		exit(EXIT_FAILURE); 
	}	
	/*
		given file's size will change to nbytes 
	*/
	int tr = truncate(filename, nbytes);
	if(tr == -1)
	{
		perror("truncate failed");
		exit(EXIT_FAILURE); 		
	}
	return fd; 
}

/*
	readDisk
	----------------------------
	reads a block from disk

	disk: the disk being read
	blocknum: the block being read
	block: buffer being read into

	returns: number of bytes read
*/

int readBlock(int disk, int blocknum, void *block)
{
  	/*
		convert virtual number to logical number 
	*/
	blocknum = blocknum * 4096;
	/*
		data type to represent file size 
	*/
	off_t offset = blocknum;
	/*
		for the given fd, it positions the file offset
		SEEK_SET: set by offset bytes, absolute value
	*/
	off_t lk = lseek(disk, offset, SEEK_SET);
	if(lk == -1)
	{
		perror("seek failed");
		exit(EXIT_FAILURE); 		
	}
	/*
		reads the file represented by the fd
		block: buffer that will be read into 
		4096: read up to 4096 bytes 
	*/
	int rd = read(disk, block, 4096);
	if (rd != 4096)
	{
		printf("%d\n",rd );
		perror("read failed");
		exit(EXIT_FAILURE); 
	}	
	/*
		write read results to stdout for debugging 
	*/	
	//write(1, block, rd);
	//printf("\n");
	return rd; 
}

/*
	writeDisk
	----------------------------
	writes a block from disk

	disk: the disk being writen
	blocknum: the block being writen
	block: buffer being written into disk

	returns: number of bytes written
*/

int writeBlock(int disk, int blocknum, void *block)
{
	/*
		convert virtual number to logical number 
	*/
	blocknum = blocknum * 4096; 
	/*
		data type to represent file size 
	*/
	off_t offset = blocknum; 
	/*
		for the given fd, it positions the file offset
		SEEK_SET: set by offset bytes, absolute value
	*/
	off_t lk = lseek(disk, offset, SEEK_SET);
	if(lk == -1)
	{
		perror("seek failed");
		exit(EXIT_FAILURE); 		
	}	
	/*
		writes to the file represented by the fd
		block: buffer that will be written 
		4096: size of the buffer in bytes
	*/
	int wr = write(disk, block, 4096);
	if (wr != 4096)
	{
		perror("write failed");
		exit(EXIT_FAILURE); 
	}	

	return wr; 
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

int parseBlock(char block[4096])
{


	//printf("%c\n",block[0] );
	return 0;
}

directory parseDirectory(int disk, int dirBlock) 
{
	directory dir;
	readBlock(disk, dirBlock, rBlock);
	int parent = rBlock[0] + rBlock[1];
	dir.parent = parent;
	int numberElements = rBlock[2] + rBlock[3]; 
	dir.numberElements = numberElements;
	return dir;
}



int updateDirectory(int disk, int iBlock)
{
	directory d = parseDirectory(disk, currentDir);

	d.numberElements = d.numberElements + 1; 


	printf("parent: %d\n", d.parent);
	printf("numberElements: %d\n", d.numberElements);
	printf("%s\n",d.nodes[1]);


	// typedef struct 
	// {
	// 	int parent; 			//2 bytes 
	// 	int numberElements; 
	// 	dirNode nodes[40];  
	// } directory;


	return 0;
}

int createiNode(int disk, char type, void *name)
{
	iNode node; 
	//memset(&node, 0, sizeof(node));
	node.type = type;
	strcpy(node.name,name);
	node.datablock = pop(BLOCK_STACK);
	printf("datablock:%d\n",node.datablock);
	int iBlock = pop(INODE_STACK);
	writeBlock(disk, iBlock, &node);
	printf("iStack:%d\n",iBlock);
	updateDirectory(disk, iBlock);
	return node.datablock; 
}

int createFile(int disk, void *filename)
{
	int datablock = createiNode(disk, FILE, filename);
	char initBuffer[4096] = {0};
	writeBlock(disk, datablock, initBuffer);
	printf("File Data Location%d\n",datablock );
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
	strcpy(node.name,name);
	//printf("%s\n",node.name);
	node.datablock = pop(BLOCK_STACK);
	printf("root Data Block:%d\n",node.datablock);
	int iBlock = ROOT;
	writeBlock(disk, ROOT, &node);
	// Create Data for ROOT
	directory root;
	root.parent = ROOT;
	root.numberElements = 0;
	writeBlock(disk, node.datablock, &root);
	return node.datablock;
}
/*
	syncDisk
	----------------------------
	syncs all outstanding writes
*/

void syncDisk()
{
	/*
		Sync is always successful
	*/	
	sync();
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
	strcpy(buffer,"File 1");
	printf("Create File 1 in Root........\n");
	createFile(disk,buffer);
	//directory dir = parseDirectory(disk);

	



	// char buffer[4096] = "hello world";
	// writeBlock(disk, 0, buffer);

	// readBlock
	// read file static 
	// readBlock(disk, 0, rBlock);
	// //parseBlock(rBlock);
	// freeBlocks(disk);
	// char buffer2[1023] = "987654321234567790";
	// createFile(disk, 0, &buffer2);

	// Create i node first then the file 





	close(disk);
    return 0;  
}








