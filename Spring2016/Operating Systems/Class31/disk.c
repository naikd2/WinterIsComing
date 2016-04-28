#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> 


#include "disk.h"

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
