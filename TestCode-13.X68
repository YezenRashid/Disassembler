* *-----------------------------------------------------------
** Title      : Test
** Written by :
** Date       :
** Description:
**-----------------------------------------------------------
*
SADDR    EQU    $00007000 *starting address


START    ORG    SADDR

*******************MOVE******************************************
         MOVE.B D0,D0
         MOVE.W D0,(A1)
         MOVE.L D1,(A2)+
         MOVE.B D5,-(A3)
         MOVE.W D1,$4444
         MOVE.L D4,$44445555
         
         MOVE.W A0,D0
         MOVE.W A0,(A1)
         MOVE.L A1,(A2)+
         MOVE.W A5,-(A3)
         MOVE.W A1,$4444
         MOVE.L A4,$44445555
         
         MOVE.B (A0),D0
         MOVE.W (A0),(A1)
         MOVE.L (A1),(A2)+
         MOVE.B (A5),-(A3)
         MOVE.W (A1),$4444
         MOVE.L (A4),$44445555
         
         MOVE.B (A0)+,D0
         MOVE.W (A0)+,(A1)
         MOVE.L (A1)+,(A2)+
         MOVE.B (A5)+,-(A3)
         MOVE.W (A1)+,$4444
         MOVE.L (A4)+,$44445555
         
         MOVE.B -(A0),D0
         MOVE.W -(A0),(A1)
         MOVE.L -(A1),(A2)+
         MOVE.B -(A5),-(A3)
         MOVE.W -(A1),$4444
         MOVE.L -(A4),$44445555
         
         MOVE.W $1234,D0
         MOVE.W $1234,(A1)
         MOVE.W $1234,(A2)+
         MOVE.W $1234,-(A3)
         MOVE.W $1234,$4444
         MOVE.W $1234,$44445555
         
         MOVE.L $12345678,D0
         MOVE.L $12345678,(A1)
         MOVE.L $12345678,(A2)+
         MOVE.L $12345678,-(A3)
         MOVE.L $12345678,$4444
         MOVE.L $12345678,$44445555
         
         MOVE.B #$12,D0
         MOVE.W #$1234,(A1)
         MOVE.L #$12345678,(A2)+
         MOVE.B #$12,-(A3)
         MOVE.W #$1234,$4444
         MOVE.L #$12345678,$44445555
  
*******************MOVEQ******************************************
         MOVEQ #$12,D0
         MOVEQ #$12,D1
         MOVEQ #$12,D2
         MOVEQ #$12,D3
         MOVEQ #$12,D4
         MOVEQ #$12,D5

********************MOVEM******************************************
        MOVEM   (A0),D0-D5
        MOVEM   (A1)+,D0-D3
        MOVEM   $2222,A2-A7
        MOVEM   $33333333,A3-D4
        
        MOVEM   A2-A0,(A0)
        MOVEM   D7-A7,-(A1)
        MOVEM   A3-A2,$2222
        MOVEM   A2-A3,$33333333
        
*********************ADD*******************************************
         ADD.B D1,D0
         ADD.W A3,D1
         ADD.L (A2),D2
         ADD.B (A5)+,D3
         ADD.W -(A7),D4
         ADD.W $1234,D5
         ADD.L $12345678,D6
         ADD.W #$1234,D7
         ADD.L #$12345678,D0
         
         ADD.W D0,(A1)
         ADD.L D1,(A2)+
         ADD.B D5,-(A3)
         ADD.W D1,$4444
         ADD.L D4,$44445555

**********************ADDA*****************************************
         ADDA.W D1,A0
         ADDA.W A3,A1
         ADDA.L (A2),A2
         ADDA.W (A5)+,A3
         ADDA.W -(A7),A4
         ADDA.W $1234,A5
         ADDA.L $12345678,A6
         ADDA.W #$1234,A7
         ADDA.L #$12345678,A0

************************ADDQ*****************************************
         ADDQ  #1,D0
         ADDQ  #1,A1
         ADDQ  #1,(A2)
         ADDQ  #8,(A3)+
         ADDQ  #8,-(A4)
         ADDQ  #5,$1234
         ADDQ  #3,$12345678

************************SUB*******************************************       
         SUB.B D1,D0
         SUB.W A3,D1
         SUB.L (A2),D2
         SUB.B (A5)+,D3
         SUB.W -(A7),D4
         SUB.W $1234,D5
         SUB.L $12345678,D6
         SUB.W #$1234,D7
         SUB.L #$12345678,D0
         
         SUB.W D0,(A1)
         SUB.L D1,(A2)+
         SUB.B D5,-(A3)
         SUB.W D1,$4444
         SUB.L D4,$44445555  

************************SUBA************************************        
         SUBA.W D1,A0
         SUBA.W A3,A1
         SUBA.L (A2),A2
         SUBA.W (A5)+,A3
         SUBA.W -(A7),A4
         SUBA.W $1234,A5
         SUBA.L $12345678,A6
         SUBA.W #$1234,A7
         SUBA.L #$12345678,A0   
      
***********************SUBI***************************************       
         SUBI.B  #$12,D0
         SUBI.W  #$1234,(A2)
         SUBI.L  #$12345678,(A3)+
         SUBI.B  #$12,-(A4)
         SUBI.W  #$1234,$1234
         SUBI.L  #$12345678,$12345678
        
************************MULS************************************        
         MULS.W D1,D0
         MULS.W (A2),D2
         MULS.W (A5)+,D3
         MULS.W -(A7),D4
         MULS.W $1234,D5
         MULS.W $12345678,D6
         MULS.W #$1234,D7
         
*****************************DIVS**************************************
    	 DIVS.W D1,D0
         DIVS.W (A2),D2
         DIVS.W (A5)+,D3
         DIVS.W -(A7),D4
         DIVS.W $1234,D5
         DIVS.W $12345678,D6
         DIVS.W #$1234,D7

*************************LEA********************************             
         LEA (A2),A2
         LEA $1234,A5
         LEA $12345678,A6       
       
*************************CLR**********************************
         CLR.B D0
         CLR.L (A2)
         CLR.B (A3)+
         CLR.W -(A4)
         CLR.L $1234
         CLR.B $12345678   

*************************AND********************************** 
         AND.B D1,D0
         AND.L (A2),D2
         AND.B (A5)+,D3
         AND.W -(A7),D4
         AND.W $1234,D5
         AND.L $12345678,D6
         AND.W #$1234,D7
         AND.L #$12345678,D0
         
         AND.W D0,(A1)
         AND.L D1,(A2)+
         AND.B D5,-(A3)
         AND.W D1,$4444
         AND.L D4,$44445555   

*************************ANDI**********************************
         ANDI.B  #$12,D0
         ANDI.W  #$1234,(A2)
         ANDI.L  #$12345678,(A3)+
         ANDI.B  #$12,-(A4)
         ANDI.W  #$1234,$1234
         ANDI.L  #$12345678,$12345678
         
*****************************EOR**************************************
        EOR.B   D1,D0
        EOR.W   D3,(A2)
        EOR.L   D5,(A3)+
        EOR.B   D1,-(A4)
        EOR.W   D3,$5555
        EOR.L   D2,$55556666
        
*****************************EORI**************************************
         EORI.B  #$12,D0
         EORI.W  #$1234,(A2)
         EORI.L  #$12345678,(A3)+
         EORI.B  #$12,-(A4)
         EORI.W  #$1234,$1234
         EORI.L  #$12345678,$12345678

*********************LSL********************************************
        LSL     D1,D0        
        LSL     #1,D2
        LSL     #8,D3
        LSL     (A4)
        LSL     (A5)+
        LSL     -(A6)
        LSL     $1234
        LSL     $12345678

**************************LSR**************************************
        LSR     D1,D0        
        LSR     #1,D2
        LSR     #8,D3
        LSR     (A4)
        LSR     (A5)+
        LSR     -(A6)
        LSR     $1234
        LSR     $12345678
        
************************ASL***************************************
        ASL     D1,D0        
        ASL     #1,D2
        ASL     #8,D3
        ASL     (A4)
        ASL     (A5)+
        ASL     -(A6)
        ASL     $1234
        ASL     $12345678
        
*************************ASR*************************************** 
        ASR     D1,D0        
        ASR     #1,D2
        ASR     #8,D3
        ASR     (A4)
        ASR     (A5)+
        ASR     -(A6)
        ASR     $1234
        ASR     $12345678      
       
*************************ROL*************************************
        ROL     D1,D0        
        ROL     #1,D2
        ROL     #8,D3
        ROL     (A4)
        ROL     (A5)+
        ROL     -(A6)
        ROL     $1234
        ROL     $12345678

************************ROR*************************************** 
        ROR     D1,D0        
        ROR     #1,D2
        ROR     #8,D3
        ROR     (A4)
        ROR     (A5)+
        ROR     -(A6)
        ROR     $1234
        ROR     $12345678  
        
*************************BCHG***********************************
        BCHG   D1,D0
        BCHG   D3,(A2)
        BCHG   D5,(A3)+
        BCHG   D1,-(A4)
        BCHG   D3,$5555
        BCHG   D2,$55556666
        
        BCHG  #$12,D0
        BCHG  #$1234,(A2)
        BCHG  #$12345678,(A3)+
        BCHG  #$12,-(A4)
        BCHG  #$1234,$1234
        BCHG  #$12345678,$12345678
        
*****************************CMP************************************
        CMP.B D1,D0
        CMP.W (A2),D2
        CMP.L (A5)+,D3
        CMP.B -(A7),D4
        CMP.W $1234,D5
        CMP.L $12345678,D6
        CMP.W #$1234,D7
        CMP.L #$12345678,D0
        
*****************************CMPA**********************************
        CMPA.W D1,A0
        CMPA.W (A2),A2
        CMPA.L (A5)+,A3
        CMPA.W -(A7),A4
        CMPA.W $1234,A5
        CMPA.L $12345678,A6
        CMPA.W #$1234,A7
        CMPA.L #$12345678,A0
        
***************************CMPI***********************************
        CMPI.B  #$12,D0
        CMPI.W  #$1234,(A2)
        CMPI.L  #$12345678,(A3)+
        CMPI.B  #$12,-(A4)
        CMPI.W  #$1234,$1234
        CMPI.L  #$12345678,$12345678

*********************Bcc(BGT,BLT,BLE,BVS)*************************

yolo
        BCC    $1111
        
fuck_shit

swag_300
        BCS    $2222
too_much_swag
        BGE    $4444
 
        BCC    $11
        BCS    $2222
        BEQ    $3333
        BGE    $4444
        BGT    $5555
        BHI    $6666
        BLE    $7777
        BLS    $8888
        BLT    $9999
        BMI    $AAAA
        BNE    $BBBB
        BPL    $CCCC
        BVC    $DDDD
        BVS    $EEEE
        
        BEQ         functio
        BEQ         func
        BEQ         lol

        BCC    yolo
        BRA    yolo
        BHI    swag_300
        BGT    too_much_swag
        
*------------------BRA Instructions-----------------------
        BRA    functio
functio BRA    func
func    BRA    lol
lol     BRA    to
to      BRA    hello
hello   BRA    993
                 
**********************JSR***********************************
        JSR     (A0)
        JSR     $1111
        JSR     $22222222
*************************RTS***********************************
        RTS
        
        
    END    START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
