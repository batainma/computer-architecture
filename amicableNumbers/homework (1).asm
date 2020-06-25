	.data
prompt_one:
	.asciiz "\nInput the start of the range: "
prompt_two:
	.asciiz "\nInput the end of the range: "
swap_prompt:
	.asciiz "\nEnd of range < start of range -- swapping values\n"
negative_input:
	.asciiz	"\nUnable to check non-positive values\nExiting......\n"
	
newline:
	.asciiz "\n"
	
	.text
main:

	loop:
	la $a0, prompt_one	#get start of range
	li $v0, 4		#loads print value
	syscall			#prints prompt_one
	
	la $v0, 5		#get user input
	syscall
	
	slt $t0, $zero, $v0	#checks if input is negative
	beq $t0, $zero, is_neg	#if negative, go to is_neg
	
	move $s0, $v0		#moves prompt_input to $s0
	
	#move $a0, $v0		#move user input to a0
	#li $v0, 1		#loads print value
	#syscall
	
	la $a0, prompt_two	#get end of range
	li $v0, 4		#loads print value
	syscall
	
	li $v0, 5		#gets user input
	syscall
	
	move $s1, $v0		#user input is stored
	
	#move $a0, $s1		#move user input to a0
	#li $v0, 1		#loads print value
	#syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	slt $t0, $zero, $s1	#checks if input is negative
	beq $t0, $zero, is_neg	#if false, go to swap_ranges
	
	#move $s1, $v0		#user prompt input 2 into $s1
	
	slt $t0, $s1, $s0	#checks if range end < range start
	beq $t0, 1, swap_ranges	#if true, go to swap_ranges

	
	swap_range_return:	#swap range comes back here
	
	move $s4, $s0		#puts start of range into s4
	rangeloop:
	jal is_factor
	beq $s4, $s1, rangeloop_end	#if counter = range end
	addi $s4, $s4, 1	#increments range counter
	j rangeloop
	
	rangeloop_end:
	j loop			#restarts the loop
	
	
	is_neg:
	la $a0, negative_input	#loads in negative prompt
	li $v0, 4		#loads print value
	syscall
	
	li $v0, 10		#terminate program
	syscall
	
	swap_ranges:
	la $a0, swap_prompt	#loads prompt to tell user of the swap
	li $v0, 4		#loads print value
	syscall
	
	move $t0, $s0		#move range start to temp
	move $s0, $s1		#move range end to range start
	move $s1, $t0		#move range start to range end
	
	j swap_range_return	#return to main
	
	
	is_factor:
	li $s3, 0
	move $t0, $s4		#moves range start ($s0) to $t0
	li $t7, 2
	div $t0, $t7		#divides current index by 2
	mflo $t6		#t6 holds what we check against
	
	li $t2, 1		#inner loop counter
	
	fact_inner_loop:
	beq $t2, $t6, fact_inner_end	#ends loop

	div $t0, $t2		#divides index by counter
	mfhi $t4		#holder for remainder
	mflo $t5		#holder for quotient
	beq $s2, $t5, fact_inner_end	#stops from repeating divisions
	move $s2, $t5
	beq $t4, $zero, adds	#if $t1 % $t2 == 0, then go to print
	addi $t2, $t2, 1	#increments inner counter
	j fact_inner_loop 	#loop restart
	
	
	adds:
	add $s3, $s3 ,$t2
	add $s3, $s3, $s2
	addi $t2, $t2, 1	#increments inner counter
	j fact_inner_loop
	
	fact_inner_end:		#inner loop end

	sub  $s3, $s3, $s4	#fix to not add the number itself to sum
	move $a0, $s3		#loads sum of proper divisor
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	jr $ra
	
	li $v0, 10
	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	#---------------------
	#DO NOT LOOK AT THIS
	#THIS IS FOR HISTORICAL
	#PURPOSES ONLY
	#---------------------
	not_used:
	move $t0, $s0		#moves range start ($s0) to $t0
	move $t1, $s1		#moves range end ($s1) to $t1
	addi $t1, $t1, 1	#range is inclusive
	li $t7, 2
	#li $t2, 1		#puts 1 in $t2, this will be used as a counter later
	unusedfactor_loop:
	
	div $t0, $t7		#divides current index by 2
	mflo $t6		#t6 holds what we check against
	li $t2, 1		#inner loop counter
	unusedfact_inner_loop:
	beq $t2, $t6, unusedfact_inner_end	#ends loop

	div $t0, $t2		#divides index by counter
	mfhi $t4		#holder for remainder
	mflo $t5		#holder for quotient
	beq $s2, $t2, unusedfact_inner_end	#stops from repeating divisions
	move $s2, $t5
	beq $t4, $zero, unusedprint	#if $t1 % $t2 == 0, then go to print
	addi $t2, $t2, 1	#increments inner counter
	j unusedfact_inner_loop 	#loop restart
	unusedprint:
	move $a0, $t2		#moves counter into $a0
	li $v0, 1		#loads print value
	syscall
	
	la $a0, newline		#loads in a new line
	li $v0, 4		#loads in print value
	syscall
	
	move $a0, $t5		#moves quotient to $a0
	li $v0, 1		#loads print integer value
	syscall

	la $a0, newline		#loads in a new line
	li $v0, 4		#loads in print value
	syscall
	
	
	addi $t2, $t2, 1
	j fact_inner_loop	#loop start over
	
	unusedfact_inner_end:		#inner loop end
	
	addi $t0, $t0, 1	#increments outer counter
	beq $t1, $t0, unusedfactor_end	#checks if for loop is done

	unusedfactor_end:		#loop end
	
	jr $ra			#return to main
	
	
	
	
	
