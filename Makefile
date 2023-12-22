PROJ_NAME = Blink
MCU = attiny88 
COMPILER_OPTIONS = -c -Os -Wall
INCLUDES = -I ./Include
SOURCES = $(wildcard ./Source/*.c)
OBJECTS = $(patsubst ./Source/%.c, $(BINARY_PATH)/$(CONFIGURATION)/%.o, $(SOURCES))

CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
AVRSIZE = avr-size
AVRDUDE = avrdude

BINARY_PATH = ./bin
CONFIGURATION = Debug
# CONFIGURATION = Release

all: build

$(BINARY_PATH)/$(CONFIGURATION)/$(PROJ_NAME).elf: $(OBJECTS)
	@echo / 
	@echo - Linking: $^
	$(CC) -o $@ $^ -mmcu=$(MCU)

$(BINARY_PATH)/$(CONFIGURATION)/%.o: Source/%.c
	@echo / 
	@echo - Building file: $^
	$(CC) $(COMPILER_OPTIONS) $(INCLUDES) -o $@ $^
	
flash: build
	@echo / 
	@echo - MCU Programming
	$(AVRDUDE) -pt88 -cUSBASP -b9600 -Uflash:w:$(BINARY_PATH)/$(CONFIGURATION)/$(PROJ_NAME).hex:i

build: clean $(BINARY_PATH)/$(CONFIGURATION)/$(PROJ_NAME).elf
	@echo / 
	@echo - Converting $(PROJ_NAME).elf to $(PROJ_NAME).hex
	$(OBJCOPY) -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures  $(word 2, $^) $(patsubst %.elf, %.hex, $(word 2, $^))

clean:
	@if exist "$(BINARY_PATH)/$(CONFIGURATION)" rmdir /s /q "$(BINARY_PATH)/$(CONFIGURATION)"
	@mkdir "$(BINARY_PATH)/$(CONFIGURATION)"
	
.PHONY: flash build clean