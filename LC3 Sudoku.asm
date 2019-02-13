;Written by Tanmay Mishra
;
;===============Display================
;--------------------------------------
;R0: OUT,PUT Register.
;R1: Counter.
;R2: Operations.
;R3: Stores memory addresses.
;R4: Counter for Collumns.
;R5: Counter for Rows.
;R6: Stores Offset.
;R7: Reserved for PC
;---------------------------------------




;============Check_For_Win==============
;---------------------------------------
;R0: Stores memory addresses.
;R1: Counter.
;R2: Operations.
;R3: Counter
;R4: Unused.
;R5: Unused.
;R6: Operations.
;R7: Reserved for PC
;---------------------------------------




;===============Get_Input===============
;---------------------------------------
;R0: Temporary storage.
;R1: Counter.
;R2: Operations.
;R3: Unused.
;R4: Unused.
;R5: Unused.
;R6: Unused.
;R7: Unused.
;---------------------------------------




;==============Check_Input==============
;--------------------------------------=
;R0: Memory/Temporary Storage.
;R1: Operations.
;R2: Operations.
;R3: Memory.
;R4: Memory.
;R5: Operations.
;R6: Memory.
;R7: Operations/Temporary storage.
;---------------------------------------






       .ORIG x3000     ;Program starting at location address x3000.




MAIN


       JSR DISPLAY     ;Our first function, DISPLAY, will draw the graph and
;will fill in the values for the consecutive spots using memory locations x4000
;as the starting location and by going from left to right and moving downwards.
;If the memory location to the corresponding spot in the sudoku puzzle has a
;value of 0, no value is written. However, if there exists a number at that
;location, that number is written in its decimal form.


       JSR CHECK_FOR_WIN       ;This is our second function which will simply
;check if all the numbers are filled out or are not filled out on the sudoku
;board. If they are all filled out, a "you have won" message will appear while
;if all spots are not filled in, the program returns to the main and starts
;over.
       JSR GET_INPUT   ;Will check for input for row, collumn and data at the
;row and collumn. Will store the data appropriately as well.


       JSR CHECK_INPUT ;Will check the input and verify that it is valid
;according to the Sudoku rules.


       LEA R0, WAIT_MSG        ;The following three lines will allow the user
;to press any key to continue execution of the program.


       PUTS
       GETC
       BRnzp MAIN      ;Skip back to Main regardless. If the user presses "q"
;while in the GET_INPUT routine stage, the program will quit execution.




;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================


DISPLAY
       ST R7, R7_BCKUP ;Here, I am storing the current address of R7 into a
;defined memory location so I can recall it later back into R7 because our
;trap functions within the Display function will alter the value of R7.


       LD R3, STARTL   ;Loading the value x4000 into R3. We will be using this
;as a sort of up counter so we need to keep the address into R3 and then LDR
;from this register into another register for the actual memory locations.


       LD R0, NEWLINE  ;Loading this value into the R0 allows us to create a
;new line in the code.


       LD R5, NINE2    ;Storing R5 to 9 because it governs our rows that we
;have processed. When R5 reaches 0, we know that we have processsed the entire
;square. However, if R4 (which stores the collums to be processed) is 0, it
;does not necessarily mean that we are done with the program; it can simply
;mean that we are done processing just a bunch of collumns on a specific row.


       LD R6, OFFSET   ;This stores the offset that is to applied to the
;contents of the memory if it is non-zero to get it to display properly.


       LD R1, FIFTY    ;We are going to be loading #50 because we need to be
;able to count down 50 times to ensure that our loop is creating 50 new lines.


CLEAR_FIFTY


       OUT     ;Since Out is a trap routine, it will utilize the contents of
;register R0 to output whatever needs to be outputted. In this case, it will
;be a new line since that is what we stored into it.


       ADD R1, R1, #-1 ;Our counter - which must go from 50 to 0 with a
;decrement of -1 to ensure that we repeat 50 times.


       BRp CLEAR_FIFTY ;Keep repeating until R1=0


       LD R0, BOARD_STR        ;Now that we have created 50 new lines, we can
;begin to display our "+---+" pattern.


       PUTS    ;This will allow us to display the pattern described above.


NEW_ROW


       LD R4, NINE2    ;We are loading the value 9 into R4 since R4 is to be
;used as a counter.


       LD R0, BAR      ;Loading the | symbol into R0 so we can start our next
;line as |. We did not have to make a new line because the BOARD_STR itself is
;going to be able to create a new line at the end for us.


       OUT     ;Displaying the | symbol.


REPEAT2


       LD R0, SPACE    ;Once we have displayed a |, we need to display a space.


       OUT     ;Displaying the space.


       AND R2, R2, #0  ;Clearing out register R2 for operations.


       LDR R2, R3, #0  ;Loading the memory of the address stored in R3.
;Effectively, we are loading the character at each position of the board.


       BRp DISPR0      ;If the above comes to be positive, it means that our
;memory location does not store "null" and therefore we can add our offset and
;OUT it.


       LD R0, SPACE    ;However, if not positive, (if zero, that is)we can set
;it equal to a space so effectively, it looks as though there is nothing there.


       OUT     ;Displaying the space.


       ADD R3, R3, #1  ;Adding 1 to R3 (which stores the memory locations so
;we are actually incrementing the memory counter one up).


       BRnzp SKIPP     ;Skip to the reading and writing of the next memory
;location.


DISPR0
       ADD R0, R2, R6  ;If our number was positive, we are adding the offset
;(R6) to the read memory (R2) and storing it into R0.


       OUT     ;We are outputting that symbol.


       ADD R3, R3, #1  ;Once again, incrementing the memory counter one up.


SKIPP


       LD R0, SPACE    ;After displaying the number, outputting a space.


       OUT     ;Outputting the space.


       LD R0, BAR      ;Now we need to load a bar.


       OUT     ;Loading the bar.


       ADD R4, R4, #-1 ;Decrementing the counter by 1 because we have done
;one "cycle."


       BRp REPEAT2     ;If R4 (the counter for the collumns on a specific row)
;is positive, we haven't processed that entire row so we continue to. Otherwise
;,we have to switch to a new line, draw the "+---+" symbol and reset R4 to 9.


       LD R0, NEWLINE  ;Resetting to a new line.


       OUT     ;Outputting the new line.


       LD R0, BOARD_STR        ;Loading the "+--+" structure.


       PUTS    ;actually printing it.


       ADD R5, R5, #-1 ;Decrementing the outerloop counter by -1. Just like a
;nested for loop, the inner for loop will continously change and reset as many
;times as the outer loop is repeating.


       BRp NEW_ROW     ;If we have reached the end of the outer loops' runs,
;we must quit this subroutine and go back to main. However, since we used many
;traps, we must reset R7 to what it used to be.


       LD R7, R7_BCKUP ;Resetting R7 to what it used to be.


       RET     ;Returning to Main to perform the second function.


;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================


CHECK_FOR_WIN
       LD R1, BACKUP_LOC
       BRnp DONT_DEL
       AND R1, R1, #0
       LD R0, BACKUP_LOC
       STR R1, R0, #0
DONT_DEL
       ST R7, R7_BCKUP ;Since this is the start of a new function, must backup
;the PC's address.


       LD R1, COUNTER  ;Setting R1 to 81 so we can navigate the entire game-
;board sequentially.


       LD R0, STARTL   ;We know that the start location of the memory is at
;x4000.


       AND R6, R6, #0  ;Setting R6=0 since it will be used as our counter.


AGAIN


       AND R2, R2, #0  ;Setting R2=0 for computational purposes.


       LDR R2, R0, #0  ;Loading memory of the address located within R0 into
;R2. If it is 0, we need to not add this to the total number of characters.


       BRz SKIP        ;If we have a 0 at the memory location being read, do
;not add 1 to R6, our counter.


       ADD R6, R6, #1  ;If, however, was positive, add 1 to R6 to keep track
;of how many characters we have counted so far.


SKIP    ADD R0, R0, #1  ;Incrementing the memory counter.


       ADD R1, R1, #-1 ;Decrementing the counter of memory locations needed
;to be still read.


       BRp AGAIN       ;If we still have more than zero locations to be read,
;continue to loop.


       LD R3, COUNTER  ;If not, we are going to subtract R6 from R3 - where
;R3 will store 81. If their sum equals 0, it means that we have counted 81
;locations and therefore, have a full board.


       NOT R6, R6      ;Taking first step to 2's complement.


       ADD R6, R6, #1  ;2's complement complete by adding 1.


       ADD R3, R3, R6  ;Testing to see whether the sum of R6 and R3 is equal
; to 0.


       BRp RETURN      ;If not equal to 0, it means that we do not have a full
;board and therefore, we must not display the winning message but we should
;still halt.


       LEA R0, WIN_MSG ;However, if 0, then we have a full board and we can do
;the extra step of displaying the winning message and then quitting.


       PUTS    ;Display the winning message.
       HALT    ;Halt program execution.


SPACE           .FILL x0020
NINE2           .FILL x0009
NEWLINE         .FILL x000A
OFFSET          .FILL x0030
FIFTY           .FILL x0032
BAR             .FILL x007C
STARTL          .FILL x4000
COUNTER         .FILL x0051
WAIT_MSG        .STRINGZ "\nPress key to continue...\n"
WIN_MSG         .STRINGZ "\nCongrats!  You have won!\n"
BOARD_STR       .FILL BOARD_DLM
R7_BCKUP        .BLKW 1
BACKUP_LOC      .FILL x0000


RETURN  LD R7, R7_BCKUP ;Reset the value of R7 so we can correctly jump back to
;the correct location prescribed in memory - that is - to the main so we can
;halt.
       RET     ;Return to Main.


;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================


CHECK_INPUT


;First checks the collumn at which our data point that we have entered is
;located.


       ST R7, R7_BCKUP ;Backing up R7
       LD R0, INPUT_COL        ;Loading the collumn into R0.
       ADD R0, R0, #-1 ;Subtracting one for coordinate issues.
       AND R1, R1, #0  ;Clearing R1.
       ADD R1, R1, #9  ;Setting R1 to 9.
       ADD R2, R0, #0  ;Setting R0=R2


       LD R4, COMPLOC  ;Loading the address x5000 into R4
       LEA R0, SUDOKU_ROW      ;Loading the effective address of the
;sudoku_rows label.


SKIP4
       LDR R7, R0, #0  ;Loading the address stored in the sudoku_rows
;so we can manipulate it.


       ADD R7, R7, R2  ;Adding the number of collumns we need to offset by
;into R7


       LDR R3, R7, #0  ;Loading mem(R7+R2).


       BRz ZERO_IN2    ;If it is 0, skip to ZERO_IN2.


       ADD R5, R3, #-1 ;The following segments of code is being used to decide
;whether or not we are in a valid collumn or not. The way it works is by
;firstly allocating locations x5000 to x5008 for purposes of comparision. The
;locations from the collumns are read one by one. If the read number is a "1,"
;then a 1 is stored into the 1st location of our comparision memory spaces (in
;x5000, we have a 1 now). However, before setting the 1 at that location, we
;want to obtain what is previously located there (which should be 0), and then
;subtract what we can have there (a 1). If the difference is not 0, it means
;that we have only scanned 1 instance of that number so far. However, if we
;take the difference and it comes out to be 0, we can conclude that we have
;encountered another of that number in a collumn and we must, remove that
;number from the sudoku board and also display the error message.


       ADD R5, R5, R4  ;R5=R5+R4
       ADD R6, R5, #0  ;R6=R5
       LDR R5, R5, #0  ;R5=mem(R5)
       NOT R5, R5      ;Not(R5)=R5
       ADD R5, R5, #1  ;R5=R5+1
       ADD R5, R3, R5  ;R5=R3+R5
       BRz REMOVE_LAST ;If R5 is equal to 0, it means that we already have
;the same number in memory so we have a double count...which is illegal.


       STR R3, R6, #0  ;Storing the number to memory if it is the first time.


ZERO_IN2
       ADD R0, R0, #1  ;R0=R0+1
       ADD R1, R1, #-1 ;R1=R1-1
       BRp SKIP4       ;If R1-1 is positive, go back to R4.
       JSR DEL_9S




;Secondly checks the rows at which our data point that we have entered is
;located.


       LD R0, INPUT_ROW        ;Loading INPUT_ROW into R0.
       ADD R0, R0, #-1 ;Subtracting 1 from R0 to account for differences in
;notation for rows and collumsn.


       AND R1, R1, #0  ;Clearing R1.
       ADD R1, R1, #9  ;R1 = 9. To be used.
       AND R2, R2, #0  ;R2=0.
       ADD R0, R0, #0  ;Testing R0 to see if it 0, if it is, no need to have
;it be used as an offset.


       BRz LOOP_IN
LOOP3   ADD R2, R2, #9  ;If we have an offset, we must add 9xR0 as one of the
;offset conditions.


       ADD R0, R0, #-1 ;counter.
       BRp LOOP3


LOOP_IN LD R4, COMPLOC  ;Loading x5000 into R4
       LEA R0, SUDOKU_COLLUMN  ;Loading address of Label "Sudoku_Collumn"


;The following segments of code is being used to decide
;whether or not we are in a valid row or not. The way it works is by
;firstly allocating locations x5000 to x5008 for purposes of comparision. The
;locations from the collumns are read one by one. If the read number is a "1,"
;then a 1 is stored into the 1st location of our comparision memory spaces (in
;x5000, we have a 1 now). However, before setting the 1 at that location, we
;want to obtain what is previously located there (which should be 0), and then
;subtract what we can have there (a 1). If the difference is not 0, it means
;that we have only scanned 1 instance of that number so far. However, if we
;take the difference and it comes out to be 0, we can conclude that we have
;encountered another of that number in a row and we must, remove that
;number from the sudoku board and also display the error message.


SKIP3
       ADD R7, R0, #0  ;R7=R0
       LDR R0, R0, #0  ;R0=mem(R0)
       ADD R0, R0, R2  ;R0=R0+R2
       LDR R3, R0, #0  ;R3=mem(R0)
       BRz ZERO_IN     ;if R3 is 0 skip to zero_in
       ADD R5, R3, #-1 ;R5=R3-1
       ADD R5, R5, R4  ;R5=R5+R4
       ADD R6, R5, #0  ;R6=R5
       LDR R5, R5, #0  ;R5=mem(R5)
       NOT R5, R5      ;R5=not(R5)
       ADD R5, R5, #1  ;R5=R5+1
       ADD R5, R3, R5  ;R5=R3+R5
       BRz REMOVE_LAST ;If R5=0, it means that we have a duplicate in the set
;and we must remove the last input and also dispay the error message.


       STR R3, R6, #0


ZERO_IN
       ADD R0, R7, #1  ;R0=R7+1
       ADD R1, R1, #-1 ;R1=R1-1 (counter)
       BRp SKIP3       ;If finished with counting, backup R7 and run DEL_9S.
       JSR DEL_9S




;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================
;The following is the check for the square at which the number we are looking
;at is located. The way my algorithm works is by loading the bottom right
;coordinates of each of the 9 squares going from left to right and then down.
;if the difference between the INPUT_ROW and the bottom right row is positive
;and if the difference between the INPUT_COL and the bottom right col is also
;positive, it means that we are in the correct box. For each time that we fail
;to find the correct box, we add 1 to R0 each time we move right and we add
;1 to R6 each time we move down. Therefore, depending on the values of the R0
;and R6, we are able to use a formula to calculate the offset to which we can
;offset the entire original top left square by.




SQUARE_CHECK
       AND R6, R6, #0  ;Clearing R6
       AND R0, R0, #0  ;Clearing R0
       AND R1, R1, #0  ;Clearing R1




LOOP6   ADD R1, R1, #3  ;Adding 3 to R1.
       AND R2, R2, #0  ;Clearing register R2.
       AND R0, R0, #0


LOOP7   ADD R2, R2, #3  ;Adding 3 to R2.
       LD R3, INPUT_ROW        ;R3=ROW.
       LD R4, INPUT_COL        ;R4=COLLUMNS.
       NOT R3, R3              ;Negating R3.
       NOT R4, R4              ;Negating R4.
       ADD R3, R3, #1          ;Negation complete.
       ADD R4, R4, #1          ;Negation complete.
       ADD R3, R1, R3          ;Taking R1-R3.
       BRn GO_BACK             ;If it is positive or zero,
;we are in the range of the rows.


       ADD R4, R4, R2          ;Taking R2-R4.
       BRn GO_BACK             ;If it is positive or zero,
;we are in the range of the rows.
       BRnzp CHECK_SQUARE      ;If they were both positive, then we must
;continue to check with the square because we are successfully in
;the correct square.


GO_BACK
       ADD R0, R0, #1  ;Since we failed to find the correct location,
;we are increasing the square to the right and have to add 1 to R0.


       ADD R5, R2, #-9 ; A Counter to check whether or not we are in
;the rightest most collumn. If we are, we are to go to the top most
;loop.
       BRz LOOP9
       BRnzp LOOP7


LOOP9
       ADD R6, R6, #1 ;Since we moved to a new row, we must add 1 to R6.
       BR LOOP6


CHECK_SQUARE
       AND R2, R2, #0  ;Clearing R2
       ADD R2, R2, #9  ;Setting R2 to 9.
       AND R1, R1, #0  ;Clearing R1
       ADD R0, R0, #0  ;Adding 0 to R0 to see if we obtain a zero.
       BRz SKIP7       ;If we do, it means that we are in no need
;of a horizontal offset.


GBACK   ADD R1, R1, #3  ;Offsetting horizontally.
       ADD R0, R0, #-1 ;R0-1=R0
       BRp GBACK
SKIP7   ADD R6, R6, #0  ;Now testing to see if there is a need to offset
;vertically.
       BRz SKIP8


GBACK2  LD R7, TWENTY_7 ;Offsetting vertically if needed.
       ADD R1, R1, R7
       ADD R6, R6, #-1
       BRp GBACK2
SKIP8   LD R4, COMPLOC  ;Loading x5000 into R4.
       LEA R0, SUDOKU_FIRSTBOX ;Loading address of label SUDOKU_FIRSTBOX
;into R0.




;The following segments of code is being used to decide
;whether or not we are in a valid square or not. The way it works is by
;firstly allocating locations x5000 to x5008 for purposes of comparision. The
;locations from the collumns are read one by one. If the read number is a "1,"
;then a 1 is stored into the 1st location of our comparision memory spaces (in
;x5000, we have a 1 now). However, before setting the 1 at that location, we
;want to obtain what is previously located there (which should be 0), and then
;subtract what we can have there (a 1). If the difference is not 0, it means
;that we have only scanned 1 instance of that number so far. However, if we
;take the difference and it comes out to be 0, we can conclude that we have
;encountered another of that number in a square and we must, remove that
;number from the sudoku board and also display the error message.


SKIPPP  LDR R7, R0, #0 ;R7=R0+0
       ADD R7, R7, R1  ;R7=R7+R1
       LDR R3, R7, #0  ;R3=mem(R7)
       BRz ZERO_IN3    ;if R3 is 0, goto ZERO_IN3
       ADD R5, R3, #-1 ;R5=R3-1
       ADD R5, R5, R4  ;R5=R5+R4
       ADD R6, R5, #0  ;R6=R5
       LDR R5, R5, #0  ;R5=mem(R5)
       NOT R5, R5      ;R5=NOT(R5)
       ADD R5, R5, #1  ;R5=R5+1
       ADD R5, R3, R5  ;R5=R3+R5
       BRz REMOVE_LAST ;If R5 is 0, it means that we have a duplicate value
;and we must quit testing and go to the REMOVE_LAST routine so we can get
;rid of the last input  and display the error message.


       STR R3, R6, #0; Storing the number to the memory so we know that we
;have encountered it.


ZERO_IN3
       ADD R0, R0, #1; R0=R0+1
       ADD R2, R2, #-1 ;R2=R2-1 (counter)
       BRp SKIPPP      ;while counter is still counting, goto SKIPPP
       LD R1, BACKUP_LOC
       LD R2, INPUT_NUM
       STR R2, R1, #0  ;Finally storing the number after all the tests are
;complete.
       AND R2, R2, #0
       ST R2, BACKUP_LOC
       JSR DEL_9S


       LD R7, R7_BCKUP
       RET


;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================
;The following code allows you to clear the locations x5000 to x5008 because
;they are being used and have to be cleared so they can be safely used again.


DEL_9S
       LD R0, COMPLOC  ;Loading x5000 to R0.
       AND R3, R3, #0  ;R3=0
       AND R1, R1, #0  ;R1=0
       AND R2, R2, #0  ;R2=0
       ADD R2, R2, #1  ;R2=1
       ADD R1, R1, #9  ;R1=9
DELETES5
       STR R3, R0, #0  ;Storing 0 at x5000 plus the offset.
       ADD R0, R0, R2  ;Incrementing the memory to write to.
       ADD R1, R1, #-1 ;Decrementing the counter.
       BRp DELETES5    ;While the counter is positive keep repeating.
       RET     ;Go back to the code.


R7_BACK2        .FILL x0000


;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================


GET_INPUT
       ST R7, R7_BCKUP ;This segment will input the row at which we would
;like to enter the data.
       LEA R0, FIRST_MSG       ;Loading FIRST_MSG string.
       PUTS    ;Displaying string.
       JSR GET_VALID_INPUT     ;Checking for valid input.
       ST R0, INPUT_ROW        ;Storing the input to Input_row.


       LEA R0, SECOND_MSG      ;This segment will input the collum at which we
;would like to enter the data. Loading SECOND_MSG.
       PUTS    ;Displaying the string.
       JSR GET_VALID_INPUT     ;Checking for valid input.
       ST R0, INPUT_COL        ;Storing the input to Input_collumn.


       LEA R0, THIRD_MSG       ;This segment will input the data at our
;location. Then, it will go through an algorithm to determine which location in
;memory we are writing to.


       PUTS    ;Displaying the third message.
       JSR GET_VALID_INPUT     ;Getting valid input.


       ;The following code will take the algorithm 9(Row-1)+Collumn-1+x4000
;to figure out which location in memory we will be writing to. We will write
;several variables to memory. For example, we will write the value of
;INPUT_NUM, something which we had to write. Also, we will write the value of
;R0 at the memory location that corresponds to the appropriate location in the
;sudoku puzzle. In addition, we must write R1


       LD R1, INPUT_ROW        ;loading row to R1.
       AND R2, R2, #0  ;R2 = 0
       ADD R1, R1, #-1 ;R1-1=R1 (accomodating for the different numbering of
;the rows and collumns.


       BRz SKIP11      ;If 0, no need to do an offset in the up and down
;direction.


LOOP5   ADD R2, R2, #9  ;Add 9xmem(R1) to R2.
       ADD R1, R1, #-1
       BRp LOOP5
SKIP11  LD R1, INPUT_COL        ;loading row to R1.
       ADD R1, R1, #-1 ;R1=R1-1
       ADD R2, R2, R1  ;Add the value of R1-1 to R2.
       LD R1, STARTL   ;Loading x4000 into R1.
       ADD R1, R2, R1  ;Adding R2 to x4000 to calculate the location at which
;we must store R0.




       ST R0, INPUT_NUM        ;Storing R0 into INPUT_NUM
       STR R0, R1, #0


       ST R1, BACKUP_LOC       ;Storing the memory address of the location
;that we just stored our number to into BACKUP_LOC.




       LD R7, R7_BCKUP ;Loading back R7.


       RET


;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================


SUDOKU_ROW
               .FILL x4000
               .FILL x4009
               .FILL x4012
               .FILL x401B
               .FILL x4024
               .FILL x402D
               .FILL x4036
               .FILL x403F
               .FILL x4048
SUDOKU_COLLUMN
               .FILL x4000
               .FILL x4001
               .FILL x4002
               .FILL x4003
               .FILL x4004
               .FILL x4005
               .FILL x4006
               .FILL x4007
               .FILL x4008
SUDOKU_FIRSTBOX
               .FILL x4000
               .FILL x4001
               .FILL x4002
               .FILL x4009
               .FILL x400A
               .FILL x400B
               .FILL x4012
               .FILL x4013
               .FILL x4014


COMPLOC         .FILL x5000


;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================
;Allows for the removal of the last written location in memory if it was tested
;to be an invalid one. In addition, it displays the INVALID_MSG2.


REMOVE_LAST
       LD R2, BACKUP_LOC
       AND R3, R3, #0
       STR R3, R2, #0
       LEA R0, INVALID_MSG2
       PUTS
       JSR DEL_9S
       LD R7, R7_BCKUP
       RET


;===========================================================================
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;===========================================================================


; Strings and constants - DO NOT EDIT THIS SECTION OF CODE


INPUT_ROW       .FILL x0000
INPUT_COL       .FILL x0000
INPUT_NUM       .FILL x0000
PLUS            .FILL x002B
DASH            .FILL x002D
TWENTY_7        .FILL x001B
FIRST_MSG       .STRINGZ "\nInput Row:\n"
SECOND_MSG      .STRINGZ "\nInput Column:\n"
ZERO            .FILL x0030 ;Had to put this here because of an offset issue.
QUIT            .FILL x0071
ONE             .FILL x0031
NINE            .FILL x0039
THIRD_MSG       .STRINGZ "\nInput Entry:\n"
INVALID_MSG     .STRINGZ "\nInvalid input!  Try again...\n"
INVALID_MSG2    .STRINGZ "\nSudoku fail!  Try again...\n"
BOARD_DLM       .STRINGZ "+---+---+---+---+---+---+---+---+---+\n"


; Look up table for rows






; Look up table for figuring out which box you are in




SUDOKU_BOX_ROW_LUT
               .FILL x0000
               .FILL x0000
               .FILL x0000
               .FILL x0003
               .FILL x0003
               .FILL x0003
               .FILL x0006
               .FILL x0006
               .FILL x0006
SUDOKU_BOX_COL_LUT
               .FILL x0000
               .FILL x0001
               .FILL x0002
               .FILL x0000
               .FILL x0001
               .FILL x0002
               .FILL x0000
               .FILL x0001
               .FILL x0002
; Look up table for boxes
SUDOKU_BOXES
               .FILL x4000
               .FILL x4003
               .FILL x4006
               .FILL x401B
               .FILL x401E
               .FILL x4021
               .FILL x4036
               .FILL x4039
               .FILL x403C


; Valid Input Code
; Inputs: None
; Outputs:
;       R0 = Legal Numeric Input Value
; Register Usage:
;       R1 = character value
GET_VALID_INPUT
               ST R1, VI_R1            ; Save all registers
               ST R7, VI_R7
VALID_INPUT_GET_CHAR
               GETC                    ; Get character
               OUT
               LD R1, QUIT             ; Compare against 'q' character
               NOT R1, R1
               ADD R1, R1, #1
               ADD R1, R1, R0
               BRz VALID_INPUT_EXIT    ; Exit if 'q'
               LD R1, ONE              ; Compare against '1' character
               NOT R1, R1
               ADD R1, R1, #1
               ADD R1, R1, R0
               BRn VALID_INPUT_NO      ; Invalid input if result < 0
               LD R1, NINE             ; Compare against '9' character
               NOT R1, R1
               ADD R1, R1, #1
               ADD R1, R1, R0
               BRp VALID_INPUT_NO      ; Invalid input if result > 0x000A
               BR VALID_INPUT_YES
VALID_INPUT_NO
               LEA R0, INVALID_MSG
               PUTS
               BR VALID_INPUT_GET_CHAR
VALID_INPUT_YES
               LD R1, ZERO             ; Convert from ASCII to binary
               NOT R1, R1
               ADD R1, R1, #1
               ADD R0, R0, R1
               LD R1, VI_R1            ; Restore all registers
               LD R7, VI_R7
               RET                     ; Return
VALID_INPUT_EXIT
               HALT
VI_R1           .FILL x0000
VI_R7           .FILL x0000
; End valid input code
               .END
