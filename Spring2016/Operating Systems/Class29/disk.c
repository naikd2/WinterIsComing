
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> 

#define DISK_NAME "DISK_0.txt"
#define DISK_SIZE 40960


void syncDisk()
{
	sync();

}

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
	if(fd < 0) return 0; 
	/*
		given file's size will change to nbytes 
	*/
	truncate(filename, nbytes);

	return fd; 

}

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
	lseek(disk, offset, SEEK_SET);
	/*
		writes to the file represented by the fd
		block: buffer that will be written 
		4096: size of the buffer in bytes
	*/
	int wr = write(disk, block, 4096);
	return wr; 

}

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
	lseek(disk, offset, SEEK_SET);
	/*
		reads the file represented by the fd
		block: buffer that will be read into 
		4096: read up to 4096 bytes 
	*/
	int rd = read(disk, block, 4096);
	/*
		write read results to stdout for debugging 
	*/	
	write(1, block, rd);
	printf("\n");
	return rd; 

}



int main()
{


	int disk = 0;
	int rd = 0;
	int wr = 0;
	disk = openDisk(DISK_NAME, DISK_SIZE);
	

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
	char buf[4096];
	printf("Enter Data to write into BLOCK FOUR:\n");
	scanf("%4096s", buf);
	wr = writeBlock(disk, 3, buf);
	rd = readBlock(disk, 3, buf);


	syncDisk();
	close(disk);

    return 0; 
}






