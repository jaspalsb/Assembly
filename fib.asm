TITLE Fibo    (fib.asm)

; Author: Jaspal Bainiwal          Date: 01/27/2018


INCLUDE Irvine32.inc

.data
number_1			 =		1 ; symbolic constant to be used for cmp
number_46			 =		46
first_number		DWORD	? ; first number for the fibonacci calculation
row					DWORD	? ; row accumulator
spacer				BYTE	"     ",0
intro_1				BYTE	"Fibonacci" ,0	
intro_2				BYTE	"Programmed by Jaspal Bainiwal",0
name_prompt			BYTE	"What's your name? ", 0
name_input			BYTE	33 DUP(0)
hello_display		BYTE	"Hello, ",0
instructions_1		BYTE	"Enter the number of Fibonacci terms",0
instructions_2		BYTE	"Give the number as an integer in the range",0
terms_prompt		BYTE	"How many Fibonacci terms do you want? ",0
terms_input			DWORD	?
out_of_range		BYTE	"Enter a number in [1 .. 46]",0
goodbye				BYTE	"Results certified by Jaspal Bainiwal.", 0
goodbye_user		BYTE	"Goodbye, ",0



.code
main PROC

;introduction
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLF
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLF
	call	CrLF

	mov		edx, OFFSET name_prompt
	call	WriteString
	mov		edx, OFFSET name_input
	mov		ecx, 32
	call	ReadString

	mov		edx, OFFSET hello_display
	call	WriteString
	mov		edx, OFFSET name_input
	call	WriteString
	call	CrLf

;userInstructions
	mov		edx, OFFSET instructions_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	instructions_2
	call	WriteString
	call	CrLf
	call	CrLf

;getUserData

do:
	mov		edx, OFFSET terms_prompt			;data validation used as a do while loop
	call	WriteString
	call	ReadInt
	mov		terms_input, eax

	cmp		eax, number_1						;while part of the do while loop
	jl		outOfRange							;jump if lesser
	cmp		eax, number_46
	jg		outOfRange							; jump if greater
	jmp		displayFibs

outOfRange:
	mov		edx, OFFSET out_of_range
	call	writeString
	call	CrLF
	jmp		do

displayFibs:
	;initialize
	mov		ecx, terms_input					;calculate number of times to execute the loop
	mov		eax, 1								
	mov		first_number, eax					; move 1 to first number
	mov		ebx, first_number					; move 1 to ebx	
	dec		ebx									; decrease ebx register to zero
	mov		row, ebx							;initialize row to zero

top:
	inc		row									;increment row 
	mov		eax, first_number
	add		eax, ebx
	mov		first_number, ebx
	mov		ebx, eax
	call	WriteDec
	mov		edx, OFFSET spacer
	call	WriteString
	cmp		row, 5								;compare row increments to 5
	je		carriageRow							; jump if equal to loc carriageRow
	loop	top
	jmp		farewell

carriageRow:
	sub		row, 5								;subtract 5 from row to return it back to 0
	call	CrLf
	loop	top

farewell:
	call	CrLF
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLF
	mov		edx, OFFSET goodbye_user
	call	WriteString
	mov		edx, OFFSET name_input
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
