/*******************************************************
This program was created by the
CodeWizardAVR V3.10 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 28.04.2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#define speed_led0 PORTD.0
#define speed_led1 PORTD.1
#define speed_led2 PORTD.2
#define speed_led3 PORTD.3
#define speed_led4 PORTD.4
#define speed_led5 PORTD.5
#define speed_led6 PORTD.6

#define bat_led1 PORTB.3
#define bat_led2 PORTB.4
#define bat_led3 PORTB.5

#define red_led PORTB.6
#define blue_led PORTB.7

#define rotate_led PORTB.0

#define light PORTC.5

#define brake PORTD.7
#define audio PORTB.2

#define back_run PINC.0
#define run_sens PINC.1
#define beep PINC.3
#define zummer PINC.4

#define gaz 6
#define batt 7
#define max_speed 2

#define rotate_period 80
#define blink_period 8

#define full_batt 14
#define half_batt 12
#define low_batt 11
#define empy_bat 10

#define brake_len 200;

#define out_power OCR1AL

#include <mega8.h>
#include <delay.h>
#include <stdlib.h>


void proces_rotate(void);
void proces_blink(void);
unsigned int read_adc(unsigned char adc_input);
void proces_run(void);
void proces_siren(void);
void proces_button(void);
void set_tone(int freq);
void set_speed_led(char speed);
void check_battery(void);
void all_off(void);
long map(long x, long in_min, long in_max, long out_min, long out_max);// ������ �������
void proces_control_power(void);

char run_mode=0; // 0-stop, 1-run,2-back_run, 3-emergency
char audio_mode=0; // 0-stop, 1-beep, 2-back_run, 3-siren, 4-alarm

char rotate_tmr=0;
char blink_tmr=0,blink_reg=0;
long period=0;

char curent_speed=0,old_speed=0;
int run_wathdog=0;
int brake_tmr=0;

bit old_zummer=1,old_run_sens=1;
bit state_zummer=0,state_beep=0,state_back_run=0;

bit blink_bat=0,battery_empy=0;
char bat_period=0;


const int pitchLow = 300;
const int pitchHigh = 1000;
int pitchStep = 35;
int currentPitch=300;



// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    check_battery();
    if (battery_empy==0)
    {
        proces_rotate();
        proces_blink();
        proces_button();
        proces_run();
        proces_control_power(); 
        if(state_zummer==1) proces_siren();
        if(state_beep==1)set_tone(400);
        if(state_beep==0 && state_zummer==0) period=0; 
        
    } 
         
      
}
// Timer2 overflow interrupt service routine
void check_battery(void)// �������� ������ ������
{
    double cur_bat=1023;
    bat_period++;
    if (bat_period<100)  return; else bat_period=0;
    cur_bat=read_adc(batt);
    cur_bat=cur_bat/68;
    if (cur_bat>full_batt) bat_led1=1; else bat_led1=0;
    if (cur_bat>half_batt) bat_led2=1; else bat_led2=0;
    if (cur_bat>low_batt) bat_led3=1; else bat_led3=0;
    if (cur_bat<empy_bat)
    { 
        all_off();
        battery_empy=1;
       blink_bat=!blink_bat;
       bat_led1=blink_bat;bat_led2=blink_bat;bat_led3=blink_bat;
    }    
    else
    {
        battery_empy=0;
        light=1;
    }
}
void all_off(void)// ��������� ��� ��������
{
speed_led0=0;speed_led1=0;speed_led2=0;speed_led3=0;speed_led4=0;speed_led5=0;speed_led6=0;
red_led=0;blue_led=0;rotate_led=0;
light=0;brake=0;audio=0;period=0;out_power=0;
}
void proces_run(void)
{
    
    char max_spd =map(read_adc(max_speed),0,1023,0,255);
    curent_speed=map(read_adc(gaz),0,1023,0,255);
    if (curent_speed<20)
    {
        curent_speed=0;
        run_mode=0;
        if (brake_tmr>0) brake_tmr--; else brake=0;
    }  
    else
    {
        brake=0;
    }
    if (run_mode==3) {return; curent_speed=0;}
    if (back_run==1) {run_mode=2;max_spd=max_spd/2;} else {run_mode=1;}   
    set_speed_led(curent_speed);
    curent_speed=map(curent_speed,0,255,0,max_spd);
} 
void proces_control_power(void)
{
    if (run_mode==1 || run_mode==2)
    {
      if (out_power<curent_speed) out_power++;
      if (out_power>curent_speed) out_power--;
      if (curent_speed<20) out_power=0;   
    } 
    else
    {
        out_power=0;
        curent_speed=0;
    }  
    if (old_speed>0 && curent_speed==0) {brake=1;brake_tmr=brake_len;} 
    old_speed=curent_speed;
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
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(1<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 31,250 kHz
TCCR0=(1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;


// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 31,250 kHz
// Mode: Ph. correct PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 16,32 ms
// Output Pulse(s):
// OC1A Period: 16,32 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
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
// Clock value: 125,000 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 1,248 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 62,500 kHz
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
#asm("sei")

while (1)
      {

}
}
void proces_button(void) //������� ���������� ������
{
    state_beep=!beep; 
    state_back_run=!back_run;
    if(old_zummer!=zummer)
    {  
        state_zummer=!zummer;
        if(state_zummer==1)
        {
            pitchStep=(rand() % 3)*10 + 5; 
            currentPitch=pitchLow;
        }
    }    
    if(old_run_sens!=run_sens)
    {
        if(run_sens==0) run_wathdog=0;
    }
    old_zummer=zummer;
    old_run_sens=run_sens;
}

void set_speed_led(char speed)// ���� ���� �������� �� ���������� �����                                   
{
    if (speed>40) speed_led0=1; else speed_led0=0;  
    if (speed>70) speed_led1=1; else speed_led1=0;
    if (speed>100) speed_led2=1; else speed_led2=0;
    if (speed>130) speed_led3=1; else speed_led3=0;
    if (speed>160) speed_led4=1; else speed_led4=0;
    if (speed>190) speed_led5=1; else speed_led5=0;
    if (speed>220) speed_led6=1; else speed_led6=0;
}
void proces_rotate(void)// ��������� ������� �� ��������
{
    rotate_tmr++;   
    if (rotate_tmr<rotate_period) return; else rotate_tmr=0;
    rotate_led=!rotate_led;   
}
void proces_blink(void)// ��������� ������� �� �������
{
    blink_tmr++;   
    if (blink_tmr<blink_period) return; else blink_tmr=0;
    blink_reg++; 
     if (blink_reg>12) blink_reg=1;
    if (blink_reg>6)
    {
        red_led=0;
        blue_led=!blue_led;
    }    
    else
    {
        blue_led=0;
        red_led=!red_led;
    }  
    
}

interrupt [TIM2_OVF] void timer2_ovf_isr(void)// ������ ���������� �����
{
    TCNT2=period;     
    if (period==0) {audio=0; return;} 
   audio=!audio; 
}

void set_tone(int freq)//������������ ���� ��������
{
  period =256-(62500/freq) ;
}
void proces_siren(void)// ��������� ������
{
  set_tone(currentPitch);
  currentPitch += pitchStep;
  if(currentPitch >= pitchHigh) {
    pitchStep = -pitchStep;
  }
  else if(currentPitch <= pitchLow) {
     pitchStep = -pitchStep;
  }
}
long map(long x, long in_min, long in_max, long out_min, long out_max)// ������ �������
{
  return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
}