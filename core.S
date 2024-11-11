
.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

// Global memory locations
.global Reset_Handler

// Reset handler - Called on reset
.type Reset_Handler, %function
Reset_Handler:
	// Set the stack pointer to the end of the stack
	// The '_estack' value is defined in our linker script
	LDR		r0, =_estack
	MOV		sp, r0

	// Copy data from flash to RAM data init section.
    // R2 will store our progress along the sidata section.

    MOVS r0, #0		// Initialize base address offset
    
	// Load the start/end addresses of the data section,
    // and the start of the data init section.

    LDR  r1, =_sdata		// Load data start address
    LDR  r2, =_edata		// Load data start address
    LDR  r3, =_sidata		// Load init data section in flash
    B    copy_sidata_loop	// Start loop

    copy_sidata:
      LDR  r4, [r3, r0]		// Offset the data init section by our copy progress
      STR  r4, [r1, r0]		// Copy the current word into data (RAM)
      ADDS r0, r0, #4		// Increment offset
    
	copy_sidata_loop:
      // Unless we've copied the whole data section, copy the
      // next word from sidata->data.
      ADDS r4, r0, r1		// Retrieve next RAM address
      CMP  r4, r2			// Check next if reached _edata
      BCC  copy_sidata		// If not done branch to copy logic
    
	// Once we are done copying the data section into RAM,
    // move on to filling the BSS section with 0s.
    MOVS r0, #0				// Initialize base address offset
    LDR  r1, =_sbss			// Load bss start address
    LDR  r2, =_ebss			// Load bss end address
    B    reset_bss_loop		// Start loop
    
    reset_bss:
      STR  r0, [r1]			// Store 0 at address
      ADDS r1, r1, #4		// Increment to next address
    reset_bss_loop:
      CMP  r1, r2			// Check if reached the end of bss data
      BCC  reset_bss		// If not done branch to zero out logic


	// Branch to main (program entry)
	B main
	
	.size Reset_Handler, .-Reset_Handler

