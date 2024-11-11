#include "main.h"


int main() {

    // Peripheral init
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN; // GPIO A
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOCEN; // GPIO C

    // Configure LED
    GPIOA->MODER &= ~(0x3 << LED_PIN*2);
    GPIOA->MODER |= (0x1 << LED_PIN*2);
    GPIOA->OTYPER &= ~(0x1 << LED_PIN);

    // Configure Button
    GPIOC->MODER &= ~(0x3 << BUTTON_PIN*2);
    GPIOC->PUPDR &= ~(0x3 << BUTTON_PIN*2);
    GPIOC->PUPDR |= (0x1 << BUTTON_PIN*2);

    // GPIOA->ODR |= (0x1 << LED_PIN);

    uint32_t button_idr = 0;
    uint8_t button_down = 0;
    while (1) {

        // Store inverted button IDR to make button press appear as 1
        button_idr = ~GPIOC->IDR;
        if (button_idr & (0x1 << BUTTON_PIN)) {
            if (!button_down) {
                // Toggle LED
                GPIOA->ODR ^= (0x1 << LED_PIN);

                // Store button state
                button_down = 1;
            }
        } else {
            // Button is not pressed
            button_down = 0;
        }


    }
}
