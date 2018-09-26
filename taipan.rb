# A series of loops that iterate over one of:
# - 1 to T
# - 1 to T/2
#
# ... reading from the keyboard. It's some kind of text collection method,
# though I'm not sure why the FOR loops are combined here. It seems sometimes we
# jump straight to line 94
def sub_90
  # PEEK(-16384) => read keyboard
  # 9999 must be some magic value or something

  # 92
  FOR II = 1 TO T
    II = II + (PEEK ( -16384) > 127) * 9999
    NEXT II

  # 94
  FOR II = 1 TO T / 2
    II = II + (PEEK ( -16384) > 127) * 9999
    NEXT II

  # 96
  FOR II = 1 TO T / 2
    II = II + (PEEK ( -16384) > 127) * 9999
    NEXT II

  # 98
  # POKE -16368,0   => clear the keyboard
  # does the keyboard have it's own buffer to something?
  POKE - 16368,0
end

# I think this reads character from the user, because it's used in places where
# a prompt is printed to the screen, then this is called
def sub_100
  CALL 2560
end

# This is called right after prompts for numeric amounts (i.e. how much to
# buy/sell, move, etc.)
def sub_150
  WK$ = "" + "         "
  CALL 2680
  W =  VAL (WK$)
  R1% = LEFT$(WK$,1) = "A"
end

# Print non-combat game board?
def sub_200
  PRINT FS$;HM$;CS$; SPC( 12 -LEN (H$) / 2)
  PRINT "Firm:";CA$;H$;CS$;", ";
  X =  USR(1)
  PRINT
  VTAB 2
  PRINT CG$;"[";
  & 45,26
  PRINT "]"
  FOR II = 1 TO 5
    PRINT "!"; TAB( 28);"!"
    NEXT II

  PRINT "(";
  & 61,26
  PRINT")"
  FOR II = 1 TO 5
    PRINT"!"; TAB( 28);"!"
    NEXT II

  PRINT"<";
  & 58,26
  PRINT ">";CS$
  VTAB 3
  HTAB 2
  X =  USR (1)+  USR (2)
  VTAB 4
  HTAB 21
  PRINT "In use:"
  VTAB 6
  HTAB21
  PRINT "Vacant:"
  VTAB 9
  HTAB 2
  PRINT "Hold Guns";

  FOR II = 3 TO 9 STEP 6
    FORIJ = 1 TO 4
      VTAB II + IJ
      HTAB 5
      PRINT LEFT$ (CO$(IJ),7);
      NEXT IJ, II

  VTAB 3
  HTAB 33
  PRINT "Date"
  VTAB 6
  HTAB 31
  X =  USR(3)
  VTAB 9
  HTAB 33
  PRINT "Debt"
  VTAB 12
  HTAB 29
  PRINT" Ship status"
  VTAB 16
  HTAB 1
  PRINT CG$;
  & 45,40
  PRINT CS$
end

# This appears to be the code that prints status information such as:
# - Current data
# - How much money you have in the bank / on board
# - 
def sub_300
  REM
  VTAB 4
  HTAB 30
  PRINT "15";YE
  VTAB 4
  HTAB 33
  PRINT IV$; MID$ ("JanFebMarAprMayJunJulAugSepOctNovDec",(MO -1) * 3 + 1,3);NV$
  VTAB 7
  HTAB 31
  PRINT ""
  VTAB 7
  HTAB 35 -  LEN(LO$(LO)) / 2 + .5
  PRINT IV$;LO$(LO);NV$
  VTAB 10
  HTAB 29
  PRINT ""
  VTAB 10
  WW = DW
  sub_600

  HTAB 35 - LEN(WW$) / 2
  PRINT IV$;WW$;NV$
  WW = 100 -  INT (DM / SC * 100 + .5)
  WW = WW * (WW > 0)
  W =  INT (WW / 20)
  VTAB 13
  HTAB 30
  IF W < 2 THEN
    PRINT IV$;

  PRINT ST$(W);":";WW;

  IF  PEEK(36) > 30 THEN PRINT  TAB(40);" ";
    PRINT NV$;

  VTAB 5
  HTAB 22
  PRINT "";
  HTAB 22
  PRINT WS
  VTAB 7
  HTAB 22
  PRINT "     ";
  HTAB 22
  PRINT WC - WS
  POKE 32,12
  FOR II = 1 TO 2
    POKE 33,(II - 1) * 9 + 6
    IK = II * 6 - 3
    POKE 34,IK
    POKE35,IK + 4
    PRINT HM$
    FOR IJ = 1 TO 4
      VTAB IK + IJ
      HTAB1
      PRINT ST(II,IJ);
      NEXT IJ, II

  PRINT FS$
  VTAB 15
  HTAB 1
  WW = CA
  sub_600
  PRINT "Cash:";WW$; TAB( 21);
  WW = BA
  sub_600
  PRINT "Bank:";WW$; TAB( 40);" "
  VTAB 9
  HTAB 22
  PRINT GN;
  HTAB 7
  PRINT "        ";
  HTAB 7
  IF MW < 0 THEN PRINT IV$;"Overload";NV$
  IF MW >= 0 THEN PRINT MW;
end

# TEXT MODE settings
def sub_400
  POKE 32,0   # set min X to 0
  POKE 33,40  # set max X to 40
  POKE 34,18  # set min Y to 18
  POKE 35,24  # set max Y to 24
  PRINT HM$;
end

def sub_480
  VTAB 17
  HTAB 1
  X =  USR (4)
end

def sub_490
  VTAB 17
  HTAB 1
  X =  USR (5)
end

def sub_500
  sub_400
  X = USR (6)
  sub_150
  IF R1% THEN W = CA
  IF CA >= W THEN CA = CA - W
  BA = BA + W
  sub_300
  goto_550

  PRINT
  PRINT
  PRINT T$;
  X = USR (8)
  PRINT CA
  PRINT "in cash."
  CALL 2518
  sub_94
  goto_510
  sub_400
  X = USR (7)
  GOSUB 150
  IF R1% THEN W = BA
  IF BA >= W THEN BA = BA -W
  CA = CA + W
  sub_300
  goto_590
  PRINT
  PRINT
  PRINT T$;
  X=  USR (8)
  PRINT BA
  PRINT "in the bank."
  CALL 2518
  sub_94
  goto_550
end

# Formatting for currecny amounts
def sub_600
  IF WW < 1E6 THEN WW$ = STR$(INT (WW)): RETURN
  II = INT(LOG (WW) / LT)
  IJ = INT(II / 3) * 3
  IK = 10 ^ (II - 2)
  WW$ = LEFT$ (STR$(INT (WW / IK + 0.5) * IK /10 ^ IJ), 4) + " "
  IF IJ = 3 THEN W$ = "Thousand"
  IF IJ = 6 THEN W$ = "Million"
  IF IJ = 9 THEN W$ = "Billion"
  IF IJ = 12 THEN W$ = "Trillion"
  WW$ = WW$ + W$
end

def goto_1000
  IF D <> 0 THEN sub_490
  sub_400

  X = USR (9)
  PRINTLO$(D)
  sub_96
  BA = INT (BA + BA * .005)
  DW = INT (DW + DW * .1)
  TI = TI + 1
  MO = MO + 1
  LO = D
  IF MO > 12 THEN YE = YE +1
  MO = 1
  EC = EC + 10
  ED = ED + .5
  FOR I = 1 TO 7
    FORJ = 1 TO 4
      BP%(I,J) = BP%(I,J) +  FN R(2)
      NEXT J,I

  sub_400
  sub_480
  sub_300
  IF LO <> 1 THEN 1500
  IF LI <> 0 OR CA = 0 THEN 1120
  WW = 0
  W = 1.8
  IF TI > 12 THEN WW = FN R(1000 * TI) + 1000 * TI
  W = 1
  I =  FN R(CA / W) + WW
  WW = I
  sub_600
  sub_400

  X = USR (10)
  PRINT WW$;" ";
  X = USR (11)
  CH$ = "NY"
  sub_100

  IF CH% <> 2 THEN 1120
  LI = 1
  CA = CA - I
  IF CA > 0 THEN 1100
  sub_400

  PRINT T$;
  X = USR(12)
  CALL 2512
  PRINT
  PRINT
  X = USR (13)
  CH$ = "YN"
  sub_100

  IF CH% = 1 THEN DW = DW - CA
  CA = 0
  sub_400

  X = USR(14)
  CALL 2521
  sub_94

  IF CH% = 2 THEN CA = 0
  LI = 0
  sub_400

  X = USR (15)
  PRINTT$;"."
  CALL 2518
  sub_94
  sub_300

  IF DM = 0 THEN 1210
  sub_400

  PRINT T$;
  X =  USR(16)
  CH$ = "YN"
  sub_100

  IF CH% = 2 THEN 1210
  BR = INT (( FN R(60 * (TI +3) / 4) + 25 * (TI + 3) / 4)* SC / 50)
  WW = INT (DM / SC * 100 +.5)
  sub_400

  X =  USR (17)
  PRINT WW; "% damaged."
  PRINT
  WW = BR * DM + 1
  sub_600
  X = USR(18)
  PRINT WW$;","
  X = USR (19)
  sub_150
  IF R1% = 1 THEN W = BR * DM + 1
  IF CA < W THEN W = CA
  IF CA < W THEN sub_400
  PRINT T$;
  X = USR (12)
  sub_96
  goto_1142

  WW = INT (W / BR + .5)
  DM = DM - WW
  CA = CA - W
  DM =  INT(DM * (DM > 0))
  sub_300
  sub_400

  IF DW < 10000 OR WN OR D = 0 THEN 1300
  sub_400
  
  PRINT "Elder Brother Wu has sent "; FN R(100) + 50;" braves": PRINT "toescort you to the Wu mansion, ";T$;"."
  WN = 1
  sub_94

  sub_400
  X =  USR (20)
  sub_92
  sub_400
  X =  USR (21)
  PRINTT$;".";
  GOSUB 92
end

def unkn_1300
  # \/ 1300
  sub_400
  X =  USR (22)
  CH$ = "NY"
  WU% = 1
  sub_100
  WU% = 0
  IF CH% <> 2 THEN 1500
  W = 0
  FOR I = 1 TO 2
    FOR J = 1 TO 4
      W = W + ST(I,J)
      NEXT J,I

  IF CA OR BA OR W OR GN THEN 1360
  BL% = BL% + 1
  I =  INT ( FN R(1500) + 500)
  J =  FN R(2000) * BL% + 1500
  sub_400
  PRINT "Elder Brother is aware of your plight, ";T$;". He is willing to loan you an additional ";I;" if you will pay back"
  PRINT J;". Are you willing, ";T$;"? ";
  CH$ = "YN"
  sub_100
  IF CH% = 2 THEN sub_400
  PRINT
  PRINT "Very well, Taipan, the game is over!"
  CALL 2512
  GOTO 2698

  CA = CA + I
  DW = DW + J
  sub_400
  PRINT "Very well, ";T$;". Good joss!!"
  CALL 2521
  sub_300
  sub_96
  goto_1500

  IF DW = 0 OR CA = 0 THEN 1400
  sub_400
  X = USR (23)
  sub_150
  IF R1% THEN W = CA
  IF CA > DW THEN W = DW
  IF CA >= W THEN CA = CA - W
  DW = DW - W
  sub_300
  goto_1400

  PRINT
  PRINT
  PRINT T$;", you have only ";CA
  PRINT "in cash."
  CALL 2518
  sub_94
  goto_1370
  sub_400
  X =  USR (24)
  sub_150
  IF R1% THEN W = 2 * CA
  IF CA * 2 >= W THEN CA = CA + W
  DW = DW + W
  sub_300
  goto_1450
  PRINT
  PRINT
  PRINT "He won't loan you so much, ";T$;"!"
  CALL 2518
  sub_94
  goto_1400

  # 1450
  IF DW > 20000 AND NOT ( FNR(5)) THEN sub_400
  PRINT "Bad joss!!"
  PRINT FN R(3)+ 1;" of your bodyguards have been killed"
  PRINT "by cutthroats and you have beenrobbed of all your cash, ";T$;"!!"
  CALL 2512
  CA = 0
  sub_300
  sub_94

  # 1500
  I =  INT (1000 +  FN R(1000* (TI + 5) / 6)) * ( INT (SC / 50) * (DM > 0) + 1)
  IF CA < I OR  FN R(4) THEN 1700
  W$ =  CHR$ (15) +  CHR$ (15) + "damaged_______" +  CHR$(15) + CHR$(16) + "fine"
  WW = I
  sub_600
  sub_400

  # 1620
  # Do you want to upgrade your ship?
  PRINT "Do you wish to trade in your "; MID$(W$,(DM = 0) * 25 + 1,25)
  PRINT "ship for one with 50 more capacity by paying an additional ";WW$;", ";T$;"? ";
  CH$ = "YN"
  sub_100
  IF CH% = 1 THEN CA = CA - I
  MW = MW + 50
  SC = SC + 50
  DM = 0
  sub_300

  # 1700
  I =  INT ( FN R(1000 * (TI +5) / 6) + 500)
  IF CA < I OR FN R(3) THEN 1900
  WW = I
  sub_600
  sub_400

  # Do you want to buy a gun?
  PRINT "Do you wish to buy a ship's gun"
  PRINT "for ";WW$;", ";T$;"? ";
  CH$ = "NY"
  sub_100
  IF CH% = 1 THEN 1900

  IF MW >= 10 THEN CA = CA - I
  GN = GN + 1
  MW = MW - 10
  sub_300
  goto_1900

  # Oh, but you can't because you don't have enough space for another gun
  PRINT
  PRINT
  PRINT "Your ship would be overburdened, ";T$;"!"
  CALL 2518
  sub_94

  # 1900
  IF ST(2,1) = 0 OR LO = 1 OR FN R(18) THEN 2000
  I =  FN R(CA / 1.8)
  WW = I
  sub_600
  sub_400
  CALL 2512
  X =  USR (25) +  USR (26)
  PRINT WW$;", ";T$;"!"
  MW = MW + ST(2,1)
  ST(2,1) = 0
  CA = CA - I
  sub_300
  sub_94

  # 2000
  W = 0
  FOR J = 1 TO 4
    W = W + ST(1,J)
    NEXT J

  IF W = 0 OR FN R(50) THEN 2100
  sub_400
  CALL 2512
  X = USR(25) +  USR (27)
  PRINT T$;"!"
  FOR J = 1 TO 4
    W = ST(1,J)
    WW =  FN R(W / 1.8)
    WS = WS - W + WW
    ST(1,J) = WW
    NEXT J
  sub_300
  sub_96

  # 2100
  FOR I = 1 TO 4
    CP(I) = BP%(LO,I) / 2 * ( FN R(3) + 1) *10 ^ (4 - I)
    NEXT I

  # 2310
  LI = LI AND  FN R(20)
  IF LI = 0 AND LI% > 0 THEN LI% = LI% + 1
  IF LI% > 4 THEN LI% = 0

  IF LI = 0 AND LO <> 1 AND FN R(4) THEN sub_400
  X = USR (28)
  CALL 2521
  sub_94

  # 2410 price rise / drop
  IF FN R(9) THEN 2500
  sub_400

  I = FN R(4) + 1
  J =  FN R(2)
  K =  FN R(2) * 5
  PRINT T$;"!!  The price of ";CO$(I)
  IF J = 0 THEN CP(I) = INT(CP(I) / 5)
  PRINT "has dropped to ";CP(I);"!!"
  CALL 2518

  IF J = 1 THEN CP(I) = CP(I) * ( FN R(5) + 5)
  WW = CP(I)
  sub_600
  PRINT "has risen to ";WW$;"!!"
  CALL 2518
  sub_94

  # 2500
  sub_400
  IF CA > 25000 AND NOT ( FN R(20)) THEN I = FNR(CA / 1.4)
  WW = I
  sub_600
  X = USR (25)
  PRINT "You've been beaten up and robbed of"
  PRINT WW$;" in cash, ";T$;"!!"
  CALL 2512
  CA = CA - I
  sub_300
  sub_94
  VTAB 22
  HTAB 1
  PRINT CE$

  sub_400
  PRINT T$;
  X = USR(29)
  FOR I = 1 TO 3 STEP 2
    PRINT TAB( 4); LEFT$ (CO$(I),7);": ";CP(I); TAB( 18); LEFT$ (CO$(I + 1),7);": ";CP(I + 1)
    NEXT I

  # 2520
  I = CA + BA - DW
  VTAB 22
  HTAB 1
  PRINT CE$
  IF LO <> 1 THEN X = USR(30)
  CH$ = "BSQ"

  IF LO = 1 AND I < 1E6 THEN X =  USR (31) +  USR (32)
  CH$ = "BSQTV"

  IF LO = 1 AND I >= 1E6 THEN X = USR (31) +  USR (33)
  CH$ = "BSQTVR"

  sub_100

  # ON cmd is a like a case statement
  # This appears to be the code that manages the in-port interactions, or at least the buying/selling
  ON CH% GOTO 2530,2570,2700,2620,2680,2695

  # 2530
  VTAB 23
  HTAB 1
  PRINT CE$;"What do you wish me to buy, ";T$;"? ";
  CH$ = "OSAG"
  sub_100
  CO$ = CO$(CH%)
  CP = CP(CH%)

  # 2540
  VTAB 22
  HTAB 1
  PRINT CE$,IV$;
  HTAB 31
  PRINT " You can ";
  VTAB 23
  HTAB 31
  PRINT "  afford ";
  VTAB 24
  HTAB 31
  PRINT "         ";
  W =  INT(CA / CP)
  IF W > 1E9 THEN W = 1E9 - 1
  HTAB 36 - LEN ( STR$ (W)) / 2
  PRINT W;NV$;
  VTAB 23
  HTAB 1
  PRINT "How much ";CO$;" shall"
  PRINT "I buy, ";T$;"? ";
  sub_150
  IF R1% THEN W =  INT (CA / CP)
  IF W > 1E9 THEN W = 1E9 - 1
  IF W < 0 OR CA < W * CP THENCALL 2524
  goto_2540

  MW = MW - W
  CA = CA - W * CP
  ST(2,CH%) = ST(2,CH%) + W
  sub_300
  VTAB 22
  HTAB 1
  CALL - 958
  goto_2520

  VTAB 23
  HTAB 1
  PRINT CE$;"What do you wish me to sell, ";T$;"? ";
  CH$ = "OSAG" # 'OSAG' = Opium, Silk, Arms, General
  sub_100
  CO$ = CO$(CH%)
  CP = CP(CH%)

  # 2580
  VTAB 22
  HTAB 1
  PRINT CE$
  PRINT "How much ";CO$;" shall": PRINT "I sell, ";T$;"?";
  sub_150

  IF R1% THENW = ST(2,CH%)
  IF W < 0 OR ST(2,CH%) < W THEN CALL 2524
  goto_2580

  MW = MW + W
  CA = CA + W * CP
  ST(2,CH%) = ST(2,CH%) - W
  sub_300: VTAB 22: HTAB 1:PRINT CE$;: GOTO 2520

  # 2620
  W = 0
  FOR I = 1 TO 2
    FOR J = 1 TO 4
      W = W + ST(I,J)
      NEXT J,I

  IF W = 0 THEN VTAB 22
  HTAB 1
  PRINT CE$;"You have no cargo, ";T$;"."
  CALL 2518
  sub_94
  goto_2520

  # Loop through goods (Opium, Silk, Arms, General)
  FOR J = 1 TO 4
    # Look through move-to-warehouse, and move aboard
    FOR K = 1 TO 2
      I = 3 - K
      IF ST(I,J) = 0 THEN 2634
      sub_400

      # 2626
      PRINT "How much";CO$(J);" shall I move"
      PRINT MID$ ("to the warehouseaboard ship",K * 16 - 15,16);",";T$;"? ";
      GOSUB 150

      IF R1% THEN W = ST(I,J)
      IF W > (WC - WS) AND K = 1 THEN W = (WC - WS)
      IF K = 2 THEN 2630
      IF W > 0 AND WS = WC THEN
        PRINT
        PRINT
        PRINT "Your warehouse is full, ";T$;"!"
        CALL 2518
        sub_94
        goto_2626
2629  IF W > (WC - WS) THEN  PRINT: PRINT : PRINT "Your warehouse will only hold an": PRINT"additional ";WC - WS;", ";T$;"!";: CALL 2518: GOSUB 94:GOTO 2626
2630  IF W > ST(I,J) THEN  PRINT: PRINT : PRINT "You have only ";ST(I,J);", ";T$;".": CALL2518: GOSUB 94: GOTO 2626
2632 ST(I,J) = ST(I,J) - W:ST(K,J) = ST(K,J) + W:MW = MW +  SGN(I - K) * W:WS = WS +  SGN (I - K) * W: GOSUB 300

# 2634
2634  NEXT K,J: GOTO 2500
2680  REM
2690  GOSUB 500: GOTO 2500
2695 OK = 16
2696  GOSUB 400: PRINT IV$; TAB(26): PRINT : PRINT " Y o u 'r e    a"; TAB( 26): PRINT: PRINT  TAB( 26): PRINT : PRINT" M I L L I O N A I R E ! ":PRINT  TAB( 26): PRINT NV$:GOSUB 96
2698 : GOSUB 20000
2699  PRINT "Play again? ";:CH$ ="NY": GOSUB 100: ON CH% GOTO63999: RUN
2700  REM
2810  IF MW < 0 THEN  GOSUB 400:PRINT "You're ship is overloaded, ";T$;"!!": CALL 2518:GOSUB 94: GOTO 2500
3010  GOSUB 400: PRINT T$;", doyou wish to go to:": PRINT "1) Hong Kong, 2) Shanghai, 3) Nagasaki, 4) Saigon, 5) Manila, 6) Singapore, or  7) Batavia ? ";
3020 CH$ = "1234567": GOSUB 100:D = CH%: IF D = LO THEN  PRINT: PRINT : PRINT "You're already here, ";T$;".";: CALL 2518: GOSUB 94: GOTO 3010
3030 LO = 0: GOSUB 300: GOSUB 400: GOSUB 490
3100  REM
3110  IF  FN R(BP) THEN 3200
3120 SN =  FN R(SC / 10 + GN) +1: GOSUB 400: CALL 2512: PRINTSN;" hostile ship"; MID$ ("s",(SN = 1) + 1,1);" approaching, ";T$;"!!": GOSUB 96:F1 =1: GOTO 5000
3200  REM
3210  IF  FN R(4 + 8 * LI) THEN3300
3220  GOSUB 400: PRINT "Li Yuen's pirates, ";T$;"!!": CALL 2521: GOSUB 94: IF LI THEN  PRINT: PRINT "Good joss!! They let us be!!": CALL 2521: GOSUB94: GOTO 3300
3230 SN =  FN R(SC / 5 + GN) + 5: GOSUB 400: PRINT SN;" ships of Li Yuen's pirate": PRINT"fleet, ";T$;"!!": CALL 2512: GOSUB 94:F1 = 2: GOTO 5000
3300  REM
3310  IF  FN R(10) THEN 3350
3320  GOSUB 400: PRINT "Storm, ";T$;"!!": CALL 2521: GOSUB 94: IF  NOT ( FN R(30)) THENPRINT : PRINT "   I think we're going down!!": CALL 2521: GOSUB 94: IF  FN R(DM / SC * 3) THEN  PRINT : PRINT "We're going down, Taipan!!":CALL 2512:OK = 1: GOTO 2698
3330  PRINT : PRINT "    We madeit!!": CALL 2521: GOSUB 94:IF  FN R(3) THEN 3350
3340 LO =  FN R(7) + 1: ON (LO =D) GOTO 3340: GOSUB 400: PRINT"We've been blown off course": PRINT "to ";LO$(LO):D = LO: GOSUB 94
3350 LO = D: GOTO 1000
5000  REM
5030 LC = 0:CMD = 0: PRINT FS$;HM$
5050  VTAB 1: HTAB 1: PRINT "ships attacking, ";T$;"!":VTAB 1: HTAB 32: PRINT CG$;"!": VTAB 2: HTAB 32: PRINT"!": VTAB 3: HTAB 32: PRINT"<::::::::";CS$: VTAB 2: HTAB37: PRINT "guns": VTAB 1: HTAB34: PRINT "We have";
5060  PRINT "Your orders are to:"
5080  FOR I = 0 TO 9:AM%(I,0) =0:AM%(I,1) = 0: NEXT I:SA =SN:S0 = SN:BT =  FN R(TI / 4* 1000 * SN ^ 1.05) +  FN R(1000) + 250:SS = 0
5090  REM
5100  GOSUB 5760: GOSUB 5700:LC =CMD: VTAB 12: HTAB 40: PRINTMID$ ("+ ", NOT (SA) + 1,1)
5160 DM =  INT (DM):WW = 100 -  INT(DM / SC * 100): IF WW < 0 THENWW = 0
5162  VTAB 4: PRINT "Current seaworthiness: ";ST$( INT (WW /20));" (";WW;"%)": GOSUB 5600: VTAB 4: PRINT CL$
5165  IF WW = 0 THEN OK = 0: GOTO5900
5175  GOSUB 5600
5180  ON CMD GOTO 5200,5300,5400
5190  VTAB 4: PRINT T$;", what shall we do??": CALL 2512: GOSUB5600: ON (CMD = 0) + 1 GOTO5500,5180
5200  REM
5205  VTAB 4: HTAB 1: PRINT CL$:VTAB 4: PRINT "Aye, we'll run, ";T$;"!": GOSUB 96: VTAB4: PRINT CL$
5207  IF LC = 1 OR LC = 3 THEN OK = OK + IK:IK = IK + 1
5208  IF LC = 0 OR LC = 2 THEN OK = 3:IK = 1
5210  IF  FN R(OK) >  FN R(SN) THENVTAB 4: PRINT "We got awayfrom 'em, ";T$;"!!": CALL 2518: GOSUB 96: VTAB 4: PRINTCL$:OK = 3: GOTO 5900
5220  VTAB 4: PRINT "Can't lose'em!!": GOSUB 5600: VTAB 4: PRINTCL$
5230  IF SN > 2 AND  FN R(5) = 0THEN W =  FN R(SN / 2) + 1:SN = SN - W:SA = SA - W: GOSUB5680: GOSUB 5750: VTAB 4: PRINT"But we escaped from ";W;" of 'em, ";T$;"!": GOSUB 5600:VTAB 4: PRINT CL$
5240  GOTO 5500
5300  REM
5302  IF GN = 0 THEN  VTAB 4: HTAB1: PRINT "We have no guns, ";T$;"!!": GOSUB 5600: VTAB 4: PRINT CL$: GOTO 5500
5305  VTAB 4: HTAB 1: PRINT CL$:VTAB 4: PRINT "Aye, we'll fight 'em, ";T$;"!": GOSUB 5600: VTAB 4: PRINT CL$
5310 SK = 0: VTAB 4: PRINT "We're firing on 'em, ";T$;"!": FORK = 1 TO GN: IF SN = 0 THEN5340
5320 I =  FN R(10): IF AM%(I,0) =0 THEN 5320
5330  GOSUB 5840:AM%(I,1) = AM%(I,1) +  FN R(30) + 10: IF AM%(I,1) > AM%(I,0) THEN AM%(I,0) = 0:AM%(I,1) = 0: GOSUB5860: GOSUB 5820:SK = SK + 1:SN = SN - 1:SS = SS - 1: GOSUB5750: IF SS = 0 THEN  GOSUB5700
5340  NEXT K: IF SK > 0 THEN  VTAB4: HTAB 1: PRINT "Sunk ";SK;" of the buggers, ";T$;"!": CALL2521: GOSUB 5600: VTAB 4: PRINTCL$
5350  IF SK = 0 THEN  VTAB 4: HTAB1: PRINT "Hit 'em, but didn't sink 'em, ";T$;"!": GOSUB5600: VTAB 4: PRINT CL$
5360  IF  FN R(S0) < SN * .6 / F1 OR SN = 0 OR SN = S0 OR SN< 3 THEN 5500
5362 W =  FN R(SN / 3 / F1) + 1:SN = SN - W:SA = SA - W: GOSUB5680
5390  VTAB 4: PRINT W;" ran away, ";T$;"!": GOSUB 5750: CALL2521: GOSUB 5600: VTAB 4: PRINTCL$: GOTO 5500
5400  REM
5410  GOSUB 400: PRINT "You havethe following on board, ";T$;":";: FOR J = 1 TO 4: VTAB20 + (J = 3 OR J = 4): HTAB1 + 19 * (J = 2 OR J = 4): PRINTRIGHT$ ("         " +  LEFT$(CO$(J),7),9);": ";ST(2,J): NEXTJ
5420  VTAB 4: PRINT "What shallI throw overboard, ";T$;"? ";:CH$ = "OSAG*": GOSUB 100: VTAB4: HTAB 1: PRINT CL$
5430  IF CH% = 5 THEN II = 1:IJ =4:IK = 1E9: GOTO 5450
5440  VTAB 4: PRINT "How much, ";T$;"? ";: GOSUB 150:II = CH%:IJ = CH%: IF R1% THEN W =ST(2,II)
5450 WW = 0: FOR J = II TO IJ:IK= ST(2,J): IF W > IK THEN W= IK
5460 ST(2,J) = ST(2,J) - W:WW =WW + W:MW = MW + W: NEXT J: VTAB4: HTAB 1: PRINT CL$
5470  IF WW = 0 THEN  VTAB 4: PRINT"There's nothing there, ";T$;"!": CALL 2518: GOSUB 5600:VTAB 4: PRINT CL$
5480  GOSUB 400: IF WW > 0 THENRF = RF + WW / 3:OK = OK + WW / 10: VTAB 4: PRINT "Let'shope we lose 'em, ";T$;"!":CALL 2521: GOSUB 5600: VTAB4: PRINT CL$: GOTO 5210
5500  REM
5505  IF SN = 0 THEN  VTAB 4: PRINT"We got 'em all, ";T$;"!!": CALL2521: GOSUB 5600:OK = 1: GOTO5900
5510  VTAB 4: PRINT "They're firing on us, ";T$;"!": GOSUB 5600: VTAB 4: PRINT CL$
5540  FOR I = 1 TO 10: POKE  - 16298,0: POKE  - 16299,0: POKE- 16297,0: POKE  - 16300,0:FOR J = 1 TO 10: NEXT J,I
5542  VTAB 4: PRINT "We've beenhit, ";T$;"!!": CALL 2512
5545 I = SN: IF I > 15 THEN I =15
5550  IF GN THEN  IF  FN R(100) <(DM / SC) * 100 OR (DM / SC)* 100 > 80 THEN I = 1: GOSUB5600: VTAB 4: PRINT CL$: VTAB4: PRINT "The buggers hit agun, ";T$;"!!": CALL 2512:GN= GN - 1:MW = MW + 10: GOSUB5600: VTAB 4: PRINT CL$
5555 DM = DM +  FN R(ED * I * F1) + I / 2
5560  IF  NOT ( FN R(20)) AND F1= 1 THEN OK = 2: GOTO 5900
5590  GOTO 5090
5600  VTAB 2: HTAB 21: FOR II =1 TO T / 3
5610 W =  PEEK ( -16384): IF W <128 THEN  NEXT II: PRINT : RETURN
5620  IF W = 210 THEN CMD = 1: PRINT"Run        "
5630  IF W = 198 THEN CMD = 2: PRINT"Fight      "
5640  IF W = 212 THEN CMD = 3: PRINT"Throw cargo"
5650  POKE  - 16368,0: PRINT
5670  RETURN
5680  IF SA >  = 0 THEN  RETURN
5681 I = 9: FOR IJ = SA TO  - 1
5682  IF AM%(I,0) = 0 THEN I = I- 1: GOTO 5682
5683 AM%(I,0) = 0:AM%(I,1) = 0: GOSUB5880: GOSUB 5820:I = I - 1:SS = SS - 1: NEXT IJ: RETURN
5700  REM
5710  FOR I = 0 TO 9: IF AM%(I,0) THEN 5740
5720 SA = SA - 1: IF SA < 0 THENSA = 0: RETURN
5730 AM%(I,0) =  FN R(EC) + 20:AM%(I,1) = 0: GOSUB 5800:SS =SS + 1
5740  NEXT I: RETURN
5750  REM
5760  VTAB 1: HTAB 1: PRINT  RIGHT$("    " +  STR$ (SN),4)
5770  VTAB 2: HTAB 33: PRINT  RIGHT$("   " +  STR$ (GN),3): RETURN
5800  GOSUB 5880: HTAB X: VTAB Y: PRINT SH$: RETURN
5820  GOSUB 5880: HTAB X: VTAB Y: PRINT SB$: RETURN
5840  GOSUB 5880: POKE 2493,(Y +4) * 8 - 1: POKE 2494,X - 1:FOR J = 0 TO 1:IJ =  FN R(6):II = DL%(IJ,J): HTAB X +  INT(II / 10): VTAB Y + II -  INT(II / 10) * 10: PRINT DM$(IJ,J): NEXT J: CALL 2368: RETURN
5860  GOSUB 5880: POKE 2361,(Y +4) * 8 - 1: POKE 2362,X - 1:POKE 2300, FN R( FN R(192)): CALL 2224: RETURN
5880 X = (I -  INT (I / 5) * 5) *8 + 1:Y =  INT (I / 5) * 6 +7: RETURN
5900  GOSUB 200: GOSUB 300: GOSUB400
5910  IF OK = 0 THEN  PRINT "Thebuggers got us, ";T$;"!!!":PRINT "It's all over, now!!!":OK = 1: GOTO 2698
5920  IF OK = 1 THEN  GOSUB 400:PRINT "We've captured somebooty":WW = BT: GOSUB 600: PRINT"It's worth ";WW$;"!": CALL2518:CA = CA + BT: GOSUB 96:GOTO 3300
5930  IF OK = 2 THEN  PRINT "LiYuen's fleet drove them off!": GOSUB 96: GOTO 3220
5940  IF OK = 3 THEN  PRINT "Wemade it, ";T$;"!": CALL 2518: GOSUB 96: GOTO 3300

end

# main
wk_str = '*'
ch_str = "*"
ch_i = 0
wu_i = 0
r1_i = 0
i_i = 0
j = 0
k = 0
ii = 0
ij = 0
ik = 0
t = 300
lt = Math.log(10)
t_str = 'Taipan'

# goto_10000
# 10000
CALL 6147
POKE 1013,76
POKE1014,224
POKE 1015,9
POKE10,76
POKE 11,16
POKE 12,11
POKE 1010,102
POKE 1011,213
POKE 1012,112
DIM LO$(7), CO$(4), CP(4), BP%(7,4), ST(2,4), AM%(9,1), DM$(5,1), DL%(5,1), ST$(5)
DEF  FN R(X) =  INT ( USR(0) * X)
HM$ = CHR$ (16)
CS$ = CHR$(1) + "0"
CA$ = CHR$ (1) +"1"
CG$ = CHR$ (1) + "2"
BD$ = CHR$ (2)
CD$ = CHR$ (3)
DD$ = CHR$ (4)
IV$ = CHR$(9)
NV$ = CHR$ (14)
FS$ = CHR$(25)
CE$ = CHR$ (6)
CL$ = CHR$(5)

if PEEK (2367) = 236 THEN 10070
POKE  - 16368,0
FOR I = 1 TO 400
  CH% = PEEK( -16384)
  X =  USR (0)
  IF CH% < 128 THEN NEXT

# \/ 10062
VTAB 20
HTAB 31
PRINT IV$;CA$;"'ESC'";
FOR I = 1 TO 20
  X =  USR (0)
  IF  PEEK ( -16384) <  > 155 THEN NEXT

VTAB 20
HTAB 31
PRINT NV$;CA$ + "'ESC'";
FOR I = 1 TO 20
  X =  USR (0)
  IF  PEEK ( -16384) <  > 155 THEN NEXT
GOTO 10062

POKE 2367,236
POKE  - 16368,0
PRINT NV$;FS$;HM$
VTAB 8
HTAB 1
PRINT CG$;"[";
& 45,38
PRINT "]";
FORI = 1 TO 8
  PRINT "!"; TAB(40);"!";
  NEXT I

PRINT "<";
& 58,38
PRINT ">";CS$

# \/ 10120
VTAB 10
HTAB 7
PRINT CS$;T$;","
VTAB 12
HTAB 3
PRINT "What will you name your"
VTAB 15
HTAB 13
& 45,22
VTAB 14
HTAB 7
PRINT "Firm: ";CA$;
& 32,27
VTAB 14
HTAB 13
POKE 33,39
CALL 2200
POKE33,40

WK$ =  MID$ (WK$,1)
IFWK$ = "" THEN  CALL 2521
GOTO 10120

# \/ 10130
IF LEN (WK$) > 22 THEN PRINT
VTAB 18
PRINT IV$;
& 32,42
PRINT "Please limit your firm's name to 22 characters or less.";
& 32,59
PRINT NV$
CALL 2518
GOSUB 92
VTAB 18
PRINT CE$
GOTO 10120

# \/ 20140
H$ = WK$
PRINT HM$;CS$
VTAB 6
PRINT "Do you want to start ..."
PRINT
PRINT
PRINT "  1) With cash (and a debt)"
PRINT
PRINT
PRINT ,">> or <<"
PRINT
PRINT
PRINT "  2) With five guns and nocash (but no debt!)"

# \/ 10150
PRINT
PRINT
PRINT TAB(10);" ?";
CH$ = "12"
GOSUB 100
MO = 1
YE = 1860
SC = 60
BA = 0
LO = 1
TI = 1
WC = 10000
WS = 0

IF CH% = 1 THEN DW = 5000
CA = 400
MW = 60
GN = 0
BP =10

IF CH% = 2 THEN DW = 0
CA= 0
MW = 10
GN = 5
BP = 7

FOR I = 0 TO 7
  READ LO$(I)
  NEXT I

DATA At sea,HongKong,Shanghai,Nagasaki,Saigon,Manila,Singapore,Batavia
FOR I = 1 TO 4
  READ CO$(I)
  FOR J = 1 TO 7
    READ BP%(J,I)
    NEXT J,I

DATA  Opium,11,16,15,14,12,10,13,Silk,11,14,15,16,10,13,12,Arms,12,16,10,11,13,14,15,General Cargo,10,11,12,13,14,15,16
FOR I = 0 TO 5
  READ ST$(I)
  NEXT I

DATA "Critical","Poor","Fair","Good","Prime","Perfect"
SH$ = BD$ + CG$ + "ABCDEFG" + CD$ + "HIJKLMN" + CD$ +"OIJKLPQ" + CD$ + "RSTUVWX" +CD$ + "YJJJJJZ" + DD$
SB$ = BD$
FOR II = 1 TO 5
  SB$ = SB$ + "       " + CD$
  NEXT II

SB$ = SB$ + DD$
FOR I = 0 TO 5
  FOR J = 0 TO 1
    CH$ = BD$ + CG$
    READ WK$
    CH$ = CH$ + WK$
    IF RIGHT$ (CH$,1) = "*" THEN CH$ = MID$ (CH$,1, LEN (CH$) - 1) + CD$
    GOTO 10280

    DM$(I,J) = CH$ + DD$
    READ DL%(I,J)
    NEXT J,I

DATA cde,20,r,3,fg*,mn,50,tu,23,ij,11,vw,43,0,22,x*,z,63,kl,32,12,14,pq,52,345,34
EC = 20
ED = .5
sub_200
GOTO 1000

REM
WW = CA + BA - DW
sub_600
WW =  INT ((CA + BA - DW)/ 100 / TI ^ 1.1)
PRINT FS$;HM$;CS$;
PRINT "Your final status:"
PRINT
PRINT "Net Cash: ";WW$
PRINT
PRINT "Ship size: ";SC;" units with ";GN;" guns"
PRINT
PRINT "You traded for "; INT(TI / 12);" year"; MID$ ("s",(TI > 11 AND TI < 24) + 1,1);" and ";TI -  INT (TI / 12) * 12;" month"; MID$ ("s",((TI -  INT (TI / 12) * 12) =1) + 1,1)
PRINT
PRINT IV$;"Your score is ";WW;".";NV$

VTAB 14: PRINT "Your Rating:"
PRINT CG$;"[";
& 45,31
PRINT "]"
FOR I = 1 TO 5
  PRINT "!";
  HTAB 33
  PRINT"!"
  NEXT I

PRINT "<";
& 58,31
PRINT ">";CS$
VTAB 16
HTAB 2
IF WW > 49999 THEN PRINT IV$;PRINT "Ma Tsu";NV$;"50,000 and over "
HTAB 2
IF WW < 50000 AND WW > 7999 THEN PRINT IV$;PRINT "Master ";T$;NV$;"8,000 to 49,999"
HTAB 2
IF WW < 8000 ANDWW > 999 THEN  PRINT IV$;PRINT T$;NV$;"          1,000 to  7,999"
HTAB 2
IF WW < 1000 ANDWW > 499 THEN  PRINT IV$;PRINT "Compradore";NV$;"500 to    999"
HTAB 2
IF WW < 500 THENPRINT IV$;PRINT "Galley Hand";NV$;"less than 500"
VTAB 11
IF WW < 99 AND WW >= 0 THEN PRINT "Have you considered a land based job?"
PRINT
IF WW < 0 THEN PRINT "The crew has requested that you stay on shore for their safety!!"
PRINT
VTAB 23
