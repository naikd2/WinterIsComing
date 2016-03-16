
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdint.h>


//  3-byte memory references ( 24 bits ) 
//  L = 8 -- number of bytes per line of cache memory ( 64bits ) 
//  offset ( log(8) = 3 )
//  K = 2 -- number of lines per set  
//  N = 32 -- number of sets
//  KN = 64 -- log(64) = 6 

// total bits   = 24
// offset bits  = 3
// line bits    = 6
// tag bits     = 15

#define TRACE_FILE  "TRACE1.DAT"
#define READ        "rb"        // r for read, b for binary

int main()
{	

	unsigned char byte = 232;
	unsigned char mask = 1;
	unsigned char bits[8] ={0};
    unsigned char buffer[180000] = {0};

    //  word is 24 bits but we have to use 32 bit unsigned long 
    //  |8bits| |  8bits | | 8bits | | 8bits |
    //  |empty| |highByte| |midByte| |lowByte|

    unsigned long words[60000] = {0};

    unsigned char highByte = buffer[2];
    unsigned char midByte = buffer[1];
    unsigned char lowByte = buffer[0];

    FILE *fp;
    
    fp = fopen(TRACE_FILE,READ);
    
    if (!fp) {
        perror("Error Opening File");
        return -1;
    }
    
    fread(buffer,sizeof(buffer),1,fp);
   
   // 2 hex equals a byte
   // convert 3 bytes (6 hex) to a word

   int x = 0;
   for (int i = 0; i < 60000; i++ )
   {
        highByte = buffer[x+2];
        midByte = buffer[x+1];
        lowByte = buffer[x];

        words[i] = (highByte << 16) |(midByte << 8) | lowByte ;
        x = x + 3;
   }
   		
   	printf("word: %lu \n", words[0]);
    // 233448 => 0x038FE8
    printf("word: %lu \n", words[1]);
    // 233464 => 0x038FF8
    printf("word: %lu \n", words[2]);
    // 233472 => 0x039000

    return 0;
}














