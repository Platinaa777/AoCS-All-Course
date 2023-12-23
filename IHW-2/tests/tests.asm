.include "../macroses/services.s"
.include "../macroses/calculate_pi.s"
.include "../macroses/print_double.s"

.data 
	accuracy_1:	.double 0.0005
	accuracy_2:	.double 0.000005
	accuracy_3:	.double 0.000000001
	# pi = 3.14159265359
	low_degree_with_0005_acc:  .double 3.1410
	high_degree_with_0005_acc: .double 3.1420
	
	low_degree_with_000005_acc:  .double 3.141587
	high_degree_with_000005_acc: .double 3.141597
	
	low_degree_with_000000001_acc:  .double 3.141592648
	high_degree_with_000000001_acc: .double 3.141592658
.global main
# вариант 20   	
#	 Разработать программу вычисления числа π с точностью
#	 0,05% посредством произведения элементов ряда Виета.


# 	TESTS:
# 	TEST_1: Calculate with accuracy 0.0005
# 	TEST_2: Calculate with accuracy 0.000005
# 	TEST_3: Calculate with accuracy 0.000000001
.text
	main:
		print_str("TEST_1")
			
		li	t6, 1 # test
		
		fld	f10, accuracy_1, t0 # test accuracy
		calculate_pi(f10)
		# checking
		fld	f0, low_degree_with_0005_acc, t0 # low degree
		fld	f1, high_degree_with_0005_acc, t0 # high degree
		fge.d	t0, f10, f0 # comparison
		fle.d	t1, f10, f1
		beqz	t0, fail # if accuracy was not achieved
		beqz 	t1, fail
		
		print_str("\nTEST 1 is completed\n")
		
		# ---------------------------------------------------------- end test 1
		print_str("TEST_2")
		
		li	t6, 2 # test
		
		fld	f10, accuracy_2, t0 # test accuracy
		calculate_pi(f10)
		# checking
		fld	f0, low_degree_with_000005_acc, t0 # low degree
		fld	f1, high_degree_with_000005_acc, t0 # high degree
		fge.d	t0, f10, f0 # comparison
		fle.d	t1, f10, f1
		beqz	t0, fail # if accuracy was not achieved
		beqz 	t1, fail
		
		print_str("\nTEST 2 is completed\n")
		
		
		# ---------------------------------------------------------- end test 2
		print_str("TEST_3")
		
		li	t6, 3 # test
		
		fld	f10, accuracy_3, t0 # test accuracy
		calculate_pi(f10)
		# checking
		fld	f0, low_degree_with_000000001_acc, t0 # low degree
		fld	f1, high_degree_with_000000001_acc, t0 # high degree
		fge.d	t0, f10, f0 # comparison
		fle.d	t1, f10, f1
		beqz	t0, fail # if accuracy was not achieved
		beqz 	t1, fail
		
		print_str("\nTEST 3 is completed\n")
		
		# ---------------------------------------------------------- end test 3
		
		# конец
		print_str("\nAll tests are passed!\n")
		exit
	fail:
		print_msg_with_number ("\nTEST is Not passed, number - ", t6)
		print_str("Ending program...")
		exit
		
		
		
	
