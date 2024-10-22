all:	main.elf

main.elf:	core.o
	arm-none-eabi-gcc core.o -mcpu=cortex-m4 -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T linkerScript.ld -o main.elf

core.o:	core.S linkerScript.ld
	arm-none-eabi-gcc -x assembler-with-cpp -c -O0 -mcpu=cortex-m4 -mthumb -Wall core.S -o core.o

clean:
	rm -fv main.elf core.o
