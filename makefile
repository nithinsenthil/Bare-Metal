TARGET = main

# Linker script and chip architecture
LD_SCRIPT	= STM32L476RG.ld
MCU_SPEC	= cortex-m4

# Toolchain definitions (ARM bare metal defaults)
TOOLCHAIN = /opt/homebrew
CC $(TOOLCHAIN)/bin/arm-non-eabi-gcc
AS $(TOOLCHAIN)/bin/arm-non-eabi-as
LD $(TOOLCHAIN)/bin/arm-non-eabi-ld
OC $(TOOLCHAIN)/bin/arm-non-eabi-objcopy
OD $(TOOLCHAIN)/bin/arm-non-eabi-objdump
OS $(TOOLCHAIN)/bin/arm-non-eabi-size

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

# Linker directives
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
LFLAGS += nostdlib
LFLAGS += -lgcc
LFLAGS += -T$(LSCRIPT)

VECT_TBL	= ./startup_stm32l476RG.s
AS_SRC		= ./core.s
C_SRC		= ./main.c

OBJS =  $(VECT_TBL:.S=.o)
OBJS += $(AS_SRC:.S=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY: all
all: $(TARGET).bin

%.o: %.s