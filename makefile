TARGET = main

# Linker script and chip architecture
LD_SCRIPT = STM32L476RGT6.ld
MCU_SPEC = cortex-m4

# Toolchain definitions (ARM bare metal defaults)
TOOLCHAIN = /opt/homebrew
CC = $(TOOLCHAIN)/bin/arm-none-eabi-gcc
AS = $(TOOLCHAIN)/bin/arm-none-eabi-as
LD = $(TOOLCHAIN)/bin/arm-none-eabi-ld
OC = $(TOOLCHAIN)/bin/arm-none-eabi-objcopy
OD = $(TOOLCHAIN)/bin/arm-none-eabi-objdump
OS = $(TOOLCHAIN)/bin/arm-none-eabi-size

# Assembly directives
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall

# Set error messages to appear on a single line
ASFLAGS += -fmessage-length=0

# C compilation directives
CFLAGS += -mcpu=$(MCU_SPEC)
CFLAGS += -mthumb
CFLAGS += -Wall
CFLAGS += -g

# Set error messages to appear on a single line
CFLAGS += -fmessage-length=0

# Reduces junk when compiling for bare-metal
CFLAGS += --specs=nosys.specs

# Compile with C11
CFLAGS += -std=c11

# Linker directives
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -T$(LSCRIPT)

VECT_TBL = ./startup_stm32l476RG.s
AS_SRC = ./core.s
C_SRC = ./main.c

OBJS =  $(VECT_TBL:.s=.o)
OBJS += $(AS_SRC:.s=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY:	all
all:	$(TARGET).bin


%.o:	%.s
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o:	%.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

$(TARGET).elf:	$(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

$(TARGET).bin:	$(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

.PHONY:	clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf
