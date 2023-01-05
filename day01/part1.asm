%include "util.inc"		;use util file

section .data
	file db "input.txt", 0	;input file name
	bufferNBE db "The buffer is not big enough", 10, 0
	nl db 10		;newline character
	answerMSG db "The answer is: ", 0

	bufferlen equ 15360	;buffer length

section .bss
	buffer resb bufferlen	;allocate bufferlen length

section .text
	global _start

; r8: holds the current number
; r9: holds pointer to the current character
; r10: holds the current calories
; stack: holds the highest calories and some other things
; rax: temporary use

;startup logic
_start:
	;open file
	mov rax, 2
	mov rdi, file		;file name
	syscall
	push rax		;save file descriptor for later

	mov r9, buffer		;set r9 to the buffer
	push 0			;current highest calories

	;write file to buffer
	mov rdi, rax		;get file descriptor
	mov rax, 0
	mov rsi, buffer
	mov rdx, bufferlen
	syscall

	cmp rax, bufferlen
	je _possibleError	;if they are equal, the buffer might not have gotten everything
	

;add the next digit to the current number
_addNextDigit:
	xor rax, rax		;clear rax
	imul r8, 10		;make space for another digit
	mov al, [r9]		;set al to the digit/char
	sub rax, 48		;subtract 48 to make the char into digit
	add r8, rax		;add number to r8

;read the next char
_readNextChar:
	inc r9			;next char

	cmp byte [r9], 10
	jg _addNextDigit	;the char is a number
	jl _lastMinuteLogic	;the char is a 0, there is nothing left in buffer

	;the char has to be a newline at this point, so we either add new number or compare our number to the current highest
	cmp r8, 0
	je _compareCalories	;if r8 is already 0, there was a newline before this one

	add r10, r8		;add the current number to the calories
	xor r8, r8		;reset the number

	jmp _readNextChar

;compare the current calories to the top calories
_compareCalories:
	;set rax to r10 to be able to clear r10
	mov rax, r10
	xor r10, r10

	cmp rax, [rsp]
	jl _readNextChar	;read the next char if the current calories is not greater than the highest calories

;logic for setting the new highest calories
_newHighestCalories:
	mov [rsp], rax

	cmp r8, 1
	je _exit		;if r8 is 1, then we are at the end

	jmp _readNextChar

;if the buffer didn't get everything
_possibleError:
	print 0, bufferNBE, 0
	return 1

;since there isn't a double newline at the end, we have to do some last minute things
_lastMinuteLogic:
	add r10, r8		;add the current number to the calories
	mov rax, r10		;since _newHighestCalories uses rax
	mov r8, 1		;set r8 to 1 to signify the end
	cmp r10, [rsp]
	jg _newHighestCalories
	
;exit logic
_exit:
	;get highest calories
	pop rax
	print 1, answerMSG, 0
	printInt rax
	print 1, nl, 1

	;close file
	mov rax, 3
	pop rdi			;get file descriptor
	syscall

	return 0
