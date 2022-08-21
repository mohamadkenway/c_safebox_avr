
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _doorStatusFlag=R4
	.DEF _doorStatusFlag_msb=R5
	.DEF _resetPasswordCounter=R6
	.DEF _resetPasswordCounter_msb=R7
	.DEF _enteredPasswordCounter=R8
	.DEF _enteredPasswordCounter_msb=R9
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Pattern:
	.DB  0xFE,0xFD,0xFB,0xF7
_key_number:
	.DB  0x37,0x38,0x39,0x2F,0x34,0x35,0x36,0x2A
	.DB  0x31,0x32,0x33,0x2D,0x43,0x30,0x3D,0x2B

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x44,0x4F,0x4F,0x52,0x20,0x49,0x53,0x20
	.DB  0x4F,0x50,0x45,0x4E
_0x4:
	.DB  0x44,0x4F,0x4F,0x52,0x20,0x4C,0x6F,0x63
	.DB  0x6B,0x65,0x64
_0x5:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x20,0x3A
_0x6:
	.DB  0x53,0x65,0x74,0x74,0x69,0x6E,0x67,0x20
	.DB  0x50,0x61,0x73,0x73,0x77,0x6F,0x72,0x64
_0x7:
	.DB  0x57,0x72,0x6F,0x6E,0x67,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64
_0x8:
	.DB  0x52,0x65,0x73,0x65,0x74,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x20,0x2E
	.DB  0x2E,0x2E,0x2E,0x2E
_0x9:
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A
_0xA:
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0C
	.DW  _openMessage
	.DW  _0x3*2

	.DW  0x0B
	.DW  _lockedMessage
	.DW  _0x4*2

	.DW  0x10
	.DW  _enterPasswoerdMessage
	.DW  _0x5*2

	.DW  0x10
	.DW  _passwordSetMessage
	.DW  _0x6*2

	.DW  0x0E
	.DW  _wrongPasswordMessage
	.DW  _0x7*2

	.DW  0x14
	.DW  _resetPasswordMessage
	.DW  _0x8*2

	.DW  0x06
	.DW  _password
	.DW  _0x9*2

	.DW  0x06
	.DW  _enteredPasssword
	.DW  _0xA*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
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
;#include <alcd.h>
;#include <string.h>
;#include <delay.h>
;
;char openMessage[]           = "DOOR IS OPEN";

	.DSEG
;char lockedMessage[]         = "DOOR Locked";
;char enterPasswoerdMessage[] = "Enter Password :";
;char passwordSetMessage[]    = "Setting Password";
;char wrongPasswordMessage[]  = "Wrong Password";
;char resetPasswordMessage[]  = "Reset Password .....";
;char password[]              = "******";
;char enteredPasssword[]      = "******";
;
;int  doorStatusFlag          = 0; // 0 = open , 1 = locked
;int  resetPasswordCounter    = 0;
;int  enteredPasswordCounter    = 0;
;
;flash char Pattern[4] = {0xFE, 0xFD, 0xFB, 0xF7};
;flash char key_number [4][4]={'7', '8', '9', '/',
;                              '4', '5', '6', '*',
;                              '1', '2', '3', '-',
;                              'C', '0', '=', '+'};
;
;
;
;
;void printMessage(char message[],int size){
; 0000 001C void printMessage(char message[],int size){

	.CSEG
_printMessage:
; .FSTART _printMessage
; 0000 001D     int i;
; 0000 001E     for(i = 0;i<size;i++){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	message -> Y+4
;	size -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0xC:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0xD
; 0000 001F         lcd_putchar(message[i]);
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _lcd_putchar
; 0000 0020     }
	__ADDWRN 16,17,1
	RJMP _0xC
_0xD:
; 0000 0021 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; .FEND
;
;char keypad(void)
; 0000 0024 {
_keypad:
; .FSTART _keypad
; 0000 0025     char i, column = 4;
; 0000 0026 
; 0000 0027     for (i=0; i<4; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	column -> R16
	LDI  R16,4
	LDI  R17,LOW(0)
_0xF:
	CPI  R17,4
	BRSH _0x10
; 0000 0028     {
; 0000 0029        PORTD = Pattern[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Pattern*2)
	SBCI R31,HIGH(-_Pattern*2)
	LPM  R0,Z
	OUT  0x12,R0
; 0000 002A 
; 0000 002B        if (PIND.4 == 0)
	SBIC 0x10,4
	RJMP _0x11
; 0000 002C        {
; 0000 002D            column = 0;
	LDI  R16,LOW(0)
; 0000 002E            break;
	RJMP _0x10
; 0000 002F        }
; 0000 0030 
; 0000 0031        if (PIND.5 == 0)
_0x11:
	SBIC 0x10,5
	RJMP _0x12
; 0000 0032        {
; 0000 0033            column = 1;
	LDI  R16,LOW(1)
; 0000 0034            break;
	RJMP _0x10
; 0000 0035        }
; 0000 0036 
; 0000 0037        if (PIND.6 == 0)
_0x12:
	SBIC 0x10,6
	RJMP _0x13
; 0000 0038        {
; 0000 0039            column = 2;
	LDI  R16,LOW(2)
; 0000 003A            break;
	RJMP _0x10
; 0000 003B        }
; 0000 003C 
; 0000 003D        if (PIND.7 == 0)
_0x13:
	SBIC 0x10,7
	RJMP _0x14
; 0000 003E        {
; 0000 003F            column = 3;
	LDI  R16,LOW(3)
; 0000 0040            break;
	RJMP _0x10
; 0000 0041        }
; 0000 0042     }
_0x14:
	SUBI R17,-1
	RJMP _0xF
_0x10:
; 0000 0043 
; 0000 0044     if (column != 4)
	CPI  R16,4
	BREQ _0x15
; 0000 0045     {
; 0000 0046        while (PIND.4 == 0) {};
_0x16:
	SBIS 0x10,4
	RJMP _0x16
; 0000 0047        while (PIND.5 == 0) {};
_0x19:
	SBIS 0x10,5
	RJMP _0x19
; 0000 0048        while (PIND.6 == 0) {};
_0x1C:
	SBIS 0x10,6
	RJMP _0x1C
; 0000 0049        while (PIND.7 == 0) {};
_0x1F:
	SBIS 0x10,7
	RJMP _0x1F
; 0000 004A        return key_number[i][column];
	MOV  R30,R17
	LDI  R26,LOW(_key_number*2)
	LDI  R27,HIGH(_key_number*2)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RJMP _0x2040002
; 0000 004B     }
; 0000 004C     else
_0x15:
; 0000 004D         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2040002
; 0000 004E 
; 0000 004F 
; 0000 0050 }
; .FEND
;
;void setPassword(){
; 0000 0052 void setPassword(){
_setPassword:
; .FSTART _setPassword
; 0000 0053 
; 0000 0054  int counter = 0;
; 0000 0055  char ch;
; 0000 0056 
; 0000 0057  printMessage(enterPasswoerdMessage,sizeof(enterPasswoerdMessage));
	CALL __SAVELOCR4
;	counter -> R16,R17
;	ch -> R19
	__GETWRN 16,17,0
	CALL SUBOPT_0x0
; 0000 0058 
; 0000 0059  while (1){
_0x23:
; 0000 005A 
; 0000 005B  ch = keypad();
	RCALL _keypad
	MOV  R19,R30
; 0000 005C 
; 0000 005D  if (ch == 'C'){
	CPI  R19,67
	BRNE _0x26
; 0000 005E     lcd_clear();
	RCALL _lcd_clear
; 0000 005F     printMessage(enterPasswoerdMessage,sizeof(enterPasswoerdMessage));
	CALL SUBOPT_0x0
; 0000 0060     counter = 0;
	__GETWRN 16,17,0
; 0000 0061  }
; 0000 0062  if(counter == 6 && ch == '='){
_0x26:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x28
	CPI  R19,61
	BREQ _0x29
_0x28:
	RJMP _0x27
_0x29:
; 0000 0063      lcd_clear();
	RCALL _lcd_clear
; 0000 0064      printMessage(passwordSetMessage,sizeof(passwordSetMessage));
	LDI  R30,LOW(_passwordSetMessage)
	LDI  R31,HIGH(_passwordSetMessage)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(17)
	LDI  R27,0
	RCALL _printMessage
; 0000 0065      delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0066      lcd_clear();
	CALL SUBOPT_0x1
; 0000 0067      printMessage(openMessage,sizeof(openMessage));
	LDI  R27,0
	RCALL _printMessage
; 0000 0068     return;
	RJMP _0x2040003
; 0000 0069  }
; 0000 006A  if (ch != 0 && ch != '/' && ch != '*' && ch != '+' && ch != '-' && ch != '=' && counter != 6){
_0x27:
	CPI  R19,0
	BREQ _0x2B
	CPI  R19,47
	BREQ _0x2B
	CPI  R19,42
	BREQ _0x2B
	CPI  R19,43
	BREQ _0x2B
	CPI  R19,45
	BREQ _0x2B
	CPI  R19,61
	BREQ _0x2B
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2C
_0x2B:
	RJMP _0x2A
_0x2C:
; 0000 006B 
; 0000 006C   if (ch != 'C'){
	CPI  R19,67
	BREQ _0x2D
; 0000 006D    lcd_putchar(ch);
	MOV  R26,R19
	RCALL _lcd_putchar
; 0000 006E    password[counter] = ch;
	MOVW R30,R16
	SUBI R30,LOW(-_password)
	SBCI R31,HIGH(-_password)
	ST   Z,R19
; 0000 006F    counter++;
	__ADDWRN 16,17,1
; 0000 0070    }
; 0000 0071 
; 0000 0072   }
_0x2D:
; 0000 0073 
; 0000 0074  }
_0x2A:
	RJMP _0x23
; 0000 0075 
; 0000 0076 }
_0x2040003:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;int  isPasswordCorrect(){
; 0000 0078 int  isPasswordCorrect(){
_isPasswordCorrect:
; .FSTART _isPasswordCorrect
; 0000 0079     int i;
; 0000 007A     for (i = 0;i<6;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x2F:
	__CPWRN 16,17,6
	BRGE _0x30
; 0000 007B      if(password[i] != enteredPasssword[i])
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	ADD  R26,R16
	ADC  R27,R17
	LD   R0,X
	LDI  R26,LOW(_enteredPasssword)
	LDI  R27,HIGH(_enteredPasssword)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CP   R30,R0
	BREQ _0x31
; 0000 007C       return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2040002
; 0000 007D     }
_0x31:
	__ADDWRN 16,17,1
	RJMP _0x2F
_0x30:
; 0000 007E     return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x2040002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 007F }
; .FEND
;
;
;void main(void)
; 0000 0083 {
_main:
; .FSTART _main
; 0000 0084 char ch;
; 0000 0085 
; 0000 0086 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
;	ch -> R17
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0087 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0088 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0089 
; 0000 008A // Port D initialization
; 0000 008B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 008C DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 008D // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 008E PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 008F 
; 0000 0090 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0091 
; 0000 0092 /////////////////////////
; 0000 0093 
; 0000 0094 
; 0000 0095 
; 0000 0096 setPassword();
	RCALL _setPassword
; 0000 0097 
; 0000 0098 
; 0000 0099 while (1)
_0x32:
; 0000 009A       {
; 0000 009B 
; 0000 009C           ch = keypad();
	RCALL _keypad
	MOV  R17,R30
; 0000 009D 
; 0000 009E           if (ch != 0)
	CPI  R17,0
	BRNE PC+2
	RJMP _0x35
; 0000 009F           {
; 0000 00A0              //reset password
; 0000 00A1 
; 0000 00A2              if(ch == '+' || ch == '-' || ch == '/' || ch == '*'){
	CPI  R17,43
	BREQ _0x37
	CPI  R17,45
	BREQ _0x37
	CPI  R17,47
	BREQ _0x37
	CPI  R17,42
	BRNE _0x36
_0x37:
; 0000 00A3                 if(ch == '+'){
	CPI  R17,43
	BRNE _0x39
; 0000 00A4                 resetPasswordCounter = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 00A5                 }
; 0000 00A6                 else if(ch == '-' && resetPasswordCounter == 1){
	RJMP _0x3A
_0x39:
	CPI  R17,45
	BRNE _0x3C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
; 0000 00A7                 resetPasswordCounter = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R6,R30
; 0000 00A8                 }
; 0000 00A9                 else if(ch == '*' && resetPasswordCounter == 2){
	RJMP _0x3E
_0x3B:
	CPI  R17,42
	BRNE _0x40
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 00AA                 resetPasswordCounter = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R6,R30
; 0000 00AB                 }
; 0000 00AC                 else if(ch == '/' && resetPasswordCounter == 3){
	RJMP _0x42
_0x3F:
	CPI  R17,47
	BRNE _0x44
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
; 0000 00AD                 resetPasswordCounter = 0;
	CLR  R6
	CLR  R7
; 0000 00AE                 enteredPasswordCounter = 0;
	CLR  R8
	CLR  R9
; 0000 00AF                 lcd_clear();
	RCALL _lcd_clear
; 0000 00B0                 doorStatusFlag = 0;
	CLR  R4
	CLR  R5
; 0000 00B1                 printMessage(resetPasswordMessage,sizeof(resetPasswordMessage));
	LDI  R30,LOW(_resetPasswordMessage)
	LDI  R31,HIGH(_resetPasswordMessage)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(21)
	LDI  R27,0
	RCALL _printMessage
; 0000 00B2                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00B3                 lcd_clear();
	RCALL _lcd_clear
; 0000 00B4                 setPassword();
	RCALL _setPassword
; 0000 00B5                 }
; 0000 00B6                 else {resetPasswordCounter = 0;}
	RJMP _0x46
_0x43:
	CLR  R6
	CLR  R7
_0x46:
_0x42:
_0x3E:
_0x3A:
; 0000 00B7              }
; 0000 00B8 
; 0000 00B9 
; 0000 00BA              else if (ch == 'C' && doorStatusFlag == 0){
	RJMP _0x47
_0x36:
	CPI  R17,67
	BRNE _0x49
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BREQ _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 00BB               resetPasswordCounter = 0;
	CLR  R6
	CLR  R7
; 0000 00BC               enteredPasswordCounter = 0;
	CLR  R8
	CLR  R9
; 0000 00BD               doorStatusFlag = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 00BE               lcd_clear();
	RCALL _lcd_clear
; 0000 00BF               printMessage(lockedMessage,sizeof(lockedMessage));
	LDI  R30,LOW(_lockedMessage)
	LDI  R31,HIGH(_lockedMessage)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(12)
	LDI  R27,0
	RCALL _printMessage
; 0000 00C0               delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _0x5E
; 0000 00C1               lcd_clear();
; 0000 00C2               printMessage(enterPasswoerdMessage,sizeof(enterPasswoerdMessage));
; 0000 00C3              }
; 0000 00C4 
; 0000 00C5 
; 0000 00C6 
; 0000 00C7 
; 0000 00C8               // entering password
; 0000 00C9              else if (ch != 'C' && ch != '*' && ch != '/' && ch != '+' &&
_0x48:
; 0000 00CA                  ch != '-' && ch != '=' && enteredPasswordCounter != 6 && doorStatusFlag == 1){
	CPI  R17,67
	BREQ _0x4D
	CPI  R17,42
	BREQ _0x4D
	CPI  R17,47
	BREQ _0x4D
	CPI  R17,43
	BREQ _0x4D
	CPI  R17,45
	BREQ _0x4D
	CPI  R17,61
	BREQ _0x4D
	CALL SUBOPT_0x2
	BREQ _0x4D
	CALL SUBOPT_0x3
	BREQ _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00CB                resetPasswordCounter = 0;
	CLR  R6
	CLR  R7
; 0000 00CC                enteredPasssword[enteredPasswordCounter] = ch;
	MOVW R30,R8
	SUBI R30,LOW(-_enteredPasssword)
	SBCI R31,HIGH(-_enteredPasssword)
	ST   Z,R17
; 0000 00CD                enteredPasswordCounter++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 00CE                lcd_putchar(ch);
	MOV  R26,R17
	RCALL _lcd_putchar
; 0000 00CF               }
; 0000 00D0 
; 0000 00D1               else if(ch == 'C' && enteredPasswordCounter > 0){
	RJMP _0x4F
_0x4C:
	CPI  R17,67
	BRNE _0x51
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRLT _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 00D2               resetPasswordCounter = 0;
	CLR  R6
	CLR  R7
; 0000 00D3               lcd_clear();
	RCALL _lcd_clear
; 0000 00D4               enteredPasswordCounter = 0;
	CLR  R8
	CLR  R9
; 0000 00D5               printMessage(enterPasswoerdMessage,sizeof(enterPasswoerdMessage));
	RJMP _0x5F
; 0000 00D6              }
; 0000 00D7 
; 0000 00D8 
; 0000 00D9              // check entered password
; 0000 00DA              else if(ch == '=' && enteredPasswordCounter != 6 && doorStatusFlag == 1){
_0x50:
	CPI  R17,61
	BRNE _0x55
	CALL SUBOPT_0x2
	BREQ _0x55
	CALL SUBOPT_0x3
	BREQ _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 00DB                 resetPasswordCounter = 0;
	CLR  R6
	CLR  R7
; 0000 00DC                 lcd_clear();
	RJMP _0x60
; 0000 00DD                 enteredPasswordCounter = 0;
; 0000 00DE                 printMessage(wrongPasswordMessage,sizeof(wrongPasswordMessage));
; 0000 00DF                 delay_ms(1000);
; 0000 00E0                 lcd_clear();
; 0000 00E1                 printMessage(enterPasswoerdMessage,sizeof(enterPasswoerdMessage));
; 0000 00E2               }
; 0000 00E3 
; 0000 00E4              else if(ch == '=' && enteredPasswordCounter == 6 && doorStatusFlag == 1){
_0x54:
	CPI  R17,61
	BRNE _0x59
	CALL SUBOPT_0x2
	BRNE _0x59
	CALL SUBOPT_0x3
	BREQ _0x5A
_0x59:
	RJMP _0x58
_0x5A:
; 0000 00E5               resetPasswordCounter = 0;
	CLR  R6
	CLR  R7
; 0000 00E6               if(isPasswordCorrect() == 1){
	RCALL _isPasswordCorrect
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5B
; 0000 00E7                 doorStatusFlag = 0;
	CLR  R4
	CLR  R5
; 0000 00E8                 lcd_clear();
	CALL SUBOPT_0x1
; 0000 00E9                 printMessage(openMessage,sizeof(openMessage));
	RJMP _0x61
; 0000 00EA               }
; 0000 00EB               else{
_0x5B:
; 0000 00EC                 lcd_clear();
_0x60:
	RCALL _lcd_clear
; 0000 00ED                 enteredPasswordCounter = 0;
	CLR  R8
	CLR  R9
; 0000 00EE                 printMessage(wrongPasswordMessage,sizeof(wrongPasswordMessage));
	LDI  R30,LOW(_wrongPasswordMessage)
	LDI  R31,HIGH(_wrongPasswordMessage)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(15)
	LDI  R27,0
	RCALL _printMessage
; 0000 00EF                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
_0x5E:
	CALL _delay_ms
; 0000 00F0                 lcd_clear();
	RCALL _lcd_clear
; 0000 00F1                 printMessage(enterPasswoerdMessage,sizeof(enterPasswoerdMessage));
_0x5F:
	LDI  R30,LOW(_enterPasswoerdMessage)
	LDI  R31,HIGH(_enterPasswoerdMessage)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(17)
_0x61:
	LDI  R27,0
	RCALL _printMessage
; 0000 00F2               }
; 0000 00F3              }
; 0000 00F4 
; 0000 00F5         }
_0x58:
_0x4F:
_0x47:
; 0000 00F6 
; 0000 00F7       }
_0x35:
	RJMP _0x32
; 0000 00F8 }
_0x5D:
	RJMP _0x5D
; .FEND
;
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 2
	SBI  0x1B,2
	__DELAY_USB 2
	CBI  0x1B,2
	__DELAY_USB 2
	RJMP _0x2040001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	RJMP _0x2040001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R11,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x4
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	MOV  R10,R30
	MOV  R11,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R11,R13
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R10
	MOV  R26,R10
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040001
_0x2000004:
	INC  R11
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2040001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2040001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG
_openMessage:
	.BYTE 0xD
_lockedMessage:
	.BYTE 0xC
_enterPasswoerdMessage:
	.BYTE 0x11
_passwordSetMessage:
	.BYTE 0x11
_wrongPasswordMessage:
	.BYTE 0xF
_resetPasswordMessage:
	.BYTE 0x15
_password:
	.BYTE 0x7
_enteredPasssword:
	.BYTE 0x7
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_enterPasswoerdMessage)
	LDI  R31,HIGH(_enterPasswoerdMessage)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(17)
	LDI  R27,0
	JMP  _printMessage

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	CALL _lcd_clear
	LDI  R30,LOW(_openMessage)
	LDI  R31,HIGH(_openMessage)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(13)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
