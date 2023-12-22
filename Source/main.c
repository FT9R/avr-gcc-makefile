#include "main.h"

int main()
{
    DDRD |= (1 << PD0);
    while (1)
    {
        // BlinkFast();
        BlinkSlow();
    }
    return 0;
}