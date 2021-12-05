TITLE Program Template     (Proj6_lubranoa.asm)

; Author:  Alexander Lubrano
; Last Modified:  12/04/2021
; OSU email address: lubranoa@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  6 - String Primitives and Macros        Due Date:  12/05/2021
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; --------------------------------------------------------------------------------------
; Name: mGetString
;
; Dislpays a prompt to the user, gets the input from the user, stores it in a memory
;	  location, and returns the number of characters entered in EAX for validation.
;
; Preconditions: Do not use EAX, ECX, or EDX as arguments. Prompt string and string array
;	  at location of userStrLocation must be a string Byte array. The userStrBuffer is 
;	  the buffer size (length of the string array)
;
; Receives:
;	  promptStr = address of prompt string array
;	  userStrLocation = address of temp user string holder
;	  userStrBuffer	  = length of string array
;
; Returns: 
;	  userStrLocation = address of new user-entered string
;				  EAX = number of characters entered
;
; --------------------------------------------------------------------------------------
mGetString MACRO promptStr, userStrLocation, userStrBuffer
	push	ecx
	push	edx
	
	; display prompt
	mDisplayString	promptStr

	; Get user input and store at memory location in EDX
	mov		edx, userStrLocation	; Replaced by a memory location to store an entered string
	mov		ecx, userStrBuffer		; Replaced by an integer of how large the buffer is
	call	ReadString

	; ----------------------------------------------------------------------------------
	; The EAX register is not preserved or restored because it will hold the number of 
	;	  entered characters, excluding a null terminator, which will be used to check
	;	  the user entered nothing or something too big.
	;
	; ----------------------------------------------------------------------------------
	pop		edx
	pop		ecx

ENDM

; --------------------------------------------------------------------------------------
; Name: mDisplayString
;
; Prints a string from a provided memory location.
;
; Preconditions: Do not use EDX as an argument. Placeholder argument must be a 4 Byte
;     memory location. The array at that location must be a string Byte array.
;
; Receives:
;	  strLocation = string array address
;
; Returns: None
;
; --------------------------------------------------------------------------------------
mDisplayString	 MACRO   strLocation
	
	; Prints string Byte array to console
	push	edx
	mov		edx, strLocation	; strLocation placeholder is replaced by a memory offest
	call	WriteString
	pop		edx

ENDM

MIN_VALUE	 = 80000000h
MAX_VALUE	 = 7FFFFFFFh
MAX_STR_SIZE = 11
PLUS_ASCII	 = 43
MINUS_ASCII	 = 45
ZERO_ASCII	 = 48
NINE_ASCII	 = 57

.data
; Descriptive string Byte arrays for printing to console
titleStr	BYTE	"CS 271 ASSIGNMENT 6: Designing Low-Level I/O Procedures",13,10,"Written by: Alexander Lubrano",13,10,0
introStr	BYTE	"Please provide 10 signed decimal integers.",13,10,
					"Each number needs to be small enough to fit inside aaa 32-bit register. After you have",13,10,
					"finished entering the raw numbers, this program will display a list of the integers, their",13,10,
					"sum, and their average value.",13,10,0
promptStr	BYTE	"Please enter a signed integer: ",0
errorStr	BYTE	"ERROR: You did not enter a signed integer or your integer was too big.",13,10,"Please try again: ",0
listStr		BYTE	"You entered the following numbers: ",13,10,0
sumStr		BYTE	"The sum of these numbers is: ",0
avgStr		BYTE	"The truncated average is: ",0
byeStr		BYTE	"Hope this was fun!",13,10,"- Alex",0
; Data manipulation helpers
userStr		BYTE	13 DUP(0)	; Holds entered strings in ReadVal, helps WriteVal with conversion and holds WriteVal's final string array
mulHelper	SDWORD	1			; Holds a value to help multiply values in ASCII to digit conversion
userNum		SDWORD	0			; Helps ReadVal procedure with conversion and holds ReadVal's final number
userArray	SDWORD	10 DUP(?)	; Will hold numbers converted from user number strings
sumNum		SDWORD	0			; Helps with keeping track of the sum of the numbers

.code
main PROC

	mDisplayString offset titleStr	; Display title string
	call	CrLf

	mDisplayString offset introStr	; Display introduction string
	call	CrLf

	mov		ecx, 10					; Initialize ECX to 10 for loop below

	; ----------------------------------------------------------------------------------
	; Loop 10 times to get 10 number strings from user, gets ReadVal to validate and 
	;	  convert them, finds their correct index in userArray, and stores them there.
	;
	; ----------------------------------------------------------------------------------
	_getNumberLoop:
		
		; Push parameters to stack for ReadVal, and call ReadVal to get input from user
		push	offset promptStr			; Push address of promptStr string array (input parameter)
		push	offset errorStr				; Push address of errorStr string array (input)
		push	offset userStr				; Push address of userStr helper string array (input/output)
		push	DWORD ptr SIZEOF userStr	; Push length of userStr string array (input)
		push	offset userNum				; Push address of userNum helper label (output)
		push	offset mulHelper			; Push address of mulHelper helper label (input/output)
		call	ReadVal

		; ------------------------------------------------------------------------------
		; Take value in userNum and put it in its correct index of the userArray. This 
		;	  finds the correct index value using this equation: 
		;	  
		;	  Address of array[n] = (address of array) + (n * (TYPE of element))
		;
		; ------------------------------------------------------------------------------
		mov		edi, offset	userArray		
		mov		eax, 10
		sub		eax, ecx					; Gets correct index position (n)
		mov		ebx, TYPE userArray
		mul		ebx							; Gets correct Byte index position (n * (TYPE of element))
		mov		ebx, eax
		mov		eax, userNum				; Gets new number
		mov		[edi+ebx], eax				; Puts new number at (address of list) + (n * (TYPE of element))

		mov		edi, offset userNum
		mov		SDWORD ptr [edi], 0			; Clear userNum label

		loop	_getNumberLoop

	mDisplayString offset listStr
	call	CrLf
	
	mov		ecx, 10
	_writeLoop:
		mov		esi, offset	userArray		
		mov		eax, 10
		sub		eax, ecx
		mov		ebx, TYPE userArray
		mul		ebx
		mov		ebx, eax

		mov		eax, [esi+ebx]
		add		sumNum, eax

		push	DWORD ptr [esi+ebx]
		push	offset userStr
		push	offset mulHelper
		call	WriteVal

		mov		edx, offset userStr
		call	WriteString
		cmp		ecx, 1
		jz		_doneLooping
		mov		al, ','
		call	WriteChar
		mov		al, ' '

	_doneLooping:
		call	CrLf

	mDisplayString offset sumStr
	call	CrLf

	mDisplayString offset avgStr
	call	CrLf
	
	mDisplayString offset byeStr
	call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------------------------------------
; Name: ReadVal
;
; Invokes the mGetString macro to get a user-entered number, then converts the string of
;	  characters to its numerical value, validating along the way that it has no symbols 
;	  or letters, small enough to fit inside a 32-bit register, and that the user did 
;	  not just enter nothing.
;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;	  [ebp+28]  = address of prompt string array
;	  [ebp+24]  = address of error prompt string array
;	  [ebp+20]  = address of the temp user string array
;	  [ebp+16]  = number of characters the temp user string array can hold
;	  [ebp+12]  = address of temp user number label
;	  [ebp+8]   = address of multiplication helper label
;
; Returns: 
;	  EAX		= converted number from user string
; --------------------------------------------------------------------------------------
ReadVal PROC
	; Preserve used registers and assign static stack-fram pointer
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx			; May be overwritten after IMUL instructions so, preserve EDX just in case
	push	esi
	push	edi

	; Get new number string using mGetString macro with placeholders, address of promptStr,
	; address of userStr array label, and size of userStr array
	mGetString	DWORD ptr [ebp+28], DWORD ptr [ebp+20], DWORD ptr [ebp+16]
	jmp		_validate

	; Get a different numeer string after an invalid input
	_invalidInput:
		push	DWORD ptr [ebp+20]
		call	clearUserStr			; Clear userStr helper label to prep for new input
		mov		edi, [ebp+12]
		mov		SDWORD ptr [edi], 0		; Reset the userNum helper label to 0
		mov		edi, [ebp+8]
		mov		SDWORD ptr [edi], 1		; Reset the mulHelper label to 1

		; Get another number string from user using the same macro with placeholders, address 
		; of errorStr, address of userStr array label, and size of userStr array
		mGetString	DWORD ptr [ebp+24], DWORD ptr[ebp+20], DWORD ptr [ebp+16]
	
	; ----------------------------------------------------------------------------------
	; Check user's input for validity. The user string number cannot be nothing, cannot
	;	  be greater than 11 digits long, cannot contain characters other than -, +, or
	;	  the digits 0 through 9, nor can it be larger than what a 32-bit register can
	;	  contain (-2^31 to 2^31 - 1). 
	;
	; The number string can be 11 digits long because a number string starting with a
	;	  +/- will be 10 digits long, which is the number of digits of the max value a 
	;	  32-bit register can hold, i.e., -2^31 is equal tO -2,147,483,648, which is 10 
	;	  digits and a sign. 
	;
	; ----------------------------------------------------------------------------------
	_validate:
		cmp		eax, 0
		jz		_invalidInput			; If user input nothing, jump up to _invalidInput block
		cmp		eax, MAX_STR_SIZE
		ja		_invalidInput			; If user input something too large, jump up to _invalidInput block

		; ------------------------------------------------------------------------------
		; At this point, if number string has either sign at the 1st index, we can start 
		;	  to convert and check for more accurate out of range conditions.
		;
		; ------------------------------------------------------------------------------
		mov		esi, [ebp+20]
		cmp		BYTE ptr [esi], PLUS_ASCII
		jz		_convert				; If user input has a '+' at index 0, jump to convert
		cmp		BYTE ptr [esi], MINUS_ASCII
		jz		_convert				; If user input has a '-' at index 0, jump to convert
		cmp		eax, MAX_STR_SIZE
		jz		_invalidInput			; If user input has 11 characters but no sign, it's too big so, jump to _invalidInput
		
	; ----------------------------------------------------------------------------------
	; Convert the string to an integer. Each character is checked for being a digit 0-9,
	;	  and, if it is not, the number string is invalid, unless it is a + or - and it
	;	  is the leftmost character in the string.
	;
	; This conversion relies on starting at the last character in the array, and moving
	;	  left until the beginning is reached. Each successive iteration is multiplied
	;	  by a power of 10 to get its proper decimal position, then added to a running 
	;     total.
	;
	; ----------------------------------------------------------------------------------
	_convert:		
		
		mov		ecx, eax				; Initialize ECX to the number of entered characters
		mov		esi, [ebp+20]			; Initialize ESI to point to address of user input string
		add		esi, ecx
		dec		esi						; Points ESI at the last value of the user string
		mov		edi, [ebp+12]			; Initialize EDI to point to the temp user number label's address
		mov		ebx, 10					; Initialize EBX to hold the value 10
		
		
		; Top of loop
		_convertLoop:
			xor		eax, eax					; Clear EAX each iteration
			cmp		ecx, 1
			jz		_lastCharacter				; If ECX is 1, current character is leftmost(last) so, jump to _lastCharacter
			cmp		BYTE ptr [esi], ZERO_ASCII
			jb		_invalidInput
			cmp		BYTE ptr [esi], NINE_ASCII
			ja		_invalidInput				; Else, if current character != any digit ASCII, number is invalid so, jump to _invalidInput
			
		; Update value in userNum helper data label
		_updateUserNum:
			
			; Get character's actual value (all characters that reach this block are digits 0-9)
			mov		al, [esi]
			sub		al, ZERO_ASCII				; Subtract ZERO_ASCII value from character's ASCII value to get its numerical value
			
			; Multiply this iteration by its power of 10 (first iteration is multiplied by 1)
			push	esi
			push	edx
			mov		esi, [ebp+8]				; Put address of multiplication helper in ESI
			imul	DWORD ptr [esi]				; Multiply value in EAX by value in multiplication helper
			jo		_invalidInput				; If the multiplication resulted in an overflow condition, the number is too big
			pop		edx
			pop		esi

			; Add the value in EAX to the value in the UserNum label to update running total
			add		[edi], eax
			jo		_invalidInput				; If addition resulted in an overflow condition, the number is too big
			
			; If this is the last or 2nd to last character, they must be handled differently
			cmp		ecx, 1
			jz		_end						; If this is the last digit, don't need to update mulHelper so, jump to _end
			cmp		ecx, 2
			ja		_updateHelpers				; Else, if value is not 2nd to last, jump to _updateHelpers
												; Otherwise, continue down

		_secondToLast:
			dec		ecx							; Pre-decrement ECX in case of jump to top of loop
			dec		esi							; Pre-decrement ESI in case of jump to top of loop
			cmp		BYTE ptr [esi], ZERO_ASCII
			jb		_convertLoop
			cmp		BYTE ptr [esi], NINE_ASCII
			ja		_convertLoop				; If the character is not a digit, loop back to top
			inc		ecx
			inc		esi
			jmp		_updateHelpers				; Otherwise, character = digit so, re-increment ECX and ESI then jump to _updateHelpers
		
		_lastCharacter:
			cmp		BYTE ptr [esi], MINUS_ASCII
			jz		_convertNegative			; If last character ASCII = minus sign ASCII, jump to _convertNegative
			cmp		BYTE ptr [esi], PLUS_ASCII
			jz		_end						; Else, if last character ASCII = plus sign ASCII, jump to _end
			cmp		BYTE ptr [esi], ZERO_ASCII
			jb		_invalidInput
			cmp		BYTE ptr [esi], NINE_ASCII
			ja		_invalidInput				; Else, if last character != digit ASCII, the number is invalid so, jump to _invalidInput
			jmp		_updateUserNum				; Else, last character = digit so, jump to _updateUserNum


		; Convert negative string to negative integer
		_convertNegative:
			mov		eax, [edi]
			neg		eax
			mov		[edi], eax
			jmp		_end						; If execution reaches this block, it's done converting and can break out of loop

		; Updates mulitplication helper and ESI for next iteration, only when not on last and sometimes 2nd to last iterations
		_updateHelpers:
			
			; Multiplies the value in the mulHelper label by 10 to get the next power of 10
			push	edi
			push	edx
			mov		edi, [ebp+8]
			mov		eax, [edi]					; Put current power of 10 value in EAX, then multiply by 10
			imul	ebx
			jo		_invalidInput				; If this results in an overflow condition, the next value will too so, jump to _invalidInput
			mov		[edi], eax					; Otherwise, store the result in mulHelper
			pop		edx
			pop		edi
			
			; Decrement address in ESI to point to next character that is 1 Byte below current one in memory
			dec		esi
			
			; When ECX is 0, execution moves to next line of code below
			loop	_convertLoop				

	; Clears the helper string, resets mulHelper to 1
	_end:
		push	DWORD ptr [ebp+20]
		call	clearUserStr
		mov		edi, [ebp+8]
		mov		SDWORD ptr [edi], 1
	
	; Restore used registers, de-reference 24 Bytes of parameters, and return control to main
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
	ret		24

ReadVal ENDP

; --------------------------------------------------------------------------------------
; Name: WriteVal
;
; Converts a numeric Signed Doubleword data type to a string of ASCII characters.
;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;
; Returns: 
; --------------------------------------------------------------------------------------
WriteVal PROC

	ret
WriteVal ENDP

; --------------------------------------------------------------------------------------
; Name: clearUserStr
;
; Clears the userStr helper array for a new entry by changing all the bytes to 0 excpt
;	  the null terminator.
;
; Preconditions: The helper array must be a 13 Byte string array, including the null
;	  terminator
;
; Postconditions: All used registers are preserved and restored.
;
; Receives:
;	  [ebp+8]  = address of userStr array
;
; Returns: 
;	  userStr  = empty 13-Byte array
; --------------------------------------------------------------------------------------
clearUserStr PROC
	
	; Preserve used registers and assign static stack-fram pointer
	push	ebp
	mov		ebp, esp
	push	ecx
	push	edi

	; Initialize ECX to the number of Bytes to replace and EDI to point to the address of the array to modify
	mov		ecx, 12
	mov		edi, [ebp+8]
	
	; Set each Byte in the array to 0
	_clearLoop:
		mov		BYTE ptr [edi], 0
		add		edi, 1		; Increment address in EDI by 1 Byte
		loop	_clearLoop

	; Restore used registers, de-reference 4 Bytes of parameters, and return control to calling procedure
	pop		edi
	pop		ecx
	pop		ebp
	ret		4

clearUserStr ENDP

END main
