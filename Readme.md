CHECKPOINT 1

The purpose of this program is to do two tasks. The first task is to draw
out a Sudoku gameboard and also accordingly fill in the values - which are
loaded from a memory location. Our information is stored from left to right
going down so our first memory value will belong in the top left and our
last memory value will belong in the bottom right. The memory locations
being read have to be in the range of 1 to 9 to be displayed. However, if
they aren't in that range, we display a blank space (as in nothing). The
second part of the program tests whether or not every square is filled in.
We scroll through the memory locations incrementing a register intially set
to 0 each time we encounter a memory value of 1 to 9. Then we take the
difference of 81 and the register. If we get 0, it means that we have filled
in all the spots and we can display a message to the player that he/she has
won the game. However, If we do not get a difference of 0, it means that
we do not have all the spaces filled in and no message is shown.

CHECKPOINT 2

The purpose of checkpoint two was to actually implement a system where data
could be inputted.Data was usually taken in using a subroutine that displayed
a message of which data to input and then a given subroutine would actually
ask for the value and assure that it was a valid value. When the data for the
actual number to be written in memory was entered, a more complex task had to
be done because one had to calculate the offset from x4000 to see where the
data had to be submitted. The data was stored in memory but was then tested
in the next section of code to see if whether or whether not it complied with
the rules of Sudoku. There were 3 tests run on the number. The tests verified
that there were only 1 of each number from 1 to 9 in any order in the row, the
collumn and the square in which that number was located in.The testing
procedure worked as following: I allocated 9 locations in memory starting at
address x5000 to x5008 that would be used as test locations. Suppose, for
example that a row is being read that contains the following numbers:1,2,9,2.
the program would first read the first number from the left, which would be
1 and would go to the first location of our "test" memory, which would be 
x5000. If we are running this check from the beginning, we will also run a
clearing mechanism that will ensure that x5000 to x5008 always contain 0.
So, since initially we have 0 at x5000. We can use subtraction to see the
difference. If the difference is a non 0 number. We know that we have infact
encountered the first kind of the number. However, to ensure that we know that
we have encountered this number, we have to set x5000 to 1. Similarily, we do
the same thing for 2 and 9. However, when we come across the second 2, we see
that address x5001, which would store 2, contains 2 from before. Now, when we
take the difference, we get 0. We can implement a BRz into here and make the
program go to routine that would remove the character and also display an
"invalid" message. Before the checking procedure, the program would also see
if we have all the spaces filled in. If we do, it means that we have won and
the game will terminate. However, if not, the game will continue with a pause
feature.
