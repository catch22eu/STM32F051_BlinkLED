/* MIT License

Copyright (c) 2017 catch22eu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include "stm32f0xx_hal.h"
#include "stm32f0xx_hal_rcc.h"
#include "stm32f0xx_hal_gpio.h"

#include "stm32f0xx.h"

void delay (int a);

int main(void)
{
	// Enable the GPIO AHB clock
	__HAL_RCC_GPIOB_CLK_ENABLE();
	// which is done low-level by:
    // RCC->AHBENR |= RCC_AHBENR_GPIOBEN;

    // Configure PB12 in output  mode
    GPIOB->MODER |= GPIO_MODER_MODER12_0;

    // Ensure push pull mode selected--default
    GPIOB->OTYPER &= ~GPIO_OTYPER_OT_12;

    //Ensure maximum speed setting (even though it is unnecessary)
    GPIOB->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR12;

    //Ensure all pull up pull down resistors are disabled
    GPIOB->PUPDR &= ~GPIO_PUPDR_PUPDR12;

    while (1)
    {
        // Set PB12
        GPIOB->BSRR = 0x1000;
        delay(500000);
        // Reset PB12
        GPIOB->BRR = 0x1000;
        delay(500000);
    }

    return 0;
}

void delay (int a)
{
    volatile int i,j;

    for (i=0 ; i < a ; i++)
    {
        j++;
    }

    return;
}
