#MIT License
#
#Copyright (c) 2017 catch22eu
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

DEVICE      = cortex-m0
PORT        = /dev/ttyUSB0
FILENAME    = main
GCC         = arm-none-eabi-gcc
LD			= arm-none-eabi-ld
OBJCP		= arm-none-eabi-objcopy
AS			= arm-none-eabi-gcc -x assembler-with-cpp
#OPT			= -Wall -Os -std=c99 -nostartfiles -mcpu=$(DEVICE) -mthumb -Wl,-Map,output.map
OPT			= -Wall -Os -std=c99 -specs=nosys.specs -mcpu=$(DEVICE) -mthumb -Wl,-Map,output.map
STM32LIBS	= ../STM32Cube_FW_F0/Drivers

INC			= -I$(STM32LIBS)/STM32F0xx_HAL_Driver/Inc/
INC		   += -I$(STM32LIBS)/CMSIS/Device/ST/STM32F0xx/Include/
INC		   += -I$(STM32LIBS)/CMSIS/Include/
INC        += -I.

DEF			= -DCORE_M0 -DSTM32F051x8

SRC			= $(STM32LIBS)/CMSIS/Device/ST/STM32F0xx/Source/Templates/system_stm32f0xx.c
SRC			+= $(STM32LIBS)/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_gpio.c
SRC			+= $(STM32LIBS)/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_i2c.c
SRC			+= $(STM32LIBS)/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_rcc.c
SRC			+= $(STM32LIBS)/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal.c
SRC			+= $(STM32LIBS)/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_cortex.c
SRC  		+= $(FILENAME).c

#copy all $(SRC) files into $(OBJS) and rename them to .o 
OBJS  		= $(SRC:.c=.o)

ASSRC		= $(STM32LIBS)/CMSIS/Device/ST/STM32F0xx/Source/Templates/gcc/startup_stm32f051x8.s
ASOBJ		= $(ASSRC:.s=.o)

# Define linker script file here
LINKER_SCRIPT = STM32F051C6T6.ld

all: clean $(OBJS) $(ASOBJ) $(FILENAME).elf $(FILENAME).bin upload

$(ASOBJ): $(ASSRC)
	$(AS) -c $(OPT) $(INC) $(DEF) $(ASSRC) -o $(ASOBJ)

%.o: %.c $(ASSRC)
	$(GCC) -c $(OPT) $(INC) $(DEF) $< -o $@
	
%.elf: $(OBJS)
	$(GCC) $(OPT) $(LIBS) -T$(LINKER_SCRIPT) $(OBJS) $(ASOBJ) -o $@

%bin: %elf
	$(OBJCP) -O binary -S $< $@

upload:
#	stm32flash -w $(FILENAME).bin -i -dtr,-rts:dtr,rts,dtr,-rts /dev/ttyUSB0
	stm32flash -w $(FILENAME).bin -g 0x0 -i -dtr,rts,-rts:dtr /dev/ttyUSB0

clean:
	rm -f $(OBJS) $(ASOBJ)

