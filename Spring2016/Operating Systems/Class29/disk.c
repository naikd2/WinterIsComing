
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> 

#define DISK_NAME "DISK_0.txt"
#define DISK_SIZE 40960

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
		perror("read failed");
		exit(EXIT_FAILURE); 
	}	
	/*
		write read results to stdout for debugging 
	*/	
	write(1, block, rd);
	printf("\n");
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
	int disk = 0;
	int rd = 0;
	int wr = 0;

	/*
		Open Disk
	*/	

	disk = openDisk(DISK_NAME, DISK_SIZE);
	
	/*
		Read and Write Sequentially Into Disk 
	*/	
	char buf1[4096] = "BLOCK_ONE";
	printf("writing block...\n");
	wr = writeBlock(disk, 0, buf1);
	printf("reading block...\n");
	rd = readBlock(disk, 0, buf1);
	
	char buf2[4096] = "BLOCK_TWO";
	printf("writing block...\n");
	wr = writeBlock(disk, 1, buf2);
	printf("reading block...\n");
	rd = readBlock(disk, 1, buf2);

	char buf3[4096] = "BLOCK_THREE";
	printf("writing block...\n");
	wr = writeBlock(disk, 2, buf3);
	printf("reading block...\n");
	rd = readBlock(disk, 2, buf3);

	char buf4[4096] = "BLOCK_FOUR";
	printf("writing block...\n");
	wr = writeBlock(disk, 3, buf4);
	printf("reading block...\n");
	rd = readBlock(disk, 3, buf4);

	char buf5[4096] = "BLOCK_FIVE";
	printf("writing block...\n");
	wr = writeBlock(disk, 4, buf5);
	printf("reading block...\n");
	rd = readBlock(disk, 4, buf5);

	char buf6[4096] = "BLOCK_SIX";
	printf("writing block...\n");
	wr = writeBlock(disk, 5, buf6);
	printf("reading block...\n");
	rd = readBlock(disk, 5, buf6);

	/*
		Update Disk with user input
	*/	
	printf("Update Disk\n");	
	while(1)
	{	
		int i = 0;
		char buf[4096];

		printf("1)Write Blocks 1-5:\n");
		printf("2)Read Blocks 1-5:\n");
		printf("6)Exit:\n");
		scanf("%d", &i);

		if (i==6)
			break;


		if (i == 1)
		{
			while(1)
			{
				printf("1-5)Choose what Block to write (1-5):\n");
				printf("6)Back:\n");
				scanf("%d", &i);

				if (i==6)
					break;

				printf("Enter Data to write into Block %d:\n", i);
				scanf("%4096s", buf);
				wr = writeBlock(disk, i-1, buf);
			}
		}

		if (i == 2)
		{
			while(1)
			{
				printf("1-5)Choose what Block to read (1-5):\n");
				printf("6)Back:\n");
				scanf("%d", &i);

				if (i==6)
					break;

				printf("-----Block %d Read", i);
				rd = readBlock(disk, i-1, buf);
			}


		}
		// printf("Enter Data to write into Block %d:\n", i);
		// scanf("%4096s", buf);
		// wr = writeBlock(disk, i-1, buf);
		// printf("-----Block %d Read", i);
		// rd = readBlock(disk, i-1, buf);










	}	

	syncDisk();
	printf("Disk Closed\n");
	close(disk);
    return 0;  
}






