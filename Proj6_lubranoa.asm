TITLE Designing Low-Level I/O Procedures     (Proj6_lubranoa.asm)

; Author:  Alexander Lubrano
; Last Modified:  12/05/2021
; OSU email address:  lubranoa@oregonstate.edu
; Course number/section:  CS271 Section 400
; Project Number:  6 - String Primitives and Macros        Due Date:  12/05/2021
; Description: This program introduces itself, prints introductory instructions to the
;	  user, has the user input 10 values, validating that each one meets specifications,
;	  converts them from input strings to values, and stores them in an array. Then,
;	  the program converts the values from numbers to strings, displays the entered 
;	  numbers, calculates and converts the sum from number to string to display it, and
;	  calculates and converts a truncated average from number to string to display it,
;	  then displays a goodbye message. All strings are displayed via macros. All user 
;	  input is captured via macros also.

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
;	  userStrLocation = address of new user-entered string in temp user string holder
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

MAX_STR_SIZE = 11
MAX_ARR_SIZE = 13
PLUS_ASCII	 = 43
MINUS_ASCII	 = 45
ZERO_ASCII	 = 48
NINE_ASCII	 = 57

.data
; Descriptive string Byte arrays for printing to console
titleStr	BYTE	"CS 271 ASSIGNMENT 6: Designing Low-Level I/O Procedures",13,10,"Written by: Alexander Lubrano",13,10,0
introStr	BYTE	"Please provide 10 signed decimal integers.",13,10,
					"Each number needs to be small enough to fit inside a 32-bit register. After you have",13,10,
					"finished entering the raw numbers, this program will display a list of the integers, their",13,10,
					"sum, and their average value.",13,10,0
promptStr	BYTE	"Please enter a signed integer: ",0
errorStr	BYTE	"ERROR: You did not enter a signed integer or your integer was too big.",13,10,"Please try again: ",0
listStr		BYTE	"You entered the following numbers: ",13,10,0
sumStr		BYTE	"The sum of these numbers is: ",0
avgStr		BYTE	"The truncated average is: ",0
byeStr		BYTE	"Hope this was fun!",13,10,"- Alex",0
; Data manipulation helpers
userStr		BYTE	MAX_ARR_SIZE DUP(0)	; Holds entered strings in ReadVal, helps WriteVal with conversion and holds WriteVal's final string array
mulHelper	SDWORD	1					; Holds a value to help multiply values in ASCII to digit conversion
userNum		SDWORD	0					; Helps ReadVal procedure with conversion and holds ReadVal's final number
userArray	SDWORD	10 DUP(?)			; Will hold numbers converted from user number strings
sumNum		SDWORD	0					; Helps with keeping track of the sum of the numbers
revStr		BYTE	MAX_ARR_SIZE DUP(0)

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

	call	CrLf
	mDisplayString offset listStr	; Display list string
	
	mov		ecx, 10					; Initialize ECX for loop below

	; ----------------------------------------------------------------------------------
	; Loop 10 times to call the WriteVal procedure, converting each value in the user
	;	  array to a string and printing each to the console, each followed by a comma
	;	  and space character, except the last value.
	; 
	; ----------------------------------------------------------------------------------
	_writeLoop:
		
		; Get current index of array using (address of array[n]) = (address of array) + (n * (TYPE of array))
		mov		esi, offset	userArray
		mov		eax, 10
		sub		eax, ecx				; Get current index of array (n)
		mov		ebx, TYPE userArray
		mul		ebx						; Get current Byte index of array (n * (TYPE of array))
		mov		ebx, eax

		mov		eax, [esi+ebx]			; Get value at current index of array (address of array + (n * (TYPE of array)))
		add		sumNum, eax				; Add to sumNum value for running sum of values

		; Push parameters to stack for WriteVal, then call WriteVal to display the value as a string
		push	SDWORD ptr [esi+ebx]	; Push value at current address of userArray (input)
		push	offset userStr			; Push address of userStr helper (input/output)
		push	offset revStr			; Push address of revStr helper (input/output)
		push	SDWORD ptr 10			; Push the value 10 (input)
		call	WriteVal

		cmp		ecx, 1
		jz		_doneLooping			; If it's the last iteration, skip the ',' and ' ' printing, otherwise, print them
		mov		al, ','
		call	WriteChar
		mov		al, ' '
		call	WriteChar

		; Clear userStr and revStr for use again later
		push	offset userStr
		call	clearStrArray
		push	offset revStr
		call	clearStrArray
		
		loop	_writeLoop				; Loop back up until ECX = 0

	_doneLooping:
		call	CrLf
	
	; Clear userStr and revStr for use again later
	push	offset userStr
	call	clearStrArray
	push	offset revStr
	call	clearStrArray
	
	mDisplayString offset sumStr	; Display sum string
	
	; Push parameters on stack for WriteVal, then call WriteVal to display the value as a string
	push	sumNum					; Push final sum to stack for WriteVal (input)
	push	offset userStr
	push	offset revStr
	push	SDWORD ptr 10
	call	WriteVal
	call	CrLf

	; Clear userStr and revStr for use again later
	push	offset userStr
	call	clearStrArray
	push	offset revStr
	call	clearStrArray

	mDisplayString offset avgStr	; Dispaly average string
	
	; Divide sum by 10 to get the average
	mov		eax, sumNum
	mov		ebx, 10
	cdq								; Sign extend into EDX, precondition for IDIV
	idiv	ebx						; Divide the sum by 10
	
	; Push parameters on stack for WriteVal, then call WriteVal to display the value as a string
	push	eax						; Push the truncated average (quotient of division) to stack for WriteVal (input)
	push	offset userStr
	push	offset revStr
	push	SDWORD ptr 10
	call	WriteVal
	call	CrLf
	call	CrLf
	
	mDisplayString offset byeStr	; Display farewell string
	call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------------------------------------
; Name: ReadVal
;
; Invokes the mGetString macro to get a user-entered number, then converts the string of
;	  characters to its numerical value, validating along the way that it has no symbols 
;	  or letters, that it is small enough to fit inside a 32-bit register, and that the 
;	  user did not just enter nothing.
;
; Preconditions: All passed string arrays must be of type BYTE. Number of characters
;	  must be of type DWORD. User number helper label and multiplication helper must
;	  be of type SDWORD.
;
; Postconditions: All used registers are preserved and restored
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
;	  userNum	= converted number from user string
;	  userStr	= always reset to empty
;	  mulHelper = always reset to 1
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
		call	clearStrArray			; Clear userStr helper label to prep for new input
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
		cmp		eax, 0					; EAX holds the number of characters entered, excluding null terminator
		jz		_invalidInput			; If user input no characters, jump up to _invalidInput block
		cmp		eax, MAX_STR_SIZE
		ja		_invalidInput			; If user input too many characters, jump up to _invalidInput block

		; ------------------------------------------------------------------------------
		; At this point, if number string has either sign at the 1st index, we can start 
		;	  to convert and check for more accurate out of range conditions.
		;
		; ------------------------------------------------------------------------------
		mov		esi, [ebp+20]
		cmp		BYTE ptr [esi], PLUS_ASCII
		jz		_convertNum				; If user input has a '+' at index 0, jump to convert
		cmp		BYTE ptr [esi], MINUS_ASCII
		jz		_convertNum				; If user input has a '-' at index 0, jump to convert
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
	_convertNum:		
		
		mov		ecx, eax				; Initialize ECX to the number of entered characters
		mov		esi, [ebp+20]			; Initialize ESI to point to address of user input string
		add		esi, ecx
		dec		esi						; Points ESI at the last value of the user string
		mov		edi, [ebp+12]			; Initialize EDI to point to the user number label's address
		mov		ebx, 10					; Initialize EBX to hold the value 10
		
		
		; Top of string conversion loop
		_convertNumLoop:
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
			std									; Set direction flag for LODSB
			LODSB								; Load ASCII value from address of userStr in ESI into AL and decrement ESI
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
			sub		[edi], eax
			jo		_invalidInput				; If addition resulted in an overflow condition, the number is too big
			
			; If this is the last or 2nd to last character, they must be handled differently
			cmp		ecx, 1
			jz		_end						; If this is the last digit, don't need to update mulHelper so, jump to _end
			cmp		ecx, 2
			ja		_updateHelpers				; Else, if value is not 2nd to last, jump to _updateHelpers
												; Otherwise, continue down

		; Checks if last character is a digit on second to last iteration
		_secondToLast:
			dec		ecx							; Pre-decrement ECX in case of jump to top of loop
			cmp		BYTE ptr [esi], ZERO_ASCII
			jb		_convertNumLoop
			cmp		BYTE ptr [esi], NINE_ASCII
			ja		_convertNumLoop				; If the character is not a digit, loop back to top
			inc		ecx
			jmp		_updateHelpers				; Otherwise, character = digit so, re-increment ECX and ESI then jump to _updateHelpers
		
		; Handles last character differently if it is a positive sign, non-sign, or negative sign
		_lastCharacter:
			cmp		BYTE ptr [esi], PLUS_ASCII
			jz		_convertToPosNum			; If last character ASCII = plus sign ASCII, jump to _convertToPosNum
			cmp		BYTE ptr [esi], MINUS_ASCII
			jnz		_nonSignLastChar			; Else, if last charaacter ACII != minus sign ASCII, jump to _nonSignLastChar
			jz		_end						; Otherwise, last character ASCII = minus sign ASCII, jump to _end	
			
		; Handles non-sign last characters
		_nonSignLastChar:
			cmp		BYTE ptr [esi], ZERO_ASCII
			jb		_invalidInput
			cmp		BYTE ptr [esi], NINE_ASCII
			ja		_invalidInput				; If non-sign last character != digit ASCII, the number is invalid so, jump to _invalidInput
			
			; Get final character's actual value
			std
			LODSB								; Load ASCII value from address of userStr in ESI into AL and decrement ESI
			sub		al, ZERO_ASCII				; Subtract ZERO_ASCII value from character's ASCII value to get its numerical value
			
			; Multiply by its power of 10
			push	esi
			push	edx
			mov		esi, [ebp+8]				; Put address of multiplication helper in ESI
			imul	DWORD ptr [esi]				; Multiply value in EAX by value in multiplication helper
			jo		_invalidInput				; If the multiplication resulted in an overflow condition, the number is too big
			pop		edx
			pop		esi

			; Add the value in EAX to the value in the UserNum label to update running total
			sub		[edi], eax
			jo		_invalidInput				; If addition resulted in an overflow condition, the number is too big
												; Otherwise, continue down to conversion to positive number

		; Convert negative integer to positive integer
		_convertToPosNum:
			mov		eax, [edi]
			neg		eax
			jo		_invalidInput
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
			
			; When ECX is 0, execution moves to next line of code below
			dec		ecx
			jmp		_convertNumLoop				

	; Clears the user string array, resets mulHelper to 1
	_end:
		push	DWORD ptr [ebp+20]
		call	clearStrArray
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
; Converts a numeric Signed Doubleword data type to a string of ASCII characters, then
;	  invokes the mDisplayString macro to display the converted number.
;
; Preconditions: Value to convert and the value 10 both need to be of Type SDWORD. Both
;	  the user string label and reverse string labels must be string Byte arrays that 
;	  are 13 Bytes.
;
; Postconditions: All used registers are preserved and restored.
;
; Receives:
;	  [ebp+20]  = the value to convert (e.g., -1234)
;	  [ebp+16]	= address of userStr label
;	  [ebp+12]	= address of revStr label
;	  [ebp+8]	= the value 10
;
; Returns: 
;	  userStr   = new number string from converted number (e.g., "-1234")
;	  revStr	= reversed number string from converted number (e.g., "4321-")
;
; --------------------------------------------------------------------------------------
WriteVal PROC

	; Preserve used registers and assign static stack-fram pointer
	push	ebp
	mov		ebp, esp
	push	eax
	push	ecx
	push	edx
	push	esi
	push	edi

	mov		eax, [ebp+20]	; Put value to convert into EAX
	mov		edi, [ebp+12]	; Point EDI to first address of reverse string
	xor		ecx, ecx

	cmp		eax, 0
	jz		_inputIsZero	; If the value is already 0, jump to _inputIsZero block for handling, otherwise, continue down
	
	; ----------------------------------------------------------------------------------
	; Conversion is a while loop that ends when the quotient of sequential division by
	;	  10 is 0. Execution takes the remainder of division by 10 and uses it to find
	;	  the correct ASCII value to store in reverse in revStr. Then the reversed 
	;	  string array of ASCII values is reversed into the userStr array to de-reverse
	;	  the revStr string array, giving us the converted number string from the 
	;	  original value.
	;
	; ----------------------------------------------------------------------------------
	
	_convertStrLoop:
		cmp		eax, 0
		jz		_revToCorrect			; If quotient in EAX is 0, break to _revToCorrect block
		cdq								; Sign-extend EAX into EDX, precondition for IDIV
		idiv	SDWORD ptr [ebp+8]
		cmp		edx, 0
		jl		_convertNegStr			; If remainder of division by 10 is negative, jump to _convertNegStr
										; Otherwise remainder is positive so, continue down

		; Finds remainder's correct ASCII, then jumps to add it to the reverse string
		push	eax						; Preserve number being converted
		mov		eax, edx
		add		eax, ZERO_ASCII			; Add 0's ASCII value to remainder to get its own ASCII value
		jmp		_addToRevStr

	; Only for negative numbers, check for last character so it can handle adding a negative sign
	_convertNegStr:		
		cmp		eax, 0					; If quotient of last division is 0, current negative remainder is last character to add to revStr
		jz		_addNegativeSign		; so, execution must handle this differently and jumps to _addNegativeSign block
		
		; If not the last character to add, add it and jump
		neg		edx						; Negate remainder to make it positve
		push	eax						; Preserve number being converted
		mov		eax, edx
		add		eax, ZERO_ASCII			; Add 0's ASCII value to remainder to get its own ASCII value
		jmp		_addToRevStr			; Jump down to _addToRevStr

		; Else, if it is the last character to add, add it, add a minus sign, and continue down
		_addNegativeSign:
			neg		edx
			push	eax						; Preserve number being converted
			mov		eax, edx
			add		eax, ZERO_ASCII			; Add 0's ASCII value to remainder to get its own ASCII value
			cld
			STOSB							; Store last remainder's ascii
			inc		ecx						; Increment ECX to account for extra storage instruction
			mov		eax, MINUS_ASCII

	; ----------------------------------------------------------------------------------
	; Store the current character's ASCII value in the reverse string array, saving how
	;	  many total individual storage operations occur in ECX by incrementing on each
	;	  storage operation. ECX will be used below to reverse the reverse string.
	;
	; This process will loop to turn a value, e.g., -1234, and turn it into a string 
	;	  that looks like "4321-".
	;
	; ----------------------------------------------------------------------------------
	_addToRevStr:
		cld								; Clear direction flag
		STOSB							; Store ASCII value in AL into memory address in EDI and increment EDI by 1 Byte
		pop		eax						; Restore number being converted
		inc		ecx						
		jmp		_convertStrLoop			; Loop back up to convert next remainder
	
	; Jumping off point for the loop below, initializes registers
	_revToCorrect:
		mov		esi, [ebp+12]			; Point ESI to revStr
		add		esi, ecx
		dec		esi						; Point ESI to last character in revStr
		mov		edi, [ebp+16]			; Point EDI to userStr

		_revLoop:
			std								; Set direction flag so that LODSB decrements ESI
			LODSB							; Load current address of revStr character in ESI into register AL
			cld								; Clear direction flag so that STOSB increments EDI
			STOSB							; Load current value in AL into current address of userStr in EDI
			loop	_revLoop				; Loop again until ECX is 0

		jmp		_end						; Executes after ECX is found to be 0

	; Store the ASCII value for 0 in the userStr array, then continue down
	_inputIsZero:
		mov		edi, [ebp+16]
		mov		al, ZERO_ASCII
		STOSB					; No need to clear flag since execution only has to store one ASCII value 
	
	; Print final string stored in the userStr string array
	_end:
	mDisplayString	DWORD ptr [ebp+16]

	; Restore used registers, de-reference 8 Bytes of parameters, and return control to main
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		eax
	pop		ebp
	ret		16
WriteVal ENDP

; --------------------------------------------------------------------------------------
; Name: clearStrArray
;
; Clears a string helper array for a new entry by changing all the bytes to 0 except
;	  the null terminator.
;
; Preconditions: The helper array must be a 13 Byte string array, including the null
;	  terminator.
;
; Postconditions: All used registers are preserved and restored.
;
; Receives:
;	  [ebp+8]  = address of string helper array
;
; Returns: 
;	  string array  = empty 13-Byte array
;
; --------------------------------------------------------------------------------------
clearStrArray PROC
	
	; Preserve used registers and assign static stack-fram pointer
	push	ebp
	mov		ebp, esp
	push	eax
	push	ecx
	push	edi

	; Initialize ECX to the number of Bytes to replace and EDI to point to the address of the array to modify
	mov		ecx, 12
	mov		edi, [ebp+8]
	
	; Set each Byte in the array to 0
	_clearLoop:
		mov		al, 0
		cld
		STOSB				; Store value in AL into memory address of string array in EDI
		loop	_clearLoop

	; Restore used registers, de-reference 4 Bytes of parameters, and return control to calling procedure
	pop		edi
	pop		ecx
	pop		eax
	pop		ebp
	ret		4

clearStrArray ENDP

END main
