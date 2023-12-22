#include "BlinkSlow.h"

void BlinkSlow(void)
{
    PORTD |= (1 << PD0); // LED on
    _delay_ms(500);
    PORTD &= ~(1 << PD0); // LED off
    _delay_ms(1000);
}