.macro write_to_file(%file_name, %result)
.eqv	WRITE_TEXT_SIZE 5
.data 
	is_valid:	.asciz "true"
	is_not_valid:	.asciz "false"
	er_name_mes:    .asciz "Incorrect file name\n"	
.text
    open(%file_name, WRITE_ONLY)
    li		s1 -1			# check errors with openning file 
    beq		a0 s1 er_name		# handle error
    mv   	s0 a0       		# save descriptor
    # write result in output file
    li   	a7, 64       		# syscall for writing
    mv   	a0, s0 			# descriptor
    j 		write_info
    
continue_writing:
    
    li   a2, WRITE_TEXT_SIZE   		# size of writing
    ecall             			# write to file
    
    close (s0)
    j end

write_info:
	beqz	%result valid
	la	a1, is_not_valid
	j continue_writing

er_name:
    # error message 
    la		a0 er_name_mes
    li		a7 4
    ecall
    exit # end program because file is not valid

valid:
	la	a1, is_valid
	j continue_writing
end:
	
.end_macro
