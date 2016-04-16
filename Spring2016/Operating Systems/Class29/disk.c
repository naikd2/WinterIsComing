
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> // for close

#define DISK_NAME "DISK_0.txt"
#define DISK_SIZE 100


// struct block
// {
// 	int nbytes;			// Max Data is 32768
// 	char filename[256]; 
// 	struct block *next; 
// };

// block disk[DISK_SIZE];

int openDisk(char *filename, int nbytes)
{

	int fd = open(filename, O_APPEND | O_CREAT);
	printf("%d\n", fd);

	truncate(filename, nbytes);
	return fd; 

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
	// Init the disk to zero 
    // memset(disk, 0, sizeof(block)); 


	int k = openDisk(DISK_NAME, 200000);
	//printf("SIZE OF DISK: %lu\n", fsize(DISK_NAME) );
	//int k = truncate(DISK_NAME, DISK_SIZE);

    return 0; 
}

