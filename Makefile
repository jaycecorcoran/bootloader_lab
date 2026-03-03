# Makefile

# Files
X86_SRC = boot_x86.s
ARM_SRC = boot_arm.s

X86_OBJ = boot_x86.o
ARM_OBJ = boot_arm.o

X86_ELF = boot_x86.elf
ARM_ELF = boot_arm.elf

X86_BIN = i386_image.bin
ARM_BIN = akita_image.bin

# Tools
AS = as
LD = ld
OBJCOPY = objcopy

ARM_AS = arm-none-eabi-as
ARM_LD = arm-none-eabi-ld
ARM_OBJCOPY = arm-none-eabi-objcopy

# Target
all: $(X86_BIN) $(ARM_BIN)

# x86 specific
$(X86_OBJ): $(X86_SRC)
	$(AS) --32 -o $@ $<

$(X86_ELF): $(X86_OBJ)
	$(LD) -m elf_i386 -Ttext 0x7C00 \
	    --oformat elf32-i386 -o $@ $<

$(X86_BIN): $(X86_ELF)
	$(OBJCOPY) -O binary $< $@
	truncate -s 512 $@
	@echo "Built $(X86_BIN)"

# ARM specific
arm.ld:
	echo "ENTRY(_start)" > arm.ld
	echo "SECTIONS {" >> arm.ld
	echo " . = 0x0;" >> arm.ld
	echo " .text : { *(.text*) }" >> arm.ld
	echo "}" >> arm.ld

$(ARM_OBJ): $(ARM_SRC)
	$(ARM_AS) -mcpu=arm7tdmi -o $@ $<

$(ARM_ELF): $(ARM_OBJ) arm.ld
	$(ARM_LD) -T arm.ld -o $@ $(ARM_OBJ)

$(ARM_BIN): $(ARM_ELF)
	$(ARM_OBJCOPY) -O binary $< $@
	@echo "Built $(ARM_BIN)"

clean:
	rm -f *.o *.elf *.bin arm.ld
