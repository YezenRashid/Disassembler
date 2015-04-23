*-----------------------------------------------------------
* Title      : Opcodes
* Written by : Andy Thompson
* Date       :
* Description: D0 is the input, D1 holds the next 3 bits,
* D2 holds the subsequent 3, D3 holds next 3, and D4 holds 
* the last 3. D5 and D6 are meant to be garbage data, but 
* used for operations within a subroutine occasionally. D7 
* holds a 0 if good data, 1 if bad data. 
*-----------------------------------------------------------

*   Required Opcodes:
*   -----------------
*   MOVE, MOVEQ, MOVEM
*   ADD, ADDA, ADDQ
*   SUB, SUBA, SUBI
*   MULS, DIVS
*   LEA
*   CLR
*   AND, ANDI
*   EOR, EORI
*   LSR, LSL
*   ASR, ASL
*   ROL, ROR
*   BCHG
*   CMP, CMPA, 
*   Bcc (BCC, BGT, BLE, BVS)
*   JSR, RTS

*-------------------------------------------------------------------------

CLEAR_ADDRESS       EQU       $00000000  *Used for clearing address registers

*--------Hex representation of all valid ASCII inputs for address-----
ZERO_HEX            EQU       $30
ONE_HEX             EQU       $31
TWO_HEX             EQU       $32
THREE_HEX           EQU       $33
FOUR_HEX            EQU       $34
FIVE_HEX            EQU       $35
SIX_HEX             EQU       $36
SEVEN_HEX           EQU       $37
EIGHT_HEX           EQU       $38
NINE_HEX            EQU       $39

A_HEX               EQU       $41
B_HEX               EQU       $42
C_HEX               EQU       $43  
D_HEX               EQU       $44
E_HEX               EQU       $45
F_HEX               EQU       $46

COMPAR_VAL          EQU       $40   *This value is between ASCII 9 and A and is used to check if the
                                    *value is a digit or letter

MIN_ADDRESS         EQU       $7000
MAX_ADDRESS         EQU       $FFFF                                    
****************************************************************
*These values are used to convert an ASCII character into hex
*You can subtract these values from a ASCII character to determine
*what the character is.
****************************************************************
CHAR_TO_DIGIT         EQU       $30     *used to convert ASCII 1-9 to hex
CHAR_TO_LETTER        EQU       $37     *used to convert ASCII A-F to hex

*---------------Output Commands-----------------
CR      EQU     $0D                     *ASCII code for Carriage Return
LF      EQU     $0A                     *ASCII code for Line Feed
TAB     EQU     $09                     *ASCII tab characte

NULL    EQU     $00                     *NULL character to terminate strings

start_addr      EQU         $7000               *pointer initial address
CR              EQU         $0D                 *ASCII code for Carriage Return
LF              EQU         $0A                 *ASCII code for Line Feed
TAB             EQU         $9
shift_12        EQU         12                  *Shift 12 bits 
shift_9         EQU         9                   *Shift 9 bits
shift_8         EQU         8                   *Shift 8 bits
shift_6         EQU         6                   *Shift 6 bits
shift_5         EQU         5                   *shift 5 bits
shift_3         EQU         3                   *Shift 3 bits
shift_10        EQU         10                  *shift 10 bits
iso_15          EQU         $8000               *isolate bit 15
iso_14          EQU         $4000               *isolate bit 14
iso_13          EQU         $2000               *isolate bit 13
iso_12          EQU         $1000               *isolate bit 12
iso_11          EQU         $0800               *isolate bit 11
iso_10          EQU         $0400               *isolate bit 10
iso_9           EQU         $0200               *isolate bit 9
iso_8           EQU         $0100               *isolate bit 8
iso_7           EQU         $0080               *isolate bit 7
iso_6           EQU         $0040               *isolate bit 6
iso_5           EQU         $0020               *isolate bit 5
iso_4           EQU         $0010               *isolate bit 4
iso_3           EQU         $0008               *isolate bit 3
iso_2           EQU         $0004               *isolate bit 2
iso_1           EQU         $0002               *isolate bit 2
iso_0           EQU         $0001               *isolate bit 0
iso_15_12       EQU         $F000               *isolate bits 15-12
iso_11_9        EQU         $0E00               *isolate bits 11-9
iso_8_6         EQU         $01C0               *isolate bits 8-6
iso_13_12       EQU         $3000               *isolate bits 13-12
iso_11_8        EQU         $0F00               *isolate bits 11-8
iso_5_3         EQU         $0038               *isolate bits 5-3
iso_2_0         EQU         $0007               *isolate bits 2-0
iso_8_0         EQU         $00FF               *isolate bits 8-0
iso_15_6        EQU         $FFC0               *isolate bits 15-6
iso_11_6        EQU         $0FC0               *isolate bits 11-6
iso_5_0         EQU         $003F               *isolate bits 5-0
iso_8_3         EQU         $01F8               *isolate bits 8-3
bad_flag        EQU         1                   *bad flag value
good_flag       EQU         0                   *good flag value


LINES_ON_SCREEN EQU         27                  *Maximum number of lines to display on screen (30)

****************************************************************
                *start of main program*
****************************************************************                
                ORG         $1000

****************************************************************
                    *I/O SECTION*
****************************************************************                
START
*---------Welcome Message-------------       
                LEA         WELCOME,A1              *welcome message is displayed
                MOVE.B      #14,D0     
                TRAP        #15                     *prints message
                
        
BEGINING
*-------Clear all data registries---------
                CLR         D0
                CLR         D1
                CLR         D2
                CLR         D3
                CLR         D4                     
                CLR         D5                      
                CLR         D6
                CLR         D7
*-------Clear all address registries---------
                LEA         CLEAR_ADDRESS,A0
                LEA         CLEAR_ADDRESS,A1  
                LEA         CLEAR_ADDRESS,A2  
                LEA         CLEAR_ADDRESS,A3  
                LEA         CLEAR_ADDRESS,A4  
                LEA         CLEAR_ADDRESS,A5  
                LEA         CLEAR_ADDRESS,A6  
                LEA         CLEAR_ADDRESS,A7    
        
        
                JSR         INPUT_STARTING_ADDRESS
                MOVE.B      #$4,D0                  *set up counter to check 4 bytes of memory
                JSR         STRING_TO_HEX           
                MOVE.L      D2,START_ADDRESS_HEX    *Moves the fully converted long hex from D2 into START_ADDRESS_HEX
                JSR         CHECK_ADDRESS           
                
                CLR         D0                      *clears D0 to ensure there is no conflicting data
                CLR         D2                      *clears D2 to ensure there is no conflicting data
                JSR         INPUT_ENDING_ADDRESS    
                MOVE.B      #$4,D0                  *set up counter to check 4 bytes of memory
                JSR         STRING_TO_HEX
                MOVE.L      D2,END_ADDRESS_HEX      *Moves the fully converted long hex from D2 into END_ADDRESS_HEX
                JSR         CHECK_ADDRESS
                
                MOVE.L      START_ADDRESS_HEX,D2    *check if the ending address is greater then the starting
                MOVE.L      END_ADDRESS_HEX,D0      *address, if it is greater, then invalid message is output.
                CMP.L       D0,D2
                BGT         INVALID_ADDRESS_2
            
                MOVEA.L     START_ADDRESS_HEX,A0      *load starting adddress to insert data
                *JSR         TEST_CODE           *load test code into memory   

                MOVEA.L     END_ADDRESS_HEX,A2               *A2 is now end address   
             
                JSR         PRINT_RETURN
                BRA         LOOP                *begin decoding

*-------Clear all data registries---------
                CLR         D0
                CLR         D1
                CLR         D2
                CLR         D3
                CLR         D4                     
                CLR         D5                      
                CLR         D6
                CLR         D7
*-------Clear all address registries---------
                LEA         CLEAR_ADDRESS,A0
                LEA         CLEAR_ADDRESS,A1  
                LEA         CLEAR_ADDRESS,A2  
                LEA         CLEAR_ADDRESS,A3  
                LEA         CLEAR_ADDRESS,A4  
                LEA         CLEAR_ADDRESS,A5  
                LEA         CLEAR_ADDRESS,A6  
                LEA         CLEAR_ADDRESS,A7  
                
****************************************************************
                    *BEGIN DECODING*
****************************************************************
LOOP            ADDA.W      #$1,A5             *add to line counter
                CMP.W       #LINES_ON_SCREEN,A5 *have we printed 20 lines?
                BEQ         PAUSE
                
CONTINUE        JSR         FIND_BITS_15_12     *Find first 4 bits
                JSR         PRINT_RETURN
                CMPA.L      A2,A0           *end of data?
                BLT         LOOP            *loop if it's not the end
                
                BRA         EXIT            *exit if it's the end
                

PAUSE           JSR         PRINT_LINE_MESSAGE  *tells user to click enter to continue or space to exit        
                MOVE.B      #5,D0       *get input, press enter to get next lines
                TRAP        #15
                MOVE.W      #$0000,A5   *reset counter
                CMP.B       #$20,D1     *input must be space
                BEQ         EXIT        *quit if the input is space
                
                JSR         PRINT_RETURN        *new line
                JSR         PRINT_RETURN        *new line
                
                BRA         CONTINUE
                
EXIT            BRA         END
                SIMHALT
                

****************************************************************
                    *SUBROUTINE SECTION*
**************************************************************** 

**********************INPUT_STARTING_ADDRESS*********************
*Prompts user to input a starting memory location in hexadecimal
*format. Only takes ASCII characters 1-9 and A-F. Must be input 
*with with no lowercase. Stores the inputed hex as a string in A1.
*Input hex needs to be even and cannot be greater then $FFFF or   
*less than $7000 or else the program will tell you its invalid  
*and prompt you to do it again. 
****************************************************************
INPUT_STARTING_ADDRESS
        LEA     STALOC,A1  *invokes message to input starting location
        MOVE.B  #14,D0
        TRAP    #15
        
        LEA     CLEAR_ADDRESS,A1  *clears out A1 before inputing value in it
        
        MOVE.B  #2,D0       *reads a string representing a hex from keyboard into A1
        TRAP    #15
        
        RTS

**********************INPUT_ENDING_ADDRESS**********************
*Prompts user to input a ending memory location in hexadecimal
*format. Only takes ASCII characters 1-9 and A-F. Must be input 
*with with no lowercase. Stores the inputed hex as a string in A1.
*Input hex needs to be even and cannot be greater then $FFFF or   
*less than $7000 or else the program will tell you its invalid  
*and prompt you to do it again. 
****************************************************************
INPUT_ENDING_ADDRESS
        LEA     ENDLOC,A1  *invokes message to input ending location
        MOVE.B  #14,D0
        TRAP    #15
        
        LEA     CLEAR_ADDRESS,A1  *clears out A1 before inputing value in it
       
        MOVE.B  #2,D0       *reads a string representing a hex from keyboard into A1
        TRAP    #15
        
        RTS
        
**********************STRING_TO_HEX*****************************
*This subroutine converts the user inputed string placed in A1 into 
*into a hex value found in D2. If a character is found to not be
*1-9 or A-F then invalid message will be displayed.
****************************************************************
STRING_TO_HEX
        MOVE.W  D2,D3
        
        ASL.L   #4,D2    *Arthimetic shifts data in D2 left 4 bits 
        MOVE.B  (A1)+,D1 *Moves two Hexabits representing a character from A1 to D1 and increments pointer
        
        CMP.B   #$30,D1         *Checks if the character is less then ASCII 0. 
        BLT     INVALID_ADDRESS *prints invalid address message
        
        CMP.B   #$46,D1         *Checks if the character is greater then ASCII A. 
        BGT     INVALID_ADDRESS *prints invalid address message
        
        CMP.B   #COMPAR_VAL,D1           *Sees if the ASCII hex is less then $40. If it is, then                                     
        BLT     DIGIT_TO_HEX             *it assumes the ASCII is a digit character, else it is 
                                         *handeled a letter character                                        
LETTER_TO_HEX
        SUB.B   #CHAR_TO_LETTER,D1      *Subtracts $37 from the character hex in D1 to determine its letter
        BRA     CALCULATE               *branch to calculate
        
DIGIT_TO_HEX        
        SUB.B   #CHAR_TO_DIGIT,D1         *Subtracts $30 from the character hex in D1 to determine digit
        
CALCULATE
        ADD.B   D1,D2       *Adds the determined Letter or digit from D1 into D2
        SUB.W   #1,D0       *Decrement counter.
        BNE     STRING_TO_HEX   *If counter is not 0, loop
        
        RTS

**********************HEX_TO_STRING*****************************
*This subroutine converts a hex into string and places it into
*D7.
****************************************************************
HEX_TO_STRING
        MOVE.B  D1,D7
        ANDI.B  #$0F,D7                  *isolates last 4 bits        
        
        CMP.B   #$9,D7                   *Sees if the hex is less or equal to $9. If it is, then                                     
        BLE     HEX_TO_DIGIT             *it assumes the hex is a digit, else it is 
                                         *handeled as a letter for ASCII conversion
                                     
HEX_TO_LETTER
        ADDI.B  #CHAR_TO_LETTER,D7       *Adds $37 from the character hex in D3 to determine its letter
        BRA     CALC                     *branch to calc
        
HEX_TO_DIGIT        
        ADDI.B   #CHAR_TO_DIGIT,D7         *Adds $30 from the character hex in D3 to determine digit
        
CALC
        ASR.L   #4,D1       *Arthimetic shifts data in D2 right 4 bits to get next digit
        ROR.L   #8,D7       *Roll data in D3 right 8 bits
        SUB.W   #1,D0       *Decrement counter.
        BNE     HEX_TO_STRING   *If counter is not 0, loop
        
        RTS

**********************CHECK_ADDRESS*****************************
*This subroutine checks if the address entered is even or odd.
*If it is odd then invalid address is printed.
****************************************************************
CHECK_ADDRESS
            MOVE.L  D2,D3           *make a copy of the address
            
            ANDI.B  #1,D2           *this checks to see if the last bit is 0 or 1. If it is 1
            BNE     INVALID_ADDRESS *then invalid address message is printed. Otherwise program resumes.
            
            CMP.L   #MIN_ADDRESS,D3 *checks if the input address is less than the min
            BLT     INVALID_ADDRESS
            
            CMP.L   #MAX_ADDRESS,D3 *checks if the input address is greater than the max
            BGT     INVALID_ADDRESS
            
            RTS

**********************INVALID_ADDRESS***************************
*Prints invalid address message and brings the user back to
*enter a valid address.
****************************************************************            
INVALID_ADDRESS
        LEA     INVAL_A,A1  *prints invalid address message
        MOVE.B  #14,D0          
        TRAP    #15
        
        BRA     BEGINING    *branch back to input

**********************INVALID_ADDRESS_2***************************
*Prints invalid address message if the starting address
*is larger then the ending address.
****************************************************************            
INVALID_ADDRESS_2
        LEA     INVAL_A_2,A1  *prints invalid address message
        MOVE.B  #14,D0          
        TRAP    #15
        
        BRA     BEGINING    *branch back to input
        
****************************END*********************************
*Asks the user if they would like to disassemble another memory
*image.  Ends the program if the user chooses not to, otherwise
*the user starts from the begining.
****************************************************************       
END     
        CLR     D0
        CLR     D1
        
        LEA     RESTART,A1              *asks user if they would like to restart
        MOVE.B  #14,D0     
        TRAP    #15                     *prints message
        
        MOVE.B  #4,D0                   *reads a number from keyboard into D1
        TRAP    #15
        
        CMP     #1,D1                   *user enters 1, then program restarts
        BEQ     BEGINING
        
        STOP    #$2700                  * Return to the simulator
                
*---------------------------------------------------------------------------

PRINT_D0_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_15,D7
                CMP.L       #$8000,D7
                BEQ         PRINT_D0
                RTS  
                
PRINT_D1_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_14,D7
                CMP.L       #$4000,D7
                BEQ         PRINT_D1
                RTS 
                
PRINT_D2_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_13,D7
                CMP.L       #$2000,D7
                BEQ         PRINT_D2
                RTS 
                
PRINT_D3_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_12,D7
                CMP.L       #$1000,D7
                BEQ         PRINT_D3
                RTS 

PRINT_D4_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_11,D7
                CMP.L       #$0800,D7
                BEQ         PRINT_D4
                RTS 

PRINT_D5_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_10,D7
                CMP.L       #$0400,D7
                BEQ         PRINT_D5
                RTS 
                
PRINT_D6_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_9,D7
                CMP.L       #$0200,D7
                BEQ         PRINT_D6
                RTS

PRINT_D7_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_8,D7
                CMP.L       #$0100,D7
                BEQ         PRINT_D7
                RTS
                
PRINT_A0_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_7,D7
                CMP.L       #$0080,D7
                BEQ         PRINT_A0
                RTS
                
PRINT_A1_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_6,D7
                CMP.L       #$0040,D7
                BEQ         PRINT_A1
                RTS
                
PRINT_A2_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_5,D7
                CMP.L       #$0020,D7
                BEQ         PRINT_A2
                RTS
                
PRINT_A3_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_4,D7
                CMP.L       #$0010,D7
                BEQ         PRINT_A3
                RTS
                
PRINT_A4_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_3,D7
                CMP.L       #$0008,D7
                BEQ         PRINT_A4
                RTS

PRINT_A5_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_2,D7
                CMP.L       #$0004,D7
                BEQ         PRINT_A5
                RTS
                
PRINT_A6_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_1,D7
                CMP.L       #$0002,D7
                BEQ         PRINT_A6
                RTS
                
PRINT_A7_CHECK_DEC  
                MOVE.W      movem1,D7
                ANDI.L      #iso_0,D7
                CMP.L       #$0001,D7
                BEQ         PRINT_A7
                RTS
                
FIND_BITS_15_12 CLR.L       D0                  *Zero out data registers
                CLR.L       D1                  
                CLR.L       D2                  
                CLR.L       D3                  
                CLR.L       D4
                CLR.L       D5
                CLR.L       D6
                CLR.L       D7
                
                CMPA.L      A2,A0           *Do one more check to see if we are at end
                BEQ         END
                
                *does not account for an address larger then FFFF
                MOVE.L      A0,D1           *move address into D1   
                MOVE.B      #$4,D0          *This sets up counter for conversion
             
                JSR         HEX_TO_STRING   *convert address to string
                JSR         PRINT_ZEROS 
   
                LEA         CLEAR_ADDRESS,A1       *clears out A1 before inputing value in it
                MOVE.L      D7,(A1)+               *moves the ASCII into A1
                MOVE.B      #NULL,(A1)+            *terminates the string with null byte
                MOVE.L      #0,A1                  *resets A1 pointer
                MOVE.B      #14,D0                 *prints out string
                TRAP        #15
                JSR         PRINT_SPACE
                CLR         D1
                
                
                MOVE.W      (A0)+,D0            *move input to D0
                MOVE.W      D0,input
                MOVE.W      D0,D1               *move input to D1 also
                ANDI.L      #iso_15_12,D1       *isolate bits 15-12
                MOVE.B      #shift_12,D2        *Shift 12 bits to the right  
                LSR.W       D2,D1               *Move the bits

                CMP.B       #%0000,D1
                BEQ         code0000_15_12
                CMP.B       #%0001,D1
                BEQ         code0001_15_12
                CMP.B       #%0010,D1
                BEQ         code0010_15_12
                CMP.B       #%0011,D1
                BEQ         code0011_15_12
                
                CMP.B       #%0100,D1
                BEQ         code0100_15_12
                CMP.B       #%0101,D1
                BEQ         code0101_15_12
                CMP.B       #%0110,D1
                BEQ         code0110_15_12
                CMP.B       #%0111,D1
                BEQ         code0111_15_12
                
                CMP.B       #%1000,D1
                BEQ         code1000_15_12
                CMP.B       #%1001,D1
                BEQ         code1001_15_12
                CMP.B       #%1010,D1
                BEQ         code1010_15_12
                CMP.B       #%1011,D1
                BEQ         code1011_15_12
                
                CMP.B       #%1100,D1
                BEQ         code1100_15_12
                CMP.B       #%1101,D1
                BEQ         code1101_15_12
                CMP.B       #%1110,D1
                BEQ         code1110_15_12
                CMP.B       #%1111,D1
                BEQ         code1111_15_12
                
*Can be BCHG, EORI, ANDI, SUBI, CMPI
code0000_15_12  JSR         SET_DATA             
                 
                CMP.B       #%101,D2
                BEQ         PRINT_BCHG_REG      *BCHG specified in a register
                
                CLR.L       D5
                CLR.L       D6
                MOVE.W      D0,D5
                ANDI.L      #iso_11_6,D5        
                MOVE.B      #shift_6,D6           
                LSR.W       D6,D5 
                
                CMP.B       #%100001,D5
                BEQ         PRINT_BCHG_IMM      *BCHG specified as immediate data
                
                ***Why are there 2 forms of BCHG immediate?***
                
                CMP.L       #%101000,D5         *EORI.B
                BEQ         PRINT_EORI_B
                CMP.L       #%101001,D5         *EORI.W
                BEQ         PRINT_EORI_W
                CMP.L       #%101010,D5         *EORI.L
                BEQ         PRINT_EORI_L
                
                CMP.L       #%001000,D5         *ANDI.B
                BEQ         PRINT_ANDI_B
                CMP.L       #%001001,D5         *ANDI.W
                BEQ         PRINT_ANDI_W
                CMP.L       #%001010,D5         *ANDI.L
                BEQ         PRINT_ANDI_L
         
                CMP.L       #%010000,D5         *SUBI.B
                BEQ         PRINT_SUBI_B 
                CMP.L       #%010001,D5         *SUBI.W
                BEQ         PRINT_SUBI_W
                CMP.L       #%010010,D5         *SUBI.L
                BEQ         PRINT_SUBI_L
                
                CMP.L       #%110000,D5         *CMPI.B
                BEQ         PRINT_CMPI_B
                CMP.L       #%110001,D5         *CMPI.W
                BEQ         PRINT_CMPI_W
                CMP.L       #%110010,D5         *CMPI.L
                BEQ         PRINT_CMPI_L

                CMP.L       #%011000,D5         *ADDI.B
                BEQ         PRINT_ADDI_B
                CMP.L       #%011001,D5         *ADDI.W
                BEQ         PRINT_ADDI_W
                CMP.L       #%011010,D5         *ADDI.L
                BEQ         PRINT_ADDI_L
                *BRA         SET_BAD_FLAG  
                
code0000_cont   BRA         PRINT_EA_FIRST      

code0000_andi_cont       
                JSR         PRINT_SPACE
                JSR         PRINT_POUND
                JSR         PRINT_NEXT_DATA
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
code0000_andi_l_cont       
                JSR         PRINT_SPACE
                JSR         PRINT_POUND
                JSR         PRINT_NEXT_DATA
                JSR         PRINT_NEXT_AGAIN
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                                                
                                                
code0000_addi   JSR         PRINT_SPACE
                JSR         PRINT_NEXT_DATA
                JSR         PRINT_COMMA 
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP

code0000_addi_l JSR         PRINT_SPACE
                JSR         PRINT_NEXT_DATA
                JSR         PRINT_NEXT_AGAIN
                JSR         PRINT_COMMA 
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                                                
BCHG_REG_EA 	JSR     	PRINT_SPACE
            	JSR     	PRINT_D
            	JSR     	PRINT_REG
            	JSR     	PRINT_COMMA
            	JSR     	PRINT_EA_MODE
            	JSR     	CHECK_PRINT_EA_REG
            	JSR     	PRINT_RETURN
            	BRA     	LOOP

BCHG_IMM_EA 	JSR     	PRINT_SPACE
            	JSR     	PRINT_NXT_DATA_BCHG
            	JSR     	PRINT_COMMA
            	JSR     	PRINT_EA_MODE
            	JSR     	CHECK_PRINT_EA_REG
            	JSR     	PRINT_RETURN
            	BRA     	LOOP
            	
PRINT_IMM_EA_NUM	
                MOVE.L  	D1, temprace
                MOVE.L  	D4, D1 	 
                MOVE.B  	#3,D0     	 
                TRAP    	#15
               	
                MOVE.L  	temprace, D1
               	
                JSR     	PRINT_RETURN
               	 
                BRA     	Loop      
*Can be MOVE.B
code0001_15_12  JSR         SET_DATA
                CMP.B       #%001,D2
                BEQ         SET_BAD_FLAG 
                JSR         PRINT_MOVE_B 
                BRA         PRINT_EA_FIRST
                
*Can be MOVE.W
code0011_15_12  JSR         SET_DATA
                CMP.B       #%001,D2
                BEQ         SET_BAD_FLAG
                JSR         PRINT_MOVE_W
                BRA         PRINT_EA_FIRST     

*Can be MOVE.L
code0010_15_12  JSR         SET_DATA
                CMP.B       #%001,D2
                BEQ         SET_BAD_FLAG
                JSR         PRINT_MOVE_L 
                BRA         PRINT_EA_FIRST       

*Can be MOVEM, LEA, CLR, JSR, RTS
code0100_15_12  JSR         SET_DATA
                MOVE.L      D0,D7
                
                CMP.L       #%0100111001110101,D0   *RTS
                BEQ         PRINT_RTS
                JSR         MODE_REQUIRED
                
                CMP.B       #%111,D2                *LEA
                BEQ         PRINT_LEA
                
                CLR.L       D5
                CLR.L       D6
                MOVE.W      D0,D5
                ANDI.L      #iso_11_6,D5        
                MOVE.B      #shift_6,D6           
                LSR.W       D6,D5  
                
                CMP.L       #%111010,D5             *JSR
                BEQ         PRINT_JSR
                
                CMP.L       #%001000,D5             *CLR.B
                BEQ         PRINT_CLR_B
                CMP.L       #%001001,D5             *CLR.W
                BEQ         PRINT_CLR_W
                CMP.L       #%001010,D5             *CLR.L
                BEQ         PRINT_CLR_L
                
                CMP.L       #%100010,D5             *MOVEM.W
                BEQ         PRINT_MOVEM_W
                CMP.L       #%110010,D5             *MOVEM.W
                BEQ         PRINT_MOVEM_W
                CMP.L       #%100011,D5             *MOVEM.L
                BEQ         PRINT_MOVEM_L
                CMP.L       #%110011,D5             *MOVEM.L
                BEQ         PRINT_MOVEM_L
                
                BRA         SET_BAD_FLAG
                
code0100_clr    JSR         PRINT_SPACE
                CMP.B       #%001,D3
                BEQ         SET_BAD_FLAG
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
code0100_jsr    CMP.B       #%000,D3
                BEQ         SET_BAD_FLAG
                CMP.B       #%001,D3
                BEQ         SET_BAD_FLAG
                CMP.B       #%011,D3
                BEQ         SET_BAD_FLAG
                CMP.B       #%100,D3
                BEQ         SET_BAD_FLAG
                JSR         PRINT_SPACE
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP

code0100_cont   CMP.W       -(A0),D1
                MOVE.W      (A0)+,movem0
                MOVE.W      (A0)+,movem1
                MOVE.W      (A0)+,movem2
                MOVE.W      (A0)+,movem3
                JSR         PRINT_SPACE
                MOVE.W      movem0,D1
                ANDI.L      #iso_10,D1          *isolate bit 10
                MOVE.B      #shift_10,D6        *Shift 10 bits to the right  
                LSR.W       D6,D1               *Move the bits
                CMP.B       #0,D1
                BEQ         code0100_rm
                BNE         code0100_mr

code0100_rm     CMP.L       -(A0),D4
                CMP.B       #%100,D3
                BEQ         PRE_DEC
                JSR         PRINT_RL_CHECK
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                MOVE.W      movem0,D0
                JSR         SET_DATA   
                JSR         PRINT_RETURN
                BRA         LOOP                   

rm_cont         JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN                
                BRA         LOOP

PRE_DEC         JSR         PRINT_RL_CHECK_PRE_DEC
                BRA         rm_cont  
PRE_DEC_MR      JSR         PRINT_RL_CHECK_PRE_DEC
                BRA         mr_cont      

code0100_mr     CMP.L       -(A0),D4
                MOVE.W      movem0,D0
                JSR         SET_DATA
                CMP.B       #%100,D3
                BEQ         PRE_DEC_MR
                
mr_cont         JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_RL_CHECK
                JSR         PRINT_RETURN
                BRA         LOOP
                
code0100_mr_1   
                JSR         PRINT_COMMA
                JSR         PRINT_RETURN
                BRA         LOOP

PRINT_RL_CHECK  JSR         PRINT_A7_Check
                JSR         PRINT_A6_Check 
                JSR         PRINT_A5_Check 
                JSR         PRINT_A4_Check 
                JSR         PRINT_A3_Check
                JSR         PRINT_A2_Check 
                JSR         PRINT_A1_Check 
                JSR         PRINT_A0_Check 

                JSR         PRINT_D7_CHECK
                JSR         PRINT_D6_CHECK 
                JSR         PRINT_D5_CHECK 
                JSR         PRINT_D4_CHECK 
                JSR         PRINT_D3_CHECK
                JSR         PRINT_D2_CHECK 
                JSR         PRINT_D1_CHECK 
                JSR         PRINT_D0_CHECK

                RTS    

PRINT_RL_CHECK_PRE_DEC

                JSR         PRINT_D0_CHECK_DEC
                JSR         PRINT_D1_CHECK_DEC 
                JSR         PRINT_D2_CHECK_DEC 
                JSR         PRINT_D3_CHECK_DEC 
                JSR         PRINT_D4_CHECK_DEC
                JSR         PRINT_D5_CHECK_DEC 
                JSR         PRINT_D6_CHECK_DEC 
                JSR         PRINT_D7_CHECK_DEC 

                JSR         PRINT_A0_CHECK_DEC
                JSR         PRINT_A1_CHECK_DEC 
                JSR         PRINT_A2_CHECK_DEC 
                JSR         PRINT_A3_CHECK_DEC 
                JSR         PRINT_A4_CHECK_DEC
                JSR         PRINT_A5_CHECK_DEC 
                JSR         PRINT_A6_CHECK_DEC 
                JSR         PRINT_A7_CHECK_DEC

                RTS    
      

*Can be ADDQ
code0101_15_12  JSR         SET_DATA
                
                CMP.B       #%000,D2             *ADDQ.B
                BEQ         PRINT_ADDQ_B
                CMP.B       #%001,D2             *ADDQ.W
                BEQ         PRINT_ADDQ_W 
                CMP.B       #%010,D2             *ADDQ.L
                BEQ         PRINT_ADDQ_L
                
                *BRA         SET_BAD_FLAG
                
code0101_cont   JSR         PRINT_SPACE
                JSR         PRINT_POUND
                CMP.B       #0,D1
                BEQ         code0101_cont_1
                MOVE.B      #3,D0
                TRAP        #15
                
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE           *Once again, how is (xxx).X
                JSR         CHECK_PRINT_EA_REG      *a possible destination?
                JSR         PRINT_RETURN
                
                BRA         LOOP
                
code0101_cont_1 JSR         PRINT_8
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE           *Once again, how is (xxx).X
                JSR         CHECK_PRINT_EA_REG      *a possible destination?
                JSR         PRINT_RETURN
                
                BRA         LOOP
                
*Can be Bcc (BCC, BGT, BLE, BVS)
code0110_15_12  JSR         SD_MOVEQ_BCC

                CLR         D6
                MOVE.W      D0,D6                     *move the current command into D6
                
                CMP.B       #%0000,D1
                BEQ         PRINT_BRA
                CMP.B       #%0010,D1
                BEQ         PRINT_BHI
  
                CMP.B       #%0011,D1
                BEQ         PRINT_BLS       
                CMP.B       #%0100,D1
                BEQ         PRINT_BCC
                
                CMP.B       #%0101,D1
                BEQ         PRINT_BCS                
                CMP.B       #%0110,D1
                BEQ         PRINT_BNE
                
                CMP.B       #%0111,D1
                BEQ         PRINT_BEQ                
                CMP.B       #%1000,D1
                BEQ         PRINT_BVC
                
                CMP.B       #%1001,D1
                BEQ         PRINT_BVS                
                CMP.B       #%1010,D1
                BEQ         PRINT_BPL
                
                CMP.B       #%1011,D1
                BEQ         PRINT_BMI                
                CMP.B       #%1100,D1
                BEQ         PRINT_BGE
                
                CMP.B       #%1101,D1
                BEQ         PRINT_BLT                
                CMP.B       #%1110,D1
                BEQ         PRINT_BGT
                
                CMP.B       #%1111,D1
                BEQ         PRINT_BLE
                
                CMP.B       #%00000000,D2
                BEQ         PRINT_16B
                CMP.B       #%11111111,D2
                BEQ         PRINT_32B
                
                BRA         SET_BAD_FLAG
                
code0110_cont   CLR.L       D7
                MOVE.W      A0,BCC_INITIAL_ADDRESS      *keep track of the position

                ANDI        #$00FF,D6                   *isolate the byte to see if displacement is neg or pos
                CMP.W       #$0,D6                      *if byte is 0 then displacement is pos else neg
                BEQ         bcc_pos
                
bcc_neg         CLR         D5
                MOVE.W      #$100,D5                     *check the displacement of last byte
                SUB.W       D6,D5                       *subtract the difference
                MOVE.W      BCC_INITIAL_ADDRESS,D6      *move the initial address to D6
                SUB.W       D5,D6                       *subtract the displacement from initial address
                BRA         print_bcc_address
                
bcc_pos         MOVE.W      (A0)+,D6                    *move input to D7. increment pointer and get displacement
                ADD.W       BCC_INITIAL_ADDRESS,D6               *add the displacement to the address

print_bcc_address                
                CLR.L       D1
                CLR.L       D0
                JSR         PRINT_SPACE
                MOVE.L      D6,D1  
                MOVE.B      #$4,D0          *This sets up counter for conversion
                JSR         HEX_TO_STRING
                    
                LEA         CLEAR_ADDRESS,A1       *clears out A1 before inputing value in it
                MOVE.L      D7,(A1)+               *moves the ASCII into A1
                MOVE.B      #NULL,(A1)+            *terminates the string with null byte
                MOVE.L      #0,A1                  *resets A1 pointer
                MOVE.B      #14,D0                 *prints out string
                TRAP        #15
                
                JSR         PRINT_RETURN    
                CLR.L       D1
                
                BRA         LOOP

*Can be MOVEQ 
code0111_15_12  JSR         SD_MOVEQ_BCC
                
                CMP.B       #%0001,D1           *check all odd numbers 0-15
                BEQ         SET_BAD_FLAG
                CMP.B       #%0011,D1
                BEQ         SET_BAD_FLAG
                
                CMP.B       #%0101,D1
                BEQ         SET_BAD_FLAG
                CMP.B       #%0111,D1
                BEQ         SET_BAD_FLAG
                
                CMP.B       #%1001,D1
                BEQ         SET_BAD_FLAG
                CMP.B       #%1011,D1
                BEQ         SET_BAD_FLAG
                
                CMP.B       #%1101,D1
                BEQ         SET_BAD_FLAG
                CMP.B       #%1111,D1
                BEQ         SET_BAD_FLAG
                
                BRA         PRINT_MOVEQ
                
code0111_cont   JSR         PRINT_SPACE
                JSR         PRINT_POUND
                JSR         PRINT_DOLLAR
                MOVE.L      D2,D1
                MOVE.B      #3,D0          
                TRAP        #15
                
                JSR         PRINT_COMMA
                
                JSR         PRINT_D
                JSR         SET_DATA
                MOVE.B      #3,D0          
                TRAP        #15
                
                JSR         PRINT_RETURN
                
                BRA         LOOP
                
*Can be DIVS
code1000_15_12  JSR SET_DATA  

                JSR         MODE_REQUIRED

                CMP.B       #%111,D2
                BNE         SET_BAD_FLAG
                
                JSR         PRINT_DIVS_W
                BRA         PRINT_LEA_EA
                
code1000_cont   JSR         PRINT_SPACE             *Prints DIVS format
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                
                BRA         LOOP                

*Can be SUB, SUBA
code1001_15_12  JSR         SET_DATA

                *JSR         DATA_DST_CHECK
                
                JSR         MODE_REQUIRED

                CMP.B       #%000,D2
                BEQ         PRINT_SUB_B
                CMP.B       #%100,D2
                BEQ         PRINT_SUB_B

                CMP.B       #%001,D2
                BEQ         PRINT_SUB_W
                CMP.B       #%101,D2
                BEQ         PRINT_SUB_W

                CMP.B       #%010,D2
                BEQ         PRINT_SUB_L
                CMP.B       #%110,D2
                BEQ         PRINT_SUB_L  

                CMP.B       #%011,D2
                BEQ         PRINT_SUBA_W
                CMP.B       #%111,D2
                BEQ         PRINT_SUBA_L

code1001_cont   CMP.B       #%000,D2
                BEQ         PRINT_EA_FIRST
                CMP.B       #%001,D2
                BEQ         PRINT_EA_FIRST
                CMP.B       #%010,D2
                BEQ         PRINT_EA_FIRST
                
                CMP.B       #%100,D2
                BEQ         PRINT_EA_LAST
                CMP.B       #%101,D2
                BEQ         PRINT_EA_LAST
                CMP.B       #%110,D2
                BEQ         PRINT_EA_LAST
                
code1001_suba   JSR         PRINT_SPACE
                JSR         PRINT_OPMODE
                JSR         CHECK_PRINT_REG
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
*Can't be anything
code1010_15_12  BRA         SET_BAD_FLAG

*Can be EOR, CMP, CMPA
code1011_15_12  JSR         SET_DATA

                CMP.B       #%100,D2
                BEQ         PRINT_EOR_B
                CMP.B       #%101,D2
                BEQ         PRINT_EOR_W
                CMP.B       #%110,D2
                BEQ         PRINT_EOR_L
                
                CMP.B       #%000,D2
                BEQ         PRINT_CMP_B
                CMP.B       #%001,D2
                BEQ         PRINT_CMP_W
                CMP.B       #%010,D2
                BEQ         PRINT_CMP_L
                
                CMP.B       #%011,D2
                BEQ         PRINT_CMPA_W
                CMP.B       #%111,D2
                BEQ         PRINT_CMPA_L
                
 

code1011_eor    JSR         PRINT_SPACE
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE_2
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP

code1011_cmp    JSR         PRINT_SPACE
                JSR         PRINT_EA_MODE_2
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP

code1011_cmpa   JSR         PRINT_SPACE
                JSR         PRINT_EA_MODE_2
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                                
*Can be AND, MULS
code1100_15_12  JSR         SET_DATA

                *JSR         DATA_DST_CHECK
                
                JSR         MODE_REQUIRED
                
                CMP.B       #%011,D2
                BEQ         SET_BAD_FLAG
                
                CMP.B       #%111,D2
                BEQ         PRINT_MULS_W
                
                CMP.B       #%000,D2
                BEQ         PRINT_AND_B
                CMP.B       #%100,D2
                BEQ         PRINT_AND_B

                CMP.B       #%001,D2
                BEQ         PRINT_AND_W
                CMP.B       #%101,D2
                BEQ         PRINT_AND_W

                CMP.B       #%010,D2
                BEQ         PRINT_AND_L
                CMP.B       #%110,D2
                BEQ         PRINT_AND_L 
                
code1100_cont   CMP.B       #%000,D2
                BEQ         code1100_and_1
                CMP.B       #%001,D2
                BEQ         code1100_and_1
                CMP.B       #%010,D2
                BEQ         code1100_and_1
                
                CMP.B       #%100,D2
                BEQ         code1100_and_2
                CMP.B       #%101,D2
                BEQ         code1100_and_2
                CMP.B       #%110,D2
                BEQ         code1100_and_2
                
                BRA         PRINT_LEA_EA 
                
code1100_and_1  JSR         PRINT_SPACE             
                JSR         PRINT_EA_MODE_2
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
code1100_and_2  JSR         PRINT_SPACE             
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE_NP
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP

code1100_muls   JSR         PRINT_SPACE
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP       
                                               
*Can be ADD, ADDA
code1101_15_12  JSR         SET_DATA
                
                JSR         MODE_REQUIRED
                CMP.B       #%111,D2
                BEQ         PRINT_ADDA_L
                CMP.B       #%011,D2
                BEQ         PRINT_ADDA_W
                CMP.B       #%000,D2
                BEQ         PRINT_ADD_B
                CMP.B       #%100,D2
                BEQ         PRINT_ADD_B
                CMP.B       #%001,D2
                BEQ         PRINT_ADD_W
                CMP.B       #%101,D2
                BEQ         PRINT_ADD_W
                CMP.B       #%010,D2
                BEQ         PRINT_ADD_L
                CMP.B       #%110,D2
                BEQ         PRINT_ADD_L         
code1101_adda   CMP.B       #%000,D3
                BEQ         ADDA_EA_REG
                CMP.B       #%111,D3
                BEQ         ADDA_NO_EA_REG
                CMP.B       #%011,D2
                BEQ         ADDA_NO_EA_REG
                BRA         ADDA_EA_REG
                
code1101_adda_l JSR         PRINT_SPACE
                CMP.B       #%000,D3
                BEQ         adda_l_ea_000
                CMP.B       #%001,D3
                BEQ         adda_l_ea_001
                CMP.B       #%010,D3
                BEQ         adda_l_ea_010
                CMP.B       #%011,D3
                BEQ         adda_l_ea_011
                JSR         PRINT_NEXT_DATA
                CMP.B       #%100,D4
                BEQ         adda_l_print_again
                
adda_l_cont     JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP 

adda_l_print_again
                JSR         PRINT_NEXT_AGAIN
                BRA         adda_l_cont
                
adda_l_ea_000   JSR         PRINT_D
                JSR         PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP 
                
adda_l_ea_001   JSR         PRINT_A
                JSR         PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP 
                
adda_l_ea_010   JSR         PRINT_L_PAREN
                JSR         PRINT_A
                JSR         PRINT_EA_REG
                JSR         PRINT_R_PAREN
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP 
                
adda_l_ea_011   JSR         PRINT_L_PAREN
                JSR         PRINT_A
                JSR         PRINT_EA_REG
                JSR         PRINT_R_PAREN
                JSR         PRINT_PLUS
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP 
                
adda_l_ea_100   JSR         PRINT_MINUS
                JSR         PRINT_L_PAREN
                JSR         PRINT_A
                JSR         PRINT_EA_REG
                JSR         PRINT_R_PAREN
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP 
                
ADDA_EA_REG     JSR         PRINT_SPACE
                JSR         PRINT_EA_MODE
                JSR         PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
ADDA_NO_EA_REG  JSR         PRINT_SPACE
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP
code1101_add    CMP.B       #%100,D2
                BEQ         ADD_EA_LAST
                CMP.B       #%101,D2
                BEQ         ADD_EA_LAST
                CMP.B       #%110,D2
                BEQ         ADD_EA_LAST
                
                CMP.B       #%000,D2
                BEQ         ADD_EA_FIRST
                CMP.B       #%001,D2
                BEQ         ADD_EA_FIRST
                CMP.B       #%010,D2
                BEQ         ADD_EA_FIRST
ADD_EA_FIRST    JSR         PRINT_SPACE
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
ADD_EA_LAST     JSR         PRINT_SPACE
                JSR         PRINT_D
                JSR         PRINT_REG
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
*Can be LSR, LSL, ASR, ASL, ROL, ROR
code1110_15_12  JSR         SET_DATA

                MOVE.W      D0,D5               *move input to D1 also
                ANDI.L      #iso_15_6,D5        *isolate bits 11-9
                MOVE.B      #shift_6,D6         *Shift 9 bits to the right  
                LSR.W       D6,D5 

                CMP.W       #%1110001011,D5    *LSR memory shift
                BEQ         MEM_SHIFT_EA_LSR
                CMP.W       #%1110001111,D5    *LSL memory shift
                BEQ         MEM_SHIFT_EA_LSL
                CMP.W       #%1110000011,D5    *ASR memory shift
                BEQ         MEM_SHIFT_EA_ASR
                CMP.W       #%1110000111,D5    *ASL memory shift
                BEQ         MEM_SHIFT_EA_ASL
                CMP.W       #%1110011011,D5    *ROR memory shift
                BEQ         MEM_SHIFT_EA_ROR
                CMP.W       #%1110011111,D5    *ROL memory shift
                BEQ         MEM_SHIFT_EA_ROL
                
                CMP.B       #%011,D2
                BNE         code1110_reg
                CMP.B       #%111,D2
                BNE         code1110_reg
                
code1110_cont   BRA         PRINT_EA_LAST

MEM_SHIFT_EA_LSR   
                JSR         PRINT_LSR_MEM
                JSR         PRINT_SPACE       
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
MEM_SHIFT_EA_LSL   
                JSR         PRINT_LSL_MEM
                JSR         PRINT_SPACE       
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP

MEM_SHIFT_EA_ASR   
                JSR         PRINT_ASR_MEM
                JSR         PRINT_SPACE       
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP

MEM_SHIFT_EA_ASL   
                JSR         PRINT_ASL_MEM
                JSR         PRINT_SPACE       
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP

MEM_SHIFT_EA_ROR   
                JSR         PRINT_ROR_MEM
                JSR         PRINT_SPACE       
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
MEM_SHIFT_EA_ROL   
                JSR         PRINT_ROL_MEM
                JSR         PRINT_SPACE       
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_RETURN
                BRA         LOOP
                
code1110_reg    MOVE.W      D0,D7
                CLR.L       D5
                MOVE.W      D0,D5               *move input to D1 also
                ANDI.L      #iso_8_3,D5         *isolate bits 11-9
                MOVE.B      #shift_3,D6         *Shift 9 bits to the right  
                LSR.W       D6,D5 

                CMP.B       #%000000,D5
                BEQ         PRINT_ASR_B
                CMP.B       #%000100,D5
                BEQ         PRINT_ASR_B
                CMP.B       #%100000,D5
                BEQ         PRINT_ASL_B
                CMP.B       #%100100,D5
                BEQ         PRINT_ASL_B
                
                CMP.B       #%001000,D5
                BEQ         PRINT_ASR_W
                CMP.B       #%001100,D5
                BEQ         PRINT_ASR_W
                CMP.B       #%101000,D5
                BEQ         PRINT_ASL_W
                CMP.B       #%101100,D5
                BEQ         PRINT_ASL_W
                
                CMP.B       #%010000,D5
                BEQ         PRINT_ASR_L
                CMP.B       #%010100,D5
                BEQ         PRINT_ASR_L
                CMP.B       #%110000,D5
                BEQ         PRINT_ASL_L
                CMP.B       #%110100,D5
                BEQ         PRINT_ASL_L
                
                CMP.B       #%000001,D5
                BEQ         PRINT_LSR_B
                CMP.B       #%000101,D5
                BEQ         PRINT_LSR_B
                CMP.B       #%100001,D5
                BEQ         PRINT_LSL_B
                CMP.B       #%100101,D5
                BEQ         PRINT_LSL_B
                
                CMP.B       #%001001,D5
                BEQ         PRINT_LSR_W
                CMP.B       #%001101,D5
                BEQ         PRINT_LSR_W
                CMP.B       #%101001,D5
                BEQ         PRINT_LSL_W
                CMP.B       #%101101,D5
                BEQ         PRINT_LSL_W
                
                CMP.B       #%010001,D5
                BEQ         PRINT_LSR_L
                CMP.B       #%010101,D5
                BEQ         PRINT_LSR_L
                CMP.B       #%110001,D5
                BEQ         PRINT_LSL_L
                CMP.B       #%110101,D5
                BEQ         PRINT_LSL_L
                
                CMP.B       #%000011,D5
                BEQ         PRINT_ROR_B
                CMP.B       #%000111,D5
                BEQ         PRINT_ROR_B
                CMP.B       #%100011,D5
                BEQ         PRINT_ROL_B
                CMP.B       #%100111,D5
                BEQ         PRINT_ROL_B
                
                CMP.B       #%001011,D5
                BEQ         PRINT_ROR_W
                CMP.B       #%001111,D5
                BEQ         PRINT_ROR_W
                CMP.B       #%101011,D5
                BEQ         PRINT_ROL_W
                CMP.B       #%101111,D5
                BEQ         PRINT_ROL_W
                
                CMP.B       #%010011,D5
                BEQ         PRINT_ROR_L
                CMP.B       #%010111,D5
                BEQ         PRINT_ROR_L
                CMP.B       #%110011,D5
                BEQ         PRINT_ROL_L
                CMP.B       #%110111,D5
                BEQ         PRINT_ROL_L
                
code1110_reg_ea MOVE.W      D7,D0
                CLR.L       D6
                MOVE.W      D0,D6               *move input to D1 also
                ANDI.L      #iso_5,D6           *isolate bits 11-9
                MOVE.B      #shift_5,D7         *Shift 5 bits to the right  
                LSR.W       D7,D6
                CLR.L       D7

                CMP.B       #1,D6
                BEQ         code1110_IR_1
                CMP.B       #0,D6
                BEQ         code1110_IR_0
                
code1110_IR_1   JSR         PRINT_SPACE
                JSR         PRINT_D
                MOVE.B      #3,D0
                TRAP        #15
                JSR         PRINT_COMMA
                JSR         PRINT_D
                MOVE.B      D4,D1
                MOVE.B      #3,D0
                TRAP        #15
                JSR         PRINT_RETURN
                
                BRA         LOOP

code1110_IR_0   JSR         PRINT_SPACE
                JSR         PRINT_POUND
                CMP.B       #0,D1
                BEQ         code1110_IR_0_0
                MOVE.B      #3,D0
                TRAP        #15
                JSR         PRINT_COMMA
                JSR         PRINT_D
                MOVE.B      D4,D1
                MOVE.B      #3,D0
                TRAP        #15
                JSR         PRINT_RETURN
                
                BRA         LOOP
                
code1110_IR_0_0 JSR         PRINT_8
                JSR         PRINT_COMMA
                JSR         PRINT_D
                MOVE.B      D4,D1
                MOVE.B      #3,D0
                TRAP        #15
                JSR         PRINT_RETURN 
                
                BRA         LOOP

*Can't be anything
code1111_15_12  BRA         SET_BAD_FLAG

*********************************************************************************

SET_DATA        CLR.L       D1                  *set register
                CLR.L       D2
                
                MOVE.W      D0,D1               *move input to D1 also
                ANDI.L      #iso_11_9,D1        *isolate bits 11-9
                MOVE.B      #shift_9,D2         *Shift 9 bits to the right  
                LSR.W       D2,D1               *Move the bits
                
                CLR.L       D2
                CLR.L       D3                  *set opmode
                
                MOVE.W      D0,D2               *move input to D1 also
                ANDI.L      #iso_8_6,D2         *isolate bits 8-6
                MOVE.B      #shift_6,D3         *Shift 6 bits to the right  
                LSR.W       D3,D2               *Move the bits
  
                CLR.L       D3
                CLR.L       D4
                
                MOVE.W      D0,D3               *move input to D1 also
                ANDI.L      #iso_5_3,D3         *isolate bits 8-6
                MOVE.B      #shift_3,D4         *Shift 6 bits to the right  
                LSR.W       D4,D3               *Move the bits
                
                CLR.L       D4
                
                MOVE.W      D0,D4
                ANDI.L      #iso_2_0,D4
                
                CLR.L       D5
                CLR.L       D6
                CLR.L       D7                  
                
                MOVE.B      #good_flag,D7       *set good flag
                
                RTS
                
SD_MOVEQ_BCC    CLR.L       D1                  *set register
                CLR.L       D2
                
                MOVE.W      D0,D1               *move input to D1 also
                ANDI.L      #iso_11_8,D1        *isolate bits 11-8
                MOVE.B      #shift_8,D2         *Shift 8 bits to the right  
                LSR.W       D2,D1               *Move the bits
                
                CLR.L       D2                  
                
                MOVE.W      D0,D2               *move input to D2 also
                ANDI.L      #iso_8_0,D2         *isolate bits 8-0
                
                CLR.L       D3
                CLR.L       D4
                CLR.L       D5
                CLR.L       D6            
                CLR.L       D7
                
                MOVE.B      #good_flag,D7
                
                RTS
                
SET_BAD_FLAG    CLR.L       D5
                CLR.L       D6
                CLR.L       D7
                
                MOVE.B      #bad_flag,D7
                
                BRA         INVALID_MC
                
SET_BAD_FLAG_1  CLR.L       D5
                CLR.L       D6
                CLR.L       D7
                
                MOVE.B      #bad_flag,D7
                
                BRA         INVALID_MC_1
                
ADDR_MODE_NR    CLR.L       D5
                CLR.L       D6
                CLR.L       D7
                
                BRA         NOT_REQUIRED

*---------------------------------------------------------------------------------

DATA_DST_CHECK  CMP.B       #%111,D2            *Data cannot come second in syntax
                BEQ         EA_FIRST_VALID
                CMP.B       #%011,D2
                BEQ         EA_FIRST_VALID
                
                CMP.B       #%000,D2
                BEQ         EA_FIRST_VALID
                CMP.B       #%001,D2
                BEQ         EA_FIRST_VALID
                CMP.B       #%010,D2
                BEQ         EA_FIRST_VALID
                
                CMP.B       #%100,D2
                BEQ         EA_LAST_VALID
                CMP.B       #%101,D2
                BEQ         EA_LAST_VALID
                CMP.B       #%110,D2
                BEQ         EA_LAST_VALID
                
MODE_REQUIRED   CMP.B       #%101,D3                *addressing mode not required
                BEQ         ADDR_MODE_NR
                CMP.B       #%110,D3                *addressing mode not required
                BEQ         ADDR_MODE_NR
                
                RTS
               
EA_FIRST_VALID  CMP.B       #%111,D2                *data can't come second
                BEQ         SET_BAD_FLAG_1
                
                RTS

EA_LAST_VALID   CMP.B       #%111,D3                *data can't come second
                BEQ         SET_BAD_FLAG_1
                
                RTS
                
PRINT_EA_FIRST  JSR         PRINT_SPACE             *Prints EA first
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                MOVE.W      #$1228,D6        *marker to show you've printed before comma
                JSR         PRINT_OPMODE
                JSR         CHECK_PRINT_REG

PRINT_EA_FIRST_RTS                
                RTS
                
PRINT_EA_LAST   JSR         PRINT_SPACE             *Prints EA last
                JSR         PRINT_OPMODE
                JSR         CHECK_PRINT_REG
                JSR         PRINT_COMMA
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                
                RTS
                
PRINT_LEA_EA    JSR         PRINT_SPACE             *Prints LEA, DIVS format
                JSR         PRINT_EA_MODE
                JSR         CHECK_PRINT_EA_REG
                JSR         PRINT_COMMA
                JSR         PRINT_A
                JSR         PRINT_REG
                
                RTS
                
*------------------------------------------------------------------------------

PRINT_REG       CMP.B       #%000,D1
                BEQ         PRINT_0
                CMP.B       #%001,D1
                BEQ         PRINT_1
                CMP.B       #%010,D1
                BEQ         PRINT_2
                CMP.B       #%011,D1
                BEQ         PRINT_3
                CMP.B       #%100,D1
                BEQ         PRINT_4
                CMP.B       #%101,D1
                BEQ         PRINT_5
                CMP.B       #%110,D1
                BEQ         PRINT_6
                CMP.B       #%111,D1
                BEQ         PRINT_7
                
PRINT_OPMODE    CMP.B       #%000,D2
                BEQ         PRINT_D
                CMP.B       #%001,D2
                BEQ         PRINT_A
                CMP.B       #%010,D2
                BEQ         PRINT_AI
                CMP.B       #%011,D2
                BEQ         PRINT_AII
                
                CMP.B       #%100,D2
                BEQ         PRINT_AID
                CMP.B       #%111,D2
                *BEQ         PRINT_X            *use for no immediate data in test code
                BEQ         PRINT_NEXT_DATA
                
PRINT_OPMODE_2  CMP.B       #%000,D2
                BEQ         PRINT_D
                CMP.B       #%001,D2
                BEQ         PRINT_A
                CMP.B       #%010,D2
                BEQ         PRINT_AI
                CMP.B       #%011,D2
                BEQ         PRINT_AII
                
                CMP.B       #%100,D2
                BEQ         PRINT_AID
                CMP.B       #%111,D2
                *BEQ         PRINT_X            *use for no immediate data in test code
                BEQ         PRINT_NEXT_DATA_2
                
PRINT_EA_MODE   CMP.B       #%000,D3
                BEQ         PRINT_D
                CMP.B       #%001,D3
                BEQ         PRINT_A
                CMP.B       #%010,D3
                BEQ         PRINT_AI_EA
                CMP.B       #%011,D3
                BEQ         PRINT_AII_EA
                
                CMP.B       #%100,D3
                BEQ         PRINT_AID_EA
                CMP.B       #%111,D3
                *BEQ         PRINT_X_EA         *use for no immediate data in test code
                BEQ         PRINT_NEXT_DATA
                
PRINT_EA_MODE_2 CMP.B       #%000,D3
                BEQ         PRINT_D
                CMP.B       #%001,D3
                BEQ         PRINT_A
                CMP.B       #%010,D3
                BEQ         PRINT_AI_EA
                CMP.B       #%011,D3
                BEQ         PRINT_AII_EA
                
                CMP.B       #%100,D3
                BEQ         PRINT_AID_EA
                CMP.B       #%111,D3
                *BEQ         PRINT_X_EA         *use for no immediate data in test code
                BEQ         PRINT_NEXT_DATA_2
                
PRINT_EA_MODE_NP    CMP.B       #%000,D3
                BEQ         PRINT_D
                CMP.B       #%001,D3
                BEQ         PRINT_A
                CMP.B       #%010,D3
                BEQ         PRINT_AI_EA
                CMP.B       #%011,D3
                BEQ         PRINT_AII_EA
                
                CMP.B       #%100,D3
                BEQ         PRINT_AID_EA
                CMP.B       #%111,D3
                *BEQ         PRINT_X_EA         *use for no immediate data in test code
                BEQ         PRINT_NEXT_DATA_NP
                
PRINT_EA_REG    CMP.B       #%000,D4
                BEQ         PRINT_0
                CMP.B       #%001,D4
                BEQ         PRINT_1
                CMP.B       #%010,D4
                BEQ         PRINT_2
                CMP.B       #%011,D4
                BEQ         PRINT_3
                CMP.B       #%100,D4
                BEQ         PRINT_4
                CMP.B       #%101,D4
                BEQ         PRINT_5
                CMP.B       #%110,D4
                BEQ         PRINT_6
                CMP.B       #%111,D4
                BEQ         PRINT_7
                
CHECK_PRINT_REG     CMP.B       #%000,D2
                    BEQ         PRINT_REG
                    CMP.B       #%001,D2
                    BEQ         PRINT_REG
                    
                    RTS

CHECK_PRINT_EA_REG  CMP.B       #%000,D3
                    BEQ         PRINT_EA_REG
                    CMP.B       #%001,D3
                    BEQ         PRINT_EA_REG

                    RTS  
                    
PRINT_NXT_DATA_BCHG MOVE.B      D1,D5           *store D1
                    JSR         PRINT_POUND
                    JSR         PRINT_DOLLAR
                    MOVE.W      (A0)+,D1  
                    MOVE.B      #3,D0          
                    TRAP        #15
                    CLR.L       D1
                    MOVE.B      D5,D1           *move data back into D1
                    
                    RTS
                    
PRINT_NEXT_DATA     CLR         D0
                    CLR         D7
                    
                    MOVE.B      D1,D5           *store D1
                    JSR         PRINT_POUND
                    JSR         PRINT_DOLLAR
                    MOVE.W      (A0)+,D1
                    
                    MOVE.B      #$4,D0          *This sets up counter for conversion
             
                    JSR         HEX_TO_STRING
                    
                    LEA         CLEAR_ADDRESS,A1       *clears out A1 before inputing value in it
                    MOVE.L      D7,(A1)+               *moves the ASCII into A1
                    MOVE.B      #NULL,(A1)+            *terminates the string with null byte
                    MOVE.L      #0,A1                  *resets A1 pointer
                    MOVE.B      #14,D0                 *prints out string
                    TRAP        #15
                    
                    CLR.L       D1
                    MOVE.B      D5,D1           *move data back into D1
                    CLR.L       D0
        
                    *Do we need to print the next word too? (Long data)
                    
                    MOVE.W      input,D0
                    *account for MOVE.L
                    ANDI.L      #iso_15_12,D0   *isolate bits 15-12         
                    LSR.W       #6,D0    *Shift 12 bits to the right
                    LSR.W       #6,D0
                    CMP.B       #%0010,D0
                    BEQ         IS_MOVE_L
                    CMP.B       #%0011,D0
                    BEQ         IS_MOVE_W
                    
                    *account for everything else
                    CMP.B       #%001,D4
                    BEQ         PRINT_NEXT_AGAIN    *print next data, it's long
                
PRINT_NEXT_RTS    
                    RTS
                    
IS_MOVE_L           CMP.W       #$1228,D6
                    BEQ         CHECK_MOVE_L_PRINT_NEXT
                    JSR         PRINT_NEXT_AGAIN
                    BRA         PRINT_NEXT_RTS
                    
CHECK_MOVE_L_PRINT_NEXT
                    MOVE.W      input,D0
                    ANDI.L      #iso_11_6,D0
                    LSR.W       #6,D0
                    CMP.B       #%000111,D0
                    BEQ         PRINT_NEXT_RTS
                    CMP.B       #%001111,D0
                    BEQ         CHECK_MOVE_W_PRINT_NEXT
                    BRA         PRINT_NEXT_RTS
                    
                    
IS_MOVE_W           MOVE.W      input,D0
                    ANDI.L      #iso_5_0,D0
                    CMP.B       #%111001,D0
                    BEQ         CHECK_MOVE_W_PRINT_NEXT
                    CMP.W       #$1228,D6    *birthday - just a marker for whether you're printing after comma
                    BEQ         IS_MOVE_W_2
                    BRA         PRINT_NEXT_RTS
                    
IS_MOVE_W_2         MOVE.W      input,D0
                    ANDI.L      #iso_11_6,D0
                    LSR         #6,D0
                    CMP.B       #%001111,D0
                    BEQ         CHECK_MOVE_W_PRINT_NEXT
                    BRA         PRINT_NEXT_RTS
                    
CHECK_MOVE_W_PRINT_NEXT
                    JSR         PRINT_NEXT_AGAIN
                    BRA         PRINT_NEXT_RTS
                    
PRINT_NEXT_DATA_2   MOVE.B      D1,D5           *store D1
                    JSR         PRINT_POUND
                    JSR         PRINT_DOLLAR
                    MOVE.W      (A0)+,D1  
                    MOVE.B      #3,D0          
                    TRAP        #15
                    CLR.L       D1
                    MOVE.B      D5,D1           *move data back into D1
                    
                    *Do we need to print the next word too? (Long data)
                    
                    MOVE.W      input,D0
                    *account for MOVE.L
                    ANDI.L      #iso_15_12,D0   *isolate bits 15-12         
                    LSR.W       #6,D0           *Shift 12 bits to the right
                    LSR.W       #6,D0
                    CMP.B       #%0010,D0
                    BEQ         PRINT_NEXT_AGAIN
                    
                    *account for everything else
                    CMP.B       #%001,D4
                    BEQ         PRINT_NEXT_AGAIN    *print next data, it's long
                    CMP.B       #%010,D2
                    BEQ         PRINT_NEXT_AGAIN    *print next data, it's long
                    CMP.B       #%110,D2
                    BEQ         PRINT_NEXT_AGAIN    *print next data, it's long
                    CMP.B       #%111,D2
                    BEQ         PRINT_NEXT_AGAIN    *print next data, it's long
                    
                    RTS
                    
PRINT_NEXT_DATA_NP  MOVE.B      D1,D5           *store D1
                    JSR         PRINT_DOLLAR
                    MOVE.W      (A0)+,D1  
                    MOVE.B      #3,D0          
                    TRAP        #15
                    CLR.L       D1
                    MOVE.B      D5,D1           *move data back into D1
                    
                    *Do we need to print the next word too? (Long data)
                    
                    MOVE.W      input,D0
                    *account for MOVE.L
                    ANDI.L      #iso_15_12,D0   *isolate bits 15-12         
                    LSR.W       #6,D0           *Shift 12 bits to the right
                    LSR.W       #6,D0
                    CMP.B       #%0010,D0
                    BEQ         PRINT_NEXT_AGAIN
                    
                    *account for everything else
                    CMP.B       #%001,D4
                    BEQ         PRINT_NEXT_AGAIN    *print next data, it's long
                    
                    RTS
                    
PRINT_NEXT_AGAIN    CLR         D0
                    CLR         D7
                    MOVE.B      D1,D5           *store D1
                    MOVE.W      (A0)+,D1  
                    
                    MOVE.B      #$4,D0          *This sets up counter for conversion
             
                    JSR         HEX_TO_STRING
                    
                    LEA         CLEAR_ADDRESS,A1       *clears out A1 before inputing value in it
                    MOVE.L      D7,(A1)+               *moves the ASCII into A1
                    MOVE.B      #NULL,(A1)+            *terminates the string with null byte
                    MOVE.L      #0,A1                  *resets A1 pointer
                    MOVE.B      #14,D0                 *prints out string
                    TRAP        #15

                    CLR.L       D1
                    MOVE.B      D5,D1           *move data back into D1
                    
                    RTS
                    
MARK_LONG_IMM       MOVE.W      #$1228,D6       *mark as long immediate data
                                                *1228 is my birthday

*----------------------------------------------------------------------------------

****************************************************************
                *Program output section*
****************************************************************                 
WELCOME DC.B    'Team Man Power',CR,LF,CR,LF                                      
        DC.B    ' _____ ______   ________  ________ ',CR,LF
        DC.B    '|\   _ \  _   \|\   __  \|\   ___  \ ',CR,LF
        DC.B    '\ \  \\\__\ \  \ \  \|\  \ \  \\ \  \',CR,LF
        DC.B    ' \ \  \\|__| \  \ \   __  \ \  \\ \  \ ',CR,LF
        DC.B    '  \ \  \    \ \  \ \  \ \  \ \  \\ \  \',CR,LF
        DC.B    '   \ \__\    \ \__\ \__\ \__\ \__\\ \__\   ',CR,LF
        DC.B    '    \|__|     \|__|\|__|\|__|\|__| \|__|  ',CR,LF
        DC.B    '                                               ',CR,LF
        DC.B    '                                               ',CR,LF
        DC.B    ' ________  ________  ___       __   _______   ________',CR,LF                                                   ',CR,LF
        DC.B    '|\   __  \|\   __  \|\  \     |\  \|\  ___ \ |\   __  \',CR,LF                                               ',CR,LF
        DC.B    '\ \  \|\  \ \  \|\  \ \  \    \ \  \ \   __/|\ \  \|\  \',CR,LF                                                 ',CR,LF
        DC.B    ' \ \   ____\ \  \\\  \ \  \  __\ \  \ \  \_|/_\ \   _  _\',CR,LF                                                ',CR,LF
        DC.B    '  \ \  \___|\ \  \\\  \ \  \|\__\_\  \ \  \_|\ \ \  \\  \|',CR,LF                                               ',CR,LF
        DC.B    '   \ \__\    \ \_______\ \____________\ \_______\ \__\\ _\',CR,LF                                               ',CR,LF
        DC.B    '    \|__|     \|_______|\|____________|\|_______|\|__|\|__|',CR,LF                                               ',CR,LF
        DC.B    '                                               ',CR,LF
        DC.B    '                                               ',CR,LF
        DC.B    '                                               ',CR,LF
        DC.B    '                                               ',CR,LF
        DC.B    '                                               ',CR,LF,0


        DC.B    'This disassembler converts a memory image of instructions',CR,LF
        DC.B    'and data back into 68k assembly language and outputs',CR,LF
        DC.B    'the disassembled code to the display.',CR,LF,0

STALOC  DC.B    CR,LF
        DC.B    'Enter the starting address in hexadecimal format (should be word length,',CR,LF
        DC.B    'greater than $6999, even, and contain no extra characters): ',CR,LF,0
 
ENDLOC  DC.B    CR,LF
        DC.B    'Enter the ending address in hexadecimal format (should be word length,',CR,LF
        DC.B    'no greater than $FFFF, even, and contain no extra characters): ',CR,LF,0

INVAL_A DC.B    CR,LF
        DC.B    'The address you entered was invalid. It must be even and between the values',CR,LF
        DC.B    '$7000 and $FFFF. The address must also be input into proper hex format',CR,LF
        DC.B    'with no lower case letters.',CR,LF,CR,LF,0
        
INVAL_A_2
        DC.B    CR,LF
        DC.B    'The starting address cannot be larger then the ending address.',CR,LF,CR,LF,0

RESTART DC.B    CR,LF
        DC.B    'If you would like to disassemble another memory image enter 1,',CR,LF
        DC.B    'otherwise enter any other input to exit the program.',CR,LF,0
        

*************************************************************** 
               
PRINT_LSR_B     LEA         print_lsr_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_lsr_b_m   DC.B        'LSR.B',0 

PRINT_LSR_W     LEA         print_lsr_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_lsr_w_m   DC.B        'LSR.W',0

PRINT_LSR_L     LEA         print_lsr_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_lsr_l_m   DC.B        'LSR.L',0  

*************************************************************** 
               
PRINT_LSL_B     LEA         print_lsl_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_lsl_b_m   DC.B        'LSL.B',0 

PRINT_LSL_W     LEA         print_lsl_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_lsl_w_m   DC.B        'LSL.W',0

PRINT_LSL_L     LEA         print_lsl_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_lsl_l_m   DC.B        'LSL.L',0  

*************************************************************** 
               
PRINT_ASR_B     LEA         print_asr_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_asr_b_m   DC.B        'ASR.B',0 

PRINT_ASR_W     LEA         print_asr_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_asr_w_m   DC.B        'ASR.W',0

PRINT_ASR_L     LEA         print_asr_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_asr_l_m   DC.B        'ASR.L',0  

*************************************************************** 
               
PRINT_ASL_B     LEA         print_asl_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_asl_b_m   DC.B        'ASL.B',0 

PRINT_ASL_W     LEA         print_asl_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_asl_w_m   DC.B        'ASL.W',0

PRINT_ASL_L     LEA         print_asl_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_asl_l_m   DC.B        'ASL.L',0  

*************************************************************** 
               
PRINT_ROR_B     LEA         print_ror_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_ror_b_m   DC.B        'ROR.B',0 

PRINT_ROR_W     LEA         print_ror_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_ror_w_m   DC.B        'ROR.W',0

PRINT_ROR_L     LEA         print_ror_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_ror_l_m   DC.B        'ROR.L',0  

***************************************************************

PRINT_ROL_B     LEA         print_rol_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_rol_b_m   DC.B        'ROL.B',0 

PRINT_ROL_W     LEA         print_rol_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_rol_w_m   DC.B        'ROL.W',0

PRINT_ROL_L     LEA         print_rol_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_reg_ea

print_rol_l_m   DC.B        'ROL.L',0  

***************************************************************

PRINT_0         LEA         print_0_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_0_m       DC.B        '0',0 

***************************************************************

PRINT_1         LEA         print_1_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_1_m       DC.B        '1',0 

***************************************************************

PRINT_2         LEA         print_2_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_2_m       DC.B        '2',0 

***************************************************************

PRINT_3         LEA         print_3_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_3_m       DC.B        '3',0 

***************************************************************

PRINT_4         LEA         print_4_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_4_m       DC.B        '4',0 

***************************************************************

PRINT_5         LEA         print_5_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_5_m       DC.B        '5',0 

***************************************************************

PRINT_6         LEA         print_6_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_6_m       DC.B        '6',0 

***************************************************************

PRINT_7         LEA         print_7_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_7_m       DC.B        '7',0 

***************************************************************

PRINT_8         LEA         print_8_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_8_m       DC.B        '8',0 

***************************************************************

PRINT_D         LEA         print_D_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_D_m       DC.B        'D',0 

***************************************************************

PRINT_A         LEA         print_A_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_A_m       DC.B        'A',0 

***************************************************************

PRINT_AI        LEA         print_AI_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_REG
                
                LEA         print_AI_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_AI_m      DC.B        '(A',0 
print_AI_m2     DC.B        ')',0 

***************************************************************

PRINT_AI_D4     LEA         print_AI_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                *JSR         PRINT_REG
                MOVE.L      D1, temprace
                MOVE.B      D4, D1
                Move.B      #3, D0
                TRAP        #15
                MOVE.L      temprace,D1
                
                LEA         print_AI_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

***************************************************************

PRINT_AII       LEA         print_AII_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_REG
                
                LEA         print_AII_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_AII_m     DC.B        '(A',0
print_AII_m2    DC.B        ')+',0 

***************************************************************

PRINT_AID       LEA         print_AID_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_REG
                
                LEA         print_AID_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_AID_m     DC.B        '-(A',0 
print_AID_m2    DC.B        ')',0 

***************************************************************

PRINT_A7_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_15,D7
                CMP.L       #$8000,D7
                BEQ         PRINT_A7
                RTS
                
PRINT_A7        LEA         print_A7_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_A7_m      DC.B        'A7',0 

***************************************************************

PRINT_A6_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_14,D7
                CMP.L       #$4000,D7
                BEQ         PRINT_A6
                RTS
                
PRINT_A6        LEA         print_A6_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_A6_m      DC.B        'A6',0 

***************************************************************

PRINT_A5_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_13,D7
                CMP.L       #$2000,D7
                BEQ         PRINT_A5
                RTS
                
PRINT_A5        LEA         print_A5_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_A5_m      DC.B        'A5',0 
                
***************************************************************

PRINT_A4_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_12,D7
                CMP.L       #$1000,D7
                BEQ         PRINT_A4
                RTS
                
PRINT_A4        LEA         print_A4_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                    
                RTS

print_A4_m      DC.B        'A4',0 

***************************************************************

PRINT_A3_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_11,D7
                CMP.L       #$0800,D7
                BEQ         PRINT_A3
                RTS
                
PRINT_A3        LEA         print_A3_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_A3_m      DC.B        'A3',0 

***************************************************************

PRINT_A2_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_10,D7
                CMP.L       #$0400,D7
                BEQ         PRINT_A2
                RTS
                
PRINT_A2        LEA         print_A2_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_A2_m      DC.B        'A2',0 

***************************************************************

PRINT_A1_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_9,D7
                CMP.L       #$0200,D7
                BEQ         PRINT_A1
                RTS
                
PRINT_A1        LEA         print_A1_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_A1_m      DC.B        'A1',0 

***************************************************************

PRINT_A0_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_8,D7
                CMP.L       #$0100,D7
                BEQ         PRINT_A0
                RTS
                
PRINT_A0        LEA         print_A0_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_A0_m      DC.B        'A0',0 

***************************************************************

PRINT_D7_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_7,D7
                CMP.L       #$0080,D7
                BEQ         PRINT_D7
                RTS
                
PRINT_D7        LEA         print_D7_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D7_m      DC.B        'D7',0 

***************************************************************

PRINT_D6_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_6,D7
                CMP.L       #$0040,D7
                BEQ         PRINT_D6
                RTS
                
PRINT_D6        LEA         print_D6_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D6_m      DC.B        'D6',0 

***************************************************************

PRINT_D5_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_5,D7
                CMP.L       #$0020,D7
                BEQ         PRINT_D5
                RTS
                
PRINT_D5        LEA         print_D5_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D5_m      DC.B        'D5',0 

***************************************************************

PRINT_D4_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_4,D7
                CMP.L       #$0010,D7
                BEQ         PRINT_D4
                RTS
                
PRINT_D4        LEA         print_D4_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D4_m      DC.B        'D4',0 

***************************************************************

PRINT_D3_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_3,D7
                CMP.L       #$0008,D7
                BEQ         PRINT_D3
                RTS
                
PRINT_D3        LEA         print_D3_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D3_m      DC.B        'D3',0 

***************************************************************

PRINT_D2_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_2,D7
                CMP.L       #$0004,D7
                BEQ         PRINT_D2
                RTS
                
PRINT_D2        LEA         print_D2_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D2_m      DC.B        'D2',0 

***************************************************************

PRINT_D1_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_1,D7
                CMP.L       #$0002,D7
                BEQ         PRINT_D1
                RTS
                
PRINT_D1        LEA         print_D1_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D1_m      DC.B        'D1',0 

***************************************************************

PRINT_D0_CHECK  MOVE.W      movem1,D7
                ANDI.L      #iso_0,D7
                CMP.L       #$0001,D7
                BEQ         PRINT_D0
                RTS
                
PRINT_D0        LEA         print_D0_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                JSR         PRINT_SLASH
                
                RTS

print_D0_m      DC.B        'D0',0

***************************************************************

PRINT_ADDR_MODE_NR      LEA         print_addr_mode_nr_m,A1      
                        MOVE.B      #14,D0          
                        TRAP        #15
                
                        RTS

print_addr_mode_nr_m    DC.B        'Addressing Mode not required',0 

***************************************************************

PRINT_X         LEA         print_X_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_X_m       DC.B        'X',0 

*************************************************************** 

PRINT_AI_EA     LEA         print_AI_EA_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_EA_REG
                
                LEA         print_AI_EA_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_AI_EA_m   DC.B        '(A',0 
print_AI_EA_m2  DC.B        ')',0 

***************************************************************

PRINT_AI_EA_1   LEA         print_AI_EA1_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_EA_REG
                
                LEA         print_AI_EA1_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0100_mr_1

print_AI_EA1_m  DC.B        '(A',0 
print_AI_EA1_m2 DC.B        ')',0 

***************************************************************

PRINT_AII_EA    LEA         print_AII_EA_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_EA_REG
                
                LEA         print_AII_EA_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_AII_EA_m  DC.B        '(A',0
print_AII_EA_m2 DC.B        ')+',0 

***************************************************************

PRINT_AII_EA_1  LEA         print_AII_EA1_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_EA_REG
                
                LEA         print_AII_EA1_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0100_mr_1

print_AII_EA1_m  DC.B        '(A',0
print_AII_EA1_m2 DC.B        ')+',0 

***************************************************************
      
PRINT_AID_EA    LEA         print_AID_EA_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_EA_REG
                
                LEA         print_AID_EA_m2,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_AID_EA_m  DC.B        '-(A',0 
print_AID_EA_m2 DC.B        ')',0 

***************************************************************

PRINT_X_EA      LEA         print_X_EA_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

print_X_EA_m    DC.B        'X',0 

***************************************************************

PRINT_ADDA_W    LEA         print_adda_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_adda

print_adda_w_m  DC.B        'ADDA.W',0 
                
PRINT_ADDA_L    LEA         print_adda_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_adda_l

print_adda_l_m  DC.B        'ADDA.L',0 

**************************************************
                
PRINT_ADD_B     LEA         print_add_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_add
                
print_add_b_m   DC.B        'ADD.B',0

PRINT_ADD_W     LEA         print_add_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_add
                
print_add_w_m   DC.B        'ADD.W',0

PRINT_ADD_L     LEA         print_add_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_add
                
print_add_l_m   DC.B        'ADD.L',0

********************************************

PRINT_EOR_B     LEA         print_eor_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_eor
                
print_eor_b_m   DC.B        'EOR.B',0

PRINT_EOR_W     LEA         print_eor_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_eor
                
print_eor_w_m   DC.B        'EOR.W',0

PRINT_EOR_L     LEA         print_eor_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_eor
                
print_eor_l_m   DC.B        'EOR.L',0

**********************************************

PRINT_CMP_B     LEA         print_cmp_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_cmp
                
print_cmp_b_m   DC.B        'CMP.B',0

PRINT_CMP_W     LEA         print_cmp_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_cmp
                
print_cmp_w_m   DC.B        'CMP.W',0

PRINT_CMP_L     LEA         print_cmp_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_cmp
                
print_cmp_l_m   DC.B        'CMP.L',0

*********************************************

PRINT_CMPA_W    LEA         print_cmpa_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_cmpa
                
print_cmpa_w_m  DC.B       'CMPA.W',0

PRINT_CMPA_L    LEA         print_cmpa_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1011_cmpa
                
print_cmpa_l_m  DC.B        'CMPA.L',0

**********************************************

PRINT_AND_B     LEA         print_and_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1100_cont
                
print_and_b_m   DC.B        'AND.B',0

PRINT_AND_W     LEA         print_and_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1100_cont
                
print_and_w_m   DC.B        'AND.W',0

PRINT_AND_L     LEA         print_and_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1100_cont
                
print_and_l_m   DC.B        'AND.L',0     

************************************************

PRINT_ADDQ_B    LEA         print_addq_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0101_cont
                
print_addq_b_m  DC.B        'ADDQ.B',0

PRINT_ADDQ_W    LEA         print_addq_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0101_cont
                
print_addq_w_m  DC.B        'ADDQ.W',0

PRINT_ADDQ_L    LEA         print_addq_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0101_cont
                
print_addq_l_m  DC.B        'ADDQ.L',0    

************************************************

PRINT_EORI_B	LEA     	print_eori_b_m,A1 	 
            	MOVE.B  	#14,D0     	 
            	TRAP    	#15
           	 
            	BRA     	code0000_andi_cont
          	 
print_eori_b_m  DC.B    	'EORI.B',0

PRINT_EORI_W	LEA     	print_eori_w_m,A1 	 
            	MOVE.B  	#14,D0     	 
            	TRAP    	#15
           	 
            	BRA     	code0000_andi_cont
           	 
print_eori_w_m  DC.B    	'EORI.W',0

PRINT_EORI_L	LEA     	print_eori_l_m,A1 	 
            	MOVE.B  	#14,D0     	 
            	TRAP    	#15
           	 
            	BRA     	code0000_andi_l_cont
           	 
print_eori_l_m  DC.B    	'EORI.L',0  

************************************************

PRINT_SUBI_B    LEA         print_subi_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi
                
print_subi_b_m  DC.B        'SUBI.B',0

PRINT_SUBI_W    LEA         print_subi_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi
                
print_subi_w_m  DC.B        'SUBI.W',0

PRINT_SUBI_L    LEA         print_subi_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi_l
                
print_subi_l_m  DC.B        'SUBI.L',0  

************************************************

PRINT_CMPI_B    LEA         print_cmpi_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi
                
print_cmpi_b_m  DC.B        'CMPI.B',0

PRINT_CMPI_W    LEA         print_cmpi_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi
                
print_cmpi_w_m  DC.B        'CMPI.W',0

PRINT_CMPI_L    LEA         print_cmpi_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi_l
                
print_cmpi_l_m  DC.B        'CMPI.L',0  

************************************************
PRINT_ADDI_B    LEA         print_addi_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi
                
print_addi_b_m  DC.B        'ADDI.B',0

PRINT_ADDI_W    LEA         print_addi_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi
                
print_addi_w_m  DC.B        'ADDI.W',0

PRINT_ADDI_L    LEA         print_addi_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_addi_l
                
print_addi_l_m  DC.B        'ADDI.L',0  

************************************************

************************************************

PRINT_ANDI_B    LEA         print_andi_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_andi_cont
                
print_andi_b_m  DC.B        'ANDI.B',0

PRINT_ANDI_W    LEA         print_andi_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_andi_cont
                
print_andi_w_m  DC.B        'ANDI.W',0

PRINT_ANDI_L    LEA         print_andi_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0000_andi_l_cont
                
print_andi_l_m  DC.B        'ANDI.L',0  

************************************************

PRINT_SUBA_W    LEA         print_suba_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_adda
                
print_suba_w_m  DC.B       'SUBA.W',0

PRINT_SUBA_L    LEA         print_suba_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_adda_l
                
print_suba_l_m  DC.B        'SUBA.L',0   

************************************************

PRINT_SUB_B     LEA         print_sub_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_add
                
print_sub_b_m   DC.B        'SUB.B',0

PRINT_SUB_W     LEA         print_sub_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_add
                
print_sub_w_m   DC.B        'SUB.W',0

PRINT_SUB_L     LEA         print_sub_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1101_add
                
print_sub_l_m   DC.B        'SUB.L',0

************************************************

PRINT_MOVE_B    LEA         print_move_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
print_move_b_m  DC.B        'MOVE.B',0

PRINT_MOVE_W    LEA         print_move_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
print_move_w_m  DC.B        'MOVE.W',0

PRINT_MOVE_L    LEA         print_move_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
print_move_l_m  DC.B        'MOVE.L',0

************************************************

PRINT_MULS_W    LEA         print_muls_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1100_muls
                
print_muls_w_m  DC.B        'MULS.W',0

************************************************

PRINT_DIVS_W    LEA         print_divs_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1000_cont
                
print_divs_w_m  DC.B        'DIVS.W',0

************************************************
PRINT_LSR_MEM   LEA         print_lsr_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
PRINT_LSR       LEA         print_lsr_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_cont
                
print_lsr_m     DC.B        'LSR',0

************************************************
PRINT_LSL_MEM   LEA         print_lsl_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
PRINT_LSL       LEA         print_lsl_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_cont
                
print_lsl_m     DC.B        'LSL',0

************************************************
PRINT_ASL_MEM   LEA         print_asl_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

PRINT_ASL       LEA         print_asl_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_cont
                
print_asl_m     DC.B        'ASL',0

************************************************
PRINT_ASR_MEM   LEA         print_asr_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
PRINT_ASR       LEA         print_asr_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_cont
                
print_asr_m     DC.B        'ASR',0

************************************************
PRINT_ROL_MEM   LEA         print_rol_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
PRINT_ROL       LEA         print_rol_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_cont
                
print_rol_m     DC.B        'ROL',0

************************************************
PRINT_ROR_MEM   LEA         print_ror_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
PRINT_ROR       LEA         print_ror_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code1110_cont
                
print_ror_m     DC.B        'ROR',0

************************************************

PRINT_MOVEQ     LEA         print_moveq_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0111_cont
                
print_moveq_m   DC.B        'MOVEQ',0

************************************************

PRINT_BCHG_REG      LEA         print_bchg_reg_m,A1      
                    MOVE.B      #14,D0          
                    TRAP        #15
                    
                    BRA         BCHG_REG_EA
                
print_bchg_reg_m    DC.B        'BCHG',0

************************************************

PRINT_BCHG_IMM      LEA         print_bchg_imm_m,A1      
                    MOVE.B      #14,D0          
                    TRAP        #15
                    
                    BRA         BCHG_IMM_EA
                
print_bchg_imm_m    DC.B        'BCHG',0

************************************************

PRINT_BCC       LEA         print_bcc_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bcc_m     DC.B        'BCC',0

*************************************************

PRINT_BCS       LEA         print_bcs_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bcs_m     DC.B        'BCS',0

*************************************************

PRINT_BEQ       LEA         print_beq_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_beq_m     DC.B        'BEQ',0

*************************************************

PRINT_BGE       LEA         print_bge_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bge_m     DC.B        'BGE',0

*************************************************

PRINT_BGT       LEA         print_bgt_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bgt_m     DC.B        'BGT',0

*************************************************

PRINT_BHI       LEA         print_bhi_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bhi_m     DC.B        'BHI',0

*************************************************

PRINT_BLE       LEA         print_ble_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_ble_m     DC.B        'BLE',0

*************************************************

PRINT_BLS       LEA         print_bls_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bls_m     DC.B        'BLS',0

*************************************************

PRINT_BLT       LEA         print_blt_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_blt_m     DC.B        'BLT',0

*************************************************

PRINT_BMI       LEA         print_bmi_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bmi_m     DC.B        'BMI',0

**************************************************

PRINT_BNE       LEA         print_bne_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bne_m     DC.B        'BNE',0

**************************************************

PRINT_BPL       LEA         print_bpl_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bpl_m     DC.B        'BPL',0

**************************************************

PRINT_BRA       LEA         print_bra_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bra_m     DC.B        'BRA',0

**************************************************

PRINT_BVC       LEA         print_bvc_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bvc_m     DC.B        'BVC',0

**************************************************

PRINT_BVS       LEA         print_bvs_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0110_cont
                
print_bvs_m     DC.B        'BVS',0

**************************************************

PRINT_RTS       LEA         print_rts_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
print_rts_m     DC.B        'RTS',0


PRINT_JSR       LEA         print_jsr_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0100_jsr
                
print_jsr_m     DC.B        'JSR',0

PRINT_CLR_B     LEA         print_clr_b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0100_clr
                
print_clr_b_m   DC.B        'CLR.B',0

PRINT_CLR_W     LEA         print_clr_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0100_clr
                
print_clr_w_m   DC.B        'CLR.W',0

PRINT_CLR_L     LEA         print_clr_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                BRA         code0100_clr
                
print_clr_l_m   DC.B        'CLR.L',0

PRINT_LEA       LEA         print_lea_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_LEA_EA
                
                RTS
                
print_lea_m     DC.B        'LEA',0

PRINT_MOVEM_W   LEA         print_movem_w_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                        
                BRA         code0100_cont
                
print_movem_w_m DC.B        'MOVEM.W',0

PRINT_MOVEM_L   LEA         print_movem_l_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                        
                BRA         code0100_cont
                
print_movem_l_m DC.B        'MOVEM.L',0

**************************************************
                
PRINT_16B       LEA         print_16b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
print_16b_m     DC.B        ' 16-bit displacement goes here',0

**************************************************

PRINT_32B       LEA         print_32b_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS
                
print_32b_m     DC.B        ' 32-bit displacement goes here',0

************************************************

INVALID_MC      LEA         invalid_mc_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                RTS

invalid_mc_m    DC.B        'Error: invalid machine code',0

***************************************************************

INVALID_MC_1    LEA         invalid_mc_1_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_RETURN
                
                BRA         LOOP

invalid_mc_1_m  DC.B        'Error: invalid machine code',0

***************************************************************

NOT_REQUIRED    LEA         not_required_m,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                
                JSR         PRINT_RETURN
                
                BRA         LOOP

not_required_m  DC.B        'Addressing mode not required',0

***************************************************************

PRINT_RETURN    LEA         print_return_m,A1
                MOVE.B      #14,D0
                TRAP        #15

                RTS

print_return_m  DC.B        '',CR,LF,0

PRINT_SPACE     LEA         print_space_m,A1
                MOVE.B      #14,D0
                TRAP        #15

                RTS

print_space_m   DC.B        '',TAB,0

PRINT_COMMA     LEA         print_comma_m,A1
                MOVE.B      #14,D0
                TRAP        #15

                RTS

print_comma_m   DC.B        ',',0


PRINT_POUND     LEA         print_pound_m,A1
                MOVE.B      #14,D0
                TRAP        #15

                RTS

print_pound_m   DC.B        '#',0


PRINT_DOLLAR    LEA         print_dollar_m,A1
                MOVE.B      #14,D0
                TRAP        #15

                RTS

print_dollar_m  DC.B        '$',0

PRINT_L_BRACKET LEA         print_l_bracket_m,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS
print_l_bracket_m   DC.B        '<',0
PRINT_R_BRACKET LEA         print_r_bracket_m,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS
print_r_bracket_m   DC.B        '>',0
PRINT_L_PAREN   LEA         print_l_paren_m,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS
print_l_paren_m DC.B        '(',0
PRINT_R_PAREN   LEA         print_r_paren_m,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS
print_r_paren_m DC.B        ')',0

PRINT_ZEROS     LEA         print_address_zeros,A1
                MOVE.B      #14,D0
                TRAP        #15

                RTS

print_address_zeros DC.B        '0000',0

PRINT_PLUS      LEA         print_plus_m,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS
print_plus_m    DC.B        '+',0

PRINT_MINUS     LEA         print_minus_m,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS
print_minus_m   DC.B        '-',0

PRINT_SLASH     LEA         print_slash_m,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS
                
print_slash_m   DC.B        '/',0

***************************************************************
PRINT_LINE_MESSAGE
                LEA         line_message,A1      
                MOVE.B      #14,D0          
                TRAP        #15
                RTS
                
line_message    DC.B    'Input [Enter] to continue or [Space] to exit',CR,LF,0

***************************************************************

START_ADDRESS_HEX   DS.L    1
END_ADDRESS_HEX     DS.L    1 
input               DS.W    1
temprace            DS.W    1
BCC_INITIAL_ADDRESS DS.W    1   *stores initial address for branch command for displacement
movem0              DS.W    1
movem1              DS.W    1
movem2              DS.W    1
movem3              DS.W    1
                
****************************************************************

*** Test Code ***--------------------------------------------------------------------

TEST_CODE       
                MOVE.W      #%0000111101011000,(A0)+    *BCHG (specified in a register)
                MOVE.W      #%0000100001011000,(A0)+    *BCHG (specified as imm. data)
                MOVE.W      #%0000000000000111,(A0)+

                MOVE.W      #%0001111000010000,(A0)+    *MOVE.B
                MOVE.W      #%0011111000010000,(A0)+    *MOVE.W
                MOVE.W      #%0010111000111000,(A0)+    *MOVE.L
                MOVE.W      #$D321,(A0)+
                MOVE.W      #$4325,(A0)+

                MOVE.W      #%0111000001010101,(A0)+    *MOVEQ

                MOVE.W      #%0100100010010000,(A0)+    *MOVEM (reg->mem word)
                MOVE.W      #%0010001000001000,(A0)+
                MOVE.W      #%0100100011100000,(A0)+    *MOVEM (reg->mem long)
                MOVE.W      #%0010000000000001,(A0)+
                MOVE.W      #%0100110010010000,(A0)+    *MOVEM (mem->reg word)
                MOVE.W      #%1000000010000000,(A0)+
                MOVE.W      #%0100110011100000,(A0)+    *MOVEM (mem->reg long)
                MOVE.W      #%0100001000000001,(A0)+
                
                MOVE.W      #%1101111000111111,(A0)+    *ADD.B (ea + dn -> dn)
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%1101111100001111,(A0)+    *ADD.B (dn + ea -> ea)
                
                MOVE.W      #%1101111001111111,(A0)+    *ADD.W (ea + dn -> dn)
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%1101111101000111,(A0)+    *ADD.W (dn + ea -> ea) 
                
                MOVE.W      #%1101111010111111,(A0)+    *ADD.L (ea + dn -> dn)
                MOVE.W      #$3956,(A0)+
                MOVE.W      #$1989,(A0)+
                MOVE.W      #%1101111110010111,(A0)+    *ADD.L (dn + ea -> ea) 
                
                MOVE.W      #%1101111011111111,(A0)+    *ADDA.W
                MOVE.W      #%1101111111101111,(A0)+    *ADDA.L *invalid

                MOVE.W      #%0101000000111000,(A0)+    *ADDQ.B
                MOVE.W      #%0101000001111000,(A0)+    *ADDQ.W
                MOVE.W      #%0101000010111000,(A0)+    *ADDQ.L

                MOVE.W      #%1001011100011000,(A0)+    *SUB.B
                MOVE.W      #%1001011101011000,(A0)+    *SUB.W
                MOVE.W      #%1001011110011000,(A0)+    *SUB.L

                MOVE.W      #%1001011011000000,(A0)+    *SUBA.W
                MOVE.W      #%1001011111000000,(A0)+    *SUBA.L

                MOVE.W      #%0000010000111000,(A0)+    *SUBI.B
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000010001111000,(A0)+    *SUBI.W
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000010010111000,(A0)+    *SUBI.L
                MOVE.W      #$D321,(A0)+
                MOVE.W      #$4325,(A0)+

                MOVE.W      #%1100100111111111,(A0)+    *MULS.W <- .L not part of 68k

                MOVE.W      #%1000000111111000,(A0)+    *DIVS.W <- .L not part of 68k

                MOVE.W      #%0100000111111001,(A0)+    *LEA
                MOVE.W      #$D321,(A0)+
                MOVE.W      #$4325,(A0)+

                MOVE.W      #%0100001000111000,(A0)+    *CLR.B
                MOVE.W      #%0100001001111000,(A0)+    *CLR.W
                MOVE.W      #%0100001010111000,(A0)+    *CLR.L

                MOVE.W      #%1100000000111000,(A0)+    *AND.B ea AND Dn -> Dn
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%1100000100111000,(A0)+    *AND.B Dn AND ea -> ea
                MOVE.W      #%1100000001111000,(A0)+    *AND.W ea AND Dn -> Dn
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%1100000101111000,(A0)+    *AND.W Dn AND ea -> ea
                MOVE.W      #%1100000010111000,(A0)+    *AND.L ea AND Dn -> Dn
                MOVE.W      #%1100000110111000,(A0)+    *AND.L Dn AND ea -> ea

                MOVE.W      #%0000001000111000,(A0)+    *ANDI.B
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000001001111000,(A0)+    *ANDI.W
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000001010111000,(A0)+    *ANDI.L
                MOVE.W      #$D321,(A0)+
                MOVE.W      #$4325,(A0)+

                MOVE.W      #%1011010100001000,(A0)+    *EOR.B
                MOVE.W      #%1011010101000000,(A0)+    *EOR.W
                MOVE.W      #%1011010110010000,(A0)+    *EOR.L

                MOVE.W      #%0000101000111000,(A0)+    *EORI.B
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000101001111000,(A0)+    *EORI.W
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000101010111000,(A0)+    *EORI.L
                MOVE.W      #$D321,(A0)+
                MOVE.W      #$4325,(A0)+

                MOVE.W      #%1011111000111000,(A0)+    *CMP.B
                MOVE.W      #%1011111001111000,(A0)+    *CMP.W
                MOVE.W      #%1011111010111000,(A0)+    *CMP.L
                

                MOVE.W      #%1011000011111000,(A0)+    *CMPA.W
                MOVE.W      #%1011000011001000,(A0)+    *CMPA.L

                MOVE.W      #%0000110000111000,(A0)+    *CMPI.B
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000110001111000,(A0)+    *CMPI.W
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%0000110010111000,(A0)+    *CMPI.L
                MOVE.W      #$D321,(A0)+

                MOVE.W      #%0110000100000001,(A0)+    *BCC
                MOVE.W      #%0110001000000001,(A0)+    *BCS
                MOVE.W      #%0110001100000001,(A0)+    *BEQ

                MOVE.W      #%0110010000000001,(A0)+    *BGE
                MOVE.W      #%0110010100000001,(A0)+    *BGT
                MOVE.W      #%0110011000000001,(A0)+    *BHI
                MOVE.W      #%0110011100000001,(A0)+    *BLE

                MOVE.W      #%0110100000000001,(A0)+    *BLS
                MOVE.W      #%0110100100000001,(A0)+    *BLT
                MOVE.W      #%0110101000000001,(A0)+    *BMI
                MOVE.W      #%0110101100000001,(A0)+    *BNE

                MOVE.W      #%0110110000000001,(A0)+    *BPL
                MOVE.W      #%0110110100000001,(A0)+    *BVC
                MOVE.W      #%0110111000000001,(A0)+    *BVS

                MOVE.W      #%0100111010111000,(A0)+    *JSR

                MOVE.W      #%0100111001110101,(A0)+    *RTS
                
                MOVE.W      #%1110001011010000,(A0)+    *LSR memory shift
                MOVE.W      #%1110001111010000,(A0)+    *LSL memory shift
                MOVE.W      #$D321,(A0)+
                MOVE.W      #%1110000011010001,(A0)+    *ASR memory shift
                MOVE.W      #%1110000111010001,(A0)+    *ASL memory shift
                MOVE.W      #$D321,(A0)+
                MOVE.W      #$4325,(A0)+
                MOVE.W      #%1110011011011011,(A0)+    *ROR memory shift
                MOVE.W      #%1110011111011011,(A0)+    *ROL memory shift
                MOVE.W      #$D321,(A0)+
                
                MOVE.W      #%1110000101111001,(A0)+    *ROL.B register shift (Dn->Dn)
                MOVE.W      #%1110001001111001,(A0)+    *ROR.B register shift (Dn->Dn)
                MOVE.W      #%1110110101100001,(A0)+    *ASL.B register shift (Dn->Dn)
                MOVE.W      #%1110000001100001,(A0)+    *ASR.B register shift (Dn->Dn)
                MOVE.W      #%1110010101101001,(A0)+    *LSL.B register shift (Dn->Dn)
                MOVE.W      #%1110000001101001,(A0)+    *LSR.B register shift (Dn->Dn)
                
                MOVE.W      #%1110000101011001,(A0)+    *ROL.B register shift 
                MOVE.W      #%1110010001011001,(A0)+    *ROR.B register shift 
                MOVE.W      #%1110100101000001,(A0)+    *ASL.B register shift 
                MOVE.W      #%1110000101000001,(A0)+    *ASR.B register shift 
                MOVE.W      #%1110000101001001,(A0)+    *LSL.B register shift 
                MOVE.W      #%1110111001001001,(A0)+    *LSR.B register shift 

***miscellaneous invalids

                MOVE.W      #%1010000000000000,(A0)+    *invalid
                MOVE.W      #%1101111100111111,(A0)+    *ADD.B (dn + ea -> ea) *invalid
                MOVE.W      #%0110000000000001,(A0)+    *invalid
                MOVE.W      #%0110111100000001,(A0)+    *invalid
                MOVE.W      #%1101111101111111,(A0)+    *ADD.W (dn + ea -> ea) *invalid
                MOVE.W      #%1101111110111111,(A0)+    *ADD.L (dn + ea -> ea) *invalid
                
                RTS
        
*--------------------------------------------------------------------------  

                END         START        
                
             











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
