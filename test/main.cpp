
#include <avr/io.h>
#include <util/delay.h>

#include <stdint.h>

#include "bitutil.h"

#define LED_PORT     PORTB
#define LED_PORT_DDR DDRB
#define LED_PIN      5

int main()
{
	// set led as output
	SET_BIT(LED_PORT_DDR, LED_PIN);

	// set led off on init
	CLR_BIT(LED_PORT, LED_PIN);

	// blink
	for(;;)
	{
		// toggle led
		TGL_BIT(LED_PORT, LED_PIN);
		_delay_ms(1000);
	}

	return 0;
}
