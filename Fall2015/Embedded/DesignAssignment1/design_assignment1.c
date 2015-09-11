/* ========================================
 *
 * Kevin Cao and Dhruvit Naik
 *
 * ========================================
*/

#include <project.h>
#include <stdio.h>
#include <stdint.h>

//Defining macros for the registers NVIC_CPUID_BASE and PRT6_DR
#define NVIC_CPUID_BASE 0xe000ed00
#define PRT6_DR 0x40005160

//Pointer to the register address
uint32_t * regptr = NULL;

//Holds the value of the register
uint32_t reg_val;

//Declaring variables for subfields within the NVIC_CPUID_BASE register
uint32_t implementer; //[31:24]
uint32_t variant; //[23:20]
uint32_t partno; //[15:4]
uint32_t revision; //[3:0]

int main()
{
    CyGlobalIntEnable; /* Enable global interrupts. */

    for(;;){
    //Point to NVIC_CPUID_BASE address
    regptr = (uint32_t *) NVIC_CPUID_BASE; // --- Value: regptr 0xE000ED00 | *regptr 0x412FC231
    // Address of NVIC_CPUID_BASE is stored in regptr
    //Store value found within register address
    reg_val = *regptr;  // -- Value: reg_val 0x412FC231
    //Store revision subfield value
    // LSB of reg_val is stored in revision
    revision = reg_val & 0xF;   // -- Value: revision 0x00000001
    //Store partno subfield value
    // reg_val is shifted 4bits (or a single hex bit) to the right and then the last 3 bits are stored in partno
    partno = (reg_val >> 4) & 0xFFF; // // -- Value: partno 0x00000C23
    //Store variant subfield value
    // reg_val is shifted 16bits (or a four hex bit) to the right and then the last bit is stored in variant
    variant = (reg_val >> 16) & 0xF; // -- Value: variant 0x0000000F
    //Store implementer subfield value
    // reg_val is shifted 24bits (or a 6 hex bit) to the right and then the two bits are stored in variant
    implementer = (reg_val >> 24) & 0xFF; // -- Value: implementer 0x00000041
	
    //Point to PRT6_DR address
    regptr = (uint32_t *) PRT6_DR;  // -- Value: regptr 0x40005160 | *regptr 0x0C0000000
    //Store value found within PRT6_DR register address
    reg_val = *regptr; // -- Value: regval 0x0C0000000
    //Set bits [3:2] of PRT6_DR as 1
    reg_val = reg_val | 0x0000000C; // -- Value: regval 0x0C000000C
    //Store new set bit values within regptr
    *regptr = reg_val; // -- Value: *regval 0x0C0000C0C
    CyDelay(500);
    //Clear bits [3:2] of PRT6_DR. Set bit values as 0
    reg_val = reg_val & 0xFFFFFFF3;  // -- Value: regval 0x0C0000000
    CyDelay(500);
    //Store resetted bit values within regptr
    *regptr = reg_val; // -- Value:  *regptr 0x0C0000000
    }
}
