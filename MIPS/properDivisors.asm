	.data
newline:	
	.asciiz "\n"
	
	.text

main:
	li $t0, 122		#moves range start ($s0) to $t0
	addi $t1, $t1, 1	#range is inclusive
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
	
	print:
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
	
	adds:
	add $s3, $s3 ,$t2
	add $s3, $s3, $s2
	addi $t2, $t2, 1	#increments inner counter
	j fact_inner_loop
	
	fact_inner_end:		#inner loop end

	move $a0, $s3
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	