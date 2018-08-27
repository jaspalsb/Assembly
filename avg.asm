TITLE average     (avg.asm)

; Author: Jaspal Bainiwal            Date: 02/11/2018


INCLUDE Irvine32.inc

.data
lower_limit	= -100
upper_limit = -1
intro				BYTE	"Welcome to the Integer Accumulator by Jaspal Bainiwal", 0
name_prompt			BYTE	"What is your name ?", 0
name_input			BYTE	33 DUP(0)
name_prompt2		BYTE	"Hello, ", 0
instructions		BYTE	"Please enter numbers [-100, -1].", 0
instructions2		BYTE	"Enter a non-negative number when you are finished",0
enter_number		BYTE	"Enter number: ",0
entered_num			DWORD	?
accumulator			DWORD	?
display_counter		BYTE	"You entered ", 0
space				BYTE	" ", 0
display_counter2	BYTE	" valid numbers ", 0
sum					DWORD	?
average				DWORD	?
sum_message			BYTE	"The sum of your valid numbers is ", 0
avg_message			BYTE	"The rounded average is", 0
bye					BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
special_goodbye		BYTE	"No negative numbers were entered! ", 0


.code
main PROC

;intro PROC
	mov		edx, OFFSET intro				;introduction line 1
	call	WriteString
	call	Crlf

	mov		edx, OFFSET name_prompt			;user name intro
	call	WriteString
	mov		edx, OFFSET name_input
	mov		ecx, 32
	call	ReadString

	mov		edx, OFFSET name_prompt2
	call	WriteString
	mov		edx, OFFSET name_input
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET instructions		;entering number instructions
	call	WriteString
	call	CrLf

	mov		edx, OFFSET instructions2
	call	WriteString
	call	CrLf

;Get data proc
	;initialize data
	mov		eax, accumulator				;initialize accumulator
	add		eax, 0
	mov		accumulator, eax
	
	mov		eax, sum						;intialize sum
	add		eax, 0
	mov		sum, eax

	mov		eax, average					;intialize average
	add		eax, 0
	mov		average, eax
	
	dataloop:
	mov		edx, OFFSET enter_number
	call	WriteString
	call	ReadInt
	mov		entered_num, eax
	cmp		eax, lower_limit				;jump if less than -100
	jl		less_than_100
	cmp		eax, upper_limit				; jump if greater than -1
	jg		non_negative
	add		eax, sum
	mov		sum, eax
	inc		accumulator
	
	loop	dataloop

	less_than_100:
	loop	dataloop


;Calculate proc
	non_negative:
	mov		eax, accumulator				;calculate to see if user entered only non negative number
	cmp		eax, 0
	je		specialGoodbye


	calculate:
	;average
	mov		eax, sum
	cdq										;convert double to quad
	mov		ebx, accumulator
	idiv	ebx
	mov		average, eax
	call	Display


;Display results proc
	Display:
	mov		edx, OFFSET display_counter
	call	WriteString
	mov		edx, OFFSET space
	call	WriteString
	mov		eax, accumulator
	call	WriteDec
	mov		edx, OFFSET display_counter2
	call	WriteString
	mov		edx, OFFSET space
	call	WriteString
	call	CrLf

	mov		edx, OFFSET sum_message
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	Crlf

	mov		edx, OFFSET avg_message
	call	WriteString
	mov		edx, OFFSET space
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	CrLf
	call	Goodbye

;Goodbye proc
	specialGoodbye:
	mov		edx, OFFSET special_goodbye
	call	WriteString
	call	Crlf

	Goodbye:
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET space
	call	WriteString
	mov		edx, OFFSET name_input
	call	WriteString
	call	CrLf
	exit	

main ENDP


END main
