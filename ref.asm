TITLE reference     (ref.asm)

; Author: Jaspal Bainiwal
;      Date: 02/23/2018
; Description: The program is broken down into subroutines introduction, get_data, 
;fill_array, sort, display_median, and display_list. The parameters for the functions
;are passed as reference. The program validates the user request for number of integers
;to randomize in a array. The data is first displayed as unsorted, then I use the bubble
;sort algorithm to sort the array. Next I find the median and display the sorted array.

INCLUDE Irvine32.inc

max = 200
min = 10
lo	= 100
hi	= 999

.data

myIntro				BYTE	"          Programmed by Jaspal Bainiwal",0
user_directions1	BYTE	"This program generates random numbers in the range [100 .. 999],",0
user_directions2	BYTE	"displays the original list, sorts the list, and calculates the",0
user_directions3	BYTE	"median value. Finally, it displays the list sorted in descending order.",0
prompt1				BYTE	"How many numbers should be generated? [10 .. 200]: ",0
notInRange			BYTE	"Invalid input",0
myMedian			BYTE	"The median is ",0
unSorted_msg		BYTE	"The unsorted random numbers:",0
Sorted_msg			BYTE	"The Sorted list:",0
myArray				DWORD	200 DUP (?)
count				DWORD	?

.code
main PROC

	call	introduction

	push	OFFSET count
	call	get_data

	call	Randomize						;intialize random seed
	push	OFFSET	myArray
	push	count
	call	fill_array

	push	OFFSET unSorted_msg
	push	OFFSET myArray
	push	count
	call	display_list

	push	OFFSET myArray
	push	count
	call	sort

	push	OFFSET myArray
	push	count
	call	display_median

	push	OFFSET Sorted_msg
	push	OFFSET myArray
	push	count
	call	display_list

	exit	
main ENDP

;*********************************************************************
;Introduction procedure, very simle function which displays intro, 
;and directions.
;**********************************************************************
introduction PROC

	mov		edx, OFFSET myintro
	call	WriteString
	call	CrLf

	mov		edx, OFFSET user_directions1
	call	WriteString
	call	CrLf

	mov		edx, OFFSET user_directions2
	call	WriteString
	call	CrlF

	mov		edx, OFFSET user_directions3
	call	WriteString
	call	CrLf
	call	CrLf

	ret
introduction	ENDP

;*********************************************************************
;The get data function, pushes the count address onto the stack.
;I validate the user count number and if it is within range return it
;to the count variable. I used the demo5 as a guideline to complete this
;procedure.
;**********************************************************************
get_data PROC

	push	ebp
	mov		ebp, esp
	
	countDataLoop:
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt

	cmp		eax, min
	jnge	outOfRange
	cmp		eax, max
	jnle	outOfRange

	jmp		validNumber
	
	outOfRange:
	mov		edx, OFFSET notInRange
	call	WriteString
	call	CrLf
	jmp		countDataLoop

	validNumber:
	call	CrLf
	mov		ebx, [ebp + 8]
	mov		[ebx], eax
	pop		ebp
	ret		4

get_data ENDP

;*********************************************************************
;The fill array function pushes myarray and count to the stack. I add the
;count value to the ecx, so I can loop and fill the array with random integers.
;The againLoop uses the algorithm outlined in our lecture 20 video, 
;which first gets a range for the irvine library procedure RandomeRange.
;The irvine library randomrange calculates the randome numbers within range
;of [0 .. n-1], so that is why I first do hi - lo and then inc eax by 1.
;however since I am off by 100 I have to add lo to eax.
;**********************************************************************
fill_array  PROC
	
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp + 8]			;count is now in ecx so the loop will perform the count amount of times
	mov		edi, [ebp + 12]
	
	againLoop:

	mov		eax, hi					;999 - 100 = 899 (range = hi - lo + 1)
	sub		eax, lo					; so range is from 0 to 898
	inc		eax						;make range 1 to 899
	call	Randomrange
	add		eax, lo					;makes range 100 to 999

	mov		[edi], eax
	add		edi, 4
	loop	againLoop

	pop		ebp
	ret		8

fill_array ENDP

;*********************************************************************
;The sort procedure pushes the array and and count onto the stack. I add
;the count value to the ecx register and decrement by 1. I use the bubble
;sort algorithm and use the code from our book on pg 375 to outline my
;implementation of the algorithm. my sort procedure uses the nested loop
;to sort the numbers the inner loop is done by pushing the ecx to the stack
;and looping the number of times ecx to exchange the numbers if esi >= [esi +4]
;Once that is done the outer loop resets and points to first value in the array
;which is done by the instruction mov edi, [ebp + 12]. The processes is repeated
;until cx1 is > 0.
;**********************************************************************
sort PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp + 8]

	dec		ecx							;decrement count by 1 

	L1:
	push	ecx
	mov		edi, [ebp + 12]

	L2:
	mov		eax, [edi]
	cmp		[edi + 4], eax
	jl		L3
	xchg	eax, [edi + 4]
	mov		[edi], eax

	L3:
	add		edi, 4
	loop	L2

	pop		ecx
	loop	L1

	L4:		
	pop		ebp
	ret		8

	
sort ENDP

;*********************************************************************
;The display median procedure receives the address of array and the count
;onto the stack. I move the count to the eax register and then I divide
;by two to determine if even or odd, by looking at the remainder register edx.
;If the number was even then jmp to number is even, once there I move the 
;quotient to the edx register and decrement by 1 and then multiply by 4,
;so I can add that many bytes to the address of the array. Then I move that 
;value to the eax register, increment edx by 1 and add the next array elements
;value into the eax register. Finally I divide by two and then display median.
;The number_is_odd works similarly except since odd arrays the median is easy
;to find, I just move the middle element into the eax register and display the
;median.
;**********************************************************************
display_median PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp + 8]					;count value is now in eax
	mov		edi, [ebp + 12]

	mov		edx, 0							;clear the remainder
	mov		ebx, 2							
	cdq
	div		ebx								;divide count / 2

	cmp		edx, 0							;if % 2 == 0 then even numbered array
	je		number_is_even
	jmp		number_is_odd

	number_is_even:
	mov		edx, eax						;if count is 20 then eax has value of 10, so move that to edx
	dec		edx								;if edx is is 10 then edi right now is pointing to first element then need to dec by 1
	mov		eax, [edi + edx * 4]			;now 40 bytes away would be array[10]
	inc		edx								;add to edx so I can multiply it by 4 to get index 11
	add		eax, [edi + edx *4]				
	mov		ebx, 2
	cdq		
	div		ebx
	jmp		return

	number_is_odd:
	mov		edx, eax						;if count is 21 then that means eax is 10 so move that to edx								
	mov		eax, [edi + edx * 4]			;to get myArray[11] since adding 10 * 4 would add 40 after the first address which would be index 11


	return:
	call	CrLf
	mov		edx, OFFSET myMedian
	call	WriteString
	call	WriteDec
	mov		al, '.'
	call	WriteChar
	call	CrLf
	call	CrLf
	pop		ebp
	ret		8

display_median ENDP

;*********************************************************************
;The display_list procedure receieves the address of the array, count 
;and the title. I store the count in the ecx register so that the 
;amount the user entered can be used for the loop counter. The address of the
;array is stored in the esi and the value when I am looping is moved to 
;the eax register. From there I call WriteDec to display the value currently
;in eax. Then I add 4 bytes to esi to address the next array element.
;I use the ebx register to keep track of when it is time to call carriage
;row. Once the ecx counter reaches zero then I jump to return and 
;this time return 12 bytes plus pop the stack.
;**********************************************************************
display_list PROC

	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp + 8]					;count value in ecx
	mov		esi, [ebp + 12]					;array
	mov		edx, [ebp + 16]					;title reference
	
	call	WriteString						;title passed by reference and stored in edx
	call	CrLf

	mov		ebx, 0							
	moreLoop:
	mov		eax, [esi]
	call	WriteDec
	mov		al, ' '
	call	WriteChar
	mov		al, 32
	call	WriteChar
	add		esi, 4

	inc		ebx
	cmp		ebx, 10
	je		carriageRow
	loop	moreLoop
	call	CrLf
	jmp		return

	carriageRow:
	sub		ebx, 10
	call	CrLf
	loop	moreLoop

	return:
	pop		ebp
	ret		12

display_list ENDP
END main

