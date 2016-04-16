
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> // for close

#define DISK_NAME "DISK_0.txt"
#define DISK_SIZE 40960


// struct block
// {
// 	int nbytes;			// Max Data is 32768
// 	char filename[256]; 
// 	struct block *next; 
// };

// block disk[DISK_SIZE];
void syncDisk()
{
	sync();

}
int openDisk(char *filename, int nbytes)
{

	int fd = open(filename, O_CREAT | O_RDWR );
	//printf("%d\n", fd);

	truncate(filename, nbytes);
	return fd; 

}

int writeBlock(int disk, int blocknum, void *block)
{
	//char buffer[10]="vvvvv";
	blocknum = blocknum * 4096; 
	off_t offset = blocknum; 
	lseek(disk, offset, SEEK_SET);
	int wr = write(disk, block, 4096);
	// write(disk, buffer, 10);
	// lseek(disk, 5, SEEK_SET);
	// char buffer2[10] = "aaaaaaaaaa";
	// write(disk, buffer2, 10);
	return wr; 

}

int readBlock(int disk, int blocknum, void *block)
{
	//char buffer[4096] = "";
    int n_char=0;
	char buffer[4096];

        // //Initially n_char is set to 0 -- errno is 0 by default
       

        // //Display a prompt to stdout
        // n_char=write(1, "Enter a word  ", 14);

        // //Use the read system call to obtain 10 characters from stdin
        // n_char=read(0, buffer, 10);
        

        // //If read has failed


        // //Display the characters read
        // n_char=write(1,buffer,n_char);
	blocknum = blocknum * 4096;
	off_t offset = blocknum;
	lseek(disk, offset, SEEK_SET);
	int rd = read(disk, block, 4096);
	write(1, block, rd);
	syncDisk();
	return rd; 

}



unsigned long fsize(char* file)
{
    FILE * f = fopen(file, "r");
    fseek(f, 0, SEEK_END);
    unsigned long len = (unsigned long)ftell(f);
    fclose(f);
    return len;
}

int main()
{
	char buf[4096] = "hello world";
	// void *buf;
	// buf = str;
	// Init the disk to zero 
    // memset(disk, 0, sizeof(block)); 
	int disk = 0;
	disk = openDisk(DISK_NAME, DISK_SIZE);
	printf("SIZE OF DISK: %lu\n", fsize(DISK_NAME));
	//scanf("%127s", buf);
	int wr = writeBlock(disk, 0, buf);

	//printf("%d\n",wr);
	int rd = readBlock(disk, 0, buf);
	//printf("%d\n",rd);
	//syncDisk();

	close(disk);
    return 0; 
}



