CONFIGURATION = Debug
# CONFIGURATION = Release
BINARY_PATH = ./bin
OBJECTS_PATH = $(BINARY_PATH)/$(CONFIGURATION)
INCLUDES_PATH = ./Include
SOURCES_PATH = ./Source

PROJ_NAME = Blink
MCU = attiny88 
DUDE_CHIP = t88
PROGRAMMER = USBASP
BAUDRATE = 9600
COMPILER_OPTIONS = -c -Os -Wall
INCLUDES = -I $(INCLUDES_PATH)
SOURCES = $(wildcard $(SOURCES_PATH)/*.c)
OBJECTS = $(patsubst $(SOURCES_PATH)/%.c,$(OBJECTS_PATH)/%.o,$(SOURCES))

CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
AVRSIZE = avr-size

$(OBJECTS_PATH)/$(PROJ_NAME).elf: $(OBJECTS)
	@echo / 
	@echo - Linking: $^
	$(CC) -o $@ $^ -mmcu=$(MCU)
	@$(AVRSIZE) $@

$(OBJECTS_PATH)/%.o: $(SOURCES_PATH)/%.c
	@echo / 
	@echo - Building file: $^
	$(CC) $(COMPILER_OPTIONS) $(INCLUDES) -o $@ $^

all: build
	
flash: build
	@echo / 
	@echo - MCU Programming
	avrdude -p$(DUDE_CHIP) -c$(PROGRAMMER) -b$(BAUDRATE) -Uflash:w:$(OBJECTS_PATH)/$(PROJ_NAME).hex:i

build: clean $(OBJECTS_PATH)/$(PROJ_NAME).elf
	@echo / 
	@echo - Converting $(PROJ_NAME).elf to $(PROJ_NAME).hex
	$(OBJCOPY) -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(word 2, $^) $(patsubst %.elf,%.hex,$(word 2, $^))

clean:
	@if exist "$(OBJECTS_PATH)" rmdir /s /q "$(OBJECTS_PATH)"
	@mkdir "$(OBJECTS_PATH)"
	
.PHONY: all flash build clean