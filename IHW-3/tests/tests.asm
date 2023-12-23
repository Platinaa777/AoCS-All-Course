.include "../macroses/read.s"
.include "../macroses/write.s"
.include "../macroses/utils.s"
.include "../macroses/validate_sequence_of_brackets.s"
.include "../macroses/macrosyscalls.s"


.global main
# input file in project directory
# test 1
# wrong sequence
# test 2
# right sequence
# test 3
# input file does not exist -> end program (exit)

# All answers in output files
.data 
	input: 		.asciz "../input.txt\00"
	input2: 	.asciz "../input2.txt\00"
	input3: 	.asciz "../input3.txt\00"
	output: 	.asciz "../output.txt\00"
	output2: 	.asciz "../output2.txt\00"
	output3: 	.asciz "../output3.txt\00"
.text
main:
	print_str("TEST_1\n")
	
	la s1 input
	la s2 output
	push(s1)
	push(s2)
	validate_sequence_of_brackets(s1)
	pop(s2)
	pop(s1)
	push(s1)
	push(s2)
	write_to_file (s2, a5)
	pop(s2)
	pop(s1)
	print_str("result was printed in file")
	print_str("\nTEST 1 is completed\n")
	
	# ---------------------------------------------------------- end test 1
	print_str("TEST_2\n")
	
	la s1 input2
	la s2 output2
	push(s1)
	push(s2)
	validate_sequence_of_brackets(s1)
	pop(s2)
	pop(s1)
	push(s1)
	push(s2)
	write_to_file (s2, a5)
	pop(s2)
	pop(s1)
	print_str("result was printed in file")
	
	print_str("\nTEST 2 is completed\n")
	
	
	# ---------------------------------------------------------- end test 2
	print_str("TEST_3\n")
	
	la s1 input3
	la s2 output3
	push(s1)
	push(s2)
	validate_sequence_of_brackets(s1)
	pop(s2)
	pop(s1)
	push(s1)
	push(s2)
	write_to_file (s2, a5)
	pop(s2)
	pop(s1)
	print_str("result was printed in file")
	
	print_str("\nTEST 3 is completed\n")
	
	# ---------------------------------------------------------- end test 3
	
	# конец
	print_str("\nAll tests are passed!\n")
	exit

		
		
		
	
