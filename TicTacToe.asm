#################################################################################
#	PURPOSE:	This program lets the user play Tic Tac Toe.
#
#	ALGORITHM: 	SEE lines (102-109) & (146-175) & (247-253)
#
#
#	INPUTS:		User Input after being prompted for Board move location
#			User Input after Error message is displayed
#			User Input after PlayAgain message is displayed
#
#	OUTPUTS:	Board[][] is a 3x3 array used to hold contents of game board
#			Error is a string that is displayed on screen before user enters input for board
#			Win is a string that is displayed on screen when a user wins the game
#			Draw is a string that is displayed on screen when users tie
#			PlayAgain is a string that is displayed on screen when requesting user input to play again
#			
#			
#################################################################################

		.data			
moveCount:	.word	0
IsGameOver:	.word	0		
Board:		.asciiz "........."
Error:		.asciiz "Enter numbers between 1 and 3, or choose an unoccupied space! Try again.\n"
Win:		.asciiz " has won!"
Draw:		.asciiz "It's a draw!"
PlayAgain:	.asciiz "Enter '1' to play another game. Otherwise, enter any other single-digit intger to quit the program."
whoseMove:	.word 88

		.text
main:					#
	lw 	$s0, moveCount		# moveCount = 0;
	la 	$s1, Board		# char[][] Board = new char[3][3];
	lb 	$s2, whoseMove		# whoseMove = "X";
	lw 	$s3, IsGameOver		# IsGameOver = false;
newGame:				#
	li 	$t0, 0			# A = false;
	move 	$s3, $t0                # IsGameOver = false;
gameloop:				#
	beq 	$s3, 1, endloop		# if (IsGameOver == true)
	addi	$sp, $sp, -4		# 
	sw	$ra, 0($sp)		# 
	jal	AddMove			# AddMove();
	jal 	DisplayBoard		# DisplayBoard();
	jal	IsAWin			# IsAWin();
	bne 	$s3, 1, continueLoop	# if (IsGameOver != true)
	jal 	ResetBoard		# ResetBoard();
continueLoop:				#
	lw	$ra, 0($sp)		# 
	addi	$sp, $sp, 4		#
	j gameloop			# 
AddMove:				#
	li	$v0, 5			#
	syscall				# 
	addi	$t0, $v0, 0		# Column = Keyboard.nextInt();
	li	$v0, 5		        # 
	syscall				#
	addi	$t1, $v0, 0		# Row = Keyboard.nextInt();
	la 	$t2, Board		# 
	blt 	$t0, 1, InputError	# if (Column < 1)
	bgt 	$t0, 3, InputError	# if (Column > 3)
	blt 	$t1, 1, InputError	# if (Row < 1)
	bgt 	$t1, 3, InputError	# if (Row > 3)
	addi 	$t0, $t0, -1		# Column = Column - 1;
	addi 	$t1, $t1, -1		# Row = Row - 1;
	mul 	$t0, $t0, 3		# Column = Column * 3;
	add 	$t2, $t2, $t0		# 
	add 	$t2, $t2, $t1		#
					#
	lb 	$t3, ($t2)		# C = Board[Column][Row];
	beq 	$t3, 88, InputError	# if (C == X)
	beq 	$t3, 79, InputError	# if (C == O)
					#
	beq 	$s2, 79, Omove		# if (whosMove == O)
Xmove:					#
	li 	$t4, 88			# D = 'X';
	li 	$t5, 79			# E = 'O';
	move 	$s2, $t5                # whosMove = 'O';
	j 	WriteToBoard		#
Omove:					#
	li 	$t4, 79			# D = 'O';
	li 	$t5, 88			# E = 'X';
	move 	$s2, $t5                # whosMove = 'X';
WriteToBoard:				#
	sb      $t4, ($t2)       	# Board[Column][Row] = 'X' or 'O';
	addi	$s0, $s0, 1		# moveCount = moveCount + 1;
            				#
	jr	$ra                	# 
InputError:				#
	la	$a0, Error		# 
	li	$v0, 4			# 
	syscall		 		# 
	j	AddMove			#	
DisplayBoard:				#	(This for loop is for all of display board) 
        lb      $a0, ($s1)  		# for (int Column = 0; Column < 3; Column++) 
        li      $v0, 11			# {
	syscall                         #	for (int Row = 0; Row < 3; Row++) 	
	lb      $a0, 1($s1)  		#	{
        li      $v0, 11			# 		System.out.print (board[Column][Row]); 
	syscall                         #	}
	lb      $a0, 2($s1)  		#	System.out.println (""); 
        li      $v0, 11			# }
	syscall                         #	
        				#
        li      $a0, 10  		# 
        li      $v0, 11     	        # 
	syscall				#
					#
	lb      $a0, 3($s1)  		#
        li      $v0, 11     	        #
	syscall				#
	lb      $a0, 4($s1)  		#
        li      $v0, 11     	        #    
	syscall				#
	lb      $a0, 5($s1)  		#
        li      $v0, 11			#    
	syscall                         #
					#
	li      $a0, 10  		#
        li      $v0, 11     	        #         
	syscall                         #
					#
	lb      $a0, 6($s1)  		#
        li      $v0, 11     	        #      
	syscall                         #
	                                #
	lb      $a0, 7($s1)  		#
        li      $v0, 11			#   
	syscall                         #
	                                #
	lb      $a0, 8($s1)  		#
        li      $v0, 11     	        #    
	syscall                         #
					#
	li      $a0, 10  		#
        li      $v0, 11     	        #         
	syscall                         #
	jr 	$ra 			#
IsAWin:					# 
	blt 	$s0, 5, NoWinYet        # if (moveCount < 5)
	lb      $t0, ($s1)		# ------ Start for loop here ------
	lb      $t1, 1($s1)		# for (int Column = 0; Column < 3; Column++)
	lb      $t2, 2($s1)		# {
	lb      $t3, 3($s1)		#	if (Board[Column][0] == Board[Column][1] && Board[Column][1] == Board[Column][2] && Board[Column][0] != ' ')
	lb      $t4, 4($s1)		#	{
	lb      $t5, 5($s1)		#		System.out.println(Board[Column][0] + " has Won!"); 
	lb      $t6, 6($s1)		# 	}
	lb      $t7, 7($s1)		# 
	lb      $t8, 8($s1)		#
row1:					# 	for (Row = 0; Row < 3; Row++)
	blt 	$t0, 78, row2		# 	{
	bne	$t0, $t1, diag11to33	#		if (Board[0][Row] == Board[1][Row] && Board[1][Row] == Board[2][Row] && Board[0][Row] != ' ')
	bne 	$t0, $t2, diag11to33	#		{
	j 	Win11			#			System.out.println(Board[0][Row] + " has Won!");
diag11to33:				#		}
	bne	$t0, $t4, column1	# 
	bne 	$t0, $t8, column1	# 		if (Board[0][0] == Board[1][1] && Board[1][1] == Board[2][2] && Board[0][0] != ' ')
	j 	Win11			# 		{
column1:				#			System.out.println(Board[0][0] + " has Won!");
	bne	$t0, $t3, row2		#		}
	bne 	$t0, $t6, row2		#		if (Board[2][0] == Board[1][1] && Board[1][1] == Board[2][0] && Board[2][0] != ' ')
	j 	Win11			#		{
row2:					#			System.out.println(Board[2][0] + "has Won!");
	blt 	$t4, 78, row3		#		}
	bne	$t4, $t3, column2	#		else if (moveCount == 9)
	bne 	$t4, $t5, column2	#		{
	j 	Win22			#			System.out.println("Its a draw!");
column2:				#		}
	bne	$t4, $t1, diag13to31	# 	}
	bne 	$t4, $t7, diag13to31	# }
	j 	Win22			#
diag13to31:				#
	bne	$t4, $t6, row3		#
	bne 	$t4, $t2, row3		#
	j 	Win22			#
row3:					#
	blt 	$t8, 78, NoWinYet	#
	bne	$t8, $t6, column3	#
	bne 	$t8, $t7, column3	#
	j 	Win33			#
column3:				# 
	bne	$t8, $t2, ItsADraw	# 
	bne 	$t8, $t5, ItsADraw	#
	j 	Win33			# 
Win11:					#
	li 	$t9, 1			# 
	lb      $a0, ($s1)  		#
        li      $v0, 11     	       	#        
	syscall                         #
	la 	$a0, Win                #
	li 	$v0, 4			#
	syscall                         #
	li      $a0, 10  		#
        li      $v0, 11     	        #         
	syscall                         #
	move 	$s3, $t9                #
	j 	NoWinYet		#
Win22:					#
	li 	$t9, 1			#
	lb      $a0, 4($s1)  		#
        li      $v0, 11			#
	syscall                         #
	la 	$a0, Win                #
	li 	$v0, 4			#
	syscall                         #
	li      $a0, 10                 #
        li      $v0, 11     	        #         
	syscall                         #
	move 	$s3, $t9                #
	j 	NoWinYet		#
Win33:					#
	li 	$t9, 1			#
	lb      $a0, 8($s1)  		#
        li      $v0, 11                 #
	syscall                         #
	la 	$a0, Win                #
	li 	$v0, 4			#
	syscall				#
	li      $a0, 10  		#
        li      $v0, 11     	        #         
	syscall                         #
	move 	$s3, $t9                #
	j 	NoWinYet		#
ItsADraw:				#
	li 	$t9, 1			#
	blt 	$s0, 9, NoWinYet	#
	la 	$a0, Draw		#
	li 	$v0, 4			#
	syscall				#
	li      $a0, 10  		#
        li      $v0, 11     	        #         
	syscall                         #
	move 	$s3, $t9                # ------ End for loop here ------
NoWinYet:				#
	jr $ra				#
ResetBoard:				# 
	li 	$t0, 46			# A = '.';
	li 	$t1, 88			# B = 'X';
	li 	$t2, 0			# C = 0;
	sb      $t0, ($s1)		# ------ Start for loop here ------
	sb      $t0, 1($s1)		# 
	sb      $t0, 2($s1)		# for (int Row = 0; Row < 3; Row++) 
	sb      $t0, 3($s1)		# {
	sb      $t0, 4($s1)		# 	for (int Column = 0; Column < 3; Column++)
	sb      $t0, 5($s1)		# 	{
	sb      $t0, 6($s1)		#		Board[Row][Column] = '.';
	sb      $t0, 7($s1)		#	}
	sb      $t0, 8($s1)		# }
					# ------ End for loop here ------
	move 	$s0, $t2                # moveCount = C;
	move 	$s2, $t1                # whosMove = B;
	jr $ra				#
endloop:				#
	la 	$a0, PlayAgain		#
	li 	$v0, 4			# 
	syscall				# System.out.print("Enter '1' to play another game. Otherwise, enter any other single-digit intger to quit the program.");
	li      $a0, 10  		# 
        li      $v0, 11     	        #         
	syscall                         # System.out.println("");
	li	$v0, 5			# 
	syscall				# 
	beq 	$v0, 1, newGame		# if (newGame == 1) 
	li	$v0, 10			# 
	syscall				#  exit
