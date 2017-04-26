/*******************************************************
This program was created by the
CodeWizardAVR V3.10 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 31.03.2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 1,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
flash unsigned char solder_img[128] = { /* 0X00,0X01,0X20,0X00,0X20,0X00, */
0X00,0X00,0X00,0X01,0X00,0X00,0X00,0X0A,0X00,0X00,0X00,0X1C,0X00,0X00,0X00,0X3E,
0X00,0X00,0X00,0X7C,0X00,0X00,0X00,0XF8,0X00,0X00,0X01,0XF0,0X00,0X00,0X03,0XE0,
0X00,0X00,0X07,0XC0,0X00,0X00,0X0F,0X80,0X00,0X00,0X7F,0X00,0X00,0X00,0XBE,0X00,
0X00,0X01,0X7C,0X00,0X00,0X01,0XFC,0X00,0X00,0X01,0XF4,0X00,0X00,0X02,0XE8,0X00,
0X00,0X04,0X70,0X00,0X00,0X08,0X80,0X00,0X00,0X11,0X00,0X00,0X00,0X22,0X00,0X00,
0X00,0X44,0X00,0X00,0X00,0X88,0X00,0X00,0X01,0X10,0X00,0X00,0X02,0X20,0X00,0X00,
0X04,0X40,0X00,0X00,0X08,0X80,0X00,0X00,0X11,0X00,0X00,0X00,0X0A,0X00,0X00,0X00,
0X14,0X00,0X00,0X00,0X20,0X00,0X00,0X00,0X40,0X00,0X00,0X00,0X00,0X00,0X00,0X00,
};
flash unsigned char fan_img[128] = { /* 0X00,0X01,0X20,0X00,0X20,0X00, */
0X00,0X03,0XF0,0X00,0X00,0X07,0XFC,0X00,0X00,0X0F,0XFE,0X00,0X00,0X1F,0XFE,0X00,
0X00,0X1F,0XFE,0X00,0X00,0X1F,0XFE,0X00,0X00,0X1F,0XFC,0X00,0X00,0X1F,0XF8,0X00,
0X00,0X1F,0XF0,0X00,0X3C,0X0F,0XE0,0X00,0X7E,0X0F,0XE0,0X00,0X7F,0X07,0XC1,0XF8,
0XFF,0X84,0X27,0XFC,0XFF,0XE8,0X1F,0XFE,0XFF,0XF1,0X8F,0XFF,0XFF,0XF3,0XCF,0XFF,
0XFF,0XF3,0XCF,0XFF,0XFF,0XF1,0X8F,0XFF,0X7F,0XF8,0X17,0XFF,0X3F,0XE4,0X21,0XFF,
0X1F,0X83,0XE0,0XFE,0X00,0X07,0XF0,0X7E,0X00,0X07,0XF0,0X3C,0X00,0X0F,0XF8,0X00,
0X00,0X1F,0XF8,0X00,0X00,0X3F,0XF8,0X00,0X00,0X7F,0XF8,0X00,0X00,0X7F,0XF8,0X00,
0X00,0X7F,0XF8,0X00,0X00,0X7F,0XF0,0X00,0X00,0X3F,0XE0,0X00,0X00,0X0F,0XC0,0X00,
};


flash unsigned char hotair_img[128] = { /* 0X00,0X01,0X20,0X00,0X20,0X00, */
0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,
0X07,0XF0,0X00,0X00,0X1F,0XFF,0XF0,0X00,0X1F,0XFF,0XFE,0X00,0X38,0X3F,0XFE,0XFE,
0X38,0X3F,0XFE,0X00,0X78,0X3F,0XFE,0XFE,0X78,0X3F,0XFE,0X00,0X38,0X3F,0XFE,0XFE,
0X38,0X3F,0XFE,0X00,0X1F,0XFF,0XF8,0X00,0X1F,0XFF,0XC0,0X00,0X07,0XFE,0X00,0X00,
0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,
0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,
0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X00,0X00,0X00,0X00,
0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,
};

#define solder_TC 6
#define air_TC 7
#define solder_RR 0
#define air_RR 1
#define fan_RR 2
#define solder_but PINC.3
#define air_but  PINC.4
#define air_ger  PINC.5

#include <mega8.h>

#include <delay.h>
#include <stdlib.h>
#include <LPH9157-2.h>
#include <stdio.h>
 

unsigned int read_adc(unsigned char adc_input);

int solder_cur=0;
int air_cur=0;
int solder_set=0;
int air_set=0;
int fan_set=0;

long map(long x, long in_min, long in_max, long out_min, long out_max)
{
  return (((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)/5)*5;
}
void draw_2bit_image(char x, char y, char width, char height,int color,int bg, flash char *img)
{
  char xc,yc,dn=0;
  for(yc=y; yc<(y+height); yc++)
  {  
   for(xc=x; xc<x+width; )
   { 
    if ((img[dn] & 0B10000000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}  
    if ((img[dn] & 0B01000000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);} 
    if ((img[dn] & 0B00100000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}   
    if ((img[dn] & 0B00010000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);} 
    if ((img[dn] & 0B00001000))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}     
    if ((img[dn] & 0B00000100))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);} 
    if ((img[dn] & 0B00000010))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}   
    if ((img[dn] & 0B00000001))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);} 
    dn++;
   }
  }
}
void set_sold_cur_temp(int temp)
{
    char buf[5];
    sprintf( buf,"%i  ",temp);  
    buf[3]=0;
    LCD_Puts(buf,50,10,GREEN,WHITE,3,3);
}

void set_sold_temp(int temp)
{
    char buf[1];
    sprintf( buf,"%i  ",temp );  
    buf[3]=0;
    LCD_Puts(buf,120,10,RED,WHITE,3,3);
}

void set_air_cur_temp(int temp)
{
    char buf[5];
    sprintf( buf,"%i  ",temp );   
    buf[3]=0;
    LCD_Puts(buf,50,50,GREEN,WHITE,3,3);
}

void set_air_temp(int temp)
{
    char buf[5];
    sprintf( buf,"%i  ",temp);  
    buf[3]=0;
    LCD_Puts(buf,120,50,RED,WHITE,3,3);
}
void set_fan(int fan)
{
    char buf[5];
    sprintf( buf,"%i%%  ",fan );
    buf[4]=0; 
    LCD_Puts(buf,50,90,BLACK,WHITE,3,3);
}
void get_all_input(void)
{
    solder_cur= map(read_adc(solder_TC), 0, 750, 0, 480);
    air_cur= map(read_adc(air_TC), 0, 750, 0, 480);
    solder_set= map(read_adc(solder_RR), 0, 1023, 0, 480);
    air_set= map(read_adc(air_RR), 0, 1023, 0, 480);
    fan_set= map(read_adc(fan_RR), 0, 1023, 0, 100);;
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

}

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0,977 kHz
TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Ph. correct PWM top=0x03FF
// OC1A output: Inverted PWM
// OC1B output: Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 2,046 ms
// Output Pulse(s):
// OC1A Period: 2,046 ms Width: 2,046 ms// OC1B Period: 2,046 ms Width: 2,046 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (1<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 4800
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x0C;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 7,813 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts

LCD_init(); 
SetRotation(90);  
LCD_Puts(" LNSOLDER ",0,50,WHITE,BLACK,3,3); 
delay_ms(1000); 
LCD_FillScreen(WHITE);   
  
draw_2bit_image (0,5,32,32,BLUE,WHITE,solder_img);
LCD_DrawLine(0,40,175,40,BLACK);
draw_2bit_image (0,45,32,32,BLUE,WHITE,hotair_img);
LCD_DrawLine(0,80,175,80,BLACK);
draw_2bit_image (2,85,32,32,BLUE,WHITE,fan_img);  
LCD_DrawLine(0,120,175,120,BLACK); 
LCD_Puts("Powered by LnKOx & RadioVetal",0,123,SKY,WHITE,1,1);    
           
set_sold_cur_temp(480); 
set_sold_temp(480);         
            
set_air_cur_temp(480); 
set_air_temp(480);  
 set_fan(5);    
#asm("sei")
while (1)

{
      // Place your code here   
    get_all_input();
    set_fan(fan_set);  
    set_sold_cur_temp(solder_set); 
    set_sold_temp(solder_cur);         
    set_air_cur_temp(air_set); 
    set_air_temp(air_cur); 
    delay_ms(300);
}
}


