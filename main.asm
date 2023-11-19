global _start
section .data
	clean_cursor_arr times 50 db 8
	spaces times 50 db ' '
	num: dq 0
	sum: dq 0
	digits: dq 1
	exersices: dq 5
	rounds: dq 3
	again: db 0,0,0
	count_correct: dq 0
	count_wrong: dq 0
	correct_str: db "CORRECT"
	wrong_str: db "WRONG"
	str_amount1: db 10,"Amount correct answers: "
	str_amount2: db 10,"Amount wrong answers: "
	str4: db "Ready?: "
	str3: db "Enter your answer: "
	str5: db "Enter amount of digits: "
	str6: db "Enter amount of exercises: "
	str7: db "Enter amount of rounds: "
	str8: db 10,"Time elapsed: "
	str9: db 10,"Again = 1, Exit = other: "
	str10: db "Good bay",10
	str11: db "Enter amount of delay: "
	start_time_seconds: dq 0
	temp1: dq 0
	end_time_seconds: dq 0
	temp2: dq 0
	random_num: db 0
	seconds: dq 1,0
	seconds2: dq 5,0
	user_arr times 30 db 0
	num_arr times 30 db 0
	temp3 times 8 db 0
	temp4 times 4 db 0
	temp5 times 16 db 0
	character db 0
	stack_save: dq 0
	clean_amount: dq 0
	minutes: dq 0
	_seconds: dq 0
section .text
_start:
	run_game:
	mov rax,96
	mov rdi,start_time_seconds
	mov rsi,temp5
	mov rdx,temp2
	syscall
	call input_data_user
	call one_round_game
	mov rax,96
	mov rdi,end_time_seconds
	mov rsi,temp5
	mov rdx,temp2
	syscall
	call print_results
	call print_time
	mov rsi,str9
	mov rbx,26
	call print_str
	mov rsi,again
	mov rbx,3
	call input_str
	cmp byte[again],'1'
	je run_game
	mov rsi,str10
	mov rbx,9
	call print_str
	mov rax,35
	mov rdi,seconds2
	mov rsi,0
	syscall
	mov rax,60
	mov rdi,0
	syscall
gen_random_num:
	mov rbx,0
	mov r11,[digits]
	run1:
		push r11
		mov rax,96
		mov rdi,temp3
		mov rsi,temp5
		mov rdx,temp2
		syscall
		xor rax,rax
		mov eax,[temp4]
		xor rdx,rdx
		mov r12d,10
		cmp rbx,0
		je from_one
		div r12d
		jmp next1
		from_one:
		dec r12d
		div r12d
		inc dl
		next1:
		mov rdi,num_arr
		add dl,48
		mov [rdi+rbx],dl
		inc rbx
		pop r11
		dec r11
		jnz run1
	ret
str_to_num:
	xor rax,rax
	xor rdx,rdx
	xor r11,r11
	mov rbx,10
	mov rcx,[digits]
	run2:
		mul rbx
		mov r11b,[rdi]
		sub r11b,48
		add rax,r11
		inc rdi
		loop run2
	mov [num],rax	
	ret
	
str_to_num2:
	xor rax,rax
	xor rdx,rdx
	xor r11,r11
	mov rbx,10
	run5:
		mul rbx
		mov r11b,[rdi]
		sub r11b,48
		add rax,r11
		inc rdi
		cmp byte[rdi],10
		jne run5
	mov [num],rax	
	ret
one_round_game:
	run6:
	mov rsi,str4
	mov rbx,7
	call print_str
	mov rbx,1
	mov rsi,user_arr
	call input_str
	mov r12,[exersices]
	xor rax,rax
	mov [sum],rax
	run3:	
		push r12
		mov rax,96
		mov rdi,temp3
		mov rsi,temp5
		mov rdx,temp2
		syscall
		xor rax,rax
		mov eax,[temp4]
		xor rdx,rdx
		mov r13,20
		div r13
		inc rdx
		mov [clean_amount],rdx
		mov rax,1
		mov rdi,1
		mov rsi,spaces
		syscall
		call gen_random_num
		mov rax,1
		mov rdi,1
		mov rsi,num_arr
		mov rdx,[digits]
		syscall
		mov rax,35
		mov rdi,seconds
		mov rsi,0
		syscall
		mov rdi,num_arr
		call str_to_num
		mov rax,[num]
		add [sum],rax
		mov rax,[digits]
		add rax,[clean_amount]
		mov rdx,rax
		mov rax,1
		mov rdi,1
		mov rsi,clean_cursor_arr
		syscall
		mov rax,1
		mov rdi,1
		mov rsi,spaces
		mov rdx,50
		syscall
		mov rax,1
		mov rdi,1
		mov rsi,clean_cursor_arr
		mov rdx,50
		syscall
		pop r12
		dec r12
		jnz run3
	mov rsi,str3
	mov rbx,19
	call print_str
	mov rsi,user_arr
	mov rbx,20
	call input_str
	mov rbx,[digits]
	add rbx,19
	call clean_screen
	mov rdi,user_arr
	call str_to_num2
	mov rax,[sum]
	cmp rax,[num]
	jne wrong_ans
	mov rbx,7
	mov rsi,correct_str
	call print_str
	mov rbx,7
	inc qword[count_correct]
	jmp end_game_round_one
	wrong_ans:
	mov rbx,5
	mov rsi,wrong_str
	call print_str
	mov rbx,5
	inc qword[count_wrong]
	end_game_round_one:
	mov rax,35
	mov rdi,seconds2
	mov rsi,0
	syscall
	call clean_screen
	dec qword[rounds]
	cmp qword[rounds],0
	jne run6
	ret
	
print_str:
	mov rax,1
	mov rdi,1
	mov rdx,rbx
	syscall
	ret
input_str:
	xor rax,rax
	xor rdi,rdi
	mov rdx,rbx
	syscall
	ret
clean_screen:
	mov rax,1
	mov rdi,1
	mov rsi,clean_cursor_arr
	mov rdx,rbx
	syscall
	mov rax,1	
	mov rdi,1
	mov rsi,spaces
	mov rdx,50
	syscall
	mov rax,1
	mov rdi,1
	mov rsi,clean_cursor_arr
	mov rdx,50
	syscall
	ret
input_data_user:
	mov rsi,str5
	mov rbx,24
	call print_str
	mov rbx,10
	mov rsi,user_arr
	call input_str
	mov rdi,user_arr
	call str_to_num2
	mov rax,[num]
	mov [digits],rax
	mov rsi,str6
	mov rbx,27
	call print_str
	mov rbx,10
	mov rsi,user_arr
	call input_str
	mov rdi,user_arr
	call str_to_num2
	mov rax,[num]
	mov [exersices],rax
	mov rsi,str7
	mov rbx,24
	call print_str
	mov rbx,10
	mov rsi,user_arr
	call input_str
	mov rdi,user_arr
	call str_to_num2
	mov rax,[num]
	mov [rounds],rax
	mov rsi,str11
	mov rbx,23
	call print_str
	mov rsi,user_arr
	mov rbx,5
	call input_str
	mov rdi,user_arr
	call str_to_num2
	mov rax,[num]
	mov [seconds],rax
	ret
print_time:
	mov rax,[end_time_seconds]
	sub rax,[start_time_seconds]
	mov rbx,60
	mov rdx,0
	div rbx
	mov [_seconds],rdx
	mov [minutes],rax
	mov rdi,num_arr
	mov rbx,30
	call clean_arr
	mov rdi,num_arr
	mov rbx,10
	run8:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run8
	dec rdi
	mov rsi,num_arr
	run9:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run9
		
	mov rdi,user_arr
	mov rbx,30
	call clean_arr
	mov rax,[_seconds]
	mov rdi,user_arr
	mov rbx,10
	run10:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run10
	
	dec rdi
	mov rsi,user_arr
	run11:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run11
	mov rsi,str8
	mov rbx,15
	call print_str
	mov rsi,num_arr
	mov rbx,5
	call print_str
	mov al,':'
	mov [character],al
	mov rsi,character
	mov rbx,1
	call print_str
	mov rsi,user_arr
	mov rbx,5
	call print_str
	ret
clean_arr:
	mov rcx,rbx
	run12:
		mov byte[rdi],0
		inc rdi
		loop run12
	ret
print_results:
	mov rdi,num_arr
	mov rbx,30
	call clean_arr
	mov rax,[count_correct]
	mov rdi,num_arr
	mov rbx,10
	run13:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run13
	dec rdi
	mov rsi,num_arr
	run14:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run14
	mov rsi,str_amount1
	mov rbx,25
	call print_str
	mov rsi,num_arr
	mov rbx,5
	call print_str
	mov rdi,num_arr
	mov rbx,30
	call clean_arr
	mov rax,[count_wrong]
	mov rdi,num_arr
	mov rbx,10
	run15:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run15
	dec rdi
	mov rsi,num_arr
	run16:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run16
	mov rsi,str_amount2
	mov rbx,23
	call print_str
	mov rsi,num_arr
	mov rbx,5
	call print_str
	ret
		
		
		
		
		
		
		
