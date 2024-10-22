
/* Define the end of RAM and limit of stack memory */
/* 96Kbytes SRAM1 mapped starting from address 0x2000 0000 */
_estack = 0x20001000;

MEMORY
{
	FLASH ( rx )	: ORIGIN = 0x08000000, LENGTH = 512k
	RAM ( rxw )		: ORIGIN = 0x20000000, LENGTH = 96k
}

