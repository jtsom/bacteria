0100 ;
0110 ; **************************
0120 ; *        BOPOTRON        *
0130 ; *   by Kyle S. Peacock   *
0140 ; *    ANALOG COMPUTING    *
0150 ; **************************
0160 ;
0170 ; *******************
0180 ; * ZERO PAGE USAGE *
0190 ; *******************
0200 ;
0210 PLADR = $CB     ;ADDR PLR AREA
0220 PMSTR = $CD     ;ADDR PLR DATA
0230 SCREEN = $CF    ;ADDR OF SCREEN
0240 ;
0250 ; ***************************
0260 ; * HARD/SOFTWARE REGISTERS *
0270 ; ***************************
0280 ;
0290 POKMSK = $10    ;BREAK DISABLE
0300 SAVMSC = $58    ;SCREEN ADDR.
0310 STICK = $0278   ;JOYSTICK PORT
0320 COLOR3 = $02C7  ;COLOR REG. #3
0330 HPOSP0 = $D000  ;HOR. POS. PLRs
0340 TRIG0 = $D010   ;JOYSTICK BUTTON
0350 RANDOM = $D20A  ;RANDOM NO.
0360 IRQEN = $D20E   ;BREAK DISABLE
0370 CHBASE = $D409  ;CHAR SET ADDR
0380 WSYNC = $D40A   ;WAIT FOR SYNC.
0390 SETVBV = $E45C  ;SET VBLANK
0400 XITVBV = $E462  ;END OF VBLANK
0410 ;
0420 ; ****************
0430 ; * MEMORY USAGE *
0440 ; ****************
0450 ;
0460     *=  $0601
0470 ACTIVATE *= *+1 ;VBLANK ACTIVE
0480 STARTPT *= *+1  ;PLR Y START
0490 ENDPT *= *+1    ;PLR Y END
0500 DATAPT *= *+1   ;DATA POINTER
0510 XPOS *= *+4     ;PLRs X-COORDS.
0520 YPOS *= *+4     ;PLRs Y-COORDS.
0530 STATUS *= *+4   ;PLRs DEATH FLAG
0540 PNTR *= *+2     ;DATA POINTERS.
0550 XSPEED *= *+2   ;PLATFORM SPEED
0560 DELTAX *= *+2   ;PLAT. X-DELTA
0570 DELTAY *= *+2   ;PLAT. Y-DELTA
0580 SPEEDS *= *+10  ;PLAT. SPEED
0590 XSTART *= *+10  ;PLAT. X-START
0600 YSTART *= *+10  ;PLAT. Y-START
0610 XEND *= *+10    ;PLAT. X-END
0620 YEND *= *+10    ;PLAT. Y-END
0630 CHAR *= *+2     ;STANDING ON #.
0640 MOVETIME *= *+1 ;MOVEMENT TIMER
0650 TASKERS *= *+1  ;# OF PLATFORMS
0660 XHOLD *= *+1    ;X-REG. HOLD
0670 YHOLD *= *+1    ;Y-REG. HOLD
0680 SLIP *= *+1     ;ON PLAT. FLAG
0690 FALLCOUNT *= *+2 ;HOW FAR TO FALL...
0700 ;
0710 ; ******************************
0720 ; * VERTICAL BLANK INITIALIZER *
0730 ; ******************************
0740 ;
0750     CLD         ;CHILL DECIMAL.
0760     LDA POKMSK  ;DISABLE BREAK
0770     AND #$7F    ;KEY. THE BREAK
0780     STA POKMSK  ;KEY NO LONGER
0790     STA IRQEN   ;WORKS. (SO?!?)
0800     PLA         ;# OF VARIABLES
0810     PLA         ;VBLANK HI/BYTE
0820     STA XHOLD   ;HOLD ON TO IT.
0830     PLA         ;VBLANK LO/BYTE
0840     STA YHOLD   ;HOLD ON TO IT.
0850     PLA         ;PLAYERS HI/BYTE
0860     STA PLADR+1 ;STORE IT.
0870     PLA         ;PLAYERS LO/BYTE
0880     STA PLADR   ;STORE IT.
0890     PLA         ;PLAYER STRING
0900     STA PMSTR+1 ;HI/BYTE.
0910     PLA         ;PLAYER STRING
0920     STA PMSTR   ;LO/BYTE.
0930     LDA #$01    ;STOP OLD VBLANK
0940     STA ACTIVATE
0950     LDA PLADR+1 ;HOLD ON TO ADDR
0960     PHA         ;OF PM AREA.
0970     LDX #$03    ;LOAD X-REG.
0980     LDY #$00    ;LOAD Y-REG.
0990     TYA         ;LOAD A-REG.
1000 CLEAR
1010     STA (PLADR),Y ;CLEAR PMs
1020     INY         ;MOVE TO NEXT.
1030     BNE CLEAR   ;ALL DONE?
1040     INC PLADR+1 ;MOVE TO NEXT.
1050     DEX         ;ALL DONE?
1060     BPL CLEAR   ;NO. GO BACK!
1070     LDX #$09    ;SET X FOR CLEAR
1080 CLEAR2
1090     STA SPEEDS,X ;CLEAR OLD
1100     CPX #$04    ;MOTION TIMERS
1110     BCS CLEAR3  ;& STATUS. PRE-
1120     STA STATUS,X ;PARE FOR NEW
1130 CLEAR3
1140     DEX         ;DATA CONTROL
1150     BPL CLEAR2  ;INFORMATION.
1160     STA FALLCOUNT
1170     STA PNTR
1180     STA XSPEED+0 ;STOP PREVIOUS
1190     STA XSPEED+1 ;PLATFORMS.
1200     STX TASKERS ;SOUND OFFICIAL?
1210     LDA #$05    ;I DIDN'T THINK
1220     STA PNTR+1  ;SO!!!!!!!!
1230     PLA         ;YES. RESTORE
1240     STA PLADR+1 ;PM AREA.
1250     LDX XHOLD   ;VBLANK HI/BYTE
1260     LDY YHOLD   ;VBLANK LO/BYTE
1270     LDA #$07    ;DEF. VBLANK.
1280     JMP SETVBV  ;SET IT UP/BOOGIE...
1290 ;
1300 ; **************************
1310 ; * DISPLAY LIST INTERRUPT *
1320 ; **************************
1330 ;
1340     *=  $2000
1350     PHA         ;SAVE ACC.
1360     LDA $0600   ;CHR. HI/BYTE.
1370     STA WSYNC   ;WAIT A WHILE.
1380     STA CHBASE  ;SAVE CHR. SET.
1390     PLA         ;RESTORE ACC.
1400     RTI         ;BOOGIE...
1410 ;
1420 ; ***********************
1430 ; * PLAYER DRAW ROUTINE *
1440 ; ***********************
1450 ;
1460     CLD         ;CHILL DECIMAL.
1470     INC COLOR3  ;CHANGE COLOR.
1480     LDA ACTIVATE ;VBLANK ACTIVE?
1490     BEQ FUNCTION ;YES! BRANCH!
1500     JMP XITVBV  ;NO. LATER.
1510 FUNCTION
1520     LDA PLADR   ;PLR ADDR. LO.
1530     PHA         ;SAVE IT.
1540     LDA PLADR+1 ;PLR ADDR. HI.
1550     PHA         ;SAVE IT.
1560     LDY #$00    ;BLANK Y REG.
1570     LDX #$00    ;BLANK X REG.
1580 DRAW5
1590     LDA XPOS,X  ;PLR X-POS.
1600     STA HPOSP0,X ;STORE IT.
1610     LDA YPOS,X  ;PLR Y-POS.
1620     STA STARTPT ;SAVE IT.
1630     CLC         ;GET PLAYER
1640     ADC (PMSTR),Y ;LENGTH. ADD
1650     STA ENDPT   ;AND STORE IT.
1660     INY         ;MOVE TO 1st
1670     STY DATAPT  ;DATA BYTE.
1680     CPX #$00    ;PLAYER #0?
1690     BEQ PASS0   ;YES. BRANCH.
1700     LDA PLADR   ;INCREMENT
1710     CLC         ;PLAYER ADDR.
1720     ADC #128    ;FOR DRAWING
1730     STA PLADR   ;NEXT PLAYER.
1740     LDA PLADR+1 ;ADJUST FOR
1750     ADC #$00    ;256 BYTE PAGE
1760     STA PLADR+1 ;WRAP-AROUND.
1770 PASS0
1780     LDA STARTPT ;STARTING PT.
1790     SEC         ;SUBTRACT 10
1800     SBC #10     ;BYTES.
1810     TAY         ;MOVE TO Y-REG.
1820     LDA #$00    ;CLEAR ACC.
1830 INSERT1
1840     STA (PLADR),Y
1850     INY         ;CLEAR OUT
1860     CPY STARTPT ;TOP & BOTTOM
1870     BCC INSERT1 ;OF PLATFORM
1880     LDA ENDPT   ;GET ENDPOINT
1890     CLC         ;AND ADD 10
1900     ADC #10     ;DECIMAL.
1910     TAY         ;MOVE TO Y-REG.
1920     LDA #$00    ;CLEAR ACC.
1930 INSERT2
1940     STA (PLADR),Y ;STORE BLANK
1950     DEY         ;MOVE TO NEXT.
1960     CPY ENDPT   ;AT END?
1970     BCS INSERT2 ;NO. BLANK MORE.
1980 PASS1
1990     LDY STATUS,X ;GET STATUS.
2000     BPL PASS2   ;IF >=0, BRANCH.
2010     LDY PNTR-2,X ;GET POINTER.
2020     LDA YPOS,X  ;GET Y-COORD.
2030     SEC         ;SUBTRACT START-
2040     SBC YSTART,Y ;ING POINT.
2050     CMP #$0B    ;IS IT < 12?
2060     BCC PASS2   ;YES. BRANCH.
2070     CMP #245    ;IS IT >= 245?
2080     BCS PASS2   ;YES. BRANCH.
2090     LDA #$00    ;NO. CLEAR ACC.
2100     BEQ PASSX   ;BRANCH.
2110 BACKUP
2120     BCC DRAW5   ;BRANCH POINT.
2130 PASS2
2140     LDY DATAPT  ;GET POINTER.
2150     LDA (PMSTR),Y ;GET PLR DATA.
2160 PASSX
2170     LDY STARTPT ;GET START PT.
2180     STA (PLADR),Y ;PUT IT PLR AREA
2190     INC STARTPT ;INC. AREA PTR.
2200     INC DATAPT  ;INC. DATA PTR.
2210     LDA STARTPT ;GET AREA PTR.
2220     CMP ENDPT   ;AT END?
2230     BNE PASS1   ;NO. BRANCH.
2240     LDA STATUS,X ;GET STATUS.
2250     BPL OUT     ;IF >=0 BRANCH.
2260     LDA #$00    ;CLEAR ACC.
2270     STA STATUS,X ;SAVE STATUS.
2280     CPX #$02    ;DRAWING BOPOTRON?
2290     BCC OUT     ;YES. BRACH.
2300     LDY PNTR-2,X ;GET PNTR.
2310     LDA XSTART,Y ;GET X-START
2320     STA XPOS,X  ;SAVE AS X-COORD
2330     LDA YSTART,Y ;GET YSTART
2340     STA YPOS,X  ;SAVE AS Y-COORD
2350     LDA #15     ;PAUSE FOR A
2360     STA XSPEED-2,X ;WHILE.
2370 OUT
2380     LDY DATAPT  ;RESTORE Y-REG.
2390     INX         ;MOVE TO NEXT.
2400     CPX #$04    ;AT END?
2410     BCC BACKUP  ;NO. BRANCH.
2420     PLA         ;RESTORE OLD
2430     STA PLADR+1 ;PLAYER ADDR.
2440     PLA         ;POINTERS.
2450     STA PLADR   ;
2460 ;
2470 ; *************************
2480 ; * GIRDER TASKED PLAYERS *
2490 ; *************************
2500 ;
2510     LDX TASKERS ;# OF PLATFORMS.
2520     BMI FORWARD ;NONE. BRANCH.
2530 START
2540     DEC XSPEED,X ;TIME TO MOVE?
2550     BNE FORWARD ;NO BRANCH.
2560     LDA STATUS+2,X ;PLAT ALIVE?
2570     BEQ SELECT  ;YES. BRANCH.
2580     LDA #$FF    ;SET UP FOR NEW
2590     STA STATUS+2,X ;VECTOR.
2600     BMI FORWARD ;BRANCH.
2610 SELECT
2620     LDY PNTR,X  ;GET PNTR.
2630     LDA SPEEDS,Y ;GET PLAT SPEED
2640     STA XSPEED,X ;SAVE IT.
2650     LDA XPOS+2,X ;IS PLATFORM AT
2660     CMP XEND,Y  ;DESTINATION?
2670     BNE ADDUP   ;NO. BRANCH.
2680     LDA YPOS+2,X ;NOW CHECK
2690     CMP YEND,Y  ;Y-COORDS.
2700     BNE ADDUP   ;NOT THERE. BRANCH.
2710     LDA #$01    ;CHANGE STATUS
2720     STA STATUS+2,X ;TO ONE.
2730     LDA #15     ;PAUSE FOR A
2740     STA XSPEED,X ;WHILE.
2750     BPL LOAD0   ;BRANCH.
2760     BMI LOAD0   ;BRANCH.
2770 BACKTRACK
2780     BPL START   ;BRANCH POINT.
2790 FORWARD
2800     BEQ NEXT    ;BRANCH POINT.
2810     BNE NEXT    ;BRANCH POINT.
2820 LOAD0
2830     INC PNTR,X  ;AT DESTINATION.
2840     LDA PNTR,X  ;TIME TO GET
2850     CMP #$05    ;NEXT PREPROG-
2860     BNE LOAD1   ;RAMMED VECTOR.
2870     LDA #$00    ;BUT DON'T GET
2880     BEQ LOAD2   ;VECTOR IF IT
2890 LOAD1
2900     CMP #10     ;IS NOT VALID.
2910     BNE LOAD2   ;IF INVALID,
2920     LDA #$05    ;KEEP SEARCHING
2930 LOAD2
2940     STA PNTR,X  ;FOR VALID
2950     TAY         ;VECTOR.
2960     LDA SPEEDS,Y
2970     BEQ LOAD0
2980     BPL NEXT
2990 ADDUP
3000     LDA XPOS+2,X ;ADD PROPER
3010     CLC         ;DELTA TO PLAT-
3020     ADC DELTAX,X ;FORM X-COORD.
3030     STA XPOS+2,X ;SAVE IT.
3040     LDA YPOS+2,X ;ADD PROPER
3050     CLC         ;DELTA TO PLAT-
3060     ADC DELTAY,X ;FORM Y-COORD.
3070     STA YPOS+2,X ;SAVE IT.
3080     CPX SLIP    ;BOPOTRON ON
3090     BNE NEXT    ;THIS PLATFORM?
3100     LDA XPOS    ;YES. ADD
3110     CLC         ;X-DELTA TO BOP-
3120     ADC DELTAX,X ;OTRON X-COORD
3130     STA XPOS    ;AND SAVE IT.
3140     STA XPOS+1
3150     LDA YPOS    ;ADD Y-DELTA TO
3160     CLC         ;BOPOTRON
3170     ADC DELTAY,X ;Y-COORD AND
3180     STA YPOS    ;SAVE IT.
3190     STA YPOS+1
3200 NEXT
3210     DEX         ;HANDLE NEXT
3220     BPL BACKTRACK ;PLATFORM.
3230 ;
3240 ; *************************
3250 ; * BOPOTRON ON PLATFORM? *
3260 ; *************************
3270 ;
3280     LDA #$FF    ;CLEAR 'ON
3290     STA SLIP    ;PLATFORM' FLAG.
3300     LDX TASKERS ;# OF PLATFORMS
3310     BMI DELTASDONE ;NONE. QUIT.
3320 SLIPTEST
3330     LDA XPOS    ;SUBTRACT BOPO-
3340     SEC         ;TRON X-COORD
3350     SBC XPOS+2,X ;FROM PLATFORM'S
3360     BPL NOABS   ;IF >=0 BRANCH.
3370     EOR #$FF    ;TAKE ABSOLUTE
3380     CLC         ;VALUE.
3390     ADC #$01    ;
3400 NOABS
3410     CMP #$07    ;IS IT >=7?
3420     BCS SETDELTAS ;YES. BRANCH.
3430     LDA YPOS+2,X ;NO. SUBTRACT
3440     SEC         ;BOPOTRON
3450     SBC YPOS    ;Y-COORD.
3460     CMP #12     ;IS IT = 12?
3470     BNE DIETEST ;NO. BRANCH.
3480     STX SLIP    ;SET FLAG.
3490     BNE SETDELTAS ;BRANCH.
3500 DIETEST
3510     BCS SETDELTAS ;IS IT < 12?
3520     LDA #$01    ;YES!!! BOPOTRON
3530     STA ACTIVATE ;DIES PAINFULLY
3540 SETDELTAS
3550     LDA #$00    ;CLEAR OUT OLD
3560     STA DELTAX,X ;DELTA VALUES.
3570     STA DELTAY,X ;
3580     LDY PNTR,X  ;GET PNTR.
3590     LDA XPOS+2,X ;COMPARE DESTIN-
3600     CMP XEND,Y  ;ATION TO ACTUAL
3610     BCC PLUS1X  ;POSITION.
3620     BEQ NEWDELTA ;
3630     LDA #$FF    ;DELTA IS -1.
3640     BMI SETDELTAX
3650 PLUS1X
3660     LDA #$01    ;DELTA IS +1
3670 SETDELTAX
3680     STA DELTAX,X ;SAVE X-DELTA.
3690 NEWDELTA
3700     LDA YPOS+2,X ;COMPARE DES-
3710     CMP YEND,Y  ;TINATION TO
3720     BCC PLUS1Y  ;ACTUAL POSITION
3730     BEQ DELTASDONE
3740     LDA #$FF    ;DELTA IS -1
3750     BMI SETDELTAY
3760 PLUS1Y
3770     LDA #$01    ;DELTA IS +1
3780 SETDELTAY
3790     STA DELTAY,X ;SAVE Y-DELTA.
3800 DELTASDONE
3810     DEX         ;CHECK NEXT
3820     BPL SLIPTEST ;PLATFORM.
3830 ;
3840 ; ***************************
3850 ; * CHARACTER TRACE ROUTINE *
3860 ; ***************************
3870 ;
3880 PASS3
3890     LDA SAVMSC  ;GET 1st ADDR.
3900     STA SCREEN  ;OF SCREEN
3910     LDA SAVMSC+1 ;MEMORY & SAVE
3920     STA SCREEN+1 ;IT.
3930     LDA YPOS    ;BOPOTRON Y.
3940     SEC         ;SUBTRACT SEX
3950     SBC #$06    ;DECIMAL.
3960     LSR A       ;DIVIDE BY FOUR.
3970     LSR A
3980     TAX         ;MOVE TO X-REG.
3990 PASS4
4000     BEQ PASS5   ;IF =0 BRANCH.
4010     LDA SCREEN  ;GET SCREEN &
4020     CLC         ;ADD ONE LINE.
4030     ADC #40     ;(40 BYTES)
4040     STA SCREEN  ;SAVE IT.
4050     LDA SCREEN+1 ;CORRECT FOR
4060     ADC #$00    ;PAGE WRAP-
4070     STA SCREEN+1 ;AROUND.
4080     DEX         ;AT BOPOTRON'S
4090     BPL PASS4   ;Y-COORD?
4100 PASS5
4110     LDA XPOS    ;YES. GET
4120     SEC         ;X-COORD & SUB-
4130     SBC #44     ;TRACT 44.
4140     LSR A       ;DIVIDE BY
4150     LSR A       ;FOUR.
4160     TAY         ;MOVE TO Y-REG.
4170     LDA (SCREEN),Y ;CHARACTER #.
4180     LDX SLIP    ;BOPOTRON ON
4190     BMI PASS6   ;PLATFORM?
4200     LDA #$01    ;YES! CHAR=1.
4210 PASS6
4220     STA CHAR+1  ;SAVE CHARACTER
4230     AND #$7F    ;REMOVE msb
4240     STA CHAR    ;& SAVE AGAIN.
4250     LDA YPOS    ;IS BOPOTRON Y-
4260     CMP #27     ;COORD <27
4270     BCC PASS7   ;YES! BRANCH.
4280     LDA SCREEN  ;CHECK SCREEN
4290     SEC         ;POSITION 2
4300     SBC #80     ;LINES UP TO SEE
4310     STA SCREEN  ;IF BOPOTRON IS
4320     LDA SCREEN+1 ;CRASHING HIS
4330     SBC #$00    ;DOME.
4340     STA SCREEN+1 ;(80 BYTES)
4350     LDA (SCREEN),Y ;CHARACTER #.
4360     CMP #$01    ;IS IT A GIRDER?
4370     BEQ ZAP     ;YES BRANCH.
4380     CMP #$08    ;IS IT >=8?
4390     BCS ZAP     ;YES BRANCH.
4400 PASS7
4410 ;
4420 ; ***************************
4430 ; * BOPOTRON MOTION ROUTINE *
4440 ; ***************************
4450 ;
4460     LDA CHAR    ;GET CHARACTER #
4470     BEQ FALL    ;IF = 0 BRANCH.
4480     DEC MOVETIME ;DEC TIMER.
4490     BMI MOTION  ;IF <0 MOVE.
4500     JMP XITVBV  ;ELSE, QUIT.
4510 MOTION
4520     PHA         ;SAVE ACC.
4530     LDA #$01    ;RESET TIMER.
4540     LDX TRIG0   ;IS BUTTON HELD?
4550     BEQ RESET   ;NO. BRANCH.
4560     ASL A       ;YES. MOVE FAST.
4570 RESET
4580     STA MOVETIME ;SAVE TIMER.
4590     PLA         ;RESTORE ACC.
4600     CMP #$02    ;IS CHARACTER <2
4610     BCC FALLTEST ;IF YES BRANCH.
4620     CMP #$08    ;IS CHARACTER <8
4630     BCC CHECK6  ;IF YES BRANCH.
4640 FALLTEST
4650     LDA SLIP    ;ON PLATFORM?
4660     BPL CHECK8  ;IF YES BRANCH.
4670     LDA YPOS    ;MODIFY BOPO-
4680     AND #$01    ;TRON'S Y-COORD
4690     BNE FALL    ;SO HE'S ALWAYS
4700     LDA YPOS    ;ON TOP OF A
4710     AND #$03    ;GIRDER.
4720     BNE CHECK8  ;
4730 FALL
4740     INC FALLCOUNT ;FALLING...
4750     LDA #$01    ;ADD ONE TO
4760     BNE ADDY    ;Y-COORD.
4770 CHECK6
4780     LDA STICK   ;GET JOYSTICK.
4790     CMP #13     ;PUSHED DOWN?
4800     BNE CHECK7  ;NO. BRANCH.
4810     LDA YPOS    ;IS Y-COORD AT
4820     CMP #98     ;LOWER LIMIT?
4830     BNE FALL    ;NO. BRANCH.
4840     BEQ CHECK8  ;YES. BRANCH.
4850 CHECK7
4860     CMP #14     ;PUSHED UP?
4870     BNE CHECK8  ;NO. BRANCH.
4880     LDA #$FF    ;SET TO MOVE UP.
4890 ADDY
4900     CLC         ;ADD MOVEMENT
4910     ADC YPOS    ;DELTA TO BOP-
4920     STA YPOS    ;OTRON'S Y-COORD
4930     STA YPOS+1  ;AND SAVE IT.
4940 CHECK8
4950     LDA CHAR    ;GET CHARACTER #
4960     BEQ ALLDONE ;IF =0 QUIT.
4970     LDA FALLCOUNT ;IS FALLCOUNT
4980     CMP FALLCOUNT+1 ;OVER LIMIT?
4990     BCC CHECK9  ;NO. BRANCH.
5000 ZAP
5010     LDA #$01    ;STOP VBLANK &
5020     STA ACTIVATE ;INFORM BASIC.
5030 CHECK9
5040     LDA #$00    ;NOT FALLING.
5050     STA FALLCOUNT ;HALT COUNT.
5060     LDA STICK   ;GET STICK.
5070     CMP #$07    ;MOVED RIGHT?
5080     BNE CHECK10 ;NO. BRANCH.
5090     LDA XPOS    ;CHECK FOR END
5100     CMP #198    ;OF SCREEN OR
5110     BCS ALLDONE ;OBSTRUCTIONS.
5120     LDA CHAR    ;IF ANY, DO NOT
5130     CMP #$08    ;ALLOW BOPOTRON
5140     BEQ ALLDONE ;TO MOVE RIGHT.
5150     CMP #12     ;
5160     BEQ ALLDONE ;
5170     LDA #$01    ;O.K. TO MOVE
5180     BNE ADDX    ;RIGHT. BRANCH.
5190 CHECK10
5200     CMP #11     ;PUSHED LEFT?
5210     BNE ALLDONE ;NO BRANCH.
5220     LDA XPOS    ;CHECK TO SEE IF
5230     CMP #47     ;BOPOTRON IS AT
5240     BCC ALLDONE ;SCREEN END OR
5250     LDA CHAR    ;OBSTRUCTED. IF
5260     CMP #$09    ;SO DO NOT ALLOW
5270     BEQ ALLDONE ;MOVEMENT TO THE
5280     CMP #13     ;LEFT.
5290     BEQ ALLDONE ;
5300     LDA #$FF    ;O.K. TO MOVE LEFT.
5310 ADDX
5320     CLC         ;ADD RIGHT OR
5330     ADC XPOS    ;LEFT DELTA TO
5340     STA XPOS    ;BOPOTRON'S X-
5350     STA XPOS+1  ;COORD & SAVE.
5360 ALLDONE
5370     JMP XITVBV  ;LATE HOME BOY...
5380 ;
5390 ; *****************************
5400 ; * REDEFINED CHARACTER CHART *
5410 ; *****************************
5420 ;
5430 ; CHAR #   TYPE
5440 ;
5450 ;    0 BLANK SPACE
5460 ; !  1 GIRDER
5470 ; "  2 GIRDER & LADDER (left)
5480 ; #  3 GIRDER & LADDER (middle)
5490 ; $  4 GIRDER & LADDER (right)
5500 ; %  5 LADDER (left)
5510 ; &  6 LADDER (middle)
5520 ; '  7 LADDER (right)
5530 ; (  8 BATTERY (bottom left)
5540 ; )  9 BATTERY (bottom right)
5550 ; * 10 BATTERY (top left)
5560 ; + 11 BATTERY (top right)
5570 ; , 12 POWER UNIT (bottom left)
5580 ; - 13 POWER UNIT (bottom right)
5590 ; . 14 POWER UNIT (top left)
5600 ; / 15 POWER UNIT (top right)
5610 ; 0 16 EXIT GIRDER
