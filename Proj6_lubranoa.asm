TITLE Program Template     (Proj6_lubranoa.asm)

; Author:  Alexander Lubrano
; Last Modified:  12/03/2021
; OSU email address: lubranoa@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  6 - String Primitives and Macros        Due Date:  12/05/2021
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; --------------------------------------------------------------------------------------
; Name: mGetString
;
; Description goes here
;
; Preconditions: 
;
; Receives:
;
; Returns: 
; --------------------------------------------------------------------------------------
mGetString MACRO [placeholder1, placeholder2]
	; display prompt

	; get user input

	; store in memory
ENDM

; --------------------------------------------------------------------------------------
; Name: mDisplayString
;
; Description goes here
;
; Preconditions: 
;
; Receives:
;
; Returns: 
; --------------------------------------------------------------------------------------
mDisplayString MACRO [placeholder1, placeholder2]
	; Prints string at passed address

ENDM

; (insert constant definitions here)

.data
; Printing strings
titleStr	BYTE	"CS 271 ASSIGNMENT 6: Designing low-level I/O Procedures",13,10,"Written by: Alexander Lubrano",0
introStr	BYTE	"Please provide 10 signed decimal integers",13,10,
					"Each number needs to be small enough to fit inside aaa 32-bit register. After you have",13,10,
					"finished entering the raw numbers, this program will display a list of the integers, their",13,10,
					"sum, and their average value.",0
promptStr	BYTE	"Please enter a signed integer: ",0
errorStr	BYTE	"ERROR: You did not enter a signed integer or your integer was too big.",13,10,"Please try again: ",0
listStr		BYTE	"You entered the following numbers: ",13,10,0
sumStr		BYTE	"The sum of these numbers is: ",0
avgStr		BYTE	"The truncated average is: ",0
byeStr		BYTE	"Hope this was fun!",13,10,"- Alex",0
; Data Storage


.code
main PROC

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------------------------------------
; Name: ReadVal
;
; Description goes here
;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;
; Returns: 
; --------------------------------------------------------------------------------------
ReadVal PROC

	ret
ReadVal ENDP

; --------------------------------------------------------------------------------------
; Name: WriteVal
;
; Description goes here
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

END main
