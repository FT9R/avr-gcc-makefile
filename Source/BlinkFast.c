#include "BlinkFast.h"

void BlinkFast(void)
{
    PORTD |= (1 << PD0); // LED on
    _delay_ms(100);
    PORTD &= ~(1 << PD0); // LED off
    _delay_ms(100);
}