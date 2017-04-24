ORG 00H
MOV TMOD, #20H					;timer 1 mode 2
MOV P1,#00000000B        				;make p1 output port
MOV P2,#00000000B        				;make p0 output port
CLR P3.5                					;set output for sending trigger
SETB P3.2               					;set input for receiving echo
SETB P0.7 						;buzzer off
MOV A, #38H            				;lcd command: 2lines and 5x7 matrix
ACALL COMND					;call comnd function
ACALL DELAY8					;call delay8 function
MOV A, #0CH					;lcd command: display on cursor off
ACALL COMND					;call comnd function
ACALL DELAY8					;call delay8 function
MOV A, #01H					;lcd command: clear display screen
ACALL COMND					;call comnd function
ACALL DELAY9					;call delay9 function
MOV A, #06H					;lcd command: shift display right
ACALL COMND					;call comnd function
ACALL DELAY8					;call function delay8
MOV A, #80H					;display on 1st position of 1st line
ACALL COMND					;call comnd function
ACALL DELAY8					;call delay8 function
MOV A,#'D'           					;write D
ACALL DATWR					;call datwr function
ACALL DELAY8           				;call delay8 function
MOV A,#81H            					;display on 2nd position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8           				;call delay8 function
MOV A,#'I' 						;write I           
ACALL DATWR					;call datwr function
ACALL DELAY8           				;call delay8 function
MOV A,#82H              				;display on 3rd position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8           				;call delay8 function
MOV A,#'S'              					;write S
ACALL DATWR					;call datwr function
ACALL DELAY8    					;call delay8 function
MOV A,#83H						;display on 4th position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8    					;call delay8 function
MOV A,#'T'              					; write T
ACALL DATWR					;call datwr
ACALL DELAY8    					;call delay8
MOV A,#84H           					;display on 5th position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8    					;call delay8 function
MOV A,#'A'              					;write A
ACALL DATWR					;call datwr function
ACALL DELAY8     					;call delay8 function
MOV A,#85H            					;display on 6th position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8     					;call delay8 function
MOV A,#'N'              					;write N
ACALL DATWR					;call datwr function
ACALL DELAY8     					;call delay8 function
MOV A,#86H            					;display on 7th position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8        				;call delay8 function
MOV A,#'C'              					;write C
ACALL DATWR   					;call datwr function
ACALL DELAY8    					;call delay8 function
MOV A,#87H           					;display on 8th position 1st line
ACALL COMND     					;call comnd function
ACALL DELAY8					;call delay8 function
MOV A, #'E'						;write E
ACALL DATWR					;call datwr function
ACALL DELAY8					;call delay8 function
MOV A, #88H					;display on 9th position 1st line
ACALL COMND 					;call comnd function
ACALL DELAY8					;call delay8 function
MOV A, #':'						;write :
ACALL DATWR					;call datwr function
ACALL DELAY8					;call delay8 function
MOV A, #8CH					;display on 13th position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8					;call delay8 function
MOV A, #'c'						;write c
ACALL DATWR					;call datwr function
ACALL DELAY8					;call delay8 function
MOV A, #8DH					;display on 14th position 1st line
ACALL COMND					;call comnd function
ACALL DELAY8					;call delay8 function
MOV A, #'m'						;write m					
ACALL DATWR					;call datwr function
ACALL DELAY8					;call delay8 function
MAIN: 
      MOV TL1,#207D    			;loads the initial value to start counting from
      MOV TH1,#207D    			;loads the reload value
      MOV A,#00000000B 			;clears accumulator
      SETB P3.5				;starts the trigger pulse
      ACALL DELAY1     			;gives 10us width for the trigger pulse
      CLR P3.5         				;ends the trigger pulse
HERE: 
      JNB P3.2,HERE    			;loops here until echo is received
 BACK: 
      SETB TR1        				;starts the timer1
HERE1: 
      JNB TF1,HERE1   			;loops here until timer overflows (ie;48 count)
      CLR TR1          				;stops the timer
      CLR TF1          				;clears timer flag 1
      INC A            				;increments a for every timer1 overflow
      JB P3.2,BACK     				;jumps to back if echo is still available
      MOV R4,A    				;saves the value of a to r4
      SUBB A, #10				;check danger level
      JB C, RED					;jump if distance less than 10cm
      JNB C, GREEN 				;jump if distance greater than 10cm
 WWE:		
      CLR C 
      ACALL DLOOP     			;calls the display loop
      SJMP MAIN        				;jumps to main loop
RED:
     CLR P0.3					;switch off safe light
     SETB P0.1 				;turn on danger light
     CLR P0.7 					;buzzer on
     ACALL DELAY1				;call delay1 function
     ACALL DELAY1				;call delay1 function
     SETB P0.7  				;buzzer off
     SJMP WWE				;jump back to WWE

GREEN:
    CLR P0.1					;turn off danger light
    SETB P0.3 					;turn on safe light
    SJMP WWE				;jump back to WWE
 
DELAY1:					;function DELAY1
    MOV R6,#2D 				;10us delay
 LABEL1: 
    DJNZ R6,LABEL1				;loop on r6
    RET 					;return to calling function    
   ACALL CONV   			;convert received hex to ascii
   MOV A, #89H  			;1st digit position
   ACALL COMND			;call comnd function
   ACALL DELAY8			;call delay8 function
   MOV A, R0    			;100th place in r0
   ACALL DATWR			;call datwr function
   ACALL DELAY8			call delay8 function
   MOV A, #8AH    			;2nd digit position
   ACALL COMND			;call comnd function
   ACALL DELAY8			;call delay8 function
   MOV A, R1  			;10th place in r1
   ACALL DATWR			;call datwr function
   ACALL DELAY8			;call delay8 function
   MOV A, #8BH    			;3rd digit position
   ACALL COMND			;call comnd function
   ACALL DELAY8			;call delay8 function
   MOV A, R2 			            ;1s digit stored in r2
   ACALL DATWR 			;call datwr function
   ACALL DELAY8			;call delay8 function
   RET 					;return to calling function
COMND:
   MOV P2,A				;send data to data port P2
   CLR P1.0				;select command register RS=0
   CLR P1.1				;write WR=0
   SETB P1.2				;start pulse E=1
   NOP					;1micro second
   NOP					;1 micro second
   CLR P1.2				;end pulse E=0
   RET					;return to calling function
DATWR:
   MOV P2,A				;send data to data port P2
   SETB P1.0				;select data register RS=1
   CLR P1.1				;write WR=0
   SETB P1.2				;start pulse E=1
   NOP					;1micro second
   NOP					;1micro second
   CLR P1.2				;end pulse E=0
   RET					;return to calling function

DELAY8:
   MOV R0,#41			;41 count
HELLO:
   DJNZ R0,HELLO			;loop
   RET
DELAY9:
   MOV R0,#41		 	;41 outer count
   HELLO1: MOV R1,#42		;42 inner count
   HELLO2: DJNZ R1,HELLO2	;inner loop
   DJNZ R0,HELLO1			;outer loop
   RET					;return to calling function
       
CONV: 
   MOV R0,#30H			;100s position
   MOV R1,#30H			;10s position
   MOV R2,#30H			;1s position
   CJNE R4,#00H,C1_HEXTOBCD  ;check if number is 0 if not then continue
   RET
C1_HEXTOBCD:
   MOV A, R4				;distance measured in hex
   CLR C				;clear carry
   MOV B,#100 			;divide by 100 	
   DIV AB
   ORL A,R0				;convert to ascii
   MOV R0,A				;100s digit
   CLR C				
   MOV A,B				;move remainder to a
   MOV B,#10				;divide by 10
   DIV AB				
   ORL A,R1				:convert to ascii
   MOV R1,A				;10s digit
   MOV A,B				;move remainder to a
   ORL A,R2				;convert to ascii
   MOV R2,A				;1st digit
   RET					;return to calling function
 
 
END
