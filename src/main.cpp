
#include <avr/io.h>
#include <util/delay.h>

#include <stdint.h>

#include "bitutil.h"

#define LED_PORT     PORTB
#define LED_PORT_DDR DDRB
#define LED_PIN      5

template<int PERPH_ADDR, int PIN>
class PinRef
{
public:
	static void set()
	{
		*((volatile uint8_t * const) PERPH_ADDR) |= (BV(PIN));
	}

	static void clear()
	{
		*((volatile uint8_t * const) PERPH_ADDR) &= ~(BV(PIN));
	}

	static void toggle()
	{
		*((volatile uint8_t * const) PERPH_ADDR) ^= (BV(PIN));
	}
};

typedef PinRef<PORTB_ADDR, LED_PIN> led;

int main()
{
	// set led as output
	SET_BIT(LED_PORT_DDR, LED_PIN);

	// set led off on init
//	CLR_BIT(LED_PORT, LED_PIN);

	// blink
	for(;;)
	{
		// toggle led
	//	TGL_BIT(LED_PORT, LED_PIN);
		led::toggle();
		_delay_ms(1000);
	}

	return 0;
}
