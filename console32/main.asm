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

	valueToConvert WORD 0A3BFh

	; The destination string is 7 bytes long.

	stringToStoreResult BYTE 7 DUP ("x")

; procedure code
.CODE
main	PROC
	
	; offset = 6
	; insert space at offset - 3

	; loop twice ( if offset > -2 )
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

	; We have to use a DWORD for the offset because we need to add it to EBP

	; ebp = &stringToStoreResult	DWORD
	; al = currentDigit				BYTE
	; ebx = offset					DWORD
	; dx = valueToConvert			WORD

	lea ebp, stringToStoreResult	; get &stringToStoreResult

	
	mov ebx, 6						; offset := 6

	mov dl, " "
	mov BYTE PTR [ebp + ebx - 3], dl ; insert space into stringToStoreResult at offset - 3
	
	mov dx, valueToConvert			; get valueToConvert

loopStart:
	
	; we're only going to deal with the lower part of DX (DL).
	; later we will bitshift DX to move DH into DL.
	
	mov al, dl						; move the current byte into al to be operated on

	; we're masking out the last three bits of the valueToConvert
	; masking out means that I'm pulling out those last three bits - those are the ones I want
	
	and al, 00000111b				; currentDigit := least significant octal digit

	; to convert currentDigit to ASCII, we will mask in 30h (using bitwise OR). This is equivalent to adding 30h.
	; for instance, to convert 3d to ASCII: 3d = 03h = 0000 0011b
	; ( 03h OR 30h ) = ( 0000 0011b OR 0011 0011b ) = 0011 0011b = 33h = 3 (ASCII)

	or al, 00110000b				; convert currentDigit to ASCII

	mov BYTE PTR [ebp + ebx], al		; store currentDigit in stringToStoreResult at offset

	


	mov eax, 0
	ret
main	ENDP

END
