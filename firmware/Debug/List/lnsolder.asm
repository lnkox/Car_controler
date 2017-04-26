
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rot=R4
	.DEF _rot_msb=R5
	.DEF _RS_old=R7
	.DEF _solder_cur=R8
	.DEF _solder_cur_msb=R9
	.DEF _air_cur=R10
	.DEF _air_cur_msb=R11
	.DEF _solder_set=R12
	.DEF _solder_set_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_solder_img:
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x0,0xA
	.DB  0x0,0x0,0x0,0x1C,0x0,0x0,0x0,0x3E
	.DB  0x0,0x0,0x0,0x7C,0x0,0x0,0x0,0xF8
	.DB  0x0,0x0,0x1,0xF0,0x0,0x0,0x3,0xE0
	.DB  0x0,0x0,0x7,0xC0,0x0,0x0,0xF,0x80
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0xBE,0x0
	.DB  0x0,0x1,0x7C,0x0,0x0,0x1,0xFC,0x0
	.DB  0x0,0x1,0xF4,0x0,0x0,0x2,0xE8,0x0
	.DB  0x0,0x4,0x70,0x0,0x0,0x8,0x80,0x0
	.DB  0x0,0x11,0x0,0x0,0x0,0x22,0x0,0x0
	.DB  0x0,0x44,0x0,0x0,0x0,0x88,0x0,0x0
	.DB  0x1,0x10,0x0,0x0,0x2,0x20,0x0,0x0
	.DB  0x4,0x40,0x0,0x0,0x8,0x80,0x0,0x0
	.DB  0x11,0x0,0x0,0x0,0xA,0x0,0x0,0x0
	.DB  0x14,0x0,0x0,0x0,0x20,0x0,0x0,0x0
	.DB  0x40,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_fan_img:
	.DB  0x0,0x3,0xF0,0x0,0x0,0x7,0xFC,0x0
	.DB  0x0,0xF,0xFE,0x0,0x0,0x1F,0xFE,0x0
	.DB  0x0,0x1F,0xFE,0x0,0x0,0x1F,0xFE,0x0
	.DB  0x0,0x1F,0xFC,0x0,0x0,0x1F,0xF8,0x0
	.DB  0x0,0x1F,0xF0,0x0,0x3C,0xF,0xE0,0x0
	.DB  0x7E,0xF,0xE0,0x0,0x7F,0x7,0xC1,0xF8
	.DB  0xFF,0x84,0x27,0xFC,0xFF,0xE8,0x1F,0xFE
	.DB  0xFF,0xF1,0x8F,0xFF,0xFF,0xF3,0xCF,0xFF
	.DB  0xFF,0xF3,0xCF,0xFF,0xFF,0xF1,0x8F,0xFF
	.DB  0x7F,0xF8,0x17,0xFF,0x3F,0xE4,0x21,0xFF
	.DB  0x1F,0x83,0xE0,0xFE,0x0,0x7,0xF0,0x7E
	.DB  0x0,0x7,0xF0,0x3C,0x0,0xF,0xF8,0x0
	.DB  0x0,0x1F,0xF8,0x0,0x0,0x3F,0xF8,0x0
	.DB  0x0,0x7F,0xF8,0x0,0x0,0x7F,0xF8,0x0
	.DB  0x0,0x7F,0xF8,0x0,0x0,0x7F,0xF0,0x0
	.DB  0x0,0x3F,0xE0,0x0,0x0,0xF,0xC0,0x0
_hotair_img:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x7,0xF0,0x0,0x0,0x1F,0xFF,0xF0,0x0
	.DB  0x1F,0xFF,0xFE,0x0,0x38,0x3F,0xFE,0xFE
	.DB  0x38,0x3F,0xFE,0x0,0x78,0x3F,0xFE,0xFE
	.DB  0x78,0x3F,0xFE,0x0,0x38,0x3F,0xFE,0xFE
	.DB  0x38,0x3F,0xFE,0x0,0x1F,0xFF,0xF8,0x0
	.DB  0x1F,0xFF,0xC0,0x0,0x7,0xFE,0x0,0x0
	.DB  0x7,0xF0,0x0,0x0,0x7,0xF0,0x0,0x0
	.DB  0x7,0xF0,0x0,0x0,0x7,0xF0,0x0,0x0
	.DB  0x7,0xF0,0x0,0x0,0x7,0xF0,0x0,0x0
	.DB  0x7,0xF0,0x0,0x0,0x7,0xF0,0x0,0x0
	.DB  0x7,0xF0,0x0,0x0,0x7,0xF0,0x0,0x0
	.DB  0x7,0xF0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_font_5x8:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x8,0x2A,0x1C,0x2A,0x8,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x30
	.DB  0x30,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x0,0x8,0x14,0x22
	.DB  0x41,0x14,0x14,0x14,0x14,0x14,0x41,0x22
	.DB  0x14,0x8,0x0,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x1,0x1,0x3E,0x41,0x41,0x51,0x32
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0x4,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x7F,0x20,0x18,0x20,0x7F
	.DB  0x63,0x14,0x8,0x14,0x63,0x3,0x4,0x78
	.DB  0x4,0x3,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x0,0x7F,0x41,0x41,0x2,0x4,0x8,0x10
	.DB  0x20,0x41,0x41,0x7F,0x0,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0x8,0x14,0x54,0x54,0x3C
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x0
	.DB  0x7F,0x10,0x28,0x44,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x7E,0x11,0x11,0x11,0x7E,0x7F,0x45,0x45
	.DB  0x45,0x39,0x7F,0x49,0x49,0x49,0x36,0x7F
	.DB  0x1,0x1,0x1,0x3,0xC0,0x7E,0x41,0x7F
	.DB  0xC0,0x7F,0x49,0x49,0x49,0x41,0x77,0x8
	.DB  0x7F,0x8,0x77,0x22,0x49,0x49,0x49,0x36
	.DB  0x7F,0x20,0x10,0x8,0x7F,0x7F,0x20,0x13
	.DB  0x8,0x7F,0x7F,0x8,0x14,0x22,0x41,0x40
	.DB  0x3E,0x1,0x1,0x7F,0x7F,0x2,0x4,0x2
	.DB  0x7F,0x7F,0x8,0x8,0x8,0x7F,0x3E,0x41
	.DB  0x41,0x41,0x3E,0x7F,0x1,0x1,0x1,0x7F
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x41
	.DB  0x41,0x22,0x1,0x1,0x7F,0x1,0x1,0x27
	.DB  0x48,0x48,0x48,0x3F,0x1E,0x21,0x7F,0x21
	.DB  0x1E,0x63,0x14,0x8,0x14,0x63,0x7F,0x40
	.DB  0x40,0x7F,0xC0,0xF,0x10,0x10,0x10,0x7F
	.DB  0x7F,0x40,0x7C,0x40,0x7F,0x7F,0x40,0x7C
	.DB  0x40,0xFF,0x1,0x7F,0x48,0x48,0x30,0x7F
	.DB  0x48,0x30,0x0,0x7F,0x7F,0x48,0x48,0x48
	.DB  0x30,0x22,0x49,0x49,0x49,0x3E,0x7F,0x8
	.DB  0x3E,0x41,0x3E,0x76,0x9,0x9,0x9,0x7F
	.DB  0x20,0x54,0x54,0x54,0x78,0x7C,0x54,0x54
	.DB  0x54,0x24,0x7C,0x54,0x54,0x54,0x28,0x7C
	.DB  0x4,0x4,0x4,0xC,0xC0,0x78,0x44,0x7C
	.DB  0xC0,0x38,0x54,0x54,0x54,0x18,0x6C,0x10
	.DB  0x7C,0x10,0x6C,0x28,0x44,0x54,0x54,0x28
	.DB  0x7C,0x20,0x10,0x8,0x7C,0x7C,0x21,0x12
	.DB  0x8,0x7C,0x7C,0x10,0x10,0x28,0x44,0x40
	.DB  0x38,0x4,0x4,0x7C,0x7C,0x8,0x10,0x8
	.DB  0x7C,0x7C,0x10,0x10,0x10,0x7C,0x38,0x44
	.DB  0x44,0x44,0x38,0x7C,0x4,0x4,0x4,0x7C
	.DB  0x7C,0x14,0x14,0x14,0x8,0x38,0x44,0x44
	.DB  0x44,0x20,0x4,0x4,0x7C,0x4,0x4,0xC
	.DB  0x50,0x50,0x50,0x3C,0x18,0x24,0x7C,0x24
	.DB  0x18,0x44,0x28,0x10,0x28,0x44,0x7C,0x40
	.DB  0x40,0x7C,0xC0,0xC,0x10,0x10,0x10,0x7C
	.DB  0x7C,0x40,0x78,0x40,0x7C,0x7C,0x40,0x78
	.DB  0x40,0xFC,0x7C,0x54,0x50,0x50,0x20,0x7C
	.DB  0x50,0x20,0x0,0x7C,0x7C,0x50,0x50,0x50
	.DB  0x20,0x28,0x44,0x54,0x54,0x38,0x7C,0x10
	.DB  0x38,0x44,0x38,0x48,0x34,0x14,0x14,0x7C
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x25,0x69,0x20,0x20,0x0,0x25,0x69,0x25
	.DB  0x25,0x20,0x20,0x0,0x20,0x4C,0x4E,0x53
	.DB  0x4F,0x4C,0x44,0x45,0x52,0x20,0x0,0x50
	.DB  0x6F,0x77,0x65,0x72,0x65,0x64,0x20,0x62
	.DB  0x79,0x20,0x4C,0x6E,0x4B,0x4F,0x78,0x20
	.DB  0x26,0x20,0x52,0x61,0x64,0x69,0x6F,0x56
	.DB  0x65,0x74,0x61,0x6C,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _0x172
	.DW  _0x0*2+12

	.DW  0x1E
	.DW  _0x172+11
	.DW  _0x0*2+23

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.10 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 31.03.2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 1,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;flash unsigned char solder_img[128] = { /* 0X00,0X01,0X20,0X00,0X20,0X00, */
;0X00,0X00,0X00,0X01,0X00,0X00,0X00,0X0A,0X00,0X00,0X00,0X1C,0X00,0X00,0X00,0X3E,
;0X00,0X00,0X00,0X7C,0X00,0X00,0X00,0XF8,0X00,0X00,0X01,0XF0,0X00,0X00,0X03,0XE0,
;0X00,0X00,0X07,0XC0,0X00,0X00,0X0F,0X80,0X00,0X00,0X7F,0X00,0X00,0X00,0XBE,0X00,
;0X00,0X01,0X7C,0X00,0X00,0X01,0XFC,0X00,0X00,0X01,0XF4,0X00,0X00,0X02,0XE8,0X00,
;0X00,0X04,0X70,0X00,0X00,0X08,0X80,0X00,0X00,0X11,0X00,0X00,0X00,0X22,0X00,0X00,
;0X00,0X44,0X00,0X00,0X00,0X88,0X00,0X00,0X01,0X10,0X00,0X00,0X02,0X20,0X00,0X00,
;0X04,0X40,0X00,0X00,0X08,0X80,0X00,0X00,0X11,0X00,0X00,0X00,0X0A,0X00,0X00,0X00,
;0X14,0X00,0X00,0X00,0X20,0X00,0X00,0X00,0X40,0X00,0X00,0X00,0X00,0X00,0X00,0X00,
;};
;flash unsigned char fan_img[128] = { /* 0X00,0X01,0X20,0X00,0X20,0X00, */
;0X00,0X03,0XF0,0X00,0X00,0X07,0XFC,0X00,0X00,0X0F,0XFE,0X00,0X00,0X1F,0XFE,0X00,
;0X00,0X1F,0XFE,0X00,0X00,0X1F,0XFE,0X00,0X00,0X1F,0XFC,0X00,0X00,0X1F,0XF8,0X00,
;0X00,0X1F,0XF0,0X00,0X3C,0X0F,0XE0,0X00,0X7E,0X0F,0XE0,0X00,0X7F,0X07,0XC1,0XF8,
;0XFF,0X84,0X27,0XFC,0XFF,0XE8,0X1F,0XFE,0XFF,0XF1,0X8F,0XFF,0XFF,0XF3,0XCF,0XFF,
;0XFF,0XF3,0XCF,0XFF,0XFF,0XF1,0X8F,0XFF,0X7F,0XF8,0X17,0XFF,0X3F,0XE4,0X21,0XFF,
;0X1F,0X83,0XE0,0XFE,0X00,0X07,0XF0,0X7E,0X00,0X07,0XF0,0X3C,0X00,0X0F,0XF8,0X00,
;0X00,0X1F,0XF8,0X00,0X00,0X3F,0XF8,0X00,0X00,0X7F,0XF8,0X00,0X00,0X7F,0XF8,0X00,
;0X00,0X7F,0XF8,0X00,0X00,0X7F,0XF0,0X00,0X00,0X3F,0XE0,0X00,0X00,0X0F,0XC0,0X00,
;};
;
;
;flash unsigned char hotair_img[128] = { /* 0X00,0X01,0X20,0X00,0X20,0X00, */
;0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,
;0X07,0XF0,0X00,0X00,0X1F,0XFF,0XF0,0X00,0X1F,0XFF,0XFE,0X00,0X38,0X3F,0XFE,0XFE,
;0X38,0X3F,0XFE,0X00,0X78,0X3F,0XFE,0XFE,0X78,0X3F,0XFE,0X00,0X38,0X3F,0XFE,0XFE,
;0X38,0X3F,0XFE,0X00,0X1F,0XFF,0XF8,0X00,0X1F,0XFF,0XC0,0X00,0X07,0XFE,0X00,0X00,
;0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,
;0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,
;0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X07,0XF0,0X00,0X00,0X00,0X00,0X00,0X00,
;0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,
;};
;
;#define solder_TC 6
;#define air_TC 7
;#define solder_RR 0
;#define air_RR 1
;#define fan_RR 2
;#define solder_but PINC.3
;#define air_but  PINC.4
;#define air_ger  PINC.5
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#include <stdlib.h>
;#include <LPH9157-2.h>
;//********************Библиотека дисплея Siemens C75, МЕ75*******************
;//           	  	Зеленый текстолит LPH9157-2
;//             		     132х176 пикселей
;//                   		  v 1.1
;//                  Copyright (c) Кизим Игорь aka Igoryosha
;//			  Website : lobotryasy.net
;//***************************************************************************
;
;#include <delay.h>
;
;//*************************************************************
;//Команда/Данные
;#define CMD 0
;#define DAT 1
;char RS_old;
;//*************************************************************
;
;/* С помощью этой таблицы пиксели выводить сверху-вниз, слево-направо.
;Шрифт - 5х8 пикселей, разложен по кодам ASCII.
;Символы с кодами 0-31 и 128 - 191 отсутствуют за ненадобностью! */
;
;flash unsigned char font_5x8[][5]  = {
;0x00, 0x00, 0x00, 0x00, 0x00,// (space)  32
;0x00, 0x00, 0x5F, 0x00, 0x00,// !        33
;0x00, 0x07, 0x00, 0x07, 0x00,// "        34
;0x14, 0x7F, 0x14, 0x7F, 0x14,// #        35
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// $        36
;0x23, 0x13, 0x08, 0x64, 0x62,// %        37
;0x36, 0x49, 0x55, 0x22, 0x50,// &        38
;0x00, 0x05, 0x03, 0x00, 0x00,// '        39
;0x00, 0x1C, 0x22, 0x41, 0x00,// (        40
;0x00, 0x41, 0x22, 0x1C, 0x00,// )        41
;0x08, 0x2A, 0x1C, 0x2A, 0x08,// *        42
;0x08, 0x08, 0x3E, 0x08, 0x08,// +        43
;0x00, 0x50, 0x30, 0x00, 0x00,// ,        44
;0x08, 0x08, 0x08, 0x08, 0x08,// -        45
;0x00, 0x30, 0x30, 0x00, 0x00,// .        46
;0x20, 0x10, 0x08, 0x04, 0x02,// /        47
;0x3E, 0x51, 0x49, 0x45, 0x3E,// 0        48
;0x00, 0x42, 0x7F, 0x40, 0x00,// 1        49
;0x42, 0x61, 0x51, 0x49, 0x46,// 2        50
;0x21, 0x41, 0x45, 0x4B, 0x31,// 3        51
;0x18, 0x14, 0x12, 0x7F, 0x10,// 4        52
;0x27, 0x45, 0x45, 0x45, 0x39,// 5        53
;0x3C, 0x4A, 0x49, 0x49, 0x30,// 6        54
;0x01, 0x71, 0x09, 0x05, 0x03,// 7        55
;0x36, 0x49, 0x49, 0x49, 0x36,// 8        56
;0x06, 0x49, 0x49, 0x29, 0x1E,// 9        57
;0x00, 0x36, 0x36, 0x00, 0x00,// :        58
;0x00, 0x56, 0x36, 0x00, 0x00,// ;        59
;0x00, 0x08, 0x14, 0x22, 0x41,// <        60
;0x14, 0x14, 0x14, 0x14, 0x14,// =        61
;0x41, 0x22, 0x14, 0x08, 0x00,// >        62
;0x02, 0x01, 0x51, 0x09, 0x06,// ?        63
;0x32, 0x49, 0x79, 0x41, 0x3E,// @        64
;0x7E, 0x11, 0x11, 0x11, 0x7E,// A        65
;0x7F, 0x49, 0x49, 0x49, 0x36,// B        66
;0x3E, 0x41, 0x41, 0x41, 0x22,// C        67
;0x7F, 0x41, 0x41, 0x22, 0x1C,// D        68
;0x7F, 0x49, 0x49, 0x49, 0x41,// E        69
;0x7F, 0x09, 0x09, 0x01, 0x01,// F        70
;0x3E, 0x41, 0x41, 0x51, 0x32,// G        71
;0x7F, 0x08, 0x08, 0x08, 0x7F,// H        72
;0x00, 0x41, 0x7F, 0x41, 0x00,// I        73
;0x20, 0x40, 0x41, 0x3F, 0x01,// J        74
;0x7F, 0x08, 0x14, 0x22, 0x41,// K        75
;0x7F, 0x40, 0x40, 0x40, 0x40,// L        76
;0x7F, 0x02, 0x04, 0x02, 0x7F,// M        77
;0x7F, 0x04, 0x08, 0x10, 0x7F,// N        78
;0x3E, 0x41, 0x41, 0x41, 0x3E,// O        79
;0x7F, 0x09, 0x09, 0x09, 0x06,// P        80
;0x3E, 0x41, 0x51, 0x21, 0x5E,// Q        81
;0x7F, 0x09, 0x19, 0x29, 0x46,// R        82
;0x46, 0x49, 0x49, 0x49, 0x31,// S        83
;0x01, 0x01, 0x7F, 0x01, 0x01,// T        84
;0x3F, 0x40, 0x40, 0x40, 0x3F,// U        85
;0x1F, 0x20, 0x40, 0x20, 0x1F,// V        86
;0x7F, 0x20, 0x18, 0x20, 0x7F,// W        87
;0x63, 0x14, 0x08, 0x14, 0x63,// X        88
;0x03, 0x04, 0x78, 0x04, 0x03,// Y        89
;0x61, 0x51, 0x49, 0x45, 0x43,// Z        90
;0x00, 0x00, 0x7F, 0x41, 0x41,// [        91
;0x02, 0x04, 0x08, 0x10, 0x20,// "\"      92
;0x41, 0x41, 0x7F, 0x00, 0x00,// ]        93
;0x04, 0x02, 0x01, 0x02, 0x04,// ^        94
;0x40, 0x40, 0x40, 0x40, 0x40,// _        95
;0x00, 0x01, 0x02, 0x04, 0x00,// `        96
;0x20, 0x54, 0x54, 0x54, 0x78,// a        97
;0x7F, 0x48, 0x44, 0x44, 0x38,// b        98
;0x38, 0x44, 0x44, 0x44, 0x20,// c        99
;0x38, 0x44, 0x44, 0x48, 0x7F,// d        100
;0x38, 0x54, 0x54, 0x54, 0x18,// e        101
;0x08, 0x7E, 0x09, 0x01, 0x02,// f        102
;0x08, 0x14, 0x54, 0x54, 0x3C,// g        103
;0x7F, 0x08, 0x04, 0x04, 0x78,// h        104
;0x00, 0x44, 0x7D, 0x40, 0x00,// i        105
;0x20, 0x40, 0x44, 0x3D, 0x00,// j        106
;0x00, 0x7F, 0x10, 0x28, 0x44,// k        107
;0x00, 0x41, 0x7F, 0x40, 0x00,// l        108
;0x7C, 0x04, 0x18, 0x04, 0x78,// m        109
;0x7C, 0x08, 0x04, 0x04, 0x78,// n        110
;0x38, 0x44, 0x44, 0x44, 0x38,// o        111
;0x7C, 0x14, 0x14, 0x14, 0x08,// p        112
;0x08, 0x14, 0x14, 0x18, 0x7C,// q        113
;0x7C, 0x08, 0x04, 0x04, 0x08,// r        114
;0x48, 0x54, 0x54, 0x54, 0x20,// s        115
;0x04, 0x3F, 0x44, 0x40, 0x20,// t        116
;0x3C, 0x40, 0x40, 0x20, 0x7C,// u        117
;0x1C, 0x20, 0x40, 0x20, 0x1C,// v        118
;0x3C, 0x40, 0x30, 0x40, 0x3C,// w        119
;0x44, 0x28, 0x10, 0x28, 0x44,// x        120
;0x0C, 0x50, 0x50, 0x50, 0x3C,// y        121
;0x44, 0x64, 0x54, 0x4C, 0x44,// z        122
;0x00, 0x08, 0x36, 0x41, 0x00,// {        123
;0x00, 0x00, 0x7F, 0x00, 0x00,// |        124
;0x00, 0x41, 0x36, 0x08, 0x00,// }        125
;0x00, 0x00, 0x00, 0x00, 0x00,// (space)  126
;0x00, 0x00, 0x00, 0x00, 0x00,// (space)  127
;0x7E, 0x11, 0x11, 0x11, 0x7E,// A        192
;0x7F, 0x45, 0x45, 0x45, 0x39,// Б        193
;0x7F, 0x49, 0x49, 0x49, 0x36,// B        194
;0x7F, 0x01, 0x01, 0x01, 0x03,// Г        195
;0xC0, 0x7E, 0x41, 0x7F, 0xC0,// Д        196
;0x7F, 0x49, 0x49, 0x49, 0x41,// E        197
;119,8,127,8,119,             // Ж        198
;34,73,73,73,54,              // З        199
;127,32,16,8,127,             // И        200
;127,32,19,8,127,             // Й        201
;0x7F, 0x08, 0x14, 0x22, 0x41,// K        202
;64,62,1,1,127,               // Л        203
;0x7F, 0x02, 0x04, 0x02, 0x7F,// M        204
;0x7F, 0x08, 0x08, 0x08, 0x7F,// H        205
;0x3E, 0x41, 0x41, 0x41, 0x3E,// O        206
;127,1,1,1,127,               // П        207
;0x7F, 0x09, 0x09, 0x09, 0x06,// P        208
;0x3E, 0x41, 0x41, 0x41, 0x22,// C        209
;0x01, 0x01, 0x7F, 0x01, 0x01,// T        210
;39,72,72,72,63,              // У        211
;30,33,127,33,30,             // Ф        212
;0x63, 0x14, 0x08, 0x14, 0x63,// X        213
;127,64,64,127,192,           // Ц        214
;15,16,16,16,127,             // Ч        215
;127,64,124,64,127,           // Ш        216
;127,64,124,64,255,           // Щ        217
;1,127,72,72,48,              // Ъ        218
;127,72,48,0,127,             // Ы        219
;127,72,72,72,48,             // Ь        220
;34,73,73,73,62,              // Э        221
;127,8,62,65,62,              // Ю        222
;118,9,9,9,127,               // Я        223
;0x20, 0x54, 0x54, 0x54, 0x78,// a        224
;124, 84, 84, 84, 36,         // б        225
;124, 84, 84, 84, 40,         // в        226
;124, 4, 4, 4, 12,            // г        227
;192, 120, 68, 124, 192,      // д        228
;0x38, 0x54, 0x54, 0x54, 0x18,// e        229
;108, 16, 124, 16, 108,       // ж        230
;40, 68, 84, 84, 40,          // з        231
;124, 32, 16, 8, 124,         // и        232
;124, 33, 18, 8, 124,         // й        233
;124, 16, 16, 40, 68,         // к        234
;64, 56, 4, 4, 124,           // л        235
;124, 8, 16, 8, 124,          // м        236
;124, 16, 16, 16, 124,        // н        237
;0x38, 0x44, 0x44, 0x44, 0x38,// o        238
;124, 4, 4, 4, 124,           // п        239
;0x7C, 0x14, 0x14, 0x14, 0x08,// p        240
;0x38, 0x44, 0x44, 0x44, 0x20,// c        241
;4, 4, 124, 4, 4,             // т        242
;0x0C, 0x50, 0x50, 0x50, 0x3C,// y        243
;24, 36, 124, 36, 24,         // ф        244
;0x44, 0x28, 0x10, 0x28, 0x44,// x        245
;124, 64, 64, 124, 192,       // ц        246
;12, 16, 16, 16, 124,         // ч        247
;124, 64, 120, 64, 124,       // ш        248
;124, 64, 120, 64, 252,       // щ        249
;124, 84, 80, 80, 32,         // ъ        250
;124,80,32,0,124,             // ы        251
;124, 80, 80, 80, 32,         // ь        252
;40, 68, 84, 84, 56,          // э        253
;124, 16, 56, 68, 56,         // ю        254
;72, 52, 20, 20, 124          // я        255
;};
;
;#ifdef _USE_SOFT_SPI
;//===============================================================
;//			        Программный SPI
;//===============================================================
;void Send_spi(unsigned char data)
; 0000 0045 {

	.CSEG
_Send_spi:
; .FSTART _Send_spi
;
;    ClearBit(LCD_PORT, LCD_DATA);
	ST   -Y,R26
;	data -> Y+0
	RCALL SUBOPT_0x0
;    if ((data & 128) == 128)   SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x3
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0x3:
	RCALL SUBOPT_0x1
;    ClearBit(LCD_PORT, LCD_CLK);
;    ClearBit(LCD_PORT, LCD_DATA);
;    if ((data & 64) == 64) SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x40)
	CPI  R30,LOW(0x40)
	BRNE _0x4
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0x4:
	RCALL SUBOPT_0x1
;    ClearBit(LCD_PORT, LCD_CLK);
;    ClearBit(LCD_PORT, LCD_DATA);
;    if ((data & 32) == 32) SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x20)
	CPI  R30,LOW(0x20)
	BRNE _0x5
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0x5:
	RCALL SUBOPT_0x1
;    ClearBit(LCD_PORT, LCD_CLK);
;    ClearBit(LCD_PORT, LCD_DATA);
;    if ((data & 16) ==16)  SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x10)
	BRNE _0x6
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0x6:
	RCALL SUBOPT_0x1
;    ClearBit(LCD_PORT, LCD_CLK);
;    ClearBit(LCD_PORT, LCD_DATA);
;    if ((data & 8) == 8)   SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x8)
	CPI  R30,LOW(0x8)
	BRNE _0x7
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0x7:
	RCALL SUBOPT_0x1
;    ClearBit(LCD_PORT, LCD_CLK);
;    ClearBit(LCD_PORT, LCD_DATA);
;    if ((data & 4) == 4)   SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x4)
	CPI  R30,LOW(0x4)
	BRNE _0x8
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0x8:
	RCALL SUBOPT_0x1
;    ClearBit(LCD_PORT, LCD_CLK);
;    ClearBit(LCD_PORT, LCD_DATA);
;    if ((data & 2) == 2)   SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x2)
	CPI  R30,LOW(0x2)
	BRNE _0x9
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0x9:
	RCALL SUBOPT_0x1
;    ClearBit(LCD_PORT, LCD_CLK);
;    ClearBit(LCD_PORT, LCD_DATA);
;    if ((data & 1) == 1)   SetBit(LCD_PORT, LCD_DATA);
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0xA
	SBI  0x12,7
;    SetBit(LCD_PORT, LCD_CLK);
_0xA:
	SBI  0x12,6
;    ClearBit(LCD_PORT, LCD_CLK);
	CBI  0x12,6
;}
	RJMP _0x20A0003
; .FEND
;
;#else // _USE_SOFT_SPI
;//===============================================================
;//			            Аппаратный SPI
;//===============================================================
;//void Send_spi(unsigned char data)
;//{
;//	//Частота сигнала SCK: Fкварца/16
;//    SPCR = (0<<SPIE)|(1<<SPE)|(0<<DORD)|(1<<MSTR)|(0<<CPOL)|(0<<CPHA)|(0<<SPR1)|(1<<SPR0);
;//    SPDR = data;
;//    while(!(SPSR & (1<<SPIF)));
;//    SPCR = 0;
;//}
;
;#endif // _USE_SOFT_SPI
;
;//===============================================================
;//Функция записи команды/данных в LCD (RS==0 - команда, RS==1 - данные)
;//===============================================================
;void Send_to_lcd (unsigned char RS, unsigned char data)
;{
_Send_to_lcd:
; .FSTART _Send_to_lcd
;    ClearBit(LCD_PORT, LCD_CLK);
	ST   -Y,R26
;	RS -> Y+1
;	data -> Y+0
	CBI  0x12,6
;    ClearBit(LCD_PORT, LCD_DATA);
	CBI  0x12,7
;    if ((RS_old != RS) || (!RS_old && !RS)) //Проверяем старое значение RS
	LDD  R30,Y+1
	CP   R30,R7
	BRNE _0xC
	TST  R7
	BRNE _0xD
	RCALL SUBOPT_0x2
	BREQ _0xC
_0xD:
	RJMP _0xB
_0xC:
;    {
;        SetBit(LCD_PORT, LCD_CS);	// Установка CS
	SBI  0x12,5
;        if(RS)    SetBit(LCD_PORT, LCD_RS);
	RCALL SUBOPT_0x2
	BREQ _0x10
	SBI  0x12,4
;        else      ClearBit(LCD_PORT, LCD_RS);
	RJMP _0x11
_0x10:
	CBI  0x12,4
;        ClearBit(LCD_PORT, LCD_CS);	// Сброс CS
_0x11:
	CBI  0x12,5
;    }
;
;    Send_spi (data);
_0xB:
	LD   R26,Y
	RCALL _Send_spi
;
;    RS_old=RS;  //запоминаем значение RS
	LDD  R7,Y+1
;    ClearBit(LCD_PORT, LCD_DATA);
	CBI  0x12,7
;}
	RJMP _0x20A0006
; .FEND
;
;//===============================================================
;//                        ИНИЦИАЛИЗАЦИЯ
;//===============================================================
;void LCD_init(void)
;{
_LCD_init:
; .FSTART _LCD_init
; Init_Port();
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	OUT  0x11,R30
; ClearBit(LCD_PORT, LCD_RESET);
	CBI  0x12,3
; delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; SetBit(LCD_PORT, LCD_RESET);
	SBI  0x12,3
; delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL SUBOPT_0x3
; Send_to_lcd(CMD, 0x01); //Программный сброс
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x4
; Send_to_lcd(CMD, 0x36); //Memory Access Control (Направление заполнения области дисплея (памяти): 0bVHRXXXXX, V - запол ...
	LDI  R26,LOW(54)
	RCALL SUBOPT_0x5
;                         //H - заполнение по горизонтали (0 - слева-направо, 1 - справа-налево), R - меняются местами ст ...
; Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x4
; Send_to_lcd(CMD, 0x11); //Выход из спящего режима
	LDI  R26,LOW(17)
	RCALL SUBOPT_0x6
; delay_ms(20);
; Send_to_lcd(CMD, 0x3a); //Установка цветовой палитры
	LDI  R26,LOW(58)
	RCALL SUBOPT_0x5
; #ifdef _8_BIT_COLOR
; Send_to_lcd(DAT, 0x02); //Байт на пиксель 256 цветов
; #else
; Send_to_lcd(DAT, 0x05); //Два байта на пиксель 65536 цветов
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x6
; #endif
; delay_ms(20);
; Send_to_lcd(CMD, 0x29); //Включение дисплея
	LDI  R26,LOW(41)
	RCALL _Send_to_lcd
;}
	RET
; .FEND
;
;//===============================================================
;//         Задание угла поворота экрана
;//===============================================================
;void SetRotation (unsigned int angle)
;{
_SetRotation:
; .FSTART _SetRotation
;    rot=angle;
	RCALL SUBOPT_0x7
;	angle -> Y+0
	__GETWRS 4,5,0
;    Send_to_lcd(CMD, 0x36);
	RCALL SUBOPT_0x8
	LDI  R26,LOW(54)
	RCALL _Send_to_lcd
;    switch (rot)
	MOVW R30,R4
;    {
;        case 0:
	SBIW R30,0
	BRNE _0x15
;        Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея
	RCALL SUBOPT_0x9
	LDI  R26,LOW(0)
	RJMP _0x177
;        break;
;        //================================
;        case 90:
_0x15:
	RCALL SUBOPT_0xA
	BRNE _0x16
;        Send_to_lcd(DAT, 0x40); //Начальный адрес осей Х и У - правый верхний угол дисплея
	RCALL SUBOPT_0x9
	LDI  R26,LOW(64)
	RJMP _0x177
;        break;
;        //================================
;        case 180:
_0x16:
	RCALL SUBOPT_0xB
	BRNE _0x17
;        Send_to_lcd(DAT, 0xC0); //Начальный адрес осей Х и У - правый нижний угол дисплея
	RCALL SUBOPT_0x9
	LDI  R26,LOW(192)
	RJMP _0x177
;        break;
;        //================================
;        case 270:
_0x17:
	RCALL SUBOPT_0xC
	BRNE _0x14
;        Send_to_lcd(DAT, 0x80); //Начальный адрес осей Х и У - левый нижний угол дисплея
	RCALL SUBOPT_0x9
	LDI  R26,LOW(128)
_0x177:
	RCALL _Send_to_lcd
;        break;
;        //================================
;    };
_0x14:
;}
_0x20A0006:
	ADIW R28,2
	RET
; .FEND
;
;//===============================================================
;//              Задание прямоугольной области экрана
;//===============================================================
;void SetArea(char x1, char x2, char y1, char y2)
;{
_SetArea:
; .FSTART _SetArea
;    Send_to_lcd( CMD, 0x2A );  //задаем область по X
	ST   -Y,R26
;	x1 -> Y+3
;	x2 -> Y+2
;	y1 -> Y+1
;	y2 -> Y+0
	RCALL SUBOPT_0x8
	LDI  R26,LOW(42)
	RCALL SUBOPT_0x5
;    Send_to_lcd( DAT, x1 );    //начальная
	LDD  R26,Y+4
	RCALL SUBOPT_0x5
;    Send_to_lcd( DAT, x2 );    //конечная
	LDD  R26,Y+3
	RCALL SUBOPT_0x4
;
;    Send_to_lcd( CMD, 0x2B );  //задаем область по Y
	LDI  R26,LOW(43)
	RCALL SUBOPT_0x5
;    Send_to_lcd( DAT, y1 );    //начальная
	LDD  R26,Y+2
	RCALL SUBOPT_0x5
;    Send_to_lcd( DAT, y2 );    //конечная
	LDD  R26,Y+1
	RCALL SUBOPT_0x4
;
;    Send_to_lcd( CMD, 0x2C );  //отправляем команду на начало записи в память и начинаем посылать данные
	LDI  R26,LOW(44)
	RCALL _Send_to_lcd
;}
	RJMP _0x20A0005
; .FEND
;
;//===============================================================
;//                        Рисуем точку
;//===============================================================
;void Put_Pixel (char x, char y, unsigned int color)
;{
_Put_Pixel:
; .FSTART _Put_Pixel
;    SetArea( x, x, y, y );
	RCALL SUBOPT_0x7
;	x -> Y+3
;	y -> Y+2
;	color -> Y+0
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _SetArea
;    SetBit(LCD_PORT, LCD_RS); //Передаются данные
	SBI  0x12,4
;
;    #ifdef _8_BIT_COLOR		//(8-ми битовая цветовая палитра (256 цветов))
;    Send_to_lcd( DAT, color );	//Данные - задаём цвет пикселя
;    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
;    Send_to_lcd( DAT, (color >> 8) );
	RCALL SUBOPT_0x9
	LDD  R26,Y+2
	RCALL SUBOPT_0x5
;    Send_to_lcd( DAT, color );
	LDD  R26,Y+1
	RCALL _Send_to_lcd
;    #endif
;}
	RJMP _0x20A0005
; .FEND
;
;//===============================================================
;//           Функция прорисовки символа на дисплее
;//===============================================================
;void Send_Symbol (unsigned char symbol, char x, char y, int t_color, int b_color, char zoom_width, char zoom_height)
;{
_Send_Symbol:
; .FSTART _Send_Symbol
; unsigned char temp_symbol, a, b, zw, zh, mask;
;
; if (symbol>127) symbol-=64;    //Убираем отсутствующую часть таблицы ASCII
	ST   -Y,R26
	RCALL __SAVELOCR6
;	symbol -> Y+14
;	x -> Y+13
;	y -> Y+12
;	t_color -> Y+10
;	b_color -> Y+8
;	zoom_width -> Y+7
;	zoom_height -> Y+6
;	temp_symbol -> R17
;	a -> R16
;	b -> R19
;	zw -> R18
;	zh -> R21
;	mask -> R20
	LDD  R26,Y+14
	CPI  R26,LOW(0x80)
	BRLO _0x19
	LDD  R30,Y+14
	SUBI R30,LOW(64)
	STD  Y+14,R30
; for ( a = 0; a < 5; a++) //Перебираю 5 байт, составляющих символ
_0x19:
	LDI  R16,LOW(0)
_0x1B:
	CPI  R16,5
	BRLO PC+2
	RJMP _0x1C
; {
;    temp_symbol = font_5x8[symbol-32][a];
	LDD  R30,Y+14
	LDI  R31,0
	SBIW R30,32
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL __MULW12U
	SUBI R30,LOW(-_font_5x8*2)
	SBCI R31,HIGH(-_font_5x8*2)
	MOVW R26,R30
	MOV  R30,R16
	RCALL SUBOPT_0xD
	LPM  R17,Z
;    zw = 0;
	LDI  R18,LOW(0)
;    while(zw != zoom_width) //Вывод байта выполняется zw раз
_0x1D:
	LDD  R30,Y+7
	CP   R30,R18
	BRNE PC+2
	RJMP _0x1F
;    {
;        mask=0x01;
	LDI  R20,LOW(1)
;        switch(rot)
	MOVW R30,R4
;        {
;            case 0: case 180: SetArea( x+zw, x+zw, y, y+(zoom_height*8)-1 ); break;
	SBIW R30,0
	BREQ _0x24
	RCALL SUBOPT_0xB
	BRNE _0x25
_0x24:
	MOV  R30,R18
	LDD  R26,Y+13
	RCALL SUBOPT_0xE
	MOV  R30,R18
	LDD  R26,Y+14
	RCALL SUBOPT_0xE
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LSL  R30
	LSL  R30
	LSL  R30
	LDD  R26,Y+15
	ADD  R26,R30
	SUBI R26,LOW(1)
	RJMP _0x178
;            case 90: case 270: SetArea( x, x+(zoom_height*8)-1, y+zw, y+zw ); break;
_0x25:
	RCALL SUBOPT_0xA
	BREQ _0x27
	RCALL SUBOPT_0xC
	BRNE _0x22
_0x27:
	LDD  R30,Y+13
	ST   -Y,R30
	LDD  R30,Y+7
	LSL  R30
	LSL  R30
	LSL  R30
	LDD  R26,Y+14
	ADD  R26,R30
	SUBI R26,LOW(1)
	ST   -Y,R26
	MOV  R30,R18
	LDD  R26,Y+14
	RCALL SUBOPT_0xE
	MOV  R30,R18
	LDD  R26,Y+15
	ADD  R26,R30
_0x178:
	RCALL _SetArea
;        }
_0x22:
;        SetBit(LCD_PORT, LCD_RS); //Передаются данные
	SBI  0x12,4
;        for ( b = 0; b < 8; b++ ) //Цикл перебирания 8 бит байта
	LDI  R19,LOW(0)
_0x2A:
	CPI  R19,8
	BRSH _0x2B
;        {
;            zh = zoom_height; //в zoom_height раз увеличится высота символа
	LDD  R21,Y+6
;            while(zh != 0) //Вывод пикселя выполняется z раз
_0x2C:
	CPI  R21,0
	BREQ _0x2E
;            {
;                if (temp_symbol&mask)
	MOV  R30,R20
	AND  R30,R17
	BREQ _0x2F
;                {
;                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;                    Send_to_lcd( DAT, t_color ); //Данные - задаём цвет пикселя
;                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
;                    Send_to_lcd( DAT, (t_color >> 8) ); Send_to_lcd( DAT, t_color );
	RCALL SUBOPT_0x9
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	RCALL __ASRW8
	MOV  R26,R30
	RCALL SUBOPT_0x5
	LDD  R26,Y+11
	RJMP _0x179
;                    #endif
;                }
;                else
_0x2F:
;               {
;                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;                    Send_to_lcd( DAT, b_color ); //Данные - задаём цвет пикселя
;                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
;                    Send_to_lcd( DAT, (b_color >> 8) ); Send_to_lcd( DAT, b_color );
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xF
	RCALL __ASRW8
	MOV  R26,R30
	RCALL SUBOPT_0x5
	LDD  R26,Y+9
_0x179:
	RCALL _Send_to_lcd
;                    #endif
;                }
;                zh--;
	SUBI R21,1
;            }
	RJMP _0x2C
_0x2E:
;            mask<<=1; //Смещаю содержимое mask на 1 бит влево;
	LSL  R20
;        }
	SUBI R19,-1
	RJMP _0x2A
_0x2B:
;        zw++;
	SUBI R18,-1
;    }
	RJMP _0x1D
_0x1F:
;  switch(rot)
	MOVW R30,R4
;  {
;   case 0: case 180: x=x+zoom_width;  break; //Получить адрес начального пикселя по оси x для вывода очередного байта
	SBIW R30,0
	BREQ _0x35
	RCALL SUBOPT_0xB
	BRNE _0x36
_0x35:
	LDD  R30,Y+7
	LDD  R26,Y+13
	ADD  R30,R26
	STD  Y+13,R30
	RJMP _0x33
;   case 90: case 270: y=y+zoom_width; break; //Получить адрес начального пикселя по оси y для вывода очередного байта
_0x36:
	RCALL SUBOPT_0xA
	BREQ _0x38
	RCALL SUBOPT_0xC
	BRNE _0x33
_0x38:
	LDD  R30,Y+7
	LDD  R26,Y+12
	ADD  R30,R26
	STD  Y+12,R30
;  }
_0x33:
; }
	SUBI R16,-1
	RJMP _0x1B
_0x1C:
;}
	RCALL __LOADLOCR6
	ADIW R28,15
	RET
; .FEND
;
;//===============================================================
;// Функция вывода одного символа ASCII-кода
;//===============================================================
;void LCD_Putchar(char symbol, char x, char y, int t_color, int b_color, char zoom_width, char zoom_height)
;{
_LCD_Putchar:
; .FSTART _LCD_Putchar
;    unsigned char m;
;    if(zoom_width == 0)   zoom_width = 1;
	ST   -Y,R26
	ST   -Y,R17
;	symbol -> Y+9
;	x -> Y+8
;	y -> Y+7
;	t_color -> Y+5
;	b_color -> Y+3
;	zoom_width -> Y+2
;	zoom_height -> Y+1
;	m -> R17
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x3A
	LDI  R30,LOW(1)
	STD  Y+2,R30
;    if(zoom_height == 0)  zoom_height = 1;
_0x3A:
	RCALL SUBOPT_0x2
	BRNE _0x3B
	LDI  R30,LOW(1)
	STD  Y+1,R30
;    switch (rot)
_0x3B:
	MOVW R30,R4
;    {
;        case 90: case 270:  m=y; y=x; x=m;
	RCALL SUBOPT_0xA
	BREQ _0x40
	RCALL SUBOPT_0xC
	BRNE _0x3E
_0x40:
	LDD  R17,Y+7
	LDD  R30,Y+8
	STD  Y+7,R30
	__PUTBSR 17,8
;                            break;
;    };
_0x3E:
;    Send_Symbol( symbol, x, y, t_color, b_color, zoom_width, zoom_height);
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x10
	LDD  R26,Y+9
	RCALL _Send_Symbol
;}
	LDD  R17,Y+0
	ADIW R28,10
	RET
; .FEND
;
;//===============================================================
;//          Функция вывода строки, расположенной в ram
;//===============================================================
;void LCD_Puts(char *str, int x, int y,  int t_color, int b_color, char zoom_width, char zoom_height)
;{
_LCD_Puts:
; .FSTART _LCD_Puts
;    unsigned char i=0;
;
;    if(zoom_width == 0)   zoom_width = 1;
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+11
;	x -> Y+9
;	y -> Y+7
;	t_color -> Y+5
;	b_color -> Y+3
;	zoom_width -> Y+2
;	zoom_height -> Y+1
;	i -> R17
	LDI  R17,0
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x42
	LDI  R30,LOW(1)
	STD  Y+2,R30
;    if(zoom_height == 0)  zoom_height = 1;
_0x42:
	RCALL SUBOPT_0x2
	BRNE _0x43
	LDI  R30,LOW(1)
	STD  Y+1,R30
;
;    while (str[i]) //x и y - адрес пикселя начальной позиции; с увеличением переменной i адрес вывода очередного символа ...
_0x43:
_0x44:
	RCALL SUBOPT_0x12
	CPI  R30,0
	BREQ _0x46
;    {
;        LCD_Putchar(str[i], x+(i*6*zoom_width), y, t_color, b_color, zoom_width, zoom_height);
	RCALL SUBOPT_0x12
	ST   -Y,R30
	LDI  R26,LOW(6)
	MULS R17,R26
	MOVW R30,R0
	LDD  R26,Y+3
	MULS R30,R26
	MOVW R30,R0
	LDD  R26,Y+10
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x10
	LDD  R26,Y+9
	RCALL _LCD_Putchar
;        i++;
	SUBI R17,-1
;    }
	RJMP _0x44
_0x46:
;}
	LDD  R17,Y+0
	ADIW R28,13
	RET
; .FEND
;
;//===============================================================
;//          Функция вывода строки, расположенной во flash
;//===============================================================
;void LCD_Putsf(flash char *str, int x, int y,  int t_color, int b_color, char zoom_width, char zoom_height)
;{
; unsigned char i=0;
;
; if(zoom_width == 0)   zoom_width = 1;
;	*str -> Y+11
;	x -> Y+9
;	y -> Y+7
;	t_color -> Y+5
;	b_color -> Y+3
;	zoom_width -> Y+2
;	zoom_height -> Y+1
;	i -> R17
; if(zoom_height == 0)  zoom_height = 1;
;
; while (str[i]) //x и y - адрес пикселя начальной позиции; с увеличением переменной i адрес вывода очередного символа см ...
; {
;  LCD_Putchar(str[i], x+(i*6*zoom_width), y, t_color, b_color, zoom_width, zoom_height);
;  i++;
; }
;}
;
;//===============================================================
;//     Функция прорисовки символа на дисплее без цвета фона
;//===============================================================
;void Send_Symbol_Shadow (unsigned char symbol, char x, char y, int t_color, char zoom_width, char zoom_height)
;{
; unsigned char temp_symbol, a, b, zw, zh, mask;
; char m, n;
; m=x;
;	symbol -> Y+14
;	x -> Y+13
;	y -> Y+12
;	t_color -> Y+10
;	zoom_width -> Y+9
;	zoom_height -> Y+8
;	temp_symbol -> R17
;	a -> R16
;	b -> R19
;	zw -> R18
;	zh -> R21
;	mask -> R20
;	m -> Y+7
;	n -> Y+6
; n=y;
; if (symbol>127) symbol-=64;    //Убираем отсутствующую часть таблицы ASCII
; for ( a = 0; a < 5; a++) //Перебираю 5 байт, составляющих символ
; {
;  temp_symbol = font_5x8[symbol-32][a];
;  zw = 0;
;  while(zw != zoom_width) //Вывод байта выполняется zw раз
;  {
;   switch(rot)
;   {
;    case 0: case 180: n=y; break;
;    case 90: case 270: m=x; break;
;   }
;   mask=0x01;
;   for ( b = 0; b < 8; b++ ) //Цикл перебирания 8 бит байта
;   {
;    zh = 0; //в zoom_height раз увеличится высота символа
;    while(zh != zoom_height) //Вывод пикселя выполняется z раз
;    {
;     switch(rot)
;     {
;      case 0: case 180:
;      if (temp_symbol&mask)
;      {
;       Put_Pixel (m+zw, n+zh, t_color);
;      }
;      break;
;      case 90: case 270:
;      if (temp_symbol&mask)
;      {
;       Put_Pixel (m+zh, n+zw, t_color);
;      }
;      break; //Получить адрес начального пикселя по оси y для вывода очередного байта
;     }
;     zh++;
;    }
;    mask<<=1; //Смещаю содержимое mask на 1 бит влево;
;    switch(rot)
;    {
;     case 0: case 180: n=n+zoom_height; break;
;     case 90: case 270: m=m+zoom_height; break;
;    }
;   }
;   zw++;
;  }
;  switch(rot)
;  {
;   case 0: case 180: m=m+zoom_width; break;
;   case 90: case 270: n=n+zoom_width; break;
;  }
; }
;}
;
;//===============================================================
;// Функция вывода одного символа ASCII-кода без цвета фона
;//===============================================================
;void LCD_Putchar_Shadow (char symbol, char x, char y, int t_color, char zoom_width, char zoom_height)
;{
; unsigned char m;
; if(zoom_width == 0)   zoom_width = 1;
;	symbol -> Y+7
;	x -> Y+6
;	y -> Y+5
;	t_color -> Y+3
;	zoom_width -> Y+2
;	zoom_height -> Y+1
;	m -> R17
; if(zoom_height == 0)  zoom_height = 1;
; switch (rot)
; {
;    case 90: case 270:  m=y; y=x; x=m;
;                        break;
; };
; Send_Symbol_Shadow( symbol, x, y, t_color, zoom_width, zoom_height);
;}
;
;//===============================================================
;//   Функция вывода строки, расположенной в ram без цвета фона
;//===============================================================
;void LCD_Puts_Shadow(char *str, int x, int y,  int t_color, char zoom_width, char zoom_height)
;{
; unsigned char i=0;
;
; if(zoom_width == 0)   zoom_width = 1;
;	*str -> Y+9
;	x -> Y+7
;	y -> Y+5
;	t_color -> Y+3
;	zoom_width -> Y+2
;	zoom_height -> Y+1
;	i -> R17
; if(zoom_height == 0)  zoom_height = 1;
;
; while (str[i]) //x и y - адрес пикселя начальной позиции; с увеличением переменной i адрес вывода очередного символа см ...
; {
;  LCD_Putchar_Shadow(str[i], x+(i*6*zoom_width), y, t_color, zoom_width, zoom_height);
;  i++;
; }
;}
;
;//===============================================================
;// Функция вывода строки, расположенной во flash без цвета фона
;//===============================================================
;void LCD_Putsf_Shadow(flash char *str, int x, int y,  int t_color, char zoom_width, char zoom_height)
;{
; unsigned char i=0;
;
; if(zoom_width == 0)   zoom_width = 1;
;	*str -> Y+9
;	x -> Y+7
;	y -> Y+5
;	t_color -> Y+3
;	zoom_width -> Y+2
;	zoom_height -> Y+1
;	i -> R17
; if(zoom_height == 0)  zoom_height = 1;
;
; while (str[i])
; {
;  LCD_Putchar_Shadow(str[i], x+(i*6*zoom_width), y, t_color, zoom_width, zoom_height);
;  i++;
; }
;}
;
;//===============================================================
;//                  ЗАЛИВКА ЭКРАНА ЦВЕТОМ
;//===============================================================
;void LCD_FillScreen (unsigned int color)
;{
_LCD_FillScreen:
; .FSTART _LCD_FillScreen
; unsigned int x;
; SetArea( 0, 131, 0, 175 );   //Область всего экрана
	RCALL SUBOPT_0x7
	RCALL __SAVELOCR2
;	color -> Y+2
;	x -> R16,R17
	RCALL SUBOPT_0x8
	LDI  R30,LOW(131)
	ST   -Y,R30
	RCALL SUBOPT_0x8
	LDI  R26,LOW(175)
	RCALL _SetArea
; SetBit(LCD_PORT, LCD_RS);
	SBI  0x12,4
;
; //Данные - задаём цвет пикселя
; for (x = 0; x < 132*176; x++)
	__GETWRN 16,17,0
_0x92:
	__CPWRN 16,17,23232
	BRSH _0x93
; {
;  #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;  Send_to_lcd( DAT, color ); //Данные - задаём цвет пикселя
;  #else			//(16-ти битовая цветовая палитра (65536 цветов))
;  Send_to_lcd( DAT, (color >> 8) ); Send_to_lcd( DAT, color );
	RCALL SUBOPT_0x9
	LDD  R26,Y+4
	RCALL SUBOPT_0x5
	LDD  R26,Y+3
	RCALL _Send_to_lcd
;  #endif
; }
	__ADDWRN 16,17,1
	RJMP _0x92
_0x93:
;}
	RCALL __LOADLOCR2
_0x20A0005:
	ADIW R28,4
	RET
; .FEND
;
;//===============================================================
;//                 ФУНКЦИЯ ВЫВОДА ИЗОБРАЖЕНИЯ
;//===============================================================
;void LCD_Output_image (char x, char y, char width, char height, flash char *img)
;{
; unsigned char m;
; switch (rot)
;	x -> Y+6
;	y -> Y+5
;	width -> Y+4
;	height -> Y+3
;	*img -> Y+1
;	m -> R17
; {
;    case 90: case 270:  m=y; y=x; x=m;
;                        break;
; };
; Send_Image (x, y, width, height, img);
;}
;
;//===============================================================
;//          Функция для обеспечения вывода изображения
;//===============================================================
;//Вывод картинки с Image2Lcd и NokiaImageCreator должен выполняться слева-направо сверху-вниз.
;//x, y - начало области вывода изображения; width и height - ширина и высота изображения
;void Send_Image (char x, char y, char width, char height, flash char *img)
;{
; char x1, y1;
;
; switch (rot)
;	x -> Y+7
;	y -> Y+6
;	width -> Y+5
;	height -> Y+4
;	*img -> Y+2
;	x1 -> R17
;	y1 -> R16
; {
;  case 0: case 180:
;  for(y1=y; y1<(y+height); y1++)
;  {
;   SetArea( x, x+(width-1), y1, y1 );
;   for(x1=x; x1<x+width; x1++)
;   {
;    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;    Send_to_lcd( DAT, *img++ ); //Данные - задаём цвет пикселя
;    #else			//(16-ти битовая цветовая палитра (65536 цветов))
;    Send_to_lcd( DAT, *img++ ); Send_to_lcd( DAT, *img++ );
;    #endif
;   }
;  }
;  break;
;
;  case 90: case 270:
;  for(x1=x; x1<x+height; x1++)
;  {
;   SetArea( x1, x1, y, y+(width-1) );
;   for(y1=y; y1<y+width; y1++)
;   {
;    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;    Send_to_lcd( DAT, *img++ ); //Данные - задаём цвет пикселя
;    #else			//(16-ти битовая цветовая палитра (65536 цветов))
;    Send_to_lcd( DAT, *img++ ); Send_to_lcd( DAT, *img++ );
;    #endif
;   }
;  }
;  break;
; };
;}
;
;#ifdef _GEOMETRICAL
;//===============================================================
;//                      НАРИСОВАТЬ ЛИНИЮ
;//===============================================================
;void LCD_DrawLine (char x1, char y1, char x2, char y2, int color)
;{
_LCD_DrawLine:
; .FSTART _LCD_DrawLine
; short  x, y, d, dx, dy, i, i1, i2, kx, ky;
; signed char flag;
; unsigned char m;
;
; switch (rot)
	RCALL SUBOPT_0x7
	SBIW R28,16
	RCALL __SAVELOCR6
;	x1 -> Y+27
;	y1 -> Y+26
;	x2 -> Y+25
;	y2 -> Y+24
;	color -> Y+22
;	x -> R16,R17
;	y -> R18,R19
;	d -> R20,R21
;	dx -> Y+20
;	dy -> Y+18
;	i -> Y+16
;	i1 -> Y+14
;	i2 -> Y+12
;	kx -> Y+10
;	ky -> Y+8
;	flag -> Y+7
;	m -> Y+6
	MOVW R30,R4
; {
;    case 90: case 270:  m=y1; y1=x1; x1=m; m=y2; y2=x2; x2=m;
	RCALL SUBOPT_0xA
	BREQ _0xB3
	RCALL SUBOPT_0xC
	BRNE _0xB1
_0xB3:
	LDD  R30,Y+26
	STD  Y+6,R30
	LDD  R30,Y+27
	STD  Y+26,R30
	LDD  R30,Y+6
	STD  Y+27,R30
	LDD  R30,Y+24
	STD  Y+6,R30
	LDD  R30,Y+25
	STD  Y+24,R30
	LDD  R30,Y+6
	STD  Y+25,R30
;                        break;
; };
_0xB1:
;
; dx = x2 - x1;
	LDD  R26,Y+25
	CLR  R27
	LDD  R30,Y+27
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+20,R26
	STD  Y+20+1,R27
; dy = y2 - y1;
	LDD  R26,Y+24
	CLR  R27
	LDD  R30,Y+26
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+18,R26
	STD  Y+18+1,R27
; if (dx == 0 && dy == 0) Put_Pixel(x1, y1, color);  //Точка
	RCALL SUBOPT_0x13
	SBIW R26,0
	BRNE _0xB6
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SBIW R26,0
	BREQ _0xB7
_0xB6:
	RJMP _0xB5
_0xB7:
	LDD  R30,Y+27
	ST   -Y,R30
	LDD  R30,Y+27
	ST   -Y,R30
	RJMP _0x17A
; else      //Линия
_0xB5:
; {
;  kx = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x14
;  ky = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
;  if( dx < 0 )
	LDD  R26,Y+21
	TST  R26
	BRPL _0xB9
;  {
;   dx = -dx;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RCALL __ANEGW1
	STD  Y+20,R30
	STD  Y+20+1,R31
;   kx = -1;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x14
;  }
;  else
	RJMP _0xBA
_0xB9:
;  if(dx == 0) kx = 0;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	SBIW R30,0
	BRNE _0xBB
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
;  if(dy < 0)
_0xBB:
_0xBA:
	LDD  R26,Y+19
	TST  R26
	BRPL _0xBC
;  {
;   dy = -dy;
	RCALL SUBOPT_0x16
	RCALL __ANEGW1
	STD  Y+18,R30
	STD  Y+18+1,R31
;   ky = -1;
	RCALL SUBOPT_0x15
	STD  Y+8,R30
	STD  Y+8+1,R31
;  }
;  if(dx < dy)
_0xBC:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x17
	BRGE _0xBD
;  {
;   flag = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
;   d = dx;
	__GETWRS 20,21,20
;   dx = dy;
	RCALL SUBOPT_0x16
	STD  Y+20,R30
	STD  Y+20+1,R31
;   dy = d;
	__PUTWSR 20,21,18
;  }
;  else flag = 1;
	RJMP _0xBE
_0xBD:
	LDI  R30,LOW(1)
	STD  Y+7,R30
;  i1 = dy + dy;
_0xBE:
	RCALL SUBOPT_0x16
	LSL  R30
	ROL  R31
	STD  Y+14,R30
	STD  Y+14+1,R31
;  d = i1 - dx;
	RCALL SUBOPT_0x13
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R20,R30
;  i2 = d - dx;
	RCALL SUBOPT_0x13
	MOVW R30,R20
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+12,R30
	STD  Y+12+1,R31
;  x = x1;
	LDD  R16,Y+27
	CLR  R17
;  y = y1;
	LDD  R18,Y+26
	CLR  R19
;
;  for(i=0; i < dx; i++)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	STD  Y+16+1,R30
_0xC0:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x17
	BRGE _0xC1
;  {
;   Put_Pixel(x, y, color);
	ST   -Y,R16
	ST   -Y,R18
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RCALL _Put_Pixel
;   if(flag) x += kx;
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0xC2
	RCALL SUBOPT_0x19
;   else y += ky;
	RJMP _0xC3
_0xC2:
	RCALL SUBOPT_0x1A
;   if( d < 0 ) d += i1;
_0xC3:
	TST  R21
	BRPL _0xC4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	__ADDWRR 20,21,30,31
;   else
	RJMP _0xC5
_0xC4:
;   {
;    d += i2;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	__ADDWRR 20,21,30,31
;    if(flag) y += ky;
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0xC6
	RCALL SUBOPT_0x1A
;    else x += kx;
	RJMP _0xC7
_0xC6:
	RCALL SUBOPT_0x19
;   }
_0xC7:
_0xC5:
;  }
	RCALL SUBOPT_0x1B
	ADIW R30,1
	RCALL SUBOPT_0x1C
	RJMP _0xC0
_0xC1:
;  Put_Pixel(x, y, color);
	ST   -Y,R16
	ST   -Y,R18
_0x17A:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RCALL _Put_Pixel
; }
;}
	RCALL __LOADLOCR6
	ADIW R28,28
	RET
; .FEND
;
;//===============================================================
;//             НАРИСОВАТЬ ЛИНИЮ С ЗАДАВАЕМОЙ ШИРИНОЙ
;//===============================================================
;void LCD_FillLine (char tx1, char ty1, char tx2, char ty2, char width, int color)
;{
;    signed long x, y, addx, dx, dy;
;    signed long P;
;    int i;
;    long x1,x2,y1,y2;
;
;   if(ty1>ty2)  {y1=ty2; y2=ty1; x1=tx2; x2=tx1;}
;	tx1 -> Y+48
;	ty1 -> Y+47
;	tx2 -> Y+46
;	ty2 -> Y+45
;	width -> Y+44
;	color -> Y+42
;	x -> Y+38
;	y -> Y+34
;	addx -> Y+30
;	dx -> Y+26
;	dy -> Y+22
;	P -> Y+18
;	i -> R16,R17
;	x1 -> Y+14
;	x2 -> Y+10
;	y1 -> Y+6
;	y2 -> Y+2
;   else         {y1=ty1; y2=ty2; x1=tx1; x2=tx2;}
;    dx = x2 - x1;
;    dy = y2 - y1;
;   if(dx<0)     dx=-dx;
;   if(dy<0)     dy=-dy;
;    x = x1;
;    y = y1;
;
;   if(x1 > x2)  addx = -1;
;   else         addx = 1;
;
;   if(dx >= dy)
;   {
;    P = 2*dy - dx;
;
;      for(i=0; i<=dx; ++i)
;      {
;        LCD_FillRect (x, y, width, width, color);
;
;         if(P < 0)
;         {
;            P += 2*dy;
;            x += addx;
;         }
;         else
;         {
;            P += 2*dy - 2*dx;
;            x += addx;
;            y ++;
;         }
;      }
;   }
;   else
;   {
;    P = 2*dx - dy;
;
;      for(i=0; i<=dy; ++i)
;      {
;        LCD_FillRect (x, y, width, width, color);
;
;         if(P < 0)
;         {
;            P += 2*dx;
;            y ++;
;         }
;         else
;         {
;            P += 2*dx - 2*dy;
;            x += addx;
;            y ++;
;         }
;      }
;   }
;}
;
;//===============================================================
;//			НАРИСОВАТЬ РАМКУ
;//===============================================================
;void LCD_DrawRect (char x1, char y1, char width, char height, char size, int color)
;{
; unsigned int i;
; char x2=x1+(width-1), y2=y1+(height-1); //Конечные размеры рамки по осям х и у
;
;  for( i=1; i<=size; i++)   // size - толщина рамки
;	x1 -> Y+10
;	y1 -> Y+9
;	width -> Y+8
;	height -> Y+7
;	size -> Y+6
;	color -> Y+4
;	i -> R16,R17
;	x2 -> R19
;	y2 -> R18
; {
;  LCD_DrawLine(x1, y1, x1, y2, color);
;  LCD_DrawLine(x2, y1, x2, y2, color);
;  LCD_DrawLine(x1, y1, x2, y1, color);
;  LCD_DrawLine(x1, y2, x2, y2, color);
;  x1++; // Увеличиваю толщину рамки, если это задано
;  y1++;
;  x2--;
;  y2--;
; }
;}
;
;//===============================================================
;//              ЗАПОЛНИТЬ ПРЯМОУГОЛЬНИК ЦВЕТОМ COLOR
;//===============================================================
;void LCD_FillRect (char x1, char y1, char width, char height, int color)
;{
; unsigned int x;
; unsigned char m;
;
; switch (rot)
;	x1 -> Y+9
;	y1 -> Y+8
;	width -> Y+7
;	height -> Y+6
;	color -> Y+4
;	x -> R16,R17
;	m -> R19
; {
;    case 90: case 270:  m=y1; y1=x1; x1=m; m=width; width=height; height=m; break;
; };
;
; SetArea( x1, x1+(width-1), y1, y1+(height-1) );
; SetBit(LCD_PORT, LCD_RS);
;
; for (x = 0; x < width * height; x++)
; {
;  #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;  Send_to_lcd( DAT, color ); //Данные - задаём цвет пикселя
;  #else			//(16-ти битовая цветовая палитра (65536 цветов))
;  Send_to_lcd( DAT, (color >> 8) ); Send_to_lcd( DAT, color );
;  #endif
; }
;}
;
;//===============================================================
;//                  НАРИСОВАТЬ ОКРУЖНОСТЬ
;//===============================================================
;void LCD_DrawCircle (char xcenter, char ycenter, char rad, int color)
;{
;    signed int k, b, P;
;    unsigned char m;
;
;    switch (rot)
;	xcenter -> Y+11
;	ycenter -> Y+10
;	rad -> Y+9
;	color -> Y+7
;	k -> R16,R17
;	b -> R18,R19
;	P -> R20,R21
;	m -> Y+6
;    {
;        case 90: case 270:  m=ycenter; ycenter=xcenter; xcenter=m; break;
;    };
;
;    k = 0;
;    b = rad;
;    P = 1 - rad;
;    do
;    {
;        Put_Pixel(k+xcenter, b+ycenter, color);
;        Put_Pixel(b+xcenter, k+ycenter, color);
;        Put_Pixel(xcenter-k, b+ycenter, color);
;        Put_Pixel(xcenter-b, k+ycenter, color);
;        Put_Pixel(b+xcenter, ycenter-k, color);
;        Put_Pixel(k+xcenter, ycenter-b, color);
;        Put_Pixel(xcenter-k, ycenter-b, color);
;        Put_Pixel(xcenter-b, ycenter-k, color);
;
;        if(P < 0)   P+= 3 + 2*k++;
;        else        P+= 5 + 2*(k++ - b--);
;    } while(k <= b);
;}
;
;
;//===============================================================
;//                 ЗАПОЛНИТЬ КРУГ ЦВЕТОМ COLOR
;//===============================================================
;void LCD_FillCircle (char xcenter, char ycenter, char rad, int color)
;{
;    signed int x1=0, y1, tswitch;
;    y1 = rad;
;	xcenter -> Y+10
;	ycenter -> Y+9
;	rad -> Y+8
;	color -> Y+6
;	x1 -> R16,R17
;	y1 -> R18,R19
;	tswitch -> R20,R21
;    tswitch = 1 - rad;
;
;    do
;    {
;        LCD_DrawLine(xcenter-x1, ycenter+y1, xcenter+x1, ycenter+y1, color);
;        LCD_DrawLine(xcenter-x1, ycenter-y1, xcenter+x1, ycenter-y1, color);
;        LCD_DrawLine(xcenter-y1, ycenter+x1, xcenter+y1, ycenter+x1, color);
;        LCD_DrawLine(xcenter-y1, ycenter-x1, xcenter+y1, ycenter-x1, color);
;
;    if(tswitch < 0)
;    tswitch+= 3 + 2*x1++;
;    else
;    tswitch+= 5 + 2*(x1++ - y1--);
;    } while(x1 <= y1);
;}
;
;//===============================================================
;//                     НАРИСОВАТЬ ТРЕУГОЛЬНИК
;//===============================================================
;void LCD_DrawTriangle(char x1, char y1, char x2, char y2, char x3, char y3, int color)
;{
; LCD_DrawLine(x1, y1, x2, y2, color);
;	x1 -> Y+7
;	y1 -> Y+6
;	x2 -> Y+5
;	y2 -> Y+4
;	x3 -> Y+3
;	y3 -> Y+2
;	color -> Y+0
; LCD_DrawLine(x3, y3, x1, y1, color);
; LCD_DrawLine(x3, y3, x2, y2, color);
;}
;
;//===============================================================
;//              ЗАПОЛНИТЬ ТРЕУГОЛЬНИК ЦВЕТОМ COLOR
;//===============================================================
;void LCD_FillTriangle(char x1, char y1, char x2, char y2, char x3, char y3, int color)
;{
; LCD_FillTriangleA(x1, y1, x2, y2, x3, y3, color);
;	x1 -> Y+7
;	y1 -> Y+6
;	x2 -> Y+5
;	y2 -> Y+4
;	x3 -> Y+3
;	y3 -> Y+2
;	color -> Y+0
; LCD_FillTriangleA(x3, y3, x1, y1, x2, y2, color);
; LCD_FillTriangleA(x3, y3, x2, y2, x1, y1, color);
;}
;
;//===============================================================
;void LCD_FillTriangleA(char x1, char y1, char x2, char y2, char x3, char y3, int color)
;{
; signed long x, y, addx, dx, dy;
; signed long P;
; int i;
; long a1,a2,b1,b2;
; if(y1>y2)  {b1=y2; b2=y1; a1=x2; a2=x1;}
;	x1 -> Y+49
;	y1 -> Y+48
;	x2 -> Y+47
;	y2 -> Y+46
;	x3 -> Y+45
;	y3 -> Y+44
;	color -> Y+42
;	x -> Y+38
;	y -> Y+34
;	addx -> Y+30
;	dx -> Y+26
;	dy -> Y+22
;	P -> Y+18
;	i -> R16,R17
;	a1 -> Y+14
;	a2 -> Y+10
;	b1 -> Y+6
;	b2 -> Y+2
; else       {b1=y1; b2=y2; a1=x1; a2=x2;}
; dx = a2 -a1;
; dy = b2 - b1;
; if(dx<0)dx=-dx;
; if(dy<0)dy=-dy;
; x = a1;
; y = b1;
;
; if(a1 > a2)    addx = -1;
; else           addx = 1;
;
; if(dx >= dy)
; {
;  P = 2*dy - dx;
;  for(i=0; i<=dx; ++i)
;  {
;   LCD_DrawLine((int)x, (int)y, x3, y3, color);
;   if(P < 0)
;   {
;    P += 2*dy;
;    x += addx;
;   }
;   else
;   {
;    P += 2*dy - 2*dx;
;    x += addx;
;    y ++;
;   }
;  }
; }
; else
; {
;  P = 2*dx - dy;
;  for(i=0; i<=dy; ++i)
;  {
;   LCD_DrawLine((int)x, (int)y, x3, y3, color);
;   if(P < 0)
;   {
;    P += 2*dx;
;    y ++;
;   }
;   else
;   {
;    P += 2*dx - 2*dy;
;    x += addx;
;    y ++;
;   }
;  }
; }
;}
;
;//===============================================================
;//      Функция прорисовки графика состояния 0-100%
;//===============================================================
;// percent - число от 0 до 100, x и y - начальная позиция графика (верхний левый угол), width - ширина графика, zoom_hei ...
;// (при zoom_height=1 высота одной ячейки составляет 5 пикселей)
;void LCD_Put_Graph (char percent, char x, char y, int t_color, int b_color, char width, char zoom_height)
;{
;    char i, j=0, m, array[20];
;    for (i = 0; i < percent; i += 5)
;	percent -> Y+32
;	x -> Y+31
;	y -> Y+30
;	t_color -> Y+28
;	b_color -> Y+26
;	width -> Y+25
;	zoom_height -> Y+24
;	i -> R17
;	j -> R16
;	m -> R19
;	array -> Y+4
;    {
;        if (i + 5 > percent)
;        {
;            array[j++] = percent-i;
;        }
;        else
;        {
;            array[j++] = 5;
;        }
;    }
;    for (i=j; i<20; i++) //Заполнение оставшейся части нулями
;    {
;        array[i] = 0;
;    }
;
;    switch (rot)
;    {
;        case 270:   // Обновление дисплея Снизу-вверх
;                    Send_to_lcd(CMD, 0x36);
;                    Send_to_lcd(DAT, 0x80); //Начальный адрес осей Х и У - левый нижний угол дисплея
;                    break;
;        default:    // Обновление дисплея Слева-направо, сверху-вниз
;                    Send_to_lcd(CMD, 0x36);
;                    Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея
;    }
;
;
;    for (i=0; i<20; i++)
;    {
;        if (array[i]==5) //Нарисовать закрашенную ячейку (5%)
;        {
;                switch (rot)
;                {
;                    case 0:     SetArea (x, x+(5*zoom_height-1), y, y+(width-1));
;                                break;
;                    default:    SetArea (x, x+(width-1), y, y+(5*zoom_height-1));
;                }
;
;                for(j = 0; j < width*(5*zoom_height); j++)
;                {
;                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;                    Send_to_lcd( DAT, t_color ); //Данные - задаём цвет пикселя
;                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
;                    Send_to_lcd( DAT, (t_color >> 8) ); Send_to_lcd( DAT, t_color );
;                    #endif
;                }
;
;                switch (rot)
;                {
;                    case 0:     x+=(5*zoom_height);
;                                break;
;                    default:    y+=(5*zoom_height);
;                }
;
;        }
;
;        else if (array[i]==0) //Нарисовать незакрашенную ячейку (5%)
;        {
;                switch (rot)
;                {
;                    case 0:     SetArea (x, x+(5*zoom_height-1), y, y+(width-1));
;                                break;
;                    default:    SetArea (x, x+(width-1), y, y+(5*zoom_height-1));
;                }
;
;                for(j = 0; j < width*(5*zoom_height); j++)
;                {
;                    #ifdef _8_BIT_COLOR		//(8-ми битовая цветовая палитра (256 цветов))
;                    Send_to_lcd( DAT, b_color ); //Данные - задаём цвет пикселя
;                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
;                    Send_to_lcd( DAT, (b_color >> 8) ); Send_to_lcd( DAT, b_color );
;                    #endif
;                }
;                 switch (rot)
;                {
;                    case 0:     x+=(5*zoom_height);
;                                break;
;                    default:    y+=(5*zoom_height);
;                }
;        }
;
;        else  //Нарисовать полузакрашенную ячейку (1-4%)
;        {
;            m=array[i];
;            while (m--)
;            {
;
;                switch (rot)
;                {
;                    case 0:     SetArea (x, x+(zoom_height-1), y, y+(width-1));
;                                break;
;                    default:    SetArea (x, x+(width-1), y, y+(zoom_height-1));
;                }
;
;                for(j = 0; j < width*zoom_height; j++)
;                {
;                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;                    Send_to_lcd( DAT, t_color ); //Данные - задаём цвет пикселя
;                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
;                    Send_to_lcd( DAT, (t_color >> 8) ); Send_to_lcd( DAT, t_color );
;                    #endif
;                }
;                     switch (rot)
;                {
;                    case 0:     x+=zoom_height;
;                                break;
;                    default:    y+=zoom_height;
;                }
;            }
;
;            m=5-array[i];
;            while (m--)
;            {
;                switch (rot)
;                {
;                    case 0:     SetArea (x, x+(zoom_height-1), y, y+(width-1));
;                                break;
;                    default:    SetArea (x, x+(width-1), y, y+(zoom_height-1));
;                }
;
;                for(j = 0; j < width*zoom_height; j++)
;                {
;                    #ifdef _8_BIT_COLOR	//(8-ми битовая цветовая палитра (256 цветов))
;                    Send_to_lcd( DAT, b_color ); //Данные - задаём цвет пикселя
;                    #else			        //(16-ти битовая цветовая палитра (65536 цветов))
;                    Send_to_lcd( DAT, (b_color >> 8) ); Send_to_lcd( DAT, b_color );
;                    #endif
;                }
;                     switch (rot)
;                switch (rot)
;                {
;                    case 0:     x+=zoom_height;
;                                break;
;                    default:    y+=zoom_height;
;                }
;            }
;        }
;
;    }
;    Send_to_lcd(CMD, 0x36);
;    Send_to_lcd(DAT, 0x00); //Начальный адрес осей Х и У - левый верхний угол дисплея
;}
;
;//===============================================================
;#endif //_GEOMETRICAL
;#include <stdio.h>
;
;
;unsigned int read_adc(unsigned char adc_input);
;
;int solder_cur=0;
;int air_cur=0;
;int solder_set=0;
;int air_set=0;
;int fan_set=0;
;
;long map(long x, long in_min, long in_max, long out_min, long out_max)
; 0000 0052 {
_map:
; .FSTART _map
; 0000 0053   return (((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)/5)*5;
	RCALL __PUTPARD2
;	x -> Y+16
;	in_min -> Y+12
;	in_max -> Y+8
;	out_min -> Y+4
;	out_max -> Y+0
	RCALL SUBOPT_0x1D
	__GETD1S 16
	RCALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1E
	RCALL __GETD1S0
	RCALL __SUBD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1D
	__GETD1S 8
	RCALL __SUBD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVD21
	RCALL SUBOPT_0x1E
	RCALL __ADDD21
	__GETD1N 0x5
	RCALL __DIVD21
	__GETD2N 0x5
	RCALL __MULD12
	RJMP _0x20A0002
; 0000 0054 }
; .FEND
;void draw_2bit_image(char x, char y, char width, char height,int color,int bg, flash char *img)
; 0000 0056 {
_draw_2bit_image:
; .FSTART _draw_2bit_image
; 0000 0057   char xc,yc,dn=0;
; 0000 0058   for(yc=y; yc<(y+height); yc++)
	RCALL SUBOPT_0x7
	RCALL __SAVELOCR4
;	x -> Y+13
;	y -> Y+12
;	width -> Y+11
;	height -> Y+10
;	color -> Y+8
;	bg -> Y+6
;	*img -> Y+4
;	xc -> R17
;	yc -> R16
;	dn -> R19
	LDI  R19,0
	LDD  R16,Y+12
_0x15A:
	LDD  R26,Y+12
	CLR  R27
	LDD  R30,Y+10
	RCALL SUBOPT_0xD
	MOV  R26,R16
	LDI  R27,0
	RCALL SUBOPT_0x17
	BRLT PC+2
	RJMP _0x15B
; 0000 0059   {
; 0000 005A    for(xc=x; xc<x+width; )
	LDD  R17,Y+13
_0x15D:
	LDD  R26,Y+13
	CLR  R27
	LDD  R30,Y+11
	RCALL SUBOPT_0xD
	MOV  R26,R17
	LDI  R27,0
	RCALL SUBOPT_0x17
	BRLT PC+2
	RJMP _0x15E
; 0000 005B    {
; 0000 005C     if ((img[dn] & 0B10000000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x80)
	BREQ _0x15F
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x189
_0x15F:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x189:
	RCALL _Put_Pixel
; 0000 005D     if ((img[dn] & 0B01000000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x40)
	BREQ _0x161
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x18A
_0x161:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x18A:
	RCALL _Put_Pixel
; 0000 005E     if ((img[dn] & 0B00100000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x20)
	BREQ _0x163
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x18B
_0x163:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x18B:
	RCALL _Put_Pixel
; 0000 005F     if ((img[dn] & 0B00010000)) {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x10)
	BREQ _0x165
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x18C
_0x165:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x18C:
	RCALL _Put_Pixel
; 0000 0060     if ((img[dn] & 0B00001000))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x8)
	BREQ _0x167
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x18D
_0x167:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x18D:
	RCALL _Put_Pixel
; 0000 0061     if ((img[dn] & 0B00000100))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x4)
	BREQ _0x169
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x18E
_0x169:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x18E:
	RCALL _Put_Pixel
; 0000 0062     if ((img[dn] & 0B00000010))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x2)
	BREQ _0x16B
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x18F
_0x16B:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x18F:
	RCALL _Put_Pixel
; 0000 0063     if ((img[dn] & 0B00000001))  {Put_Pixel(yc,xc++,color);} else {Put_Pixel(yc,xc++,bg);}
	RCALL SUBOPT_0x1F
	LPM  R30,Z
	ANDI R30,LOW(0x1)
	BREQ _0x16D
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x190
_0x16D:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
_0x190:
	RCALL _Put_Pixel
; 0000 0064     dn++;
	SUBI R19,-1
; 0000 0065    }
	RJMP _0x15D
_0x15E:
; 0000 0066   }
	SUBI R16,-1
	RJMP _0x15A
_0x15B:
; 0000 0067 }
	RCALL __LOADLOCR4
	ADIW R28,14
	RET
; .FEND
;void set_sold_cur_temp(int temp)
; 0000 0069 {
_set_sold_cur_temp:
; .FSTART _set_sold_cur_temp
; 0000 006A     char buf[5];
; 0000 006B     sprintf( buf,"%i  ",temp);
	RCALL SUBOPT_0x23
;	temp -> Y+5
;	buf -> Y+0
; 0000 006C     buf[3]=0;
; 0000 006D     LCD_Puts(buf,50,10,GREEN,WHITE,3,3);
	RCALL SUBOPT_0x24
	LDI  R30,LOW(2016)
	LDI  R31,HIGH(2016)
	RJMP _0x20A0004
; 0000 006E }
; .FEND
;
;void set_sold_temp(int temp)
; 0000 0071 {
_set_sold_temp:
; .FSTART _set_sold_temp
; 0000 0072     char buf[1];
; 0000 0073     sprintf( buf,"%i  ",temp );
	RCALL SUBOPT_0x7
	SBIW R28,1
;	temp -> Y+1
;	buf -> Y+0
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	RCALL SUBOPT_0x27
; 0000 0074     buf[3]=0;
; 0000 0075     LCD_Puts(buf,120,10,RED,WHITE,3,3);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x24
	LDI  R30,LOW(63488)
	LDI  R31,HIGH(63488)
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
; 0000 0076 }
	ADIW R28,3
	RET
; .FEND
;
;void set_air_cur_temp(int temp)
; 0000 0079 {
_set_air_cur_temp:
; .FSTART _set_air_cur_temp
; 0000 007A     char buf[5];
; 0000 007B     sprintf( buf,"%i  ",temp );
	RCALL SUBOPT_0x23
;	temp -> Y+5
;	buf -> Y+0
; 0000 007C     buf[3]=0;
; 0000 007D     LCD_Puts(buf,50,50,GREEN,WHITE,3,3);
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(2016)
	LDI  R31,HIGH(2016)
	RJMP _0x20A0004
; 0000 007E }
; .FEND
;
;void set_air_temp(int temp)
; 0000 0081 {
_set_air_temp:
; .FSTART _set_air_temp
; 0000 0082     char buf[5];
; 0000 0083     sprintf( buf,"%i  ",temp);
	RCALL SUBOPT_0x7
	SBIW R28,5
;	temp -> Y+5
;	buf -> Y+0
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x27
; 0000 0084     buf[3]=0;
; 0000 0085     LCD_Puts(buf,120,50,RED,WHITE,3,3);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(63488)
	LDI  R31,HIGH(63488)
	RJMP _0x20A0004
; 0000 0086 }
; .FEND
;void set_fan(int fan)
; 0000 0088 {
_set_fan:
; .FSTART _set_fan
; 0000 0089     char buf[5];
; 0000 008A     sprintf( buf,"%i%%  ",fan );
	RCALL SUBOPT_0x7
	SBIW R28,5
;	fan -> Y+5
;	buf -> Y+0
	RCALL SUBOPT_0x25
	__POINTW1FN _0x0,5
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0xF
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 008B     buf[4]=0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
; 0000 008C     LCD_Puts(buf,50,90,BLACK,WHITE,3,3);
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RCALL SUBOPT_0x2C
_0x20A0004:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x2A
; 0000 008D }
	ADIW R28,7
	RET
; .FEND
;void get_all_input(void)
; 0000 008F {
_get_all_input:
; .FSTART _get_all_input
; 0000 0090     solder_cur= map(read_adc(solder_TC), 0, 750, 0, 480);
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x2D
	MOVW R8,R30
; 0000 0091     air_cur= map(read_adc(air_TC), 0, 750, 0, 480);
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x2D
	MOVW R10,R30
; 0000 0092     solder_set= map(read_adc(solder_RR), 0, 1023, 0, 480);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x2E
	MOVW R12,R30
; 0000 0093     air_set= map(read_adc(air_RR), 0, 1023, 0, 480);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x2E
	STS  _air_set,R30
	STS  _air_set+1,R31
; 0000 0094     fan_set= map(read_adc(fan_RR), 0, 1023, 0, 100);;
	LDI  R26,LOW(2)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x2F
	__GETD1N 0x3FF
	RCALL SUBOPT_0x2F
	__GETD2N 0x64
	RCALL _map
	STS  _fan_set,R30
	STS  _fan_set+1,R31
; 0000 0095 }
	RET
; .FEND
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0098 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
; 0000 0099 // Place your code here
; 0000 009A 
; 0000 009B }
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00A2 {
_read_adc:
; .FSTART _read_adc
; 0000 00A3 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 00A4 // Delay needed for the stabilization of the ADC input voltage
; 0000 00A5 delay_us(10);
	__DELAY_USB 27
; 0000 00A6 // Start the AD conversion
; 0000 00A7 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 00A8 // Wait for the AD conversion to complete
; 0000 00A9 while ((ADCSRA & (1<<ADIF))==0);
_0x16F:
	SBIS 0x6,4
	RJMP _0x16F
; 0000 00AA ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 00AB return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x20A0003:
	ADIW R28,1
	RET
; 0000 00AC }
; .FEND
;
;
;void main(void)
; 0000 00B0 {
_main:
; .FSTART _main
; 0000 00B1 // Declare your local variables here
; 0000 00B2 
; 0000 00B3 // Input/Output Ports initialization
; 0000 00B4 // Port B initialization
; 0000 00B5 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 00B6 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 00B7 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 00B8 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00B9 
; 0000 00BA // Port C initialization
; 0000 00BB // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00BC DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00BD // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00BE PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00BF 
; 0000 00C0 // Port D initialization
; 0000 00C1 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00C2 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(248)
	OUT  0x11,R30
; 0000 00C3 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C4 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00C5 
; 0000 00C6 // Timer/Counter 0 initialization
; 0000 00C7 // Clock source: System Clock
; 0000 00C8 // Clock value: 0,977 kHz
; 0000 00C9 TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00CA TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00CB 
; 0000 00CC // Timer/Counter 1 initialization
; 0000 00CD // Clock source: System Clock
; 0000 00CE // Clock value: 1000,000 kHz
; 0000 00CF // Mode: Ph. correct PWM top=0x03FF
; 0000 00D0 // OC1A output: Inverted PWM
; 0000 00D1 // OC1B output: Inverted PWM
; 0000 00D2 // Noise Canceler: Off
; 0000 00D3 // Input Capture on Falling Edge
; 0000 00D4 // Timer Period: 2,046 ms
; 0000 00D5 // Output Pulse(s):
; 0000 00D6 // OC1A Period: 2,046 ms Width: 2,046 ms// OC1B Period: 2,046 ms Width: 2,046 ms
; 0000 00D7 // Timer1 Overflow Interrupt: Off
; 0000 00D8 // Input Capture Interrupt: Off
; 0000 00D9 // Compare A Match Interrupt: Off
; 0000 00DA // Compare B Match Interrupt: Off
; 0000 00DB TCCR1A=(1<<COM1A1) | (1<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(243)
	OUT  0x2F,R30
; 0000 00DC TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 00DD TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00DE TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00DF ICR1H=0x00;
	OUT  0x27,R30
; 0000 00E0 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00E1 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00E2 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00E3 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00E4 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E5 
; 0000 00E6 // Timer/Counter 2 initialization
; 0000 00E7 // Clock source: System Clock
; 0000 00E8 // Clock value: Timer2 Stopped
; 0000 00E9 // Mode: Normal top=0xFF
; 0000 00EA // OC2 output: Disconnected
; 0000 00EB ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00EC TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00ED TCNT2=0x00;
	OUT  0x24,R30
; 0000 00EE OCR2=0x00;
	OUT  0x23,R30
; 0000 00EF 
; 0000 00F0 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00F1 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00F2 
; 0000 00F3 // External Interrupt(s) initialization
; 0000 00F4 // INT0: Off
; 0000 00F5 // INT1: Off
; 0000 00F6 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00F7 
; 0000 00F8 // USART initialization
; 0000 00F9 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00FA // USART Receiver: Off
; 0000 00FB // USART Transmitter: On
; 0000 00FC // USART Mode: Asynchronous
; 0000 00FD // USART Baud Rate: 4800
; 0000 00FE UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00FF UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0100 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0101 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0102 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 0103 
; 0000 0104 // Analog Comparator initialization
; 0000 0105 // Analog Comparator: Off
; 0000 0106 // The Analog Comparator's positive input is
; 0000 0107 // connected to the AIN0 pin
; 0000 0108 // The Analog Comparator's negative input is
; 0000 0109 // connected to the AIN1 pin
; 0000 010A ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 010B 
; 0000 010C // ADC initialization
; 0000 010D // ADC Clock frequency: 7,813 kHz
; 0000 010E // ADC Voltage Reference: AREF pin
; 0000 010F ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0110 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0111 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0112 
; 0000 0113 // SPI initialization
; 0000 0114 // SPI disabled
; 0000 0115 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0116 
; 0000 0117 // TWI initialization
; 0000 0118 // TWI disabled
; 0000 0119 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 011A 
; 0000 011B // Global enable interrupts
; 0000 011C 
; 0000 011D LCD_init();
	RCALL _LCD_init
; 0000 011E SetRotation(90);
	LDI  R26,LOW(90)
	LDI  R27,0
	RCALL _SetRotation
; 0000 011F LCD_Puts(" LNSOLDER ",0,50,WHITE,BLACK,3,3);
	__POINTW1MN _0x172,0
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x29
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _LCD_Puts
; 0000 0120 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0121 LCD_FillScreen(WHITE);
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	RCALL _LCD_FillScreen
; 0000 0122 
; 0000 0123 draw_2bit_image (0,5,32,32,BLUE,WHITE,solder_img);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	LDI  R26,LOW(_solder_img*2)
	LDI  R27,HIGH(_solder_img*2)
	RCALL _draw_2bit_image
; 0000 0124 LCD_DrawLine(0,40,175,40,BLACK);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x32
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x33
; 0000 0125 draw_2bit_image (0,45,32,32,BLUE,WHITE,hotair_img);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(45)
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	LDI  R26,LOW(_hotair_img*2)
	LDI  R27,HIGH(_hotair_img*2)
	RCALL _draw_2bit_image
; 0000 0126 LCD_DrawLine(0,80,175,80,BLACK);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(80)
	RCALL SUBOPT_0x32
	LDI  R30,LOW(80)
	RCALL SUBOPT_0x33
; 0000 0127 draw_2bit_image (2,85,32,32,BLUE,WHITE,fan_img);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(85)
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	LDI  R26,LOW(_fan_img*2)
	LDI  R27,HIGH(_fan_img*2)
	RCALL _draw_2bit_image
; 0000 0128 LCD_DrawLine(0,120,175,120,BLACK);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(120)
	RCALL SUBOPT_0x32
	LDI  R30,LOW(120)
	RCALL SUBOPT_0x33
; 0000 0129 LCD_Puts("Powered by LnKOx & RadioVetal",0,123,SKY,WHITE,1,1);
	__POINTW1MN _0x172,11
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x29
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	RCALL SUBOPT_0x29
	LDI  R30,LOW(23836)
	LDI  R31,HIGH(23836)
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x9
	LDI  R26,LOW(1)
	RCALL _LCD_Puts
; 0000 012A 
; 0000 012B set_sold_cur_temp(480);
	RCALL SUBOPT_0x34
	RCALL _set_sold_cur_temp
; 0000 012C set_sold_temp(480);
	RCALL SUBOPT_0x34
	RCALL _set_sold_temp
; 0000 012D 
; 0000 012E set_air_cur_temp(480);
	RCALL SUBOPT_0x34
	RCALL _set_air_cur_temp
; 0000 012F set_air_temp(480);
	RCALL SUBOPT_0x34
	RCALL _set_air_temp
; 0000 0130  set_fan(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _set_fan
; 0000 0131 #asm("sei")
	sei
; 0000 0132 while (1)
_0x173:
; 0000 0133 
; 0000 0134 {
; 0000 0135       // Place your code here
; 0000 0136     get_all_input();
	RCALL _get_all_input
; 0000 0137     set_fan(fan_set);
	LDS  R26,_fan_set
	LDS  R27,_fan_set+1
	RCALL _set_fan
; 0000 0138     set_sold_cur_temp(solder_set);
	MOVW R26,R12
	RCALL _set_sold_cur_temp
; 0000 0139     set_sold_temp(solder_cur);
	MOVW R26,R8
	RCALL _set_sold_temp
; 0000 013A     set_air_cur_temp(air_set);
	LDS  R26,_air_set
	LDS  R27,_air_set+1
	RCALL _set_air_cur_temp
; 0000 013B     set_air_temp(solder_but);
	LDI  R30,0
	SBIC 0x13,3
	LDI  R30,1
	LDI  R31,0
	MOVW R26,R30
	RCALL _set_air_temp
; 0000 013C     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 013D }
	RJMP _0x173
; 0000 013E }
_0x176:
	RJMP _0x176
; .FEND

	.DSEG
_0x172:
	.BYTE 0x29
;
;//solder_but
;// air_but
;// air_ger

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	RCALL SUBOPT_0x7
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x35
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	RCALL SUBOPT_0x35
	ADIW R26,2
	RCALL SUBOPT_0x37
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	RCALL SUBOPT_0x35
	RCALL __GETW1P
	TST  R31
	BRMI _0x2020014
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x37
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x15
	ST   X+,R30
	ST   X,R31
_0x2020015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	RCALL SUBOPT_0x7
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	RCALL SUBOPT_0x16
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x38
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x38
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x1B
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x3A
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	RCALL SUBOPT_0x3D
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	RCALL SUBOPT_0x3D
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x14
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x14
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x38
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x3D
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x38
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x3D
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x17
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	RCALL SUBOPT_0x22
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x14
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	RCALL SUBOPT_0x22
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x3A
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x38
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x22
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x3A
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
_0x20A0002:
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x3E
	SBIW R30,0
	BRNE _0x2020072
	RCALL SUBOPT_0x15
	RJMP _0x20A0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x29
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	RCALL SUBOPT_0x29
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x7
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x7
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_air_set:
	.BYTE 0x2
_fan_set:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CBI  0x12,7
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	SBI  0x12,6
	CBI  0x12,6
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R30,Y+1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL _delay_ms
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	RCALL _Send_to_lcd
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5:
	RCALL _Send_to_lcd
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL _Send_to_lcd
	LDI  R26,LOW(20)
	LDI  R27,0
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	CPI  R30,LOW(0xB4)
	LDI  R26,HIGH(0xB4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	CPI  R30,LOW(0x10E)
	LDI  R26,HIGH(0x10E)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xD:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ADD  R30,R26
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDD  R30,Y+9
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	__ADDWRR 16,17,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__ADDWRR 18,19,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1F:
	MOV  R30,R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x20:
	ST   -Y,R16
	ST   -Y,R17
	INC  R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x22:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x7
	SBIW R28,5
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0xF
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(0)
	STD  Y+3,R30
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(0)
	STD  Y+3,R30
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x29:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RJMP _LCD_Puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x29
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2D:
	RCALL _read_adc
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	__GETD1N 0x0
	RCALL __PUTPARD1
	__GETD1N 0x2EE
	RCALL __PUTPARD1
	__GETD1N 0x0
	RCALL __PUTPARD1
	__GETD2N 0x1E0
	RJMP _map

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	RCALL _read_adc
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	__GETD1N 0x0
	RCALL __PUTPARD1
	__GETD1N 0x3FF
	RCALL __PUTPARD1
	__GETD1N 0x0
	RCALL __PUTPARD1
	__GETD2N 0x1E0
	RJMP _map

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	RCALL __PUTPARD1
	__GETD1N 0x0
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	LDI  R30,LOW(32)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x31:
	ST   -Y,R30
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x15
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	ST   -Y,R30
	LDI  R30,LOW(175)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _LCD_DrawLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(480)
	LDI  R27,HIGH(480)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x38:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x1B
	SBIW R30,4
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0x18
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
