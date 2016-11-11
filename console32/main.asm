; general comments
; This version is compatible with Visual Studio 2012 and Visual C++ Express Edition 2012

; preprocessor directives
.586
.MODEL FLAT

; external files to link with

; stack configuration
.STACK 4096

; named memory allocation and initialization
.DATA

	; The value we're converting will be a WORD.
	; When we code the procedure, we will need to push it to the stack as a DWORD.

	valueToConvert WORD A3BFh

	; The destination string is 7 bytes long.

	stringToStoreResult BYTE "xxx xxx"

; procedure code
.CODE
main	PROC
	
	; offset = 7
	; loop twice ( if offset > -1 )
	;	
	;	get least significant octal digit from valueToConvert
	;	convert to ASCII
	;	store in stringToStoreResult at offset
	;	
	;	get middle significant octal digit from valueToConvert
	;	convert to ASCII
	;	store in stringToStoreResult at offset - 1
	;
	;	get most significant octal digit from valueToConvert
	;	convert to ASCII
	;	store in stringToStoreResults at offset - 2
	;
	;	offset = offset - 4
	;	bit shift right valuteToConvert 8 bits
	; end loop



	mov eax, 0
	ret
main	ENDP

END
