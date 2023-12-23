
# precision 0,05% => (pi - pi_prev) < 0.0005 => stop

.macro calculate_pi(%input_accuracy)

	# (python)
	# denom = math.sqrt(2)
	# pi_prev = 0
	# pi = 2.0 / math.sqrt(2)
	
	fld	f1, pi_prev, t0 # f1 ~ previous value of pi
	fld	f2, denominator, t0 # f2 ~ sqrt(2)
	fld	f3, two, t0 # f3 = 2
	fdiv.d	f7, %input_accuracy, f3 # divide because in Vieta's theory we calculate value
					# for pi / 2

	# find first element in row (pi) 
	# first element in vieta row = 1.41421 because 2/sqrt(2) = 2 * sqrt(2) / 2 = sqrt(2)
	fdiv.d	f0, f3, f2 # f0 ~ 2/sqrt(2) = pi
	# multiply result by 2 because in Vieta's theory we calculate for pi / 2
	fmul.d	f0, f0, f3	
	# loop to find approximate pi
	
	# (python)
	# while (pi - pi_prev > accuracy):
	#   pi_prev = pi
	#   denom = math.sqrt(denom + 2) 
	#   pi *= 2.0 / denom
	loop:
		fmv.d	f1, f0 # pi_prev = pi
		fadd.d	f2, f3, f2 # (denominator + 2)
		fsqrt.d f2, f2 # cur_elem = math.sqrt(cur_elem + 2)
		
		fdiv.d	f5, f3, f2 # temp = 2.0 / denominator ~> 2.0 / sqrt(2 + sqrt(2 + ...))
		fmul.d 	f0, f1, f5 # pi = prev_pi * cur_element
		# find (pi - pi_prev)
		fsub.d	f6, f0, f1 
		# compare to 0.0005
		fle.d 	t1, f6, f7 # check if (pi - pi_prev) > 0.0005
		# case: 0 => repeat again
		# case: 1 => end of calculating
		beqz 	t1, loop
		
	fmv.d	f10, f0 # return value
	
.end_macro

.data
	pi_prev:      .double 0.0
	denominator:  .double 1.41421356237 # sqrt(2)
	two:	      .double 2.0
	
