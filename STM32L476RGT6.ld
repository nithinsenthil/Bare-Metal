/* Startup code taken from guide at https://vivonomicon.com/2018/04/20/bare-metal-stm32-programming-part-2-making-it-to-main/ */


/* Program entry point */
ENTRY(Reset_Handler)


/* Define the end of RAM and limit of stack memory */
/* 96Kbytes SRAM1 mapped starting from address 0x2000 0000 */
_estack = 0x20018000;

/* Sets a minimum size for the stack and dynamic memory */
_Min_Leftover_RAM = 0x400;

MEMORY
{
	FLASH ( rx )	: ORIGIN = 0x08000000, LENGTH = 512k
	RAM ( rxw )		: ORIGIN = 0x20000000, LENGTH = 96k
}

SECTIONS {

  /* The vector table goes at the start of flash. */
  .vector_table :
  {
    . = ALIGN(4);
    KEEP (*(.vector_table))
    . = ALIGN(4);
  } >FLASH
  /* The 'text' section contains the main program code. */
  .text :
  {
    . = ALIGN(4);
    *(.text)
    *(.text*)
    . = ALIGN(4);
  } >FLASH
  /* The 'rodata' section contains read-only data,
   * constants, strings, information that won't change. */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)
    *(.rodata*)
    . = ALIGN(4);
  } >FLASH
  /* The 'data' section is space set aside in RAM for
   * things like variables, which can change. */
  _sidata = .;
  .data : AT(_sidata)
  {
    . = ALIGN(4);
    /* Mark start/end locations for the 'data' section. */
    _sdata = .;
    *(.data)
    *(.data*)
    _edata = .;
    . = ALIGN(4);
  } >RAM
  /* The 'bss' section is similar to the 'data' section,
   * but its space is initialized to all 0s at the
   * start of the program. */
  .bss :
  {
    . = ALIGN(4);
    /* Also mark the start/end of the BSS section. */
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } >RAM

  /* Space set aside for the application's heap/stack. */
  /* Used to help avoid errors by adding a buffer region to throw ... */
  /* ...linker errors for "out of memory" rather than undefined... */
  /* ...behavior during runtime */
  .dynamic_allocations :
  {
    . = ALIGN(4);
    _ssystem_ram = .;
    . = . + _Min_Leftover_RAM;
    . = ALIGN(4);
    _esystem_ram = .;
  } >RAM

}
