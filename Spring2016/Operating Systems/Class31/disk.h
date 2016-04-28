#ifndef DISK_H_   /* Include guard */
#define DISK_H_

int openDisk(char *filename, int nbytes);

int readBlock(int disk, int blocknum, void *block);

int writeBlock(int disk, int blocknum, void *block);

void syncDisk();

#endif // DISK_H_