
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>

//  3-byte memory references ( 24 bits ) 
//  L = 8 -- number of bytes per line of cache memory ( 64bits ) 
//  offset ( log2(8) = 3 )
//  K = 2 -- number of lines per set  
//  N = 32 -- number of sets
//  

// total bits   = 24
// offset bits  = 3
// line bits    = 5
// tag bits     = 16

#define TRACE_FILE  "TRACE2.DAT"
#define READ        "rb"        // r for read, b for binary
// number of sets (N)
#define SET 16
// number of lines per set (K)
#define LINE 16
// number of offset bits
#define OFFSET 3
// number of line/set bits
#define INDEX (unsigned int)(log(SET) / log(2))
// number of tag bits
#define TAG (24 - INDEX - OFFSET)

// single cache line struct
typedef struct 
{
  unsigned int lastUsed;
	unsigned long tag;
	unsigned char valid; 
} cLine;

// cache "object"
cLine cache[LINE][SET];

int main()
{	
  printf("%d\n", TAG);
	// initilize cache to zero
	memset(cache, 0, sizeof(cLine));
	double hits = 0;
	double misses = 0;
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

    unsigned int indexBits = 0;
    unsigned long tagBits = 0;

    bool replace = false;
    unsigned char lruLine = 0;
    unsigned int lru = 0;

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


    FILE * pFile;
    pFile = fopen ("myfile.txt","w");
	  for (int n=0 ; n<60000 ; n++)
   {


   fprintf(pFile,"Word: %lu\n", words[n]);
   // Get Line/Set Bits


   indexBits = words[n] >> OFFSET;
   indexBits = indexBits & ( (unsigned int)pow(2,INDEX)  - 1 );
   fprintf(pFile,"Index: %u\n", indexBits);

   // Get Tag Bits
   tagBits = words[n] >> (OFFSET + INDEX);
   fprintf(pFile,"Tag: %lu\n", tagBits);

 
   /*
	1. Check Tag value for each Line 
	2. If match and valid then its a hit 
	3. If not check valid bits for open space
	4. FIFO implementation update pointer 
   */

	replace = true;

	for (int l = 0; l < LINE; l++)
	{

		//printf("Checking\n");
		if (cache[l][indexBits].tag == tagBits && cache[l][indexBits].valid == 1)
		{
			fprintf(pFile,"HIT\n");
			hits++;
      cache[l][indexBits].lastUsed = n;
			replace = false; 
			break;
		}
	}
	
	if (replace == true)
	{
		fprintf(pFile,"MISS\n");
		misses++;
    // find lru look through lines --- first get all invalid lines then find lru 
	
    for (int l = 0; l < LINE; l++)
    {
      // find invalid lines to replace
      if (cache[l][indexBits].valid == 0) 
      {
        cache[l][indexBits].tag = tagBits;
        cache[l][indexBits].valid = 1;
        cache[l][indexBits].lastUsed = n;
        fprintf(pFile,"Replace in Line: %u of Set: %u\n", l,indexBits);
        replace = false;
        break;
      }
    }
    if(replace == true)
    {
      lruLine = 0; 
      lru = cache[0][indexBits].lastUsed;
      for (int l = 0; l < LINE; l++)
      {
        //find lowest number  
        fprintf(pFile,"LRU: %d Line: %u\n", cache[l][indexBits].lastUsed, l);
        if( cache[l][indexBits].lastUsed < lru )
        {
          lru = cache[l][indexBits].lastUsed;
          lruLine = l;
          fprintf(pFile,"New LRU: %d replaced %u\n", lru, lruLine);
        }
      }
      cache[lruLine][indexBits].tag = tagBits;
      cache[lruLine][indexBits].valid = 1;
      cache[lruLine][indexBits].lastUsed = n;
      fprintf(pFile,"Replace in Line: %u of Set: %u\n", lruLine,indexBits);
    }

	}

  }
  fclose (pFile);

  printf("Hits: %f\n", hits);
  printf("Misses: %f\n", misses);
  printf("Misses Rate: %f\n", misses/60000);

    return 0;
}








