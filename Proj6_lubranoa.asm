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

; (insert variable definitions here)

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
