
# main logic of program

# returns in a5 value:
#   			-1 - is not valid consequence
#			0 -  is valid consequence

.macro validate_sequence_of_brackets (%input_file)
.eqv    NAME_SIZE 256	 # size of file_name
.eqv	TEXT_SIZE 512    # buf text size

.data
	er_name_mes:    .asciz "Incorrect file name\n"
	er_read_mes:    .asciz "Incorrect read operation\n"
	strbuf:		.space TEXT_SIZE			# reading buf
	open_bracket:	.asciz "("
	close_bracket:	.asciz ")"
.text
    
    open(%input_file, READ_ONLY)
    li		s1 -1			# isCorrect?
    beq		a0 s1 er_name		# Error with openning
    mv   	s0 a0       		# save descriptor
   
    # allocate memory
    allocate(TEXT_SIZE)		        # return address in a0 
    mv 		s3, a0			# save address of heap
    mv 		s5, a0			# save changing address of heap
    li		s4, TEXT_SIZE		# constant
    mv		s6, zero		# 0 char have already read 
    
    li      	t2 '('  		# open bracket
    li 		t3 ')' 			# close bracket
    
read_loop:
    # read from openning file
    read_addr_reg(s0, s5, TEXT_SIZE)    # read for address block from register

    beq		a0 s1 er_read		# Error of reading
    mv   	s2 a0       		# save len of read text
    add 	s6, s6, s2		# Add count of chars
    
    # save string in s5 register
    mv   	a6 s5

    # status code - 0 is ok	 	# in a5 register
    # status code - -1 is error		# in a5 register
    j read_bracket
    
    continue_reading:
    
    # if len of read text less than text_buffer then finish of reading text from file
    bne	 s2 s4 end_loop

    b read_loop
    
end_loop:
    # closing file
    close(s0)
    j end_valid 
    
# string in a0 register
read_bracket:
	mv 	a3 zero		 # elements counter
        mv      t0 zero          # counter
        
loop:   lb      t1 (a6)          # current char	
	beq 	t1 t2	add_bracket
	beq	t1 t3 	remove_bracket
	continue:
	bltz	t0 sequence_is_not_valid
	addi    a6 a6 1         # next char
	addi 	a3 a3 1
        ble	a3 s2 loop
        
fin:    bgt	t0 s6 sequence_is_not_valid
        li	a5 0
        j  	continue_reading
        
add_bracket:
	addi 	t0 t0 1
	j continue
	
remove_bracket:
	addi 	t0 t0 -1
	j continue
	
sequence_is_not_valid:
	li 	a5 -1
	j end_loop
	
er_name:
    # error message 
    la		a0 er_name_mes
    li		a7 4
    ecall
    exit # end program because file is not valid
    
er_read:
    # error file with reading
    la		a0 er_read_mes
    li		a7 4
    ecall
    exit # end program
    
end_valid:
	beqz t0 set_valid
	li a5 -1
	j end
set_valid:
	li a5 0
	j end
end:	

.end_macro
