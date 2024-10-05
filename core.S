
.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

// Global memory locations
.global vtable
.global reset_handler

// Vector table
.type vtable, %object
vtable:
	.word _estack
	.word reset_handler
.size vtable, .-vtable

// Reset handler - Called on reset

.type reset_handler, %function
reset_handler:
	// Set the stack pointer to the end of the stack
	// The '_estack' value is defined in our linker script
	LDR		r0, =_estack
	MOV		sp, r0
	
	// Setup dummy values to look at in debugger
	LDR		r7, =0xDEADBEEF
	MOVS	r0, #0

	main_loop:
		// Add 1 to r0
		ADDS	r0, r0, #1
		
		// Loop back
		B		main_loop
	.size reset_handler, .-reset_handler

