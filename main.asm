.nolist
.include "m16def.inc"
.list

.equ fCK = 3686400
.equ BAUD = 4800
.equ UBRR_value = (fCK/(BAUD*16))-1

.cseg
.org 0
    rjmp main

main:
    rcall init_USART

    ldi R16, 0xFF
    out DDRC, R16

    ldi R16, 0x00
    out DDRA, R16

loop:
    rcall USART_receive

    out PORTC, R16

    in R16, PINA

    out PORTC, R16

    rcall USART_send

    rjmp loop

init_USART:
    ldi R16, high(UBRR_value)
    out UBRRH, R16

    ldi R16, low(UBRR_value)
    out UBRRL, R16

    ldi R16, (1<<RXEN)|(1<<TXEN)
    out UCSRB, R16

    ldi R16, (1<<URSEL)|(0<<UCSZ1)|(1<<UPM1)|(1<<UPM0)|(0<<UCSZ0)|(1<<USBS)
    out UCSRC, R16

    ret

USART_send:
    out UDR, R16

sending:
    in R17, UCSRA
    sbrs R17, TXC
    rjmp sending

    ldi R17, (1<<TXC)
    out UCSRA, R17

    ret

USART_receive:
receive_wait:
    in R17, UCSRA
    sbrs R17, RXC
    rjmp receive_wait

    in R16, UDR

    ret
    end:
    rjmp end
