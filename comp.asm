TITLE Composite     (comp.asm)

; Author: Jaspal Bainiwal    
;Date: 02/17/2018
; This program asks the user how many composites they wish to display
;The program uses data validation to check if the number to display is within range.
;The program is broken down into subroutines that are called from main procedure.
;For the showcomposite procedure it is implemented with loops and the isComposite
;procedure is implemented with nested loop to deteremine if current integer is composite or not.

INCLUDE Irvine32.inc


.data
lower_limit		  =		0
upper_limit		  =		400
nameIntro		BYTE	"Composite Numbers           Programmed by Jaspal bainiwal",0
directions		BYTE	"Enter the number of composite numbers you would like to see.",0
directions2		BYTE	"I'll accept orders for up to 400 composites.",0
getData			BYTE	"Enter the number of composites to display [1 ... 400]: ",0
outOfRange		BYTE	"Out of range. Try again.",0
userData		DWORD	?
composite		DWORD	?
tracker			DWORD	?
seven			DWORD	7
five			DWORD	5
three			DWORD	3
two				DWORD	2
printComposite	DWORD	?
row				DWORD	?
spacer1			BYTE	"     ",0
spacer100		BYTE	"    ",0
spacer1000		BYTE	"   ",0
byeMessage		BYTE	"Results Certified by Jaspal Bainiwal. Goodbye.",0

.code
main PROC

	call	introduction
	call	getUserData
	call	showComposite
	call	farewell
	
	exit	

main ENDP

introduction PROC
	mov		edx, OFFSET nameIntro
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET directions
	call	WriteString
	call	CrLf

	mov		edx, OFFSET directions2
	call	WriteString
	call	Crlf
	call	CrLf
	
	ret
introduction ENDP

getUserData PROC

	mov		edx, OFFSET getData
	call	WriteString
	
	call	ReadDec
	mov		userData, eax

	call	validate
	
	ret

getUserData ENDP

validate PROC
	
	mov		eax, userData
	cmp		eax, lower_limit 
	jbe		outRange
	cmp		eax, upper_limit
	ja		outRange
	jmp		return

	outRange:
	mov	edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
	call	getUserData
	ret
	
	return:
	
	ret

validate ENDP

showComposite PROC

	;intialize
	mov		composite, 4
	mov		eax, userData
	mov		tracker, eax
	mov		row, 0
	
	track:
	cmp		tracker, 0						;first I track the number of composites user wants to display
	JBE		return							;If the tracker reaches 0 that means I have displayed all the composites
	call	isComposite						
	cmp		printComposite, 1				;Similar to c++ if true then bool value is 1
	JE		show							;If true then number returned from isComposite is composite so I need to jmp to show

	show:
	inc		row								;column alignment
	mov		eax, composite
	call	WriteDec
	cmp		eax, 10
	JB		lessThanTen
	cmp		eax, 100
	JB		lessThanHun
	cmp		eax, 1000
	JB		lessThanthou

	lessThanTen:
	mov		edx, OFFSET spacer1
	call	WriteString
	cmp		row, 10
	je		carriageRow
	jmp		restore

	lessThanHun:
	mov		edx, OFFSET spacer100
	call	WriteString
	cmp		row, 10
	je		carriageRow
	jmp		restore

	lessThanThou:
	mov		edx, OFFSET spacer1000
	call	WriteString
	cmp		row, 10
	je		carriageRow
	jmp		restore

	carriageRow:
	sub		row, 10
	call	CrLf

	restore:
	dec		tracker							;Once composite is displayed I decrease my tracker
	mov		printComposite, 0				
	inc		composite						;increment composite by 1 so I can test the next number if it is composite
	jmp		track

	return:
	call	CrLf
	ret

showcomposite ENDP

isComposite PROC
	
	;intialize
	mov		ecx, userData

	compositeLoop:
	mov		edx, 0							;if number div by 7,5,3,2 has remainder of 0
	mov		eax, composite					;then jmp to yesComposite and make 
	div		seven							;print composite true
	cmp		composite, 7
	JE		skip
	cmp		edx, 0
	JE		yesComposite
	
	mov		edx, 0	
	mov		eax, composite
	div		five
	cmp		composite, 5
	JE		skip
	cmp		edx, 0
	JE		yesComposite
	
	mov		edx, 0
	mov		eax, composite
	div		three
	cmp		edx, 0
	JE		yesComposite

	mov		edx, 0
	mov		eax, composite
	div		two
	cmp		edx, 0
	JE		yesComposite
	
	inc		composite
	loop	compositeLoop									

	skip:
	inc		composite
	loop	compositeLoop

	yesComposite:
	mov		printComposite, 1
	ret

isComposite ENDP

farewell PROC
	call	CrLf
	mov		edx, OFFSET byeMessage
	call	WriteString
	call	CrLf
	ret
farewell ENDP

END main
