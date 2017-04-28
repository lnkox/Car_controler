
;CodeVisionAVR C Compiler V3.10 Advanced
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
	.DEF _run_mode=R5
	.DEF _audio_mode=R4
	.DEF _rotate_tmr=R7
	.DEF _blink_tmr=R6
	.DEF _blink_reg=R9
	.DEF _curent_speed=R8
	.DEF _old_speed=R11
	.DEF _run_wathdog=R12
	.DEF _run_wathdog_msb=R13
	.DEF _bat_period=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0003

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x23
_0x4:
	.DB  0x2C,0x1
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _pitchStep
	.DW  _0x3*2

	.DW  0x02
	.DW  _currentPitch
	.DW  _0x4*2

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
;Date    : 28.04.2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#define speed_led0 PORTD.0
;#define speed_led1 PORTD.1
;#define speed_led2 PORTD.2
;#define speed_led3 PORTD.3
;#define speed_led4 PORTD.4
;#define speed_led5 PORTD.5
;#define speed_led6 PORTD.6
;
;#define bat_led1 PORTB.3
;#define bat_led2 PORTB.4
;#define bat_led3 PORTB.5
;
;#define red_led PORTB.6
;#define blue_led PORTB.7
;
;#define rotate_led PORTB.0
;
;#define light PORTC.5
;
;#define brake PORTD.7
;#define audio PORTB.2
;
;#define back_run PINC.0
;#define run_sens PINC.1
;#define beep PINC.3
;#define zummer PINC.4
;
;#define gaz 6
;#define batt 7
;#define max_speed 2
;
;#define rotate_period 80
;#define blink_period 8
;
;#define full_batt 14
;#define half_batt 12
;#define low_batt 11
;#define empy_bat 10
;
;#define brake_len 200;
;
;#define out_power OCR1AL
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
;#include <delay.h>
;#include <stdlib.h>
;
;
;void proces_rotate(void);
;void proces_blink(void);
;unsigned int read_adc(unsigned char adc_input);
;void proces_run(void);
;void proces_siren(void);
;void proces_button(void);
;void set_tone(int freq);
;void set_speed_led(char speed);
;void check_battery(void);
;void all_off(void);
;long map(long x, long in_min, long in_max, long out_min, long out_max);// перевід одиниць
;void proces_control_power(void);
;
;char run_mode=0; // 0-stop, 1-run,2-back_run, 3-emergency
;char audio_mode=0; // 0-stop, 1-beep, 2-back_run, 3-siren, 4-alarm
;
;char rotate_tmr=0;
;char blink_tmr=0,blink_reg=0;
;long period=0;
;
;char curent_speed=0,old_speed=0;
;int run_wathdog=0;
;int brake_tmr=0;
;
;bit old_zummer=1,old_run_sens=1;
;bit state_zummer=0,state_beep=0,state_back_run=0;
;
;bit blink_bat=0,battery_empy=0;
;char bat_period=0;
;
;
;const int pitchLow = 300;
;const int pitchHigh = 1000;
;int pitchStep = 35;

	.DSEG
;int currentPitch=300;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 006F {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0070     check_battery();
	RCALL _check_battery
; 0000 0071     if (battery_empy==0)
	SBRC R2,6
	RJMP _0x5
; 0000 0072     {
; 0000 0073         proces_rotate();
	RCALL _proces_rotate
; 0000 0074         proces_blink();
	RCALL _proces_blink
; 0000 0075         proces_button();
	RCALL _proces_button
; 0000 0076         proces_run();
	RCALL _proces_run
; 0000 0077         proces_control_power();
	RCALL _proces_control_power
; 0000 0078         if(state_zummer==1) proces_siren();
	SBRC R2,2
	RCALL _proces_siren
; 0000 0079         if(state_beep==1)set_tone(400);
	SBRS R2,3
	RJMP _0x7
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _set_tone
; 0000 007A         if(state_beep==0 && state_zummer==0) period=0;
_0x7:
	SBRC R2,3
	RJMP _0x9
	SBRS R2,2
	RJMP _0xA
_0x9:
	RJMP _0x8
_0xA:
	RCALL SUBOPT_0x0
; 0000 007B 
; 0000 007C     }
_0x8:
; 0000 007D 
; 0000 007E 
; 0000 007F }
_0x5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;// Timer2 overflow interrupt service routine
;void check_battery(void)// перевірка заряду батереї
; 0000 0082 {
_check_battery:
; .FSTART _check_battery
; 0000 0083     double cur_bat=1023;
; 0000 0084     bat_period++;
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	LDI  R30,LOW(192)
	STD  Y+1,R30
	LDI  R30,LOW(127)
	STD  Y+2,R30
	LDI  R30,LOW(68)
	STD  Y+3,R30
;	cur_bat -> Y+0
	INC  R10
; 0000 0085     if (bat_period<100)  return; else bat_period=0;
	LDI  R30,LOW(100)
	CP   R10,R30
	BRSH _0xB
	RJMP _0x2080003
_0xB:
	CLR  R10
; 0000 0086     cur_bat=read_adc(batt);
	LDI  R26,LOW(7)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x1
; 0000 0087     cur_bat=cur_bat/68;
	__GETD1N 0x42880000
	RCALL __DIVF21
	RCALL SUBOPT_0x1
; 0000 0088     if (cur_bat>full_batt) bat_led1=1; else bat_led1=0;
	__GETD1N 0x41600000
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0xD
	SBI  0x18,3
	RJMP _0x10
_0xD:
	CBI  0x18,3
; 0000 0089     if (cur_bat>half_batt) bat_led2=1; else bat_led2=0;
_0x10:
	RCALL SUBOPT_0x2
	__GETD1N 0x41400000
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x13
	SBI  0x18,4
	RJMP _0x16
_0x13:
	CBI  0x18,4
; 0000 008A     if (cur_bat>low_batt) bat_led3=1; else bat_led3=0;
_0x16:
	RCALL SUBOPT_0x2
	__GETD1N 0x41300000
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x19
	SBI  0x18,5
	RJMP _0x1C
_0x19:
	CBI  0x18,5
; 0000 008B     if (cur_bat<empy_bat)
_0x1C:
	RCALL SUBOPT_0x2
	__GETD1N 0x41200000
	RCALL __CMPF12
	BRSH _0x1F
; 0000 008C     {
; 0000 008D         all_off();
	RCALL _all_off
; 0000 008E         battery_empy=1;
	SET
	BLD  R2,6
; 0000 008F        blink_bat=!blink_bat;
	LDI  R30,LOW(32)
	EOR  R2,R30
; 0000 0090        bat_led1=blink_bat;bat_led2=blink_bat;bat_led3=blink_bat;
	SBRC R2,5
	RJMP _0x20
	CBI  0x18,3
	RJMP _0x21
_0x20:
	SBI  0x18,3
_0x21:
	SBRC R2,5
	RJMP _0x22
	CBI  0x18,4
	RJMP _0x23
_0x22:
	SBI  0x18,4
_0x23:
	SBRC R2,5
	RJMP _0x24
	CBI  0x18,5
	RJMP _0x25
_0x24:
	SBI  0x18,5
_0x25:
; 0000 0091     }
; 0000 0092     else
	RJMP _0x26
_0x1F:
; 0000 0093     {
; 0000 0094         battery_empy=0;
	CLT
	BLD  R2,6
; 0000 0095         light=1;
	SBI  0x15,5
; 0000 0096     }
_0x26:
; 0000 0097 }
_0x2080003:
	ADIW R28,4
	RET
; .FEND
;void all_off(void)// Вимкнення всіх пристроїв
; 0000 0099 {
_all_off:
; .FSTART _all_off
; 0000 009A speed_led0=0;speed_led1=0;speed_led2=0;speed_led3=0;speed_led4=0;speed_led5=0;speed_led6=0;
	CBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	CBI  0x12,3
	CBI  0x12,4
	CBI  0x12,5
	CBI  0x12,6
; 0000 009B red_led=0;blue_led=0;rotate_led=0;
	CBI  0x18,6
	CBI  0x18,7
	CBI  0x18,0
; 0000 009C light=0;brake=0;audio=0;period=0;out_power=0;
	CBI  0x15,5
	CBI  0x12,7
	CBI  0x18,2
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x3
; 0000 009D }
	RET
; .FEND
;void proces_run(void)
; 0000 009F {
_proces_run:
; .FSTART _proces_run
; 0000 00A0 
; 0000 00A1     char max_spd =map(read_adc(max_speed),0,1023,0,255);
; 0000 00A2     curent_speed=map(read_adc(gaz),0,1023,0,255);
	ST   -Y,R17
;	max_spd -> R17
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x4
	MOV  R17,R30
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x4
	MOV  R8,R30
; 0000 00A3     if (curent_speed<20)
	LDI  R30,LOW(20)
	CP   R8,R30
	BRSH _0x43
; 0000 00A4     {
; 0000 00A5         curent_speed=0;
	CLR  R8
; 0000 00A6         run_mode=0;
	CLR  R5
; 0000 00A7         if (brake_tmr>0) brake_tmr--; else brake=0;
	LDS  R26,_brake_tmr
	LDS  R27,_brake_tmr+1
	RCALL __CPW02
	BRGE _0x44
	LDI  R26,LOW(_brake_tmr)
	LDI  R27,HIGH(_brake_tmr)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x45
_0x44:
	CBI  0x12,7
; 0000 00A8     }
_0x45:
; 0000 00A9     else
	RJMP _0x48
_0x43:
; 0000 00AA     {
; 0000 00AB         brake=0;
	CBI  0x12,7
; 0000 00AC     }
_0x48:
; 0000 00AD     if (run_mode==3) {return; curent_speed=0;}
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x2080002
; 0000 00AE     if (back_run==1) {run_mode=2;max_spd=max_spd/2;} else {run_mode=1;}
	SBIS 0x13,0
	RJMP _0x4C
	LDI  R30,LOW(2)
	MOV  R5,R30
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	MOV  R17,R30
	RJMP _0x4D
_0x4C:
	LDI  R30,LOW(1)
	MOV  R5,R30
_0x4D:
; 0000 00AF     set_speed_led(curent_speed);
	MOV  R26,R8
	RCALL _set_speed_led
; 0000 00B0     curent_speed=map(curent_speed,0,255,0,max_spd);
	MOV  R30,R8
	LDI  R31,0
	RCALL __CWD1
	RCALL SUBOPT_0x5
	__GETD1N 0xFF
	RCALL SUBOPT_0x5
	MOV  R30,R17
	LDI  R31,0
	RCALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _map
	MOV  R8,R30
; 0000 00B1 }
_0x2080002:
	LD   R17,Y+
	RET
; .FEND
;void proces_control_power(void)
; 0000 00B3 {
_proces_control_power:
; .FSTART _proces_control_power
; 0000 00B4     if (run_mode==1 || run_mode==2)
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x4F
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x4E
_0x4F:
; 0000 00B5     {
; 0000 00B6       if (out_power<curent_speed) out_power++;
	IN   R30,0x2A
	CP   R30,R8
	BRSH _0x51
	IN   R30,0x2A
	SUBI R30,-LOW(1)
	OUT  0x2A,R30
	SUBI R30,LOW(1)
; 0000 00B7       if (out_power>curent_speed) out_power--;
_0x51:
	IN   R30,0x2A
	CP   R8,R30
	BRSH _0x52
	IN   R30,0x2A
	SUBI R30,LOW(1)
	OUT  0x2A,R30
	SUBI R30,-LOW(1)
; 0000 00B8       if (curent_speed<20) out_power=0;
_0x52:
	LDI  R30,LOW(20)
	CP   R8,R30
	BRSH _0x53
	RCALL SUBOPT_0x3
; 0000 00B9     }
_0x53:
; 0000 00BA     else
	RJMP _0x54
_0x4E:
; 0000 00BB     {
; 0000 00BC         out_power=0;
	RCALL SUBOPT_0x3
; 0000 00BD         curent_speed=0;
	CLR  R8
; 0000 00BE     }
_0x54:
; 0000 00BF     if (old_speed>0 && curent_speed==0) {brake=1;brake_tmr=brake_len;}
	LDI  R30,LOW(0)
	CP   R30,R11
	BRSH _0x56
	CP   R30,R8
	BREQ _0x57
_0x56:
	RJMP _0x55
_0x57:
	SBI  0x12,7
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	STS  _brake_tmr,R30
	STS  _brake_tmr+1,R31
; 0000 00C0     old_speed=curent_speed;
_0x55:
	MOV  R11,R8
; 0000 00C1 }
	RET
; .FEND
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00C7 {
_read_adc:
; .FSTART _read_adc
; 0000 00C8 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 00C9 // Delay needed for the stabilization of the ADC input voltage
; 0000 00CA delay_us(10);
	__DELAY_USB 27
; 0000 00CB // Start the AD conversion
; 0000 00CC ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 00CD // Wait for the AD conversion to complete
; 0000 00CE while ((ADCSRA & (1<<ADIF))==0);
_0x5A:
	SBIS 0x6,4
	RJMP _0x5A
; 0000 00CF ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 00D0 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2080001
; 0000 00D1 }
; .FEND
;
;void main(void)
; 0000 00D4 {
_main:
; .FSTART _main
; 0000 00D5 // Declare your local variables here
; 0000 00D6 
; 0000 00D7 // Input/Output Ports initialization
; 0000 00D8 // Port B initialization
; 0000 00D9 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00DA DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00DB // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00DC PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00DD 
; 0000 00DE // Port C initialization
; 0000 00DF // Function: Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00E0 DDRC=(1<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(96)
	OUT  0x14,R30
; 0000 00E1 // State: Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00E2 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00E3 
; 0000 00E4 // Port D initialization
; 0000 00E5 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00E6 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00E7 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00E8 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00E9 
; 0000 00EA // Timer/Counter 0 initialization
; 0000 00EB // Clock source: System Clock
; 0000 00EC // Clock value: 31,250 kHz
; 0000 00ED TCCR0=(1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 00EE TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 // Timer/Counter 1 initialization
; 0000 00F2 // Clock source: System Clock
; 0000 00F3 // Clock value: 31,250 kHz
; 0000 00F4 // Mode: Ph. correct PWM top=0x00FF
; 0000 00F5 // OC1A output: Non-Inverted PWM
; 0000 00F6 // OC1B output: Disconnected
; 0000 00F7 // Noise Canceler: Off
; 0000 00F8 // Input Capture on Falling Edge
; 0000 00F9 // Timer Period: 16,32 ms
; 0000 00FA // Output Pulse(s):
; 0000 00FB // OC1A Period: 16,32 ms Width: 0 us
; 0000 00FC // Timer1 Overflow Interrupt: Off
; 0000 00FD // Input Capture Interrupt: Off
; 0000 00FE // Compare A Match Interrupt: Off
; 0000 00FF // Compare B Match Interrupt: Off
; 0000 0100 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(129)
	OUT  0x2F,R30
; 0000 0101 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 0102 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0103 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0104 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0105 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0106 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0107 OCR1AL=0x00;
	RCALL SUBOPT_0x3
; 0000 0108 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0109 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 010A 
; 0000 010B // Timer/Counter 2 initialization
; 0000 010C // Clock source: System Clock
; 0000 010D // Clock value: 125,000 kHz
; 0000 010E // Mode: Normal top=0xFF
; 0000 010F // OC2 output: Disconnected
; 0000 0110 // Timer Period: 1,248 ms
; 0000 0111 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0112 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 0113 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0114 OCR2=0x00;
	OUT  0x23,R30
; 0000 0115 
; 0000 0116 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0117 TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 0118 
; 0000 0119 // External Interrupt(s) initialization
; 0000 011A // INT0: Off
; 0000 011B // INT1: Off
; 0000 011C MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 011D 
; 0000 011E // USART initialization
; 0000 011F // USART disabled
; 0000 0120 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0121 
; 0000 0122 // Analog Comparator initialization
; 0000 0123 // Analog Comparator: Off
; 0000 0124 // The Analog Comparator's positive input is
; 0000 0125 // connected to the AIN0 pin
; 0000 0126 // The Analog Comparator's negative input is
; 0000 0127 // connected to the AIN1 pin
; 0000 0128 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0129 
; 0000 012A // ADC initialization
; 0000 012B // ADC Clock frequency: 62,500 kHz
; 0000 012C // ADC Voltage Reference: AREF pin
; 0000 012D ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 012E ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 012F SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0130 
; 0000 0131 // SPI initialization
; 0000 0132 // SPI disabled
; 0000 0133 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0134 
; 0000 0135 // TWI initialization
; 0000 0136 // TWI disabled
; 0000 0137 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0138 
; 0000 0139 // Global enable interrupts
; 0000 013A #asm("sei")
	sei
; 0000 013B 
; 0000 013C while (1)
_0x5D:
; 0000 013D       {
; 0000 013E 
; 0000 013F }
	RJMP _0x5D
; 0000 0140 }
_0x60:
	RJMP _0x60
; .FEND
;void proces_button(void) //Обробка натиснення кнопок
; 0000 0142 {
_proces_button:
; .FSTART _proces_button
; 0000 0143     state_beep=!beep;
	CLT
	SBIS 0x13,3
	SET
	BLD  R2,3
; 0000 0144     state_back_run=!back_run;
	CLT
	SBIS 0x13,0
	SET
	BLD  R2,4
; 0000 0145     if(old_zummer!=zummer)
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	LDI  R30,0
	SBIC 0x13,4
	LDI  R30,1
	RCALL SUBOPT_0x6
	BREQ _0x61
; 0000 0146     {
; 0000 0147         state_zummer=!zummer;
	CLT
	SBIS 0x13,4
	SET
	BLD  R2,2
; 0000 0148         if(state_zummer==1)
	SBRS R2,2
	RJMP _0x62
; 0000 0149         {
; 0000 014A             pitchStep=(rand() % 3)*10 + 5;
	RCALL _rand
	MOVW R26,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL __MODW21
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	ADIW R30,5
	RCALL SUBOPT_0x7
; 0000 014B             currentPitch=pitchLow;
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x8
; 0000 014C         }
; 0000 014D     }
_0x62:
; 0000 014E     if(old_run_sens!=run_sens)
_0x61:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	LDI  R30,0
	SBIC 0x13,1
	LDI  R30,1
	RCALL SUBOPT_0x6
	BREQ _0x63
; 0000 014F     {
; 0000 0150         if(run_sens==0) run_wathdog=0;
	SBIC 0x13,1
	RJMP _0x64
	CLR  R12
	CLR  R13
; 0000 0151     }
_0x64:
; 0000 0152     old_zummer=zummer;
_0x63:
	CLT
	SBIC 0x13,4
	SET
	BLD  R2,0
; 0000 0153     old_run_sens=run_sens;
	CLT
	SBIC 0x13,1
	SET
	BLD  R2,1
; 0000 0154 }
	RET
; .FEND
;
;void set_speed_led(char speed)// Вивід рівня швидкості на світлодіодне табло
; 0000 0157 {
_set_speed_led:
; .FSTART _set_speed_led
; 0000 0158     if (speed>40) speed_led0=1; else speed_led0=0;
	ST   -Y,R26
;	speed -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x29)
	BRLO _0x65
	SBI  0x12,0
	RJMP _0x68
_0x65:
	CBI  0x12,0
; 0000 0159     if (speed>70) speed_led1=1; else speed_led1=0;
_0x68:
	LD   R26,Y
	CPI  R26,LOW(0x47)
	BRLO _0x6B
	SBI  0x12,1
	RJMP _0x6E
_0x6B:
	CBI  0x12,1
; 0000 015A     if (speed>100) speed_led2=1; else speed_led2=0;
_0x6E:
	LD   R26,Y
	CPI  R26,LOW(0x65)
	BRLO _0x71
	SBI  0x12,2
	RJMP _0x74
_0x71:
	CBI  0x12,2
; 0000 015B     if (speed>130) speed_led3=1; else speed_led3=0;
_0x74:
	LD   R26,Y
	CPI  R26,LOW(0x83)
	BRLO _0x77
	SBI  0x12,3
	RJMP _0x7A
_0x77:
	CBI  0x12,3
; 0000 015C     if (speed>160) speed_led4=1; else speed_led4=0;
_0x7A:
	LD   R26,Y
	CPI  R26,LOW(0xA1)
	BRLO _0x7D
	SBI  0x12,4
	RJMP _0x80
_0x7D:
	CBI  0x12,4
; 0000 015D     if (speed>190) speed_led5=1; else speed_led5=0;
_0x80:
	LD   R26,Y
	CPI  R26,LOW(0xBF)
	BRLO _0x83
	SBI  0x12,5
	RJMP _0x86
_0x83:
	CBI  0x12,5
; 0000 015E     if (speed>220) speed_led6=1; else speed_led6=0;
_0x86:
	LD   R26,Y
	CPI  R26,LOW(0xDD)
	BRLO _0x89
	SBI  0x12,6
	RJMP _0x8C
_0x89:
	CBI  0x12,6
; 0000 015F }
_0x8C:
_0x2080001:
	ADIW R28,1
	RET
; .FEND
;void proces_rotate(void)// Генерація сигналу на повороти
; 0000 0161 {
_proces_rotate:
; .FSTART _proces_rotate
; 0000 0162     rotate_tmr++;
	INC  R7
; 0000 0163     if (rotate_tmr<rotate_period) return; else rotate_tmr=0;
	LDI  R30,LOW(80)
	CP   R7,R30
	BRSH _0x8F
	RET
_0x8F:
	CLR  R7
; 0000 0164     rotate_led=!rotate_led;
	SBIS 0x18,0
	RJMP _0x91
	CBI  0x18,0
	RJMP _0x92
_0x91:
	SBI  0x18,0
_0x92:
; 0000 0165 }
	RET
; .FEND
;void proces_blink(void)// Генерація сигналу на мигалки
; 0000 0167 {
_proces_blink:
; .FSTART _proces_blink
; 0000 0168     blink_tmr++;
	INC  R6
; 0000 0169     if (blink_tmr<blink_period) return; else blink_tmr=0;
	LDI  R30,LOW(8)
	CP   R6,R30
	BRSH _0x93
	RET
_0x93:
	CLR  R6
; 0000 016A     blink_reg++;
	INC  R9
; 0000 016B      if (blink_reg>12) blink_reg=1;
	LDI  R30,LOW(12)
	CP   R30,R9
	BRSH _0x95
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 016C     if (blink_reg>6)
_0x95:
	LDI  R30,LOW(6)
	CP   R30,R9
	BRSH _0x96
; 0000 016D     {
; 0000 016E         red_led=0;
	CBI  0x18,6
; 0000 016F         blue_led=!blue_led;
	SBIS 0x18,7
	RJMP _0x99
	CBI  0x18,7
	RJMP _0x9A
_0x99:
	SBI  0x18,7
_0x9A:
; 0000 0170     }
; 0000 0171     else
	RJMP _0x9B
_0x96:
; 0000 0172     {
; 0000 0173         blue_led=0;
	CBI  0x18,7
; 0000 0174         red_led=!red_led;
	SBIS 0x18,6
	RJMP _0x9E
	CBI  0x18,6
	RJMP _0x9F
_0x9E:
	SBI  0x18,6
_0x9F:
; 0000 0175     }
_0x9B:
; 0000 0176 
; 0000 0177 }
	RET
; .FEND
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)// Таймер відтворення звуку
; 0000 017A {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 017B     TCNT2=period;
	LDS  R30,_period
	OUT  0x24,R30
; 0000 017C     if (period==0) {audio=0; return;}
	LDS  R30,_period
	LDS  R31,_period+1
	LDS  R22,_period+2
	LDS  R23,_period+3
	RCALL __CPD10
	BRNE _0xA0
	CBI  0x18,2
	RJMP _0xA9
; 0000 017D    audio=!audio;
_0xA0:
	SBIS 0x18,2
	RJMP _0xA3
	CBI  0x18,2
	RJMP _0xA4
_0xA3:
	SBI  0x18,2
_0xA4:
; 0000 017E }
_0xA9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;void set_tone(int freq)//Встановлення тону звучання
; 0000 0181 {
_set_tone:
; .FSTART _set_tone
; 0000 0182   period =256-(62500/freq) ;
	ST   -Y,R27
	ST   -Y,R26
;	freq -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(62500)
	LDI  R27,HIGH(62500)
	RCALL __DIVW21U
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	STS  _period,R30
	STS  _period+1,R31
	STS  _period+2,R22
	STS  _period+3,R23
; 0000 0183 }
	ADIW R28,2
	RET
; .FEND
;void proces_siren(void)// Генерація сирени
; 0000 0185 {
_proces_siren:
; .FSTART _proces_siren
; 0000 0186   set_tone(currentPitch);
	RCALL SUBOPT_0x9
	RCALL _set_tone
; 0000 0187   currentPitch += pitchStep;
	LDS  R30,_pitchStep
	LDS  R31,_pitchStep+1
	RCALL SUBOPT_0x9
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x8
; 0000 0188   if(currentPitch >= pitchHigh) {
	RCALL SUBOPT_0x9
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRGE _0xA8
; 0000 0189     pitchStep = -pitchStep;
; 0000 018A   }
; 0000 018B   else if(currentPitch <= pitchLow) {
	RCALL SUBOPT_0x9
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRGE _0xA7
; 0000 018C      pitchStep = -pitchStep;
_0xA8:
	LDS  R30,_pitchStep
	LDS  R31,_pitchStep+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x7
; 0000 018D   }
; 0000 018E }
_0xA7:
	RET
; .FEND
;long map(long x, long in_min, long in_max, long out_min, long out_max)// перевід одиниць
; 0000 0190 {
_map:
; .FSTART _map
; 0000 0191   return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
	RCALL __PUTPARD2
;	x -> Y+16
;	in_min -> Y+12
;	in_max -> Y+8
;	out_min -> Y+4
;	out_max -> Y+0
	RCALL SUBOPT_0xA
	__GETD1S 16
	RCALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
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
	RCALL SUBOPT_0xA
	__GETD1S 8
	RCALL __SUBD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVD21
	RCALL SUBOPT_0xB
	RCALL __ADDD12
	ADIW R28,20
	RET
; 0000 0192 }
; .FEND

	.CSEG

	.DSEG

	.CSEG
_rand:
; .FSTART _rand
	LDS  R30,__seed_G100
	LDS  R31,__seed_G100+1
	LDS  R22,__seed_G100+2
	LDS  R23,__seed_G100+3
	__GETD2N 0x41C64E6D
	RCALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G100,R30
	STS  __seed_G100+1,R31
	STS  __seed_G100+2,R22
	STS  __seed_G100+3,R23
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_period:
	.BYTE 0x4
_brake_tmr:
	.BYTE 0x2
_pitchStep:
	.BYTE 0x2
_currentPitch:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  _period,R30
	STS  _period+1,R30
	STS  _period+2,R30
	STS  _period+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	RCALL __PUTD1S0
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
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
	__GETD2N 0xFF
	RJMP _map

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	RCALL __PUTPARD1
	__GETD1N 0x0
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	STS  _pitchStep,R30
	STS  _pitchStep+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STS  _currentPitch,R30
	STS  _currentPitch+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDS  R26,_currentPitch
	LDS  R27,_currentPitch+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD2S 4
	RET


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
