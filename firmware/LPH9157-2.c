//********************Библиотека дисплея Siemens C75, МЕ75*******************
//           	  	Зеленый текстолит LPH9157-2
//             		     132х176 пикселей
//                   		  v 1.1
//                  Copyright (c) Кизим Игорь aka Igoryosha
//			  Website : lobotryasy.net 
//***************************************************************************

#include <delay.h>

//*************************************************************
//Команда/Данные
#define CMD 0
#define DAT 1
char RS_old;
//*************************************************************

/* С помощью этой таблицы пиксели выводить сверху-вниз, слево-направо. 
Шрифт - 5х8 пикселей, разложен по кодам ASCII. 
Символы с кодами 0-31 и 128 - 191 отсутствуют за ненадобностью! */

flash unsigned char font_5x8[][5]  = {
0x00, 0x00, 0x00, 0x00, 0x00,// (space)  32
0x00, 0x00, 0x5F, 0x00, 0x00,// !        33
0x00, 0x07, 0x00, 0x07, 0x00,// "        34
0x14, 0x7F, 0x14, 0x7F, 0x14,// #        35
0x24, 0x2A, 0x7F, 0x2A, 0x12,// $        36
0x23, 0x13, 0x08, 0x64, 0x62,// %        37
0x36, 0x49, 0x55, 0x22, 0x50,// &        38
0x00, 0x05, 0x03, 0x00, 0x00,// '        39
0x00, 0x1C, 0x22, 0x41, 0x00,// (        40
0x00, 0x41, 0x22, 0x1C, 0x00,// )        41
0x08, 0x2A, 0x1C, 0x2A, 0x08,// *        42
0x08, 0x08, 0x3E, 0x08, 0x08,// +        43
0x00, 0x50, 0x30, 0x00, 0x00,// ,        44
0x08, 0x08, 0x08, 0x08, 0x08,// -        45
0x00, 0x30, 0x30, 0x00, 0x00,// .        46
0x20, 0x10, 0x08, 0x04, 0x02,// /        47
0x3E, 0x51, 0x49, 0x45, 0x3E,// 0        48
0x00, 0x42, 0x7F, 0x40, 0x00,// 1        49
0x42, 0x61, 0x51, 0x49, 0x46,// 2        50
0x21, 0x41, 0x45, 0x4B, 0x31,// 3        51
0x18, 0x14, 0x12, 0x7F, 0x10,// 4        52
0x27, 0x45, 0x45, 0x45, 0x39,// 5        53
0x3C, 0x4A, 0x49, 0x49, 0x30,// 6        54
0x01, 0x71, 0x09, 0x05, 0x03,// 7        55
0x36, 0x49, 0x49, 0x49, 0x36,// 8        56
0x06, 0x49, 0x49, 0x29, 0x1E,// 9        57
0x00, 0x36, 0x36, 0x00, 0x00,// :        58
0x00, 0x56, 0x36, 0x00, 0x00,// ;        59
0x00, 0x08, 0x14, 0x22, 0x41,// <        60
0x14, 0x14, 0x14, 0x14, 0x14,// =        61
0x41, 0x22, 0x14, 0x08, 0x00,// >        62
0x02, 0x01, 0x51, 0x09, 0x06,// ?        63
0x32, 0x49, 0x79, 0x41, 0x3E,// @        64
0x7E, 0x11, 0x11, 0x11, 0x7E,// A        65
0x7F, 0x49, 0x49, 0x49, 0x36,// B        66
0x3E, 0x41, 0x41, 0x41, 0x22,// C        67
0x7F, 0x41, 0x41, 0x22, 0x1C,// D        68
0x7F, 0x49, 0x49, 0x49, 0x41,// E        69
0x7F, 0x09, 0x09, 0x01, 0x01,// F        70
0x3E, 0x41, 0x41, 0x51, 0x32,// G        71
0x7F, 0x08, 0x08, 0x08, 0x7F,// H        72
0x00, 0x41, 0x7F, 0x41, 0x00,// I        73
0x20, 0x40, 0x41, 0x3F, 0x01,// J        74
0x7F, 0x08, 0x14, 0x22, 0x41,// K        75
0x7F, 0x40, 0x40, 0x40, 0x40,// L        76
0x7F, 0x02, 0x04, 0x02, 0x7F,// M        77
0x7F, 0x04, 0x08, 0x10, 0x7F,// N        78
0x3E, 0x41, 0x41, 0x41, 0x3E,// O        79
0x7F, 0x09, 0x09, 0x09, 0x06,// P        80
0x3E, 0x41, 0x51, 0x21, 0x5E,// Q        81
0x7F, 0x09, 0x19, 0x29, 0x46,// R        82
0x46, 0x49, 0x49, 0x49, 0x31,// S        83
0x01, 0x01, 0x7F, 0x01, 0x01,// T        84
0x3F, 0x40, 0x40, 0x40, 0x3F,// U        85
0x1F, 0x20, 0x40, 0x20, 0x1F,// V        86
0x7F, 0x20, 0x18, 0x20, 0x7F,// W        87
0x63, 0x14, 0x08, 0x14, 0x63,// X        88
0x03, 0x04, 0x78, 0x04, 0x03,// Y        89
0x61, 0x51, 0x49, 0x45, 0x43,// Z        90
0x00, 0x00, 0x7F, 0x41, 0x41,// [        91
0x02, 0x04, 0x08, 0x10, 0x20,// "\"      92
0x41, 0x41, 0x7F, 0x00, 0x00,// ]        93
0x04, 0x02, 0x01, 0x02, 0x04,// ^        94
0x40, 0x40, 0x40, 0x40, 0x40,// _        95
0x00, 0x01, 0x02, 0x04, 0x00,// `        96
0x20, 0x54, 0x54, 0x54, 0x78,// a        97
0x7F, 0x48, 0x44, 0x44, 0x38,// b        98
0x38, 0x44, 0x44, 0x44, 0x20,// c        99
0x38, 0x44, 0x44, 0x48, 0x7F,// d        100
0x38, 0x54, 0x54, 0x54, 0x18,// e        101
0x08, 0x7E, 0x09, 0x01, 0x02,// f        102
0x08, 0x14, 0x54, 0x54, 0x3C,// g        103
0x7F, 0x08, 0x04, 0x04, 0x78,// h        104
0x00, 0x44, 0x7D, 0x40, 0x00,// i        105
0x20, 0x40, 0x44, 0x3D, 0x00,// j        106
0x00, 0x7F, 0x10, 0x28, 0x44,// k        107
0x00, 0x41, 0x7F, 0x40, 0x00,// l        108
0x7C, 0x04, 0x18, 0x04, 0x78,// m        109
0x7C, 0x08, 0x04, 0x04, 0x78,// n        110
0x38, 0x44, 0x44, 0x44, 0x38,// o        111
0x7C, 0x14, 0x14, 0x14, 0x08,// p        112
0x08, 0x14, 0x14, 0x18, 0x7C,// q        113
0x7C, 0x08, 0x04, 0x04, 0x08,// r        114
0x48, 0x54, 0x54, 0x54, 0x20,// s        115
0x04, 0x3F, 0x44, 0x40, 0x20,// t        116
0x3C, 0x40, 0x40, 0x20, 0x7C,// u        117
0x1C, 0x20, 0x40, 0x20, 0x1C,// v        118
0x3C, 0x40, 0x30, 0x40, 0x3C,// w        119
0x44, 0x28, 0x10, 0x28, 0x44,// x        120
0x0C, 0x50, 0x50, 0x50, 0x3C,// y        121
0x44, 0x64, 0x54, 0x4C, 0x44,// z        122
0x00, 0x08, 0x36, 0x41, 0x00,// {        123
0x00, 0x00, 0x7F, 0x00, 0x00,// |        124
0x00, 0x41, 0x36, 0x08, 0x00,// }        125
0x00, 0x00, 0x00, 0x00, 0x00,// (space)  126
0x00, 0x00, 0x00, 0x00, 0x00,// (space)  127
0x7E, 0x11, 0x11, 0x11, 0x7E,// A        192
0x7F, 0x45, 0x45, 0x45, 0x39,// Б        193
0x7F, 0x49, 0x49, 0x49, 0x36,// B        194
0x7F, 0x01, 0x01, 0x01, 0x03,// Г        195
0xC0, 0x7E, 0x41, 0x7F, 0xC0,// Д        196
0x7F, 0x49, 0x49, 0x49, 0x41,// E        197
119,8,127,8,119,             // Ж        198
34,73,73,73,54,              // З        199
127,32,16,8,127,             // И        200
127,32,19,8,127,             // Й        201
0x7F, 0x08, 0x14, 0x22, 0x41,// K        202
64,62,1,1,127,               // Л        203
0x7F, 0x02, 0x04, 0x02, 0x7F,// M        204
0x7F, 0x08, 0x08, 0x08, 0x7F,// H        205
0x3E, 0x41, 0x41, 0x41, 0x3E,// O        206
127,1,1,1,127,               // П        207
0x7F, 0x09, 0x09, 0x09, 0x06,// P        208
0x3E, 0x41, 0x41, 0x41, 0x22,// C        209
0x01, 0x01, 0x7F, 0x01, 0x01,// T        210
39,72,72,72,63,              // У        211
30,33,127,33,30,             // Ф        212
0x63, 0x14, 0x08, 0x14, 0x63,// X        213
127,64,64,127,192,           // Ц        214
15,16,16,16,127,             // Ч        215
127,64,124,64,127,           // Ш        216
127,64,124,64,255,           // Щ        217
1,127,72,72,48,              // Ъ        218
127,72,48,0,127,             // Ы        219
127,72,72,72,48,             // Ь        220
34,73,73,73,62,              // Э        221
127,8,62,65,62,              // Ю        222
118,9,9,9,127,               // Я        223
0x20, 0x54, 0x54, 0x54, 0x78,// a        224
124, 84, 84, 84, 36,         // б        225
124, 84, 84, 84, 40,         // в        226
124, 4, 4, 4, 12,            // г        227
192, 120, 68, 124, 192,      // д        228
0x38, 0x54, 0x54, 0x54, 0x18,// e        229
108, 16, 124, 16, 108,       // ж        230
40, 68, 84, 84, 40,          // з        231
124, 32, 16, 8, 124,         // и        232
124, 33, 18, 8, 124,         // й        233
124, 16, 16, 40, 68,         // к        234
64, 56, 4, 4, 124,           // л        235
124, 8, 16, 8, 124,          // м        236
124, 16, 16, 16, 124,        // н        237
0x38, 0x44, 0x44, 0x44, 0x38,// o        238
124, 4, 4, 4, 124,           // п        239
0x7C, 0x14, 0x14, 0x14, 0x08,// p        240
0x38, 0x44, 0x44, 0x44, 0x20,// c        241
4, 4, 124, 4, 4,             // т        242
0x0C, 0x50, 0x50, 0x50, 0x3C,// y        243
24, 36, 124, 36, 24,         // ф        244
0x44, 0x28, 0x10, 0x28, 0x44,// x        245
124, 64, 64, 124, 192,       // ц        246
12, 16, 16, 16, 124,         // ч        247
124, 64, 120, 64, 124,       // ш        248
124, 64, 120, 64, 252,       // щ        249
124, 84, 80, 80, 32,         // ъ        250
124,80,32,0,124,             // ы        251
124, 80, 80, 80, 32,         // ь        252
40, 68, 84, 84, 56,          // э        253
124, 16, 56, 68, 56,         // ю        254
72, 52, 20, 20, 124          // я        255
};

#ifdef _USE_SOFT_SPI
//===============================================================
//			        Программный SPI
//===============================================================
void Send_spi(unsigned char data)
{ 

    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 128) == 128)   SetBit(LCD_PORT, LCD_DATA); 
    SetBit(LCD_PORT, LCD_CLK);
    ClearBit(LCD_PORT, LCD_CLK);  
    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 64) == 64) SetBit(LCD_PORT, LCD_DATA); 
    SetBit(LCD_PORT, LCD_CLK);  
    ClearBit(LCD_PORT, LCD_CLK);
    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 32) == 32) SetBit(LCD_PORT, LCD_DATA); 
    SetBit(LCD_PORT, LCD_CLK);  
    ClearBit(LCD_PORT, LCD_CLK); 
    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 16) ==16)  SetBit(LCD_PORT, LCD_DATA);
    SetBit(LCD_PORT, LCD_CLK);   
    ClearBit(LCD_PORT, LCD_CLK);
    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 8) == 8)   SetBit(LCD_PORT, LCD_DATA);
    SetBit(LCD_PORT, LCD_CLK);    
    ClearBit(LCD_PORT, LCD_CLK);   
    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 4) == 4)   SetBit(LCD_PORT, LCD_DATA);
    SetBit(LCD_PORT, LCD_CLK);  
    ClearBit(LCD_PORT, LCD_CLK); 
    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 2) == 2)   SetBit(LCD_PORT, LCD_DATA);
    SetBit(LCD_PORT, LCD_CLK); 
    ClearBit(LCD_PORT, LCD_CLK);
    ClearBit(LCD_PORT, LCD_DATA);
    if ((data & 1) == 1)   SetBit(LCD_PORT, LCD_DATA); 
    SetBit(LCD_PORT, LCD_CLK);  
    ClearBit(LCD_PORT, LCD_CLK);
}

#else // _USE_SOFT_SPI
//===============================================================
//			            Аппаратный SPI
//===============================================================
//void Send_spi(unsigned char data)
//{
//	//Частота сигнала SCK: Fкварца/16
//    SPCR = (0<<SPIE)|(1<<SPE)|(0<<DORD)|(1<<MSTR)|(0<<CPOL)|(0<<CPHA)|(0<<SPR1)|(1<<SPR0);	
//    SPDR = data;
//    while(!(SPSR & (1<<SPIF)));
//    SPCR = 0;
//}

#endif // _USE_SOFT_SPI

//===============================================================
//Функция записи команды/данных в LCD (RS==0 - команда, RS==1 - данные)
//===============================================================
void Send_to_lcd (unsigned char RS, unsigned char data)
{  
    ClearBit(LCD_PORT, LCD_CLK);
    ClearBit(LCD_PORT, LCD_DATA);
    if ((RS_old != RS) || (!RS_old && !RS)) //Проверяем старое значение RS 
    { 
        SetBit(LCD_PORT, LCD_CS);	// Установка CS 
        if(RS)    SetBit(LCD_PORT, LCD_RS);
        else      ClearBit(LCD_PORT, LCD_RS);	
        ClearBit(LCD_PORT, LCD_CS);	// Сброс CS 
    } 
 
    Send_spi (data); 
 
    RS_old=RS;  //запоминаем значение RS	
    ClearBit(LCD_PORT, LCD_DATA);
}    

//===============================================================
//                        ИНИЦИАЛИЗАЦИЯ
//===============================================================
void LCD_init(void)
{
 Init_Port();
 ClearBit(LCD_PORT, LCD_RESET);
 delay_ms(500);
 SetBit(LCD_PORT, LCD_RESET);
 delay_ms(500);
 Send_to_lcd(CMD, 0x01); //Программный сброс
 Send_to_lcd(CMD, 0x36); //Memory Access Control (Направление заполнения области дисплея (памяти): 0bVHRXXXXX, V - заполнение по вертикали (0 - сверху-вниз, 1 - снизу-вверх), 
                         //H - заполнение по горизонтали (0 - слева-направо, 1 - справа-налево), R - меняются местами строки и столбцы (при этом заполнение остается сверху-вниз, слева-направо))
 Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея
 Send_to_lcd(CMD, 0x11); //Выход из спящего режима
 delay_ms(20);
 Send_to_lcd(CMD, 0x3a); //Установка цветовой палитры
 #ifdef _8_BIT_COLOR
 Send_to_lcd(DAT, 0x02); //Байт на пиксель 256 цветов
 #else
 Send_to_lcd(DAT, 0x05); //Два байта на пиксель 65536 цветов
 #endif
 delay_ms(20);
 Send_to_lcd(CMD, 0x29); //Включение дисплея 
}  

//===============================================================
//         Задание угла поворота экрана
//===============================================================
void SetRotation (unsigned int angle)
{
    rot=angle;
    Send_to_lcd(CMD, 0x36);
    switch (rot)
    {
        case 0:    
        Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея
        break;
        //================================
        case 90:
        Send_to_lcd(DAT, 0x40); //Начальный адрес осей Х и У - правый верхний угол дисплея 
        break;
        //================================
        case 180:       
        Send_to_lcd(DAT, 0xC0); //Начальный адрес осей Х и У - правый нижний угол дисплея 
        break;
        //================================
        case 270:
        Send_to_lcd(DAT, 0x80); //Начальный адрес осей Х и У - левый нижний угол дисплея  
        break;
        //================================           
    };  
}    
  
//===============================================================
//              Задание прямоугольной области экрана
//===============================================================
void SetArea(char x1, char x2, char y1, char y2)
{
    Send_to_lcd( CMD, 0x2A );  //задаем область по X
    Send_to_lcd( DAT, x1 );    //начальная
    Send_to_lcd( DAT, x2 );    //конечная

    Send_to_lcd( CMD, 0x2B );  //задаем область по Y
    Send_to_lcd( DAT, y1 );    //начальная 
    Send_to_lcd( DAT, y2 );    //конечная

    Send_to_lcd( CMD, 0x2C );  //отправляем команду на начало записи в память и начинаем посылать данные
}                 

//===============================================================
//                        Рисуем точку 
//=============================================================== 
void Put_Pixel (char x, char y, unsigned int color) 
{
    SetArea( x, x, y, y ); 
    SetBit(LCD_PORT, LCD_RS); //Передаются данные   
 
    #ifdef _8_BIT_COLOR		//(8-ми битовая цветовая палитра (256 цветов))
    Send_to_lcd( DAT, color );	//Данные - задаём цвет пикселя 
    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
    Send_to_lcd( DAT, (color >> 8) ); 
    Send_to_lcd( DAT, color );
    #endif
}  
                   
//===============================================================
//           Функция прорисовки символа на дисплее
//===============================================================
void Send_Symbol (unsigned char symbol, char x, char y, int t_color, int b_color, char zoom_width, char zoom_height) 
{
 unsigned char temp_symbol, a, b, zw, zh, mask; 
  
 if (symbol>127) symbol-=64;    //Убираем отсутствующую часть таблицы ASCII
 for ( a = 0; a < 5; a++) //Перебираю 5 байт, составляющих символ
 {
    temp_symbol = font_5x8[symbol-32][a];
    zw = 0; 
    while(zw != zoom_width) //Вывод байта выполняется zw раз 
    {    
        mask=0x01;  
        switch(rot)
        {
            case 0: case 180: SetArea( x+zw, x+zw, y, y+(zoom_height*8)-1 ); break;
            case 90: case 270: SetArea( x, x+(zoom_height*8)-1, y+zw, y+zw ); break;                  
        } 
        SetBit(LCD_PORT, LCD_RS); //Передаются данные          
        for ( b = 0; b < 8; b++ ) //Цикл перебирания 8 бит байта
        {         
            zh = zoom_height; //в zoom_height раз увеличится высота символа
            while(zh != 0) //Вывод пикселя выполняется z раз
            {
                if (temp_symbol&mask) 
                {
                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
                    Send_to_lcd( DAT, t_color ); //Данные - задаём цвет пикселя 
                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
                    Send_to_lcd( DAT, (t_color >> 8) ); Send_to_lcd( DAT, t_color );
                    #endif
                }
                else 
               {
                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
                    Send_to_lcd( DAT, b_color ); //Данные - задаём цвет пикселя 
                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
                    Send_to_lcd( DAT, (b_color >> 8) ); Send_to_lcd( DAT, b_color );
                    #endif
                }
                zh--;
            }
            mask<<=1; //Смещаю содержимое mask на 1 бит влево;    
        }
        zw++;
    }
  switch(rot)
  {
   case 0: case 180: x=x+zoom_width;  break; //Получить адрес начального пикселя по оси x для вывода очередного байта
   case 90: case 270: y=y+zoom_width; break; //Получить адрес начального пикселя по оси y для вывода очередного байта            
  }                  
 }
}  

//===============================================================
// Функция вывода одного символа ASCII-кода 
//===============================================================
void LCD_Putchar(char symbol, char x, char y, int t_color, int b_color, char zoom_width, char zoom_height)
{
    unsigned char m;
    if(zoom_width == 0)   zoom_width = 1;
    if(zoom_height == 0)  zoom_height = 1;
    switch (rot)  
    {         
        case 90: case 270:  m=y; y=x; x=m;        
                            break;                      
    };
    Send_Symbol( symbol, x, y, t_color, b_color, zoom_width, zoom_height);  
}

//===============================================================
//          Функция вывода строки, расположенной в ram 
//===============================================================
void LCD_Puts(char *str, int x, int y,  int t_color, int b_color, char zoom_width, char zoom_height)
{
    unsigned char i=0;
              
    if(zoom_width == 0)   zoom_width = 1;
    if(zoom_height == 0)  zoom_height = 1;
   
    while (str[i]) //x и y - адрес пикселя начальной позиции; с увеличением переменной i адрес вывода очередного символа смещается на i*6 (чем организуются столбцы дисплея)  
    {      
        LCD_Putchar(str[i], x+(i*6*zoom_width), y, t_color, b_color, zoom_width, zoom_height);
        i++;
    }  
}

//===============================================================
//          Функция вывода строки, расположенной во flash
//===============================================================
void LCD_Putsf(flash char *str, int x, int y,  int t_color, int b_color, char zoom_width, char zoom_height)
{
 unsigned char i=0;
        
 if(zoom_width == 0)   zoom_width = 1;
 if(zoom_height == 0)  zoom_height = 1;
   
 while (str[i]) //x и y - адрес пикселя начальной позиции; с увеличением переменной i адрес вывода очередного символа смещается на i*6 (чем организуются столбцы дисплея)  
 {      
  LCD_Putchar(str[i], x+(i*6*zoom_width), y, t_color, b_color, zoom_width, zoom_height);
  i++;
 }  
}    

//===============================================================
//     Функция прорисовки символа на дисплее без цвета фона
//===============================================================
void Send_Symbol_Shadow (unsigned char symbol, char x, char y, int t_color, char zoom_width, char zoom_height) 
{
 unsigned char temp_symbol, a, b, zw, zh, mask; 
 char m, n;
 m=x; 
 n=y;
 if (symbol>127) symbol-=64;    //Убираем отсутствующую часть таблицы ASCII
 for ( a = 0; a < 5; a++) //Перебираю 5 байт, составляющих символ
 {  
  temp_symbol = font_5x8[symbol-32][a];
  zw = 0; 
  while(zw != zoom_width) //Вывод байта выполняется zw раз 
  {    
   switch(rot)
   {
    case 0: case 180: n=y; break;
    case 90: case 270: m=x; break;
   } 
   mask=0x01;     
   for ( b = 0; b < 8; b++ ) //Цикл перебирания 8 бит байта
   {         
    zh = 0; //в zoom_height раз увеличится высота символа
    while(zh != zoom_height) //Вывод пикселя выполняется z раз
    {
     switch(rot)
     {
      case 0: case 180:  
      if (temp_symbol&mask) 
      {
       Put_Pixel (m+zw, n+zh, t_color);
      }
      break; 
      case 90: case 270: 
      if (temp_symbol&mask) 
      {
       Put_Pixel (m+zh, n+zw, t_color);
      }
      break; //Получить адрес начального пикселя по оси y для вывода очередного байта            
     }            
     zh++;
    }
    mask<<=1; //Смещаю содержимое mask на 1 бит влево;
    switch(rot)
    {
     case 0: case 180: n=n+zoom_height; break;
     case 90: case 270: m=m+zoom_height; break;
    }          
   }
   zw++;   
  }
  switch(rot)
  {
   case 0: case 180: m=m+zoom_width; break;
   case 90: case 270: n=n+zoom_width; break;
  }           
 }
} 

//===============================================================
// Функция вывода одного символа ASCII-кода без цвета фона
//===============================================================
void LCD_Putchar_Shadow (char symbol, char x, char y, int t_color, char zoom_width, char zoom_height)
{
 unsigned char m;
 if(zoom_width == 0)   zoom_width = 1;
 if(zoom_height == 0)  zoom_height = 1;
 switch (rot)
 {  
    case 90: case 270:  m=y; y=x; x=m;
                        break;    
 };
 Send_Symbol_Shadow( symbol, x, y, t_color, zoom_width, zoom_height);  
}

//===============================================================
//   Функция вывода строки, расположенной в ram без цвета фона 
//===============================================================
void LCD_Puts_Shadow(char *str, int x, int y,  int t_color, char zoom_width, char zoom_height)
{
 unsigned char i=0;
                    
 if(zoom_width == 0)   zoom_width = 1;
 if(zoom_height == 0)  zoom_height = 1;
   
 while (str[i]) //x и y - адрес пикселя начальной позиции; с увеличением переменной i адрес вывода очередного символа смещается на i*6 (чем организуются столбцы дисплея)  
 {      
  LCD_Putchar_Shadow(str[i], x+(i*6*zoom_width), y, t_color, zoom_width, zoom_height);
  i++;
 }  
}

//===============================================================
// Функция вывода строки, расположенной во flash без цвета фона
//===============================================================
void LCD_Putsf_Shadow(flash char *str, int x, int y,  int t_color, char zoom_width, char zoom_height)
{
 unsigned char i=0;
           
 if(zoom_width == 0)   zoom_width = 1;
 if(zoom_height == 0)  zoom_height = 1;
   
 while (str[i])   
 {      
  LCD_Putchar_Shadow(str[i], x+(i*6*zoom_width), y, t_color, zoom_width, zoom_height);
  i++;
 }  
} 
   
//===============================================================
//                  ЗАЛИВКА ЭКРАНА ЦВЕТОМ 
//===============================================================
void LCD_FillScreen (unsigned int color)
{ 
 unsigned int x; 
 SetArea( 0, 131, 0, 175 );   //Область всего экрана 
 SetBit(LCD_PORT, LCD_RS);    
 
 //Данные - задаём цвет пикселя
 for (x = 0; x < 132*176; x++)  
 {   
  #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
  Send_to_lcd( DAT, color ); //Данные - задаём цвет пикселя 
  #else			//(16-ти битовая цветовая палитра (65536 цветов))
  Send_to_lcd( DAT, (color >> 8) ); Send_to_lcd( DAT, color );
  #endif
 }                 
} 

//===============================================================
//                 ФУНКЦИЯ ВЫВОДА ИЗОБРАЖЕНИЯ
//===============================================================
void LCD_Output_image (char x, char y, char width, char height, flash char *img)
{ 
 unsigned char m;
 switch (rot)
 {
    case 90: case 270:  m=y; y=x; x=m;  
                        break;     
 };
 Send_Image (x, y, width, height, img);
}   

//===============================================================
//          Функция для обеспечения вывода изображения   
//===============================================================
//Вывод картинки с Image2Lcd и NokiaImageCreator должен выполняться слева-направо сверху-вниз.
//x, y - начало области вывода изображения; width и height - ширина и высота изображения   
void Send_Image (char x, char y, char width, char height, flash char *img)  
{  
 char x1, y1; 
 
 switch (rot)
 {
  case 0: case 180:  
  for(y1=y; y1<(y+height); y1++)
  {
   SetArea( x, x+(width-1), y1, y1 );   
   for(x1=x; x1<x+width; x1++)
   {   
    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
    Send_to_lcd( DAT, *img++ ); //Данные - задаём цвет пикселя 
    #else			//(16-ти битовая цветовая палитра (65536 цветов))
    Send_to_lcd( DAT, *img++ ); Send_to_lcd( DAT, *img++ );  
    #endif
   }
  }
  break;
 
  case 90: case 270:
  for(x1=x; x1<x+height; x1++)
  {
   SetArea( x1, x1, y, y+(width-1) );       
   for(y1=y; y1<y+width; y1++)
   {
    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
    Send_to_lcd( DAT, *img++ ); //Данные - задаём цвет пикселя 
    #else			//(16-ти битовая цветовая палитра (65536 цветов))
    Send_to_lcd( DAT, *img++ ); Send_to_lcd( DAT, *img++ );      
    #endif  
   } 
  }
  break; 
 }; 
} 

#ifdef _GEOMETRICAL
//===============================================================
//                      НАРИСОВАТЬ ЛИНИЮ
//===============================================================
void LCD_DrawLine (char x1, char y1, char x2, char y2, int color)
{ 
 short  x, y, d, dx, dy, i, i1, i2, kx, ky;
 signed char flag;
 unsigned char m;

 switch (rot)
 {
    case 90: case 270:  m=y1; y1=x1; x1=m; m=y2; y2=x2; x2=m; 
                        break;     
 };
 
 dx = x2 - x1;
 dy = y2 - y1;
 if (dx == 0 && dy == 0) Put_Pixel(x1, y1, color);  //Точка
 else      //Линия
 {
  kx = 1;
  ky = 1;
  if( dx < 0 )
  { 
   dx = -dx; 
   kx = -1; 
  }
  else
  if(dx == 0) kx = 0;
  if(dy < 0)
  { 
   dy = -dy; 
   ky = -1; 
  }
  if(dx < dy)
  { 
   flag = 0; 
   d = dx; 
   dx = dy; 
   dy = d; 
  }
  else flag = 1;
  i1 = dy + dy; 
  d = i1 - dx; 
  i2 = d - dx;
  x = x1; 
  y = y1;

  for(i=0; i < dx; i++)
  {
   Put_Pixel(x, y, color);
   if(flag) x += kx;
   else y += ky;
   if( d < 0 ) d += i1;
   else
   {
    d += i2;
    if(flag) y += ky;
    else x += kx;
   }
  }
  Put_Pixel(x, y, color);
 }
}   
  
//===============================================================
//             НАРИСОВАТЬ ЛИНИЮ С ЗАДАВАЕМОЙ ШИРИНОЙ
//===============================================================
void LCD_FillLine (char tx1, char ty1, char tx2, char ty2, char width, int color)
{
    signed long x, y, addx, dx, dy;
    signed long P;
    int i;
    long x1,x2,y1,y2;
      
   if(ty1>ty2)  {y1=ty2; y2=ty1; x1=tx2; x2=tx1;}
   else         {y1=ty1; y2=ty2; x1=tx1; x2=tx2;}
    dx = x2 - x1;
    dy = y2 - y1;
   if(dx<0)     dx=-dx;
   if(dy<0)     dy=-dy;
    x = x1;
    y = y1;

   if(x1 > x2)  addx = -1;
   else         addx = 1;

   if(dx >= dy)
   {
    P = 2*dy - dx;

      for(i=0; i<=dx; ++i)
      {
        LCD_FillRect (x, y, width, width, color);
        
         if(P < 0)
         {
            P += 2*dy;
            x += addx;
         }
         else
         {
            P += 2*dy - 2*dx;
            x += addx;
            y ++;
         }
      }
   }
   else
   {
    P = 2*dx - dy;

      for(i=0; i<=dy; ++i)
      {
        LCD_FillRect (x, y, width, width, color);

         if(P < 0)
         {
            P += 2*dx;
            y ++;
         }
         else
         {
            P += 2*dx - 2*dy;
            x += addx;
            y ++;
         }
      }
   }
}   

//===============================================================
//			НАРИСОВАТЬ РАМКУ                
//===============================================================
void LCD_DrawRect (char x1, char y1, char width, char height, char size, int color)
{
 unsigned int i;
 char x2=x1+(width-1), y2=y1+(height-1); //Конечные размеры рамки по осям х и у
 
  for( i=1; i<=size; i++)   // size - толщина рамки
 {
  LCD_DrawLine(x1, y1, x1, y2, color);
  LCD_DrawLine(x2, y1, x2, y2, color);
  LCD_DrawLine(x1, y1, x2, y1, color);
  LCD_DrawLine(x1, y2, x2, y2, color);
  x1++; // Увеличиваю толщину рамки, если это задано
  y1++;
  x2--;
  y2--;
 }
}

//===============================================================
//              ЗАПОЛНИТЬ ПРЯМОУГОЛЬНИК ЦВЕТОМ COLOR
//===============================================================
void LCD_FillRect (char x1, char y1, char width, char height, int color)
{
 unsigned int x;
 unsigned char m;

 switch (rot)
 {
    case 90: case 270:  m=y1; y1=x1; x1=m; m=width; width=height; height=m; break;     
 };
       
 SetArea( x1, x1+(width-1), y1, y1+(height-1) );
 SetBit(LCD_PORT, LCD_RS);
 
 for (x = 0; x < width * height; x++) 
 {   
  #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
  Send_to_lcd( DAT, color ); //Данные - задаём цвет пикселя 
  #else			//(16-ти битовая цветовая палитра (65536 цветов))
  Send_to_lcd( DAT, (color >> 8) ); Send_to_lcd( DAT, color );
  #endif
 }   
}  
 
//===============================================================
//                  НАРИСОВАТЬ ОКРУЖНОСТЬ
//===============================================================
void LCD_DrawCircle (char xcenter, char ycenter, char rad, int color)
{
    signed int k, b, P;
    unsigned char m;

    switch (rot)
    {
        case 90: case 270:  m=ycenter; ycenter=xcenter; xcenter=m; break;     
    };
    
    k = 0;
    b = rad;
    P = 1 - rad;
    do     
    {
        Put_Pixel(k+xcenter, b+ycenter, color);
        Put_Pixel(b+xcenter, k+ycenter, color);
        Put_Pixel(xcenter-k, b+ycenter, color);
        Put_Pixel(xcenter-b, k+ycenter, color);
        Put_Pixel(b+xcenter, ycenter-k, color);
        Put_Pixel(k+xcenter, ycenter-b, color);
        Put_Pixel(xcenter-k, ycenter-b, color);
        Put_Pixel(xcenter-b, ycenter-k, color);

        if(P < 0)   P+= 3 + 2*k++;
        else        P+= 5 + 2*(k++ - b--);
    } while(k <= b);
}      


//===============================================================
//                 ЗАПОЛНИТЬ КРУГ ЦВЕТОМ COLOR
//===============================================================
void LCD_FillCircle (char xcenter, char ycenter, char rad, int color)
{
    signed int x1=0, y1, tswitch;
    y1 = rad;
    tswitch = 1 - rad;

    do
    {
        LCD_DrawLine(xcenter-x1, ycenter+y1, xcenter+x1, ycenter+y1, color);
        LCD_DrawLine(xcenter-x1, ycenter-y1, xcenter+x1, ycenter-y1, color);
        LCD_DrawLine(xcenter-y1, ycenter+x1, xcenter+y1, ycenter+x1, color);
        LCD_DrawLine(xcenter-y1, ycenter-x1, xcenter+y1, ycenter-x1, color);

    if(tswitch < 0)
    tswitch+= 3 + 2*x1++;
    else
    tswitch+= 5 + 2*(x1++ - y1--);
    } while(x1 <= y1);
}

//===============================================================
//                     НАРИСОВАТЬ ТРЕУГОЛЬНИК
//===============================================================
void LCD_DrawTriangle(char x1, char y1, char x2, char y2, char x3, char y3, int color)
{
 LCD_DrawLine(x1, y1, x2, y2, color);
 LCD_DrawLine(x3, y3, x1, y1, color);
 LCD_DrawLine(x3, y3, x2, y2, color);  
}

//===============================================================
//              ЗАПОЛНИТЬ ТРЕУГОЛЬНИК ЦВЕТОМ COLOR
//===============================================================
void LCD_FillTriangle(char x1, char y1, char x2, char y2, char x3, char y3, int color)
{
 LCD_FillTriangleA(x1, y1, x2, y2, x3, y3, color);
 LCD_FillTriangleA(x3, y3, x1, y1, x2, y2, color);
 LCD_FillTriangleA(x3, y3, x2, y2, x1, y1, color);
}    

//===============================================================
void LCD_FillTriangleA(char x1, char y1, char x2, char y2, char x3, char y3, int color)
{
 signed long x, y, addx, dx, dy;
 signed long P;
 int i;
 long a1,a2,b1,b2;
 if(y1>y2)  {b1=y2; b2=y1; a1=x2; a2=x1;}
 else       {b1=y1; b2=y2; a1=x1; a2=x2;}
 dx = a2 -a1;
 dy = b2 - b1;
 if(dx<0)dx=-dx;
 if(dy<0)dy=-dy;
 x = a1;
 y = b1;
   
 if(a1 > a2)    addx = -1;
 else           addx = 1;
   
 if(dx >= dy)
 {
  P = 2*dy - dx;
  for(i=0; i<=dx; ++i)
  {
   LCD_DrawLine((int)x, (int)y, x3, y3, color);
   if(P < 0)
   {
    P += 2*dy;
    x += addx;
   }
   else
   {
    P += 2*dy - 2*dx;
    x += addx;
    y ++;
   }
  }
 }
 else
 {
  P = 2*dx - dy;
  for(i=0; i<=dy; ++i)
  {
   LCD_DrawLine((int)x, (int)y, x3, y3, color);
   if(P < 0)
   {
    P += 2*dx;
    y ++;
   }
   else
   {
    P += 2*dx - 2*dy;
    x += addx;
    y ++;
   }
  }
 }
}

//===============================================================
//      Функция прорисовки графика состояния 0-100%
//===============================================================
// percent - число от 0 до 100, x и y - начальная позиция графика (верхний левый угол), width - ширина графика, zoom_height - во сколько раз увеличить высоту графика 
// (при zoom_height=1 высота одной ячейки составляет 5 пикселей)
void LCD_Put_Graph (char percent, char x, char y, int t_color, int b_color, char width, char zoom_height)
{
    char i, j=0, m, array[20];
    for (i = 0; i < percent; i += 5)
    {            
        if (i + 5 > percent)
        {
            array[j++] = percent-i;
        }
        else
        {              
            array[j++] = 5;
        }
    }
    for (i=j; i<20; i++) //Заполнение оставшейся части нулями
    {
        array[i] = 0;
    }    
    
    switch (rot)
    {          
        case 270:   // Обновление дисплея Снизу-вверх
                    Send_to_lcd(CMD, 0x36); 
                    Send_to_lcd(DAT, 0x80); //Начальный адрес осей Х и У - левый нижний угол дисплея
                    break;
        default:    // Обновление дисплея Слева-направо, сверху-вниз 
                    Send_to_lcd(CMD, 0x36); 
                    Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея        
    }
        
    
    for (i=0; i<20; i++)
    {
        if (array[i]==5) //Нарисовать закрашенную ячейку (5%)
        {
                switch (rot)
                {
                    case 0:     SetArea (x, x+(5*zoom_height-1), y, y+(width-1));
                                break;
                    default:    SetArea (x, x+(width-1), y, y+(5*zoom_height-1));             
                }                  
                
                for(j = 0; j < width*(5*zoom_height); j++)
                {
                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
                    Send_to_lcd( DAT, t_color ); //Данные - задаём цвет пикселя 
                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
                    Send_to_lcd( DAT, (t_color >> 8) ); Send_to_lcd( DAT, t_color );
                    #endif
                }
                
                switch (rot)  
                {
                    case 0:     x+=(5*zoom_height);
                                break;
                    default:    y+=(5*zoom_height);             
                }
                
        }                               
        
        else if (array[i]==0) //Нарисовать незакрашенную ячейку (5%)
        {
                switch (rot)
                {
                    case 0:     SetArea (x, x+(5*zoom_height-1), y, y+(width-1));
                                break;
                    default:    SetArea (x, x+(width-1), y, y+(5*zoom_height-1));             
                }           
                
                for(j = 0; j < width*(5*zoom_height); j++)
                {
                    #ifdef _8_BIT_COLOR		//(8-ми битовая цветовая палитра (256 цветов))
                    Send_to_lcd( DAT, b_color ); //Данные - задаём цвет пикселя 
                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
                    Send_to_lcd( DAT, (b_color >> 8) ); Send_to_lcd( DAT, b_color );
                    #endif
                }
                 switch (rot)
                {
                    case 0:     x+=(5*zoom_height);
                                break;
                    default:    y+=(5*zoom_height);             
                }
        }                        
                              
        else  //Нарисовать полузакрашенную ячейку (1-4%)
        {
            m=array[i];
            while (m--)
            {  
            
                switch (rot)
                {
                    case 0:     SetArea (x, x+(zoom_height-1), y, y+(width-1));
                                break;
                    default:    SetArea (x, x+(width-1), y, y+(zoom_height-1));             
                }        
                
                for(j = 0; j < width*zoom_height; j++)
                {
                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
                    Send_to_lcd( DAT, t_color ); //Данные - задаём цвет пикселя 
                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
                    Send_to_lcd( DAT, (t_color >> 8) ); Send_to_lcd( DAT, t_color );
                    #endif
                }
                     switch (rot)
                {
                    case 0:     x+=zoom_height;
                                break;
                    default:    y+=zoom_height;             
                }                        
            }
         
            m=5-array[i];
            while (m--)
            {
                switch (rot)
                {
                    case 0:     SetArea (x, x+(zoom_height-1), y, y+(width-1));
                                break;
                    default:    SetArea (x, x+(width-1), y, y+(zoom_height-1));             
                }
                
                for(j = 0; j < width*zoom_height; j++)
                {
                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
                    Send_to_lcd( DAT, b_color ); //Данные - задаём цвет пикселя 
                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
                    Send_to_lcd( DAT, (b_color >> 8) ); Send_to_lcd( DAT, b_color );
                    #endif
                }
                     switch (rot)
                switch (rot)
                {
                    case 0:     x+=zoom_height;
                                break;
                    default:    y+=zoom_height;
                }                       
            }
        }
                    
    }
    Send_to_lcd(CMD, 0x36); 
    Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея
}

//===============================================================
#endif //_GEOMETRICAL