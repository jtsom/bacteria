* INCOMING!!
* By Conrad Tatge 1985   Hi Katie!

* Copyright (c) 1986 ANALOG Computing

	LIST	-L

* Simple macros/equates

MOV	MACRO	from,to
	LDA	%1
	STA	%2
	ENDM

ZER	MACRO	label
	LDA	#0
	STA	%1
	ENDM

ADD	MACRO	val
	CLC
	ADC	%1
	ENDM

SUB	MACRO	val
	SEC
	SBC	%1
	ENDM

MAD	MACRO	label,loc
	MOV	#LOW %1,%2
	MOV	#HIGH %1,%2+1
	ENDM

PMBASE	=	$D407
SIOINV	=	$E465
VDSLST	=	$200
SDLSTL	=	$230
GRACTL	=	$D01D
GPRIOR	=	$26F
SETVBV	=	$E45C
NMIEN	=	$D40E
COLBK	=	$D01A
SYSVBV	=	$E45F
M0PF	=	$D000
M0PL	=	$D008
P0PF	=	$D004
P1PF	=	$D005
SIZEM	=	$D00C
PMCOL0	=	$D012
COLOR0	=	708
COLOR1	=	709
COLOR2	=	710
COLOR3	=	711
COLOR4	=	712
CONSOL	=	$D01F
AUDF1	=	$D200
AUDC1	=	$D201
AUDF2	=	$D202
AUDC2	=	$D203
AUDF3	=	$D204
AUDC3	=	$D205
AUDF4	=	$D206
AUDC4	=	$D207
AUDCTL	=	$D208
RANDOM	=	$D20A
HPOSP0	=	$D000
HPOSM0	=	$D004
HITCLR	=	$D01E
WSYNC	=	$D40A
ATRACT	=	$4D
STICK	=	$278
STRIG	=	$284
DMACTL	=	559

* Program constants

TOP	=	20	;PM top of GR.7 screen
TITOFF	=	68	;down the screen
MESLEN	=	20	;length of each message
INCOME	=	7*MESLEN
GAMOVR	=	6*MESLEN	;message numbers
HIGHSC	=	5*MESLEN
SELECT	=	3*MESLEN
LEFT	=	$30	;the PM side of screen
YMAX	=	85	;number of GR.7 lines
XMAX	=	160
NUMPAR	=	19	;array size constants-1
NUMEXP	=	63
NUMCHO	=	7
NUMBLO	=	5
NUMSHO	=	15
NUMBOM	=	3
MANLIV	=	1	;alive
MANCHU	=	8	;has chute
MANZER	=	$10
MANLAN	=	$18	;landed
HTBLOK	=	6	;heights
HTPARA	=	5
GROUND	=	YMAX-HTBLOK-2	;where to land
CHEXCL	=	1	;characters
CHPER	=	$0E
CHCOM	=	$0C
CHCOL	=	$1A
CHLPAR	=	8
CHRPAR	=	9
COLMSK	=	$40	;for text
CLOUDY	=	2	;clouds on?
TRISPD	=	5	;trigger speed
SCRMEM	=	$6000	;memory allocation
PMBAS	=	$5C00
MISL	=	PMBAS+$180
PLR0	=	PMBAS+$200
PLR1	=	PMBAS+$280
PLR2	=	PMBAS+$300
PLR3	=	PMBAS+$380

	ORG	$80

VARBEG
LO	DS	1	;pointer
HI	DS	1
XPLOT	DS	1	;where to plot
YPLOT	DS	1
XEXPLO	DS	1	;where to explode
YEXPLO	DS	1
XDRINT	DS	1	;shot deltas
XDRDEC	DS	1
YDRINT	DS	1
YDRDEC	DS	1
NEXPLO	DS	1	;next pixel
CHORAT	DS	1	;rate of choppers
COUNT	DS	1
PARNUM	DS	1
SHONUM	DS	1
KILNUM	DS	1	;the paratrooper to kill
CHONUM	DS	1
CORD	DS	1
LEVEL	DS	1
LEVDON	DS	1	;level is done
JIFFY	DS	1	;tenths of seconds
CHANCE	DS	1
EXPLOC	DS	1	;explosion count
FALVEL	DS	1
DLIPNT	DS	1	;DLI pointer
TIMER	DS	1
EXPTIM	DS	1
EXPSPD	DS	1
EXPMIN	DS	1
EXPMAX	DS	1
EXPAND	DS	1
TRITIM	DS	1	;countdown for trigger
SHOTIM	DS	1	;to move shots
SHOSPD	DS	1	;reset value of SHOTIM
TITLST	DS	1	;title line on?
GUNROT	DS	1	;gun position
CHOPS	DS	1	;helicopters flying
CHONSC	DS	1	;on screen
CHOCMP	DS	1
BLASND	DS	1
PARAS	DS	1	;troopers in air
BRIGHT	DS	1	;brightness of explo
LOWCMP	DS	1
MESMAX	DS	1
NOTVOL	DS	1
NOTNUM	DS	1
BLADE	DS	1	;blade animation
BLATIM	DS	1
BOMRES	DS	1
BOMTIM	DS	1	;bomb delay
BOMNUM	DS	1	;bomb number
BOMSIZ	DS	1	;for DLI display
BOMOFF	DS	1
DOTIME	DS	1	;clock on?
SHUTLE	DS	1	;doing shuttles? 2=clouds
DEAD	DS	1
MPLOR	DS	1
XALTER	DS	1
LIVING	DS	1	;for counting landed
COLSKY	DS	1	;color of sky
MPFOR	DS	4	;collision
SCORE	DS	2	;current
HSCORE	DS	2	;high
VARSND			;sound variables
SCREAM	DS	1	;man yelling?
TUNEON	DS	1	;charge?
LOWEST	DS	1	;lowest man/bomb falling
SHOVOL	DS	1
BINGS	DS	1
RIPSND	DS	1
CHUSND	DS	1
BWOOOP	DS	1
CHOHIT	DS	1
VAREND

	ORG	$2C00

* Text for screen display

TEXT	DB	0,0,0,0,0,'incoming'
	DB	CHEXCL OR $40,CHEXCL OR $40
	DB	0,0,0,0,0
	DB	0,0,0,0,0,0,CHLPAR OR $40
	DB	'c',CHRPAR OR $40,0,$11,$19
	DB	$18,$15,0,0,0,0,0,0
	DB	0,0,'by',0,0,'conrad',0
	DB	'tatge',0,0
	DB	's' OR $C0,'e' OR $C0
	DB	'l' OR $C0,'e' OR $C0
	DB	'c' OR $C0,'t' OR $C0,0
	DB	'initial',0,'level'
	DB	'press',0
	DB	's' OR $C0,'t' OR $C0
	DB	'a' OR $C0,'r' OR $C0
	DB	't' OR $C0,0,'to',0,'begin'
	DB	0,'high',0,'score',CHCOL,0
	DB	0,0,CHCOM,0,0,0,0
	DB	0,0,0,0,0,'game',0,0,'over'
	DB	0,0,0,0,0
	DB	0,'incoming',0,0,0,0,0,0,0
	DB	0,0,CHEXCL OR $40,0

* Display list for game screen

GAMEDL	DB	$70,$70,$70,$C6
	DW	SCORLN
	DB	$4D
	DW	SCRMEM
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$8D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$8D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$8D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$8D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$0D,$0D,$0D,$0D,$0D
	DB	$0D,$41
	DW	GAMEDL

* Set up lookup table, erase screen

SETSCR
	MAD	SCRMEM,LO
	LDX	#0	;set up lookup
SETTAB	LDA	LO
	STA	SCRLO,X
	LDA	HI
	STA	SCRHI,X
	INX
	CPX	#YMAX+1	;bottom yet?
	BEQ	ENDSET
	LDA	LO
	ADD	#40	;40 bytes/line
	STA	LO
	LDA	HI
	ADC	#0
	STA	HI
	JMP	SETTAB

ENDSET	RTS

ERALIN	LDA	#0	;for falling through

DRALIN	PHA
	JSR	SETLO	;set it up
	PLA
	LDY	#39	;bytes
ERALN2	STA	(LO),Y	;do it!
	DEY
	BPL	ERALN2
	RTS

CLRSCR	LDX	#YMAX
CLEAR2	JSR	ERALIN	;erase screen
	DEX
	BPL	CLEAR2
	LDX	#YMAX-2	;draw ground
	LDA	#$FF
	JSR	DRALIN
	INX		;two lines
	LDA	#$FF
	JSR	DRALIN
	RTS

* Clear sound channels

SHUTUP	LDX	#6
	LDA	#0
HUSH	STA	AUDC1,X
	DEX
	DEX
	BPL	HUSH
	RTS

* Clear out PM buffers

CLRPLR	LDX	#$7F
	LDA	#0
CLR2	STA	MISL,X
	STA	PLR0,X
	STA	PLR1,X
	STA	PLR2,X
	STA	PLR3,X
	DEX
	BPL	CLR2
	RTS

* Draw paratrooper image Y on screen

DRAMAN	LDX	PARVER,Y	;vertical
	JSR	SETLO
	LDA	PARTYP,Y	;image number
	AND	#MANLAN	;just pic bits
	TAX
	TYA
	ASL	A
	TAY
	MOV	#6,COUNT	;6 bytes to move
	CLC		;through out loop
MOVMAN	LDA	PARLEF,X	;draw new man
	STA	(LO),Y
	INY
	LDA	PARRIG,X	;and right side
	STA	(LO),Y
	TYA
	ADC	#39	;down one line
	TAY
	INX
	DEC	COUNT	;6 times only
	BNE	MOVMAN
	RTS

SETLO	LDA	SCRLO,X	;SCRMEM to LO
	STA	LO
	LDA	SCRHI,X
	STA	HI
	RTS

* Point LO to pixel XPLOT,YPLOT and
* set up X and Y properly

PLOT	LDX	YPLOT
	JSR	SETLO	;point to line
	LDA	XPLOT	;0-159
	PHA
	LSR	A
	LSR	A	;0-39
	TAY		;point to byte
	PLA
	AND	#3
	TAX		;point to pixel
	LDA	(LO),Y
	RTS

ZEROIT	JSR	PLOT
	AND	BITAND,X	;return point
	STA	(LO),Y
	RTS

BITSON	DB	3,$0C,$30,$C0
BITOFF	DB	$FC,$F3,$CF,$3F
BITAND	DB	$3F,$CF,$F3,$FC	;mask off

PLOTIT	JSR	PLOT
	AND	BITAND,X	;return point
	ORA	BITPF1,X	;mask on
	STA	(LO),Y
	RTS

BITPF1	DB	$40,$10,$04,$01	;COLOR 1
BITPF3	DB	$C0,$30,$0C,$03	;COLOR 3

* Returns color at XPLOT,YPLOT

LOCATE	JSR	PLOT
	AND	BITPF3,X
	PHA		;save byte at coords
	TXA
	EOR	#3	;flip
	TAX
	PLA
SHIFT	DEX		;countdown
	BMI	ENDLOC
	LSR	A
	LSR	A
	JMP	SHIFT

ENDLOC	RTS

* Check pixel XPLOT,YPLOT and take
* action.  Called by SHOTS and EXPLO
* A is fate of pixel (NE or EQ)

NEWPIX	JSR	LOCATE	;what is at pixel?
	CMP	#2	;hit anything?
	BCC	PLOPIX
	TAY		;Yes! save color hit
	LDA	XPLOT
	LSR	A
	LSR	A
	LSR	A	;0-19
	TAX		;find PARatrooper
	LDA	YPLOT	;is pixel
	SEC
	SBC	#HTBLOK
	CMP	LANDED,X	;too low?
	BCS	KILPIX
	CPY	#3	;hit chute?
	BNE	MANHIT	;no.
	LDA	#MANLIV	;take off chute
	STA	PARTYP,X
	LDA	FALVEL	;give speed
	LSR	A
	LSR	A
	STA	PARSPD,X
	STA	PARVEL,X
	LDA	#5
	JSR	ADDSCO	;add 50 points
	MOV	#9,RIPSND
	JMP	KILPIX

MANHIT	JSR	KILPAR
	MOV	XPLOT,XEXPLO
	MOV	YPLOT,YEXPLO
	LDA	#7
	JSR	INIEXP	;boom
KILPIX	LDA	#0	;kill pixel
	RTS

PLOPIX	JSR	PLOTIT	;do the new point
	LDA	#1	;pixel is OK
	RTS

* Move all live shots according to DR

SHOTS	DEC	SHOTIM	;times yet?
	BEQ	MVSHOT
	RTS		;not time yet!

MVSHOT
	MOV	SHOSPD,SHOTIM	;reset
	LDX	#NUMSHO	;up to 16 bullets
	STX	SHONUM
CKSHOT	LDA	SHOLIV,X	;shot here?
	BEQ	NXSHOT
	LDA	SHXINT,X
	STA	XPLOT
	LDA	SHYINT,X
	STA	YPLOT
	JSR	ZEROIT	;erase old point
	LDX	SHONUM	;retreive
	LDA	SHXDEC,X	;horizontal
	ADD	XDRDEC
	STA	SHXDEC,X
	LDA	SHXINT,X
	ADC	XDRINT
	CMP	#XMAX	;off of screen?
	BCS	KILSHO
	STA	SHXINT,X
	STA	XPLOT
	LDA	SHYDEC,X	;and vertical
	ADD	YDRDEC
	STA	SHYDEC,X
	LDA	SHYINT,X
	ADC	YDRINT
	CMP	#YMAX
	BCS	KILSHO
	STA	SHYINT,X
	STA	YPLOT
	JSR	NEWPIX	;check
	LDX	SHONUM
	STA	SHOLIV,X	;kill it?
NXSHOT	DEC	SHONUM	;next!
	LDX	SHONUM
	BPL	CKSHOT
	RTS
KILSHO	LDA	#0
	STA	SHOLIV,X	;kill shot
	BEQ	NXSHOT	;leave...

* Init an explosion at XEXPLO,YEXPLO
* of the size in the accumulator

INIEXP	STA	COUNT	;save size
	LDX	NEXPLO	;maximum 64 pixels
CKEXP	LDA	EXPLIV,X
	BEQ	INEXPL
	JSR	ERAEXP	;erase point
	LDX	NEXPLO	;restore
INEXPL	LDA	RANDOM	;direction
	AND	EXPAND	;could be just up
	STA	EXPDIR,X
	LDA	XEXPLO	;explosion point
	STA	EXPXP,X
	LDA	YEXPLO
	STA	EXPYP,X
	JSR	GETRAN
	STA	EXPXI,X	;increments
	JSR	GETRAN
	STA	EXPYI,X
	LDA	#0
	STA	EXPXAC,X	;accumulators
	STA	EXPYAC,X
	JSR	GETRAN	;length of life
	AND	EXPMAX
	STA	EXPLIV,X
	INC	NEXPLO
	LDA	NEXPLO
	AND	#NUMEXP	;0-63
	STA	NEXPLO
	TAX
	DEC	COUNT
	BNE	CKEXP
	MOV	#$0F,BRIGHT
INITEX
	MOV	#3,EXPAND	;restore
	MOV	#7,EXPMIN	;explo varbs
	MOV	#$3F,EXPMAX
	RTS

GETRAN	LDA	RANDOM	;random between
	ORA	EXPMIN	;minimum
	RTS

* Erase explosion pixel X

ERAEXP	LDA	EXPXP,X
	STA	XPLOT
	LDA	EXPYP,X
	STA	YPLOT
	JSR	ZEROIT
	RTS

* Update the explosion

EXPLO	DEC	EXPTIM
	BEQ	SETEXP
	RTS	;not yet!

SETEXP
	MOV	EXPSPD,EXPTIM	;reset
	LDX	#NUMEXP	;do 64
	STX	EXPLOC
DOEXP1	LDA	EXPLIV,X	;pixel moving?
	BEQ	JXEXPL
	JSR	ERAEXP	;erase the old
	LDX	EXPLOC	;restore
	DEC	EXPLIV,X	;now done?
	BEQ	JXEXPL	;yes...leave
	LDA	EXPXI,X	;a new point!
	CLC
	ADC	EXPXAC,X
	STA	EXPXAC,X
	LDA	EXPDIR,X	;direction
	AND	#1
	BNE	ADDEXX
	LDA	EXPXP,X
	SBC	#0	;with carry!
	JMP	STOEXX

JXEXPL	JMP	NXEXPL

ADDEXX	LDA	EXPXP,X	;ends up here
	ADC	#0
STOEXX	CMP	#XMAX	;off of screen?
	BCS	KILEXP
	STA	EXPXP,X	;new point is OK
	STA	XPLOT
	LDA	EXPYI,X	;now do Y place
	CLC
	ADC	EXPYAC,X
	STA	EXPYAC,X
	LDA	EXPDIR,X
	AND	#2
	BNE	ADDEXY
	LDA	EXPYP,X
	SBC	#0
	JMP	STOEXY

ADDEXY	LDA	EXPYP,X
	ADC	#0
STOEXY	CMP	#YMAX	;off screen?
	BCS	KILEXP
	STA	EXPYP,X
	STA	YPLOT
	JSR	NEWPIX	;do new pixel
	BNE	NXEXPL
	LDX	EXPLOC
	STA	EXPLIV,X	;kill
NXEXPL	DEC	EXPLOC	;next!
	LDX	EXPLOC
	BMI	ENDEXP
	JMP	DOEXP1

KILEXP	LDA	#0
	STA	EXPLIV,X
	BEQ	NXEXPL	;always
ENDEXP	RTS

DOPLR0	STA	PLR0+TOP+2,Y	;this is a
	STA	PLR0+TOP+16,Y	;ridiculous
	STA	PLR0+TOP+30,Y	;waste but
	STA	PLR0+TOP+44,Y	;it works!
	RTS

DOPLR1	STA	PLR1+TOP+2,Y
	STA	PLR1+TOP+16,Y
	STA	PLR1+TOP+30,Y
	STA	PLR1+TOP+44,Y
	RTS

DOPLR2	STA	PLR2+TOP+2,Y
	STA	PLR2+TOP+16,Y
	STA	PLR2+TOP+30,Y
	STA	PLR2+TOP+44,Y
	RTS

DOPLR3	STA	PLR3+TOP+2,Y
	STA	PLR3+TOP+16,Y
	STA	PLR3+TOP+30,Y
	STA	PLR3+TOP+44,Y
	RTS

WAITVB	LDA	TIMER	;wait for VB to end
WAITIT	CMP	TIMER
	BEQ	WAITIT
	RTS

SILENT	LDX	#VAREND-VARSND-1
	LDA	#0
KILSND	STA	VARSND,X
	DEX
	BPL	KILSND
	RTS

* Erase old paratrooper X and draw a
* new one lower.  See if this guy
* has landed.  Called by MOVPAR.

SHOPAR	STX	PARNUM	;hold me now
	TXA
	ASL	A
	TAY		;horizontal
	LDA	PARVER,X	;vertical
	TAX
	JSR	SETLO
	LDA	#0
	STA	(LO),Y	;erase 2 bytes
	INY
	STA	(LO),Y
	DEY		;put back
	LDX	PARNUM
	INC	PARVER,X	;gravity
	LDA	PARVER,X
	CMP	LANDED,X	;has he landed?
	BCC	SHOHIM
	LDA	PARTYP,X	;yes
	AND	#MANCHU	;have chute?
	BNE	SAFETY
	JSR	KILPAR	;no. kill him!
	LDA	LANDED,X
	CMP	ROOF,X	;anyone below?
	BEQ	ENDMAN	;no
	LDA	LANDED,X	;yes
	ADD	#HTPARA	;move down man
	STA	LANDED,X	;adjust down
	STA	PARVER,X	;erase man
	JSR	KILPAR
	JMP	ENDMAN

SAFETY	LDA	LANDED,X	;adjust ground
	PHA		;old
	SUB	#HTPARA	;move up one
	STA	LANDED,X
	LDA	#MANLAN	;raise hands
	STA	PARTYP,X
	JSR	BASHIT	;on base?
	LDX	PARNUM
	PLA		;on building?
	CMP	ROOF,X
	BNE	SHOHIM
	CMP	#GROUND
	BEQ	SHOHIM
	JSR	CHARGE
SHOHIM	LDY	PARNUM	;get man to draw
	JSR	DRAMAN
ENDMAN	LDX	PARNUM
	RTS		;X reg is intact

* Kill paratrooper X (intact)
* by zeroing PARTYP and erasing.

KILPAR	STX	KILNUM	;save the number
	LDA	#MANZER	;erase this guy
	STA	PARTYP,X
	TXA
	TAY
	JSR	DRAMAN
	LDX	KILNUM
	LDA	#0
	STA	PARTYP,X
	TXA
	ASL	A
	ASL	A
	ASL	A
	ADD	#3
	STA	XEXPLO
	LDA	PARVER,X
	ADD	#3
	STA	YEXPLO
	LDA	#10
	JSR	INIEXP	;boom!
	LDA	#6	;60 points!
	JSR	ADDSCO
	MOV	#12,SCREAM
	LDX	KILNUM
	RTS

* Move these guys

MOVPAR
	ZER	PARAS
	STA	LOWCMP
	LDX	#NUMPAR	;do paratroopers
DOPAR	LDA	PARTYP,X	;guy here
	AND	#MANLIV	;to move?
	BEQ	NXTPAR
	INC	PARAS
	LDA	PARTYP,X	;chuteless?
	AND	#MANCHU
	BNE	HASCHU
	LDA	PARVER,X
	CMP	LOWCMP	;lower?
	BCC	HASCHU
	STA	LOWCMP
HASCHU	DEC	PARVEL,X	;countdown
	BNE	NXTPAR
	LDA	PARSPD,X	;reset
	STA	PARVEL,X
	LDA	PARVER,X
	CMP	CORD
	BNE	NXPAR
	LDA	#MANCHU OR MANLIV	;open!
	STA	PARTYP,X
	LDA	FALVEL	;slow him down!
	STA	PARSPD,X
	STA	PARVEL,X
	MOV	#5,CHUSND
NXPAR	JSR	SHOPAR	;move and draw him
NXTPAR	DEX
	BPL	DOPAR
	MOV	LOWCMP,LOWEST
	RTS

* Update the helicopters: Create new
* chopper?  Kill if necessary!
* Drop a paratrooper or a bomb?

MOVCHO
	ZER	CHOPS	;population
	LDA	SHUTLE
	CMP	#CLOUDY
	BNE	NOTCLO
	LDX	#7
	BNE	STCHNM
NOTCLO	LDA	LEVEL	;max of 8 choppers
	LSR	A
	ORA	#1
	TAX		;even
STCHNM	STX	CHONUM
DOCHO	JSR	MOVEM	;move object
	LDX	CHONUM
	LDA	CHOSPD,X	;move?
	CMP	CHOVEL,X
	BNE	JNXCHO
	LDA	DOTIME	;done?
	BEQ	JNXCHO
	JSR	MAYBE	;drop time?
	BCS	JNXCHO
	LDA	SHUTLE	;shuttles?
	BEQ	DOCHOP
	CMP	#CLOUDY	;clouds?
	BEQ	JNXCHO
	LDA	CHOPOS,X	;on screen?
	SUB	#LEFT
	CMP	#XMAX-16
	BCS	JNXCHO
	LDA	LEVEL
	LSR	A
	LSR	A
	TAX
CKBOMS	LDA	BOMLIV,X	;exists?
	BEQ	DROPIT
	DEX
	BPL	CKBOMS
JNXCHO	JMP	NXCHOP	;bag it

DROPIT	LDY	CHONUM
	LDA	ALTVER,Y
	CMP	LANDED,Y
	BCS	JNXCHO
	PHA
	JSR	ERAOLD
	PLA
	ADD	#TOP
	STA	BOMYP,X
	LDA	#0
	STA	BOMYI,X
	STA	BOMYAC,X
	STA	MPFOR,X
	LDA	RANDOM
	AND	#3
	ADD	#2
	STA	BOMSPD,X
	STA	BOMVEL,X
	LDY	CHONUM
	LDA	CHOPOS,Y
	ADD	#4	;center
	STA	BOMXP,X
	SUB	BASPOS	;base
	AND	#7
	BEQ	STBDIR	;straight?
	LDA	#0
	ROL	A
	EOR	#1
	TAY
	LDA	CHODIR,Y	;direction
STBDIR	STA	BOMDIR,X
	INC	BOMLIV,X	;drop bomb X
	MOV	#5,BWOOOP	;sound
	BNE	NXCHOP

DOCHOP	LDA	CHOPOS,X
	SUB	#LEFT-8
	LSR	A
	LSR	A
	LSR	A
	TAX	;correct column
	CPX	#20
	BCS	NXCHOP
	LDA	PARTYP,X	;trooper?
	AND	#MANLIV
	BNE	NXCHOP	;exists
	LDY	CHONUM
	LDA	ALTVER,Y	;get VER
	CMP	LANDED,X
	BCS	NXCHOP
	STA	PARVER,X
	LDA	FALVEL
	LSR	A
	STA	PARSPD,X	;rate of fall
	STA	PARVEL,X
	LDA	#MANLIV	;exists
	STA	PARTYP,X
	JSR	SHOPAR	;and draw him
NXCHOP	DEC	CHONUM	;loop count
	BMI	ENDCHO
	LDX	CHONUM
	JMP	DOCHO

ENDCHO
	MOV	CHOPS,CHONSC
	RTS

MAYBE	LDA	RANDOM
	ORA	RANDOM
	CMP	CHANCE
	RTS

* Move chopper or shuttle X
* and check collision

MOVEM	LDA	CHOLIV,X	;alive?
	BEQ	NEWCHO
	INC	CHOPS
	DEC	CHOVEL,X	;move yet?
	BNE	CKCHOP
	LDA	CHOSPD,X	;restore
	STA	CHOVEL,X
	TXA
	AND	#1
	TAY
	LDA	CHODIR,Y
	CLC
	ADC	CHOPOS,X
	STA	CHOPOS,X
	BNE	CKCHOP
	LDA	SHUTLE
	CMP	#CLOUDY	;cloud?
	BEQ	ENDMOV
	LDA	#0
	STA	CHOLIV,X	;kill
CKCHOP	LDA	SHUTLE	;don't kill clouds
	CMP	#CLOUDY
	BEQ	ENDMOV
	LDA	KILL,X	;was he hit?
	BPL	ENDMOV
	LDA	CHOPOS,X
	SUB	#LEFT-8
	STA	XEXPLO
	LDA	ALTVER,X
	STA	YEXPLO
	LDA	#0	;now zero chopper
	STA	CHOPOS,X
	STA	CHOLIV,X
	LDA	#25
	JSR	INIEXP
	LDA	#6	;60 points
	JSR	ADDSCO
	RTS

NEWCHO	LDA	DOTIME
	BEQ	ENDMOV
	LDA	TIMER
	AND	#$0F
	BNE	ENDMOV
	JSR	MAYBE
	BCS	ENDMOV
	LDA	RANDOM
	AND	#$0F
	ADD	CHORAT	;reappear
	STA	CHOVEL,X
	STA	CHOSPD,X
	LSR	A
	LSR	A
	STA	KILL,X	;resist
	INC	CHOLIV,X	;it lives
ENDMOV	RTS

* For missile work...

ERAOLD	LDA	BOMYP,X	;erase bomb X
	TAY
	DEY
	JSR	MISZER	;7 bytes!
	JSR	MISZER
	JSR	MISZER
	JSR	MISZER
	JSR	MISZER
	JSR	MISZER
	JSR	MISZER
	RTS

MISZER	LDA	MISL,Y	;bits off
	AND	BITOFF,X
	STA	MISL,Y
	INY	;next
	RTS

MISONE	LDA	MISL,Y
	ORA	BITSON,X
	STA	MISL,Y
	RTS

* Move the bombs

BOMBS	DEC	BOMTIM	;time yet?
	BEQ	SETBOM
	RTS

* Reset the time and move 'em

SETBOM
	MOV	BOMRES,BOMTIM
	STA	BOMTIM
	ZER	LOWCMP
	LDX	#NUMBOM
	STX	BOMNUM
DOBOMB	LDA	BOMLIV,X
	BNE	LIVBOM
	JMP	BOTBOM

LIVBOM	LDA	MPFOR,X	;hit the ground?
	AND	#$0E	;exclude shot PF0
	BEQ	DOFALL
	LDA	BOMXP,X
	SUB	#LEFT-3
	LSR	A
	LSR	A
	LSR	A
	TAX
	CPX	#NUMPAR+1	;make sure!
	BCS	JBOTBM
	LDA	LANDED,X
	CMP	ROOF,X
	BEQ	BUILD	;an empty building!
	ADD	#HTPARA	;kill the man
	STA	LANDED,X
	STA	PARVER,X
	JSR	KILPAR	;kill man
JBOTBM	JMP	KILLIT

BUILD	TXA
	TAY
	JSR	DRABLO
	MOV	#25,BWOOOP
	BNE	KILLIT
DOFALL	LDA	MPFOR,X	;hit?
	AND	#1	;shot or explo
	BNE	KILBOM
	INC	BOMYI,X	;gravity
	LDA	BOMYI,X
	CLC
	ADC	BOMYAC,X
	STA	BOMYAC,X
	BCC	XBOMB	;increment?
	INC	BOMYP,X	;move down
	LDA	BOMYP,X	;redraw
	TAY
	CMP	LOWCMP	;make sound?
	BCC	MOVDOW
	STA	LOWCMP
MOVDOW	JSR	MISZER
	LDA	BOMYP,X
	ADD	#4
	TAY
	JSR	MISONE
XBOMB	DEC	BOMVEL,X	;time?
	BNE	BOTBOM
	LDA	BOMSPD,X
	STA	BOMVEL,X
	LDA	BOMDIR,X
	CLC
	ADC	BOMXP,X
	CMP	#LEFT
	BCC	KILBOM
	CMP	#LEFT+XMAX-6
	BCC	SAVBOM
KILBOM	LDA	BOMXP,X
	SUB	#LEFT-3
	STA	XEXPLO
	LDA	BOMYP,X
	SUB	#TOP
	STA	YEXPLO
	LDA	#20
	JSR	INIEXP	;boom
	LDA	#5	;50 points
	JSR	ADDSCO
KILLIT	LDA	#0
	LDX	BOMNUM
	STA	BOMXP,X
	STA	HPOSM0,X	;for now...
	STA	BOMLIV,X
	STA	MPFOR,X
SAVBOM	STA	BOMXP,X	;make sure
BOTBOM	DEC	BOMNUM
	BMI	ENDBOM
	LDX	BOMNUM
	JMP	DOBOMB

ENDBOM
	MOV	LOWCMP,LOWEST
	RTS

* Subtract ten points from score

SUBSCO	LDA	SCORE+1	;cant't be zero!
	ORA	SCORE
	BEQ	ENDSCO
	SED
	LDA	SCORE+1
	SUB	#1	;minus 10 points!
	STA	SCORE+1
	LDA	SCORE
	SBC	#0	;carry
	STA	SCORE
	JMP	SHOSCO

* Add value of accumulator to score

ADDSCO	SED	;for scoring
	ADD	SCORE+1
	STA	SCORE+1
	LDA	SCORE
	ADC	#0	;carry over
	STA	SCORE

SHOSCO	LDY	#1
	LDX	#4
SHO1	LDA	SCORE,Y
	JSR	SHOHEX
	DEX		;skip over comma
	DEY
	BPL	SHO1
	CLD
ENDSCO	RTS

NEXLEV	INC	LEVEL	;add one
	LDA	LEVEL
	AND	#$0F
	STA	LEVEL
	ASL	A
	ASL	A
	ASL	A
	ASL	A
	STA	COLSKY	;for DLI
	STA	COLOR4	;background
SHOLEV	LDY	LEVEL
	LDA	BCD,Y
	LDX	#19	;upper right corner

* Show accumulator as a hex at X

SHOHEX	PHA
	AND	#$0F
	JSR	SHODIG
	PLA
	LSR	A
	LSR	A
	LSR	A
	LSR	A
SHODIG	ORA	#COLMSK OR $10
	STA	SCORLN,X
	DEX
	RTS

BCD	DB	1,2,3,4,5,6,7,8,9,$10
	DB	$11,$12,$13,$14,$15,$16

* Add a building at Y

DRABLO	TYA		;hit the base?
	JSR	CHECKB
	BEQ	ENDBLO	;no draw
	LDA	ROOF,Y	;adjust roof
	CMP	ALTVER+6	;too high?
	BCC	ENDBLO
	PHA
	TAX
	JSR	SETLO	;point
	PLA
	SUB	#HTBLOK
	STA	ROOF,Y
	STA	LANDED,Y
	TAX
	TYA
	ASL	A
	TAY
	LDX	#5
	CLC
DRABL2	LDA	BLOPIC,X	;draw the block
	STA	(LO),Y
	INY
	STA	(LO),Y
	TYA
	ADC	#39
	TAY
	DEX
	BPL	DRABL2
ENDBLO	RTS

* Building graphic

BLOPIC	DB	$C3,$C3,$FF,$C3,$C3,$FF

* Set up landing blocks at bottom

SETBLO	LDX	#NUMBLO
GETRND	LDA	RANDOM
	AND	#$1F	;0-31
	CMP	#20	;0-19
	BCS	GETRND
	TAY
	LDA	LANDED,Y	;taken?
	CMP	#GROUND
	BNE	GETRND
	STX	XREG+1	;self modify
	JSR	DRABLO
XREG	LDX	#0	;gets modified
	DEX
	BPL	GETRND
	RTS

CHARGE
	MOV	#6,NOTNUM
	STA	TUNEON
	RTS

* Check all the buildings...set DEAD
* if half are occupied.

CKDEAD	LDX	#NUMPAR
	LDY	#0
CKDED2	LDA	ROOF,X	;building?
	CMP	#GROUND
	BEQ	CKDED3
	INY
	CMP	LANDED,X	;or man?
	BEQ	CKDED3
	DEY
	DEY
CKDED3	DEX
	BPL	CKDED2
	DEY
	BPL	BASEOK
	MOV	#1,DEAD	;you're out!
BASEOK	RTS

CHECKB	CMP	#9	;do a double check
	BEQ	ENDCK
	CMP	#10
ENDCK	RTS

* Has the base been hit by a trooper?
* Called by SHOPAR to stop gun.

BASHIT	TXA
	JSR	CHECKB
	BNE	ENDCK
	STX	DEAD	;kill
	STX	LEVDON	;no shooting
	ZER	DOTIME	;stop game
	STA	BASPOS

* Blow the base up real good

BLOBAS
	MOV	#1,EXPAND
	MOV	#7,EXPMIN
	MOV	#$FF,EXPMAX
	MOV	#79,XEXPLO
	MOV	#GROUND+3,YEXPLO
	LDA	#[NUMEXP SHR 1]+1	;half
	JMP	INIEXP	;that's it

KILBAS
	MOV	#CLOUDY,SHUTLE
	STA	LEVDON	;kill
	ZER	DOTIME
	JSR	SILENT
	JSR	SHUTUP
	LDX	#$7F
ERAMIS	STA	MISL,X	;erase bombs
	DEX
	BPL	ERAMIS
	STA	BASPOS
	MOV	#4,EXPSPD
BLOBLO
	MOV	#19,XALTER
BLOBL2	LDX	XALTER
	LDA	LANDED,X	;blow 'em up!
	CMP	#GROUND
	BEQ	NEXBLO
	ADD	#3
	STA	YEXPLO
	TXA
	ASL	A
	ASL	A
	ASL	A
	ADC	#3
	STA	XEXPLO
	MOV	#1,EXPAND
	LDA	#3
	JSR	INIEXP
NEXBLO	DEC	XALTER
	BPL	BLOBL2
	BMI	SETWAI

BOOM	JSR	BLOBAS
	MOV	#$80,TIMER
	BNE	ENDGAM
JULY4	LDA	RANDOM	;fireworks
	AND	#$7F
	ADD	#16
	STA	XPLOT
	STA	XEXPLO
	LDA	RANDOM
	AND	#$3F
	STA	YPLOT
	STA	YEXPLO
	JSR	LOCATE
	CMP	#2
	BCS	JULY4
	LDA	#16
	JSR	INIEXP
SETWAI	LDA	RANDOM
	ORA	#1
	STA	TIMER
ENDGAM	JSR	WAITVB
	LDA	CONSOL
	CMP	#7
	BNE	BASEND
	JSR	EXPLO
	LDA	TIMER
	BPL	ENDGAM
	LDA	RANDOM
	ORA	RANDOM
	LSR	A
	BCS	JULY4
	LSR	A
	BCS	BLOBLO
	LSR	A
	BCS	BOOM
BASEND
	MOV	#10,EXPSPD
	JSR	BLOBAS	;last one
	JSR	BLOBAS
	JSR	FINISH	;let finish
	MOV	#GAMOVR,MESMAX
	STA	TITDL+10
	LDA	SCORE	;new high score?
	CMP	HSCORE
	BCC	ENDBAS
	LDA	SCORE+1
	CMP	HSCORE+1
	BCC	ENDBAS
	STA	HSCORE+1
	MOV	SCORE,HSCORE
	LDX	#5
MOVSCO	LDA	SCORLN,X	;move it
	STA	TEXT+[5*20]+13,X
	DEX
	BPL	MOVSCO
	MOV	#HIGHSC,TITDL+10	;point
ENDBAS	JMP	NEWGAM	;try again?

* Begin the next level

NEWLEV
	ZER	DOTIME
	LDA	#1
	JSR	SETTIM	;set minute
	LDA	LEVEL
	AND	#1
	JSR	SHOCHO	;draw choppers
	LDA	SHUTLE
	ASL	A
	ASL	A
	ASL	A
	TAY
	LDX	#7
MOVOPT	LDA	EITHER,Y	;print type
	STA	TEXT+[20*7]+10,X
	INY
	DEX
	BPL	MOVOPT
	MOV	#INCOME,TITDL+10
	JSR	SWITDL	;show message
	JSR	SILENT
	JSR	SHUTUP
	MOV	#$80,TIMER
READIT	JSR	WAITVB
	LDA	TIMER
	BEQ	CONLEV
	ASL	A
	ASL	A
	ASL	A
	EOR	#$0F
	BEQ	READIT
	STA	LOWEST
	BNE	READIT
CONLEV	STA	LOWEST	;zero
	JSR	SWITDL	;back
	LDX	LEVEL	;set up levels
	LDA	LEVCHA,X
	STA	CHANCE
	LDA	LEVRAT,X
	STA	CHORAT
	LDA	LEVEXP,X
	STA	EXPSPD
	STA	EXPTIM
	TXA
	LSR	A
	TAX		;0-7
	LDA	LEVFAL,X	;paratroopers
	STA	FALVEL
	LDA	LEVBOM,X
	STA	BOMRES
	STA	BOMTIM
	TXA
	LSR	A
	TAX		;0-3
	LDA	LEVCOR,X
	STA	CORD
	TXA
	LSR	A
	TAX
	LDA	LEVSHO,X
	STA	SHOSPD
	STA	SHOTIM
	LDA	#0
	LDX	#NUMPAR	;zero databases
ZERPAR	STA	PARTYP,X	;paratroopers
	DEX
	BPL	ZERPAR
	LDX	#NUMBOM
ZERBOM	STA	BOMLIV,X
	STA	BOMXP,X	;horizontal
	DEX
	BPL	ZERBOM
	LDX	#NUMSHO
ZERSHO	STA	SHOLIV,X	;shots
	DEX
	BPL	ZERSHO
	LDX	#NUMEXP
ZEREXP	STA	EXPLIV,X	;explosion
	DEX
	BPL	ZEREXP
	LDX	#NUMCHO
ZERCHO	STA	CHOLIV,X	;choppers
	STA	CHOPOS,X
	STA	KILL,X
	DEX
	BPL	ZERCHO
	LDX	#NUMCHO
SETCOL	TXA
	ADD	#6
	ORA	COLSKY
	EOR	#$F0
	STA	CHOCOL,X
	DEX
	BPL	SETCOL
	ZER	NEXPLO	;start off
	STA	LEVDON	;allow shooting
	RTS

EITHER	DB	'sreppohc'	;back
	DB	'selttuhs'	;wards

SWITDL	JSR	WAITVB	;hold on...
	LDA	TITLST	;OK now swap
	EOR	#6
	STA	TITLST
	TAX
	LDY	#5
DOTITL	LDA	TITDL,X
	STA	GAMEDL+TITOFF,Y
	INX
	DEY
	BPL	DOTITL
	LDA	TITLST
	BEQ	ENDTIT
	LDX	#NUMCHO
MOVCLO	LDA	RANDOM
	AND	#$7F
	ADD	#LEFT+7	;center
	STA	CHOPOS,X
	LDA	RANDOM
	AND	#$0F
	ORA	#$0A
	STA	CHOCOL,X
	DEX
	BPL	MOVCLO
ENDTIT	RTS

NXTMES	LDA	GAMEDL+TITOFF+1
	CMP	MESMAX
	BCC	MOVMES
	JSR	CHARGE
	ZER	GAMEDL+TITOFF+1
	BEQ	ENDMES
MOVMES	LDX	#19	;scroll
SCROLL	JSR	WAITVB
	INC	GAMEDL+TITOFF+1
	TXA
	AND	#1
	ASL	A
	ASL	A
	ASL	A
	STA	AUDC1
	STX	AUDF1
	DEX
	BPL	SCROLL
ENDMES	RTS

TITDL	DB	$0D,$0D,$0D
	DB	$0D,$0D,$0D	;backward
	DB	HIGH [SCRMEM+[40*64]]
	DB	LOW [SCRMEM+[40*64]],$4D
	DB	HIGH TEXT,LOW TEXT,$46

* Game initializes here...

INIT
	ZER	DMACTL	;execution begins here
	STA	AUDCTL	;sounds
	LDX	#VAREND-VARBEG-1
ZERPAG	STA	VARBEG,X	;clear 'em
	DEX
	BPL	ZERPAG
	JSR	SIOINV	;sounds
	JSR	SETSCR	;set up screen
	JSR	CLRSCR	;clear screen
	JSR	CLRPLR
	JSR	SHOSCO
	JSR	ZERTIM
	JSR	SHOLEV
	JSR	ALTPER	;period
	JSR	INITEX
	MOV	#4*20,MESMAX
	MOV	#TRISPD,TRITIM	;for gun
	MOV	#1,LEVDON
	MAD	DLI,VDSLST
	MAD	GAMEDL,SDLSTL
	MOV	#HIGH PMBAS,PMBASE
	MOV	#3,GRACTL
	MOV	#$11,GPRIOR
	LDX	#HIGH VBLANK
	LDY	#LOW VBLANK
	LDA	#6
	JSR	SETVBV
	LDX	#5
DRABAS	LDA	BASPIC,X	;draw base
	STA	PLR0+TOP+GROUND,X
	DEX
	BPL	DRABAS
	MOV	#$C0,NMIEN
	ZER	COLOR0	;shots/explo
	MOV	#$CE,COLOR1	;'troopers
	MOV	#$42,COLOR2	;'chutes
	MOV	#$2E,DMACTL	;on
	ZER	TITDL+10

* A new game starts here...

NEWGAM
	ZER	DEAD
	STA	MPLOR
	STA	DOTIME
	JSR	SHUTUP
	JSR	SILENT
	MOV	#$34,COLOR3	;red sun
	LDX	#NUMCHO
MAKCLO	LDA	RANDOM	;create clouds
	AND	#$0F
	ORA	#3
	STA	CHOLIV,X
	STA	CHOVEL,X
	STA	CHOSPD,X
	DEX
	BPL	MAKCLO
	LDA	#CLOUDY
	JSR	SHOCHO
	JSR	SWITDL	;open a line
	LDX	#7
MOVSUN	LDA	THESUN,X
	STA	MISL+TOP+3,X
	DEX
	BPL	MOVSUN
	ZER	TIMER
	LDA	RANDOM
	AND	#$7F
	ADD	#LEFT+10
	LDX	#3
	CLC
PUTSUN	STA	BOMXP,X
	ADC	#2
	DEX
	BPL	PUTSUN
	STA	HITCLR	;careful!
WAIT	JSR	WAITVB	;a jiffy
	LDA	CONSOL
	AND	#2	;SELECT?
	BNE	CKSTRT
	MOV	#SELECT,GAMEDL+TITOFF+1
	ZER	TIMER
	JSR	NEXLEV	;add one
	MOV	#$10,BINGS
WAISEL	LDA	CONSOL	;let go!
	AND	#2
	BEQ	WAISEL
CKSTRT	LDA	CONSOL
	AND	#1
	AND	STRIG	;either
	BEQ	START
	LDA	TIMER
	AND	#$7F	;switch?
	BNE	WAIT
	JSR	NXTMES
	JMP	WAIT	;bottom of loop

JNEWGM	JMP	NEWGAM

START
	ZER	SCORE
	STA	SCORE+1
	JSR	SHOSCO
	JSR	SWITDL	;restore
WAISTR	LDA	CONSOL	;let go
	LSR	A
	BCC	WAISTR
	JSR	CLRSCR
	MOV	#125,BASPOS	;place gun
	MOV	#6,JIFFY
	LDA	#0
	LDX	#7
ZERSUN	STA	MISL+TOP+3,X
	DEX
	BPL	ZERSUN
	MOV	#$2E,COLOR3	;bombs
	LDX	#NUMPAR
	LDA	#GROUND
ZERLAN	STA	LANDED,X
	STA	ROOF,X
	DEX
	BPL	ZERLAN
	LDA	#GROUND-HTBLOK	;hold base
	LDX	#1
FIXLAN	STA	LANDED+9,X
	STA	ROOF+9,X
	DEX
	BPL	FIXLAN
	JSR	SETBLO	;now it's ok

* Next level begins here...

GAME	JSR	NEWLEV	;a level begins!
	MOV	#1,DOTIME	;start clock up
LOOP	LDA	CONSOL
	CMP	#7
	BEQ	GAMCON
	MOV	#SELECT,TITDL+10
	JMP	NEWGAM

GAMCON	JSR	MOVCHO	;choppers/shuttles
	JSR	SHOTS	;do shots
	JSR	EXPLO	;explosion
	LDA	SHUTLE	;shuttles?
	BNE	LOOP2	;fork
	JSR	MOVPAR	;paratroopers
	JSR	DOBLAD	;animation
	JMP	LOOP3

LOOP2	JSR	BOMBS	;bombs
	LDA	MPLOR	;base hit?
	BEQ	LOOP3
	JMP	KILBAS	;blow up

LOOP3	LDA	DOTIME	;done yet?
	BNE	LOOP	;bottom of loop
	LDX	#NUMBOM
CKOVER	ORA	BOMLIV,X	;all of these
	DEX
	BPL	CKOVER
	ORA	PARAS	;must be zero
	ORA	CHOPS
	BNE	LOOP	;wait for those
	MOV	#10,EXPSPD	;do quickly
	STA	SHOSPD
	STA	LEVDON	;no shooting
	JSR	FINISH
	JSR	CKDEAD
	LDA	DEAD
	BNE	KILLEM
	JSR	NEXLEV	;next level...
	JMP	GAME

KILLEM	JMP	KILBAS

* Let the EXPLOsions and SHOTs quit

FINISH	JSR	SHOTS
	JSR	EXPLO
	LDA	#0
	LDX	#NUMSHO
CKSHOS	ORA	SHOLIV,X
	DEX
	BPL	CKSHOS
	LDX	#NUMEXP
CKEXPL	ORA	EXPLIV,X
	DEX
	BPL	CKEXPL
	CMP	#0
	BNE	FINISH
	RTS

* If time to, animate the blades

DOBLAD	DEC	BLATIM	;time?
	BNE	ENDBLA
	MOV	#23,BLATIM
	LDA	BLADE	;next picture
	ADD	#1
	AND	#3	;0-3
	STA	BLADE
	TAX
	LDY	#0
	LDA	BLLEF1,X
	JSR	DOPLR0
	LDA	BLLEF2,X
	JSR	DOPLR1
	LDA	BLRIG1,X
	JSR	DOPLR2
	LDA	BLRIG2,X
	JSR	DOPLR3
ENDBLA	RTS

* Draw the helicopters (or shuttles)

SHOCHO	STA	SHUTLE
	TAY
	LDX	MULT48,Y	;multiply by 48
	LDY	#0
CHO2	LDA	CHLEF1,X
	JSR	DOPLR0
	LDA	CHLEF2,X
	JSR	DOPLR1
	LDA	CHRIG1,X
	JSR	DOPLR2
	LDA	CHRIG2,X
	JSR	DOPLR3
	INX
	INY
	CPY	#12
	BCC	CHO2
	RTS

MULT48	DB	0,48,96	;times 48

* Player images
CHRIG1	DB	$07,$00,$00,$C0,$FF,$3F
	DB	$07,$01,$00,$00,$00,$01
CHRIG2	DB	$FF,$20,$78,$E4,$E2,$E2
	DB	$E2,$E2,$FC,$78,$11,$FE
CHLEF1	DB	$FF,$04,$1E,$27,$47,$47
	DB	$47,$47,$3F,$1E,$88,$7F
CHLEF2	DB	$E0,$00,$00,$03,$FF,$FC
	DB	$E0,$80,$00,$00,$00,$80

* Space shuttle
SHRIG1	DB	$E0,$F0,$F0,$F8,$FC,$7E
	DB	$7F,$FF,$FF,$FF,$FC,$7B
SHRIG2	DB	0,0,0,0,0,0
	DB	$F8,$E4,$FE,$FF,$1F,$EC
SHLEF1	DB	0,0,0,0,0,0
	DB	$1F,$27,$7F,$FF,$F8,$37
SHLEF2	DB	$07,$0F,$0F,$1F,$3F,$7E
	DB	$FE,$FF,$FF,$FF,$3F,$DE
CLOUDS	DB	0,0,0,0,0,$0C
	DB	$1F,$1F,$F,$3F,$FE,0
	DB	0,0,$30,$78,$FD,$FF
	DB	$FF,$FE,$FF,$FF,$EC,0
	DB	0,0,$0C,$1E,$5F,$FF
	DB	$FF,$7F,$FF,$FF,$37,0
	DB	0,0,0,0,0,$30
	DB	$F8,$F8,$F0,$FC,$7F,0
BLRIG1	DB	$04,$06,$03,$01	;blades
BLRIG2	DB	$71,$1C,$06,$C3
BLLEF1	DB	$8E,$C3,$60,$38
BLLEF2	DB	$20,$80,$C0,$60
THESUN	DB	$3C,$7E,$FF,$FF
	DB	$FF,$FF,$7E,$3C

* ORA the MnPFs together

ORM0PF	LDX	#3
OR2	LDA	M0PF,X	;save collision
	ORA	MPFOR,X
	STA	MPFOR,X
	DEX
	BPL	OR2
	RTS

* The DL interrupt checks shot-
* chopper collisions, gives the
* choppers color & position and gives
* the bombs their expanding effect.

DLI	PHA
	TXA
	PHA
	TYA
	PHA
	CLD
	LDX	DLIPNT
	LDY	#0
DLI1	LDA	P0PF,Y	;chopper hit?
	ORA	P1PF,Y
	AND	#1
	BEQ	DLI2
	DEC	KILL-2,X	;hit him
	LDA	CHOSPD-2,X	;slow down!
	STA	CHOHIT
	SUB	#2
	STA	CHOSPD-2,X
DLI2	INX
	INY
	INY
	CPY	#4
	BCC	DLI1
	JSR	ORM0PF
	LDA	DLIPNT
	ADD	#2
	ORA	COLSKY
	STA	WSYNC
	STA	COLBK	;color of sky
	STA	HITCLR	;clear collisions
	LDX	DLIPNT
	LDY	#0
DLI3	LDA	CHOCOL,X	;show choppers
	STA	PMCOL0,Y
	STA	PMCOL0+1,Y
	LDA	CHOPOS,X
	STA	HPOSP0,Y	;new player
	ADD	#8
	INY
	STA	HPOSP0,Y	;and right
	INX
	INY
	CPY	#4
	BCC	DLI3
	STX	DLIPNT	;update it

	CPX	#6	;handle bombs
	LDA	BOMSIZ
	ROL	A
	AND	#3
	STA	BOMSIZ
	EOR	#3
	STA	BOMOFF
	LDX	#NUMBOM
FIXSIZ	LDA	BOMSIZ	;expand BOMSIZ
	ASL	A
	ASL	A	;for 8 bits
	ORA	BOMSIZ
	STA	BOMSIZ
	DEX
	BPL	FIXSIZ
	STA	WSYNC
	STA	SIZEM	;bomb width
	LDX	#NUMBOM
	CLC
SHOBOM	LDA	BOMXP,X	;show bombs
	ADC	BOMOFF
	STA	HPOSM0,X
	DEX
	BPL	SHOBOM
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

* Clock is 0:00.0 set minutes with A

ZERTIM	LDA	#0	;early entry
SETTIM	PHA		;set clock for minutes
	LDX	#5
	LDA	#0
	JSR	PUTDIG
	DEX		;period
	JSR	PUTDIG
	JSR	PUTDIG
	DEX		;colon
	PLA
	JSR	PUTDIG
	RTS

* Clock subroutines for VBLANK

ALTCOL	LDA	TIME+1	;blink punctuation
	EOR	#CHCOL OR COLMSK
	STA	TIME+1
ALTPER	LDA	TIME+4
	EOR	#CHPER OR COLMSK
	STA	TIME+4
	RTS

GETDIG	DEC	TIME,X	;subtract
	LDA	TIME,X
	AND	#$0F
	CMP	#10	;and check overflow
	RTS

PUTDIG	ORA	#COLMSK OR $10	;get ready
	STA	TIME,X
	DEX
	RTS

* The vertical blank occurs every
* 60th of a second to adjust time,
* read the joystick, check collisions
* and update the sounds.

VBLANK	CLD
	ZER	DLIPNT	;reset DLI pointer
	STA	BOMSIZ
	INC	TIMER	;general timer
	LDA	DOTIME	;do time now?
	BEQ	CKSTIK
	DEC	JIFFY
	BNE	CKSTIK
	MOV	#6,JIFFY
	LDX	#5	;tenth of a second
	JSR	GETDIG
	BCC	CKSTIK
	LDA	#9	;reset and borrow
	JSR	PUTDIG
	JSR	ALTCOL	;flop
	DEX		;skip period
	JSR	GETDIG	;do seconds
	BCC	CKSTIK
	LDA	#9
	JSR	PUTDIG
	JSR	GETDIG
	BCC	CKSTIK
	LDA	#5
	JSR	PUTDIG
	DEX		;skip colon
	JSR	GETDIG	;do minutes
	BCC	CKSTIK
	ZER	DOTIME	;stop clock
	JSR	ZERTIM	;zero time
	MOV	#$30,BINGS
CKSTIK	LDA	TIMER
	AND	#3
	BNE	CKTRIG
	LDA	STICK	;create delta
	LSR	A
	LSR	A
	EOR	#3	;flip around
	TAX
	LDA	DIREC,X
	ADD	GUNROT
	CMP	#11	;no wrap
	BCS	CKTRIG
	STA	GUNROT
	TAX
	ASL	A
	ASL	A
	ASL	A
	ASL	A
	ORA	#8	;half shade
	STA	BASCOL
	LDA	COSDEC,X
	STA	XDRDEC
	LDA	COSINT,X
	STA	XDRINT
	LDA	SINDEC,X
	STA	YDRDEC
	LDA	SININT,X
	STA	YDRINT
	TXA		;draw new gun
	ASL	A
	ASL	A	;times four
	TAY
	LDX	#3	;four bytes
SHOGUN	LDA	GUNPIC,Y
	STA	PLR0+TOP+73,X
	INY
	DEX
	BPL	SHOGUN	;an NBC show
	BMI	CKCOLL
CKTRIG	DEC	TRITIM
	BNE	CKCOLL
	MOV	#TRISPD,TRITIM
	LDA	LEVDON	;ok to shoot?
	BEQ	TRIZER
	LDA	SHUTLE
	CMP	#CLOUDY
	BNE	CKCOLL
	JSR	MOVCHO	;move clouds
	JMP	CKCOLL

TRIZER	LDA	STRIG	;trigger?
	BNE	CKCOLL
	STA	ATRACT
	LDX	#NUMSHO
CKLIV	LDA	SHOLIV,X	;empty?
	BEQ	DOSHOT
	DEX
	BPL	CKLIV
	STX	BASCOL
	BMI	CKCOLL	;bullets!
DOSHOT	LDA	BASPOS
	EOR	#1
	STA	BASPOS
	SUB	#LEFT-4
	STA	SHXINT,X
	LDA	#GROUND
	STA	SHYINT,X
	LDA	#0
	STA	SHXDEC,X
	STA	SHYDEC,X
	INC	SHOLIV,X
	MOV	#16,SHOVOL
	JSR	SUBSCO	;lose points
CKCOLL	LDX	#3
	LDA	MPLOR
CKBASE	ORA	M0PL,X	;base hit?
	DEX
	BPL	CKBASE
	AND	#1	;just PL0
	STA	MPLOR
	JSR	ORM0PF
	STA	HITCLR
	LDA	TIMER	;sound effects
	AND	#3
	BEQ	BRITNS
	LDA	SHOVOL
	BEQ	STAUD1
	DEC	SHOVOL
	MOV	SHOVOL,AUDF1
	ORA	#$20
STAUD1	STA	AUDC1
	JMP	DOAUD2

BRITNS	LDA	BRIGHT
	BEQ	STAUD1
	STA	COLOR0	;b/w
	ORA	#$40
	STA	AUDC1
	LDA	RANDOM
	AND	#$1F
	ADD	#40
	STA	AUDF1
	DEC	BRIGHT
DOAUD2	LDA	TUNEON	;playing charge?
	BEQ	LOWSND
	LDA	TIMER	;time to update?
	AND	#1
	BNE	DOAUD3
	LDA	NOTVOL	;volume
	ORA	#$A0
	STA	AUDC2
	DEC	NOTVOL	;lower volume
	BPL	DOAUD3
	DEC	NOTNUM	;next note
	BPL	NEXNOT
	ZER	TUNEON	;kill tune
	STA	NOTVOL
	STA	NOTNUM
	BEQ	LOWSND
NEXNOT	LDX	NOTNUM
	LDA	NOTES,X
	STA	AUDF2
	LDX	#5	;note length
	CMP	#60	;long note?
	BNE	SHNOTE
	LDX	#10
SHNOTE	STX	NOTVOL
	BNE	DOAUD3
NOTES	DB	60,72,60,72,91,121
LOWSND	LDA	LOWEST
	BEQ	ZERLOW
	STA	AUDF2
	LDA	#$A8
ZERLOW	STA	AUDC2

DOAUD3	LDA	SHUTLE
	SUB	#2
	BEQ	NOBLAS
	LDA	CHOHIT	;a chopper hit?
	BEQ	ENGSND
	STA	AUDF3
	MOV	#$A8,AUDC3
	ZER	CHOHIT
	BEQ	DOAUD4
ENGSND	LDA	CHONSC
	BEQ	NOBLAS
	LDA	SHUTLE
	BEQ	CHOSND
	LDA	CHONSC	;use for volume
	PHA
	ORA	#$C0
	STA	AUDC3
	PLA
	ASL	A
	ASL	A
	ASL	A
	ADD	#120
	STA	AUDF3
	BNE	DOAUD4
CHOSND	INC	BLASND
	LDA	BLASND
	AND	#$0F
	STA	BLASND
	TAX
	LDA	BLAFRQ,X
	STA	AUDF3
	LDA	CHONSC
	CLC
	ADC	BLACNT,X
NOBLAS	STA	AUDC3

* lots of sound effects here

DOAUD4
	ZER	AUDC4	;make sure
	LDA	CHUSND
	BEQ	CKRIP
	TAX
	LDA	CHUFRQ-1,X
	STA	AUDF4
	LDA	CHUCNT-1,X
	STA	AUDC4
	DEC	CHUSND
CKRIP	LDA	RIPSND	;ripping sound
	BEQ	CKYELL
	STA	AUDF4
	TAX
	LDA	RIPCNT-1,X
	STA	AUDC4
	DEC	RIPSND
CKYELL	LDA	SCREAM
	BEQ	CKBWOP
	TAX
	LDA	SCRFRQ-1,X
	STA	AUDF4
	LDA	SCRCNT-1,X
	STA	AUDC4
	DEC	SCREAM
CKBWOP	LDA	BWOOOP
	BEQ	CKBING
	ASL	A
	ASL	A
	ASL	A
	STA	AUDF4
	MOV	#$A6,AUDC4
	DEC	BWOOOP
CKBING	LDA	BINGS	;bing sound?
	BEQ	ENDVBI
	MOV	#80,AUDF4
	DEC	BINGS
	LDA	BINGS
	AND	#$0F
	ORA	#$A0
	STA	AUDC4
ENDVBI	JMP	SYSVBV	;exit VBI

SCRCNT	DB	$A3,$A4,$A5,$A7,$A9,$A8
	DB	$A7,$A6,$A8,$AA
SCRFRQ	DB	4,6,9,11,15,12,17,13,19,14
RIPCNT	DB	12,10,8,6,5,4,3,2,2,1
CHUCNT	DB	$45,$47,$49,$4B,$4D,$4F
CHUFRQ	DB	10,14,18,22,26,30

BLAFRQ	DB	10,11,12,13,14,13,12,11,10
	DB	9,8,7,6,7,8,9
BLACNT	DB	3,2,1,0,3,2,1,0,2,1,0,2
	DB	2,0,1,0

COS15	=	$E1
COS30	=	$DD
COS45	=	$B4
COS60	=	$80
COS75	=	$42
COS90	=	0
COS105	=	0-COS75
COS120	=	0-COS60
COS135	=	0-COS45
COS150	=	0-COS30
COS165	=	0-COS15
SIN15	=	COS105
SIN30	=	COS120
SIN45	=	COS135
SIN60	=	COS150
SIN75	=	COS165
SIN90	=	0-$100

COSDEC	DB	LOW COS165,LOW COS150
	DB	LOW COS135,LOW COS120
	DB	LOW COS105,LOW COS90
	DB	LOW COS75,LOW COS60
	DB	LOW COS45,LOW COS30
	DB	LOW COS15
COSINT	DB	HIGH COS165,HIGH COS150
	DB	HIGH COS135,HIGH COS120
	DB	HIGH COS105,HIGH COS90
	DB	HIGH COS75,HIGH COS60
	DB	HIGH COS45,HIGH COS30
	DB	HIGH COS15
SINDEC	DB	LOW SIN15,LOW SIN30
	DB	LOW SIN45,LOW SIN60
	DB	LOW SIN75,LOW SIN90
	DB	LOW SIN75,LOW SIN60
	DB	LOW SIN45,LOW SIN30
	DB	LOW SIN15
SININT	DB	HIGH SIN15,HIGH SIN30
	DB	HIGH SIN45,HIGH SIN60
	DB	HIGH SIN75,HIGH SIN90
	DB	HIGH SIN75,HIGH SIN60
	DB	HIGH SIN45,HIGH SIN30
	DB	HIGH SIN15

SCORLN	DB	0,0,CHCOM OR COLMSK,0,0
	DB	$10 OR COLMSK,0,0,0,0,0
	DB	CHCOL OR COLMSK,0,0
	DB	CHPER OR COLMSK,0,0,0,0,0

TIME	=	SCORLN+9	;center it

* Pictures of things...

* Gun at angles

GUNPIC	DB	$F8,$F8,$00,$00
	DB	$78,$F0,$40,$00
	DB	$38,$70,$60,$00
	DB	$38,$70,$70,$20
	DB	$38,$38,$70,$70
	DB	$38,$38,$38,$38	;vertical
	DB	$38,$38,$1C,$1C
	DB	$38,$1C,$1C,$08
	DB	$38,$1C,$0C,$00
	DB	$3C,$1E,$04,$00
	DB	$3E,$3E,$00,$00

BASPIC	DB	$38,$7C,$7C,$FE,$FE,$FE

* Paratrooper images
PARLEF	DB	$00,$00,$02,$2A,$02,$28
	DB	0,0
	DB	$0F,$3F,$30,$2A,$02,$28
	DB	0,0,0,0,0,0,0,0,0,0
	DB	0,0,$22,$0A,$02,$28,0,0
PARRIG	DB	$00,$00,$80,$A8,$80,$28
	DB	0,0
	DB	$F0,$FC,$0C,$A8,$80,$28
	DB	0,0,0,0,0,0,0,0,0,0
	DB	0,0,$88,$A0,$80,$28,0,0
DIREC	DB	0
CHODIR	DB	0-1,1,0

* Level database

LEVEXP	DB	70,90,65,80,80,80,80,70
	DB	80,80,90,80,40,70,30,50
LEVRAT	DB	70,30,65,30,50,45,40,35
	DB	30,25,21,18,14,11,8,5
LEVCHA	DB	10,20,30,30,40,40,50,50
	DB	60,60,70,70,80,90,100,110
LEVFAL	DB	$FF,$C0,$B0,$A0
	DB	$90,$70,$50,$30
LEVBOM	DB	35,30,25,20,15,10,5,3
LEVVEL	DB	$BF,$3F,$1F,$14	;speed
LEVCOR	DB	20,34,44,54	;cord
LEVSHO	DB	18,11
ALTVER	DB	8,8,22,22,36,36,50,50

* Explosion database

EXPLIV	DS	NUMEXP+1
EXPXP	DS	64
EXPYP	DS	64
EXPXI	DS	64
EXPYI	DS	64
EXPXAC	DS	64
EXPYAC	DS	64
EXPDIR	DS	64

* Shot database

SHOLIV	DS	NUMSHO+1	;exists?
SHXINT	DS	16	;position on screen
SHYINT	DS	16
SHXDEC	DS	16
SHYDEC	DS	16
SHVDEC	DS	16	;for gravity
SHVINT	DS	16

* Paratrooper database

PARTYP	DS	NUMPAR+1	;D3=chute D2=landed D0=exists
PARVEL	DS	20	;countdown to inc'
PARSPD	DS	20
PARVER	DS	20	;vertical position
LANDED	DS	20	;landed on ground
ROOF	DS	20	;height of roofs

* Chopper database

	DS	2	;just to be safe
CHOVEL	DS	NUMCHO+1	;countdown
	DS	2
CHOSPD	DS	8	;reset value
	DS	2
CHOTIM	DS	8
	DS	2
CHOCOL	DS	8	;chopper color
	DS	2
BASCOL	=	CHOCOL+NUMCHO+1	;color
CHOPOS	DS	8
	DS	2
BASPOS	=	CHOPOS+NUMCHO+1	;gun
CHOLIV	DS	8
	DS	2
KILL	DS	8	;resistance to shot
	DS	2

* The four bombs are missles

BOMLIV	DS	NUMBOM+1
BOMXP	DS	4
BOMVEL	DS	4	;rate of fall
BOMSPD	DS	4
BOMYP	DS	4
BOMYI	DS	4
BOMYAC	DS	4
BOMDIR	DS	4	;direction

* Screen memory lookup

SCRLO	DS	YMAX+1	;memory pointers
SCRHI	DS	YMAX+1

* And that's all she wrote!

	END	INIT

