%macro return 1			;exit code
	mov rax, 60		;sys_exit
	mov rdi, %1		;exit code
	syscall
%endmacro

%macro print 3			;file descriptor (1: output, 2: error), null terminated string, length
	; push values unto stack to retrieve later
	push rax
	push rdx
	push rsi
	push rdi

	mov rax, %2		;set rax to the string
	mov rdx, %3		;set rdx to the length

	cmp rdx, 0
	jne %%printString	;if the length is not 0, we can print the string right away

%%getLength:
	inc rax			;get next char of string
	inc rdx			;add 1 to the length

	cmp byte [rax], 0
	jne %%getLength		;continue if not at end of string

%%printString:
	;print the string
	;rdx is the length of string already
	mov rax, 1
	mov rdi, %1
	mov rsi, %2
	syscall

	;retrieve the values
	pop rdi
	pop rsi
	pop rdx
	pop rax
%endmacro

%macro printInt 1		;print a whole number with 20 digits maximum
	;push values unto stack to retrieve later
	push rax
	push rdx
	push rdi
	push rsi

	mov rax, %1		;rax is set to the int
	mov rdi, 0		;rdi set to 0 to count length of int
	mov rsi, 10		;set the divisor to 10

%%numberToString:
	mov rdx, 0		;rdx set to 0 for the divison

	div rsi			;divide rax by rsi
	add rdx, 48		;add 48 to remainder to turn from digit to char
	push rdx		;push rdx onto the stack

	inc rdi			;add 1 to the length
	cmp rax, 0
	jne %%numberToString	;continue for the full number

	mov rdx, DigitSpace	;rdx now used for a pointer to load number to digitspace

%%loadIntoDigitSpace:
	pop rsi			;get number
	mov [rdx], sil		;move number into digitspace
	inc rdx			;set rdx to next space

	inc rax			;add 1 to the length
	cmp rax, rdi		;compare the lengths to know when to stop
	jne %%loadIntoDigitSpace

	;print the number
	mov rdx, rdi		;set rdx to the length
	mov rax, 1
	mov rdi, 1
	mov rsi, DigitSpace
	syscall

	;retrieve the values
	pop rsi
	pop rdi
	pop rdx
	pop rax
%endmacro

section .bss
	DigitSpace resb 20	;reserve 20 bytes for 20 digits