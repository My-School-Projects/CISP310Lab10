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
	; edi = offset					DWORD
	; dx = valueToConvert			WORD

	lea ebp, stringToStoreResult	; get &stringToStoreResult

	
	mov edi, 6						; offset := 6

	mov dl, " "
	mov BYTE PTR [ebp + edi - 3], dl ; insert space into stringToStoreResult at offset - 3
	
	mov dx, valueToConvert			; get valueToConvert

loopStart:
	
	; we're only going to deal with the lower part of DX (DL).
	; later we will bitshift DX to move DH into DL.
	
	mov al, dl						; get the current byte to convert


	; given a byte value, eg. 53h = 0111 0011b = 163o
	; the rightmost 3 bytes (011b) represent the last digit of the octal form		(011b = 3o)
	; the 3 bytes left of those (110b) represent the middle digit of the octal form (110b = 6o)
	; and the leftmost two bytes (01b) represent the leftmost byte of the octal form (01b = 1o)
	;
	; to get the rightmost 3 digits, we're masking out the last three bits of the valueToConvert
	; masking out means that I'm pulling out those last three bits - those are the ones I want

	and al, 00000111b				; currentDigit := least significant octal digit

	; to convert currentDigit to ASCII, we will mask in 30h (using bitwise OR). This is equivalent to adding 30h.
	; for instance, to convert 3d to ASCII: 3d = 03h = 0000 0011b
	; ( 03h OR 30h ) = ( 0000 0011b OR 0011 0011b ) = 0011 0011b = 33h = 3 (ASCII)

	or al, 00110000b				; convert currentDigit to ASCII

	mov BYTE PTR [ebp + edi], al	; store currentDigit in stringToStoreResult at offset

	mov al, dl						; get the current byte to convert

	and al, 00111000b				; currentDigit := middle significant octal digit

	; the current value is masked out, but it's shifted over 3 bits like so:
	; 00111000b
	; it needs to be: 00000111b
	; to do this, we will rotate it right 3 bits.

	ror al, 3						; rotate so that the currentDigit is in the 3 least significant bits

	or al, 00110000b				; convert currentDigit to ASCII

	mov BYTE PTR [ebp + edi - 1], al; store currentDigit in stringToStoreResult at offset - 1

	mov al, dl						; get the current byte to convert

	and al, 11000000b				; currentDigit := most significant octal digit

	ror al, 6						; this time we need to rotate 6 bits to get the result in the 2 least significant bits

	or al, 00110000b				; convert currentDigit to ASCII
	
	mov BYTE PTR [ebp + edi - 2], al; store currentDigit in stringToStoreResult at offset - 2

	sub edi, 4						; offset := offset - 4

	ror dx, 8						; rotate valueToConvert so that the most MSB is in the LSB and vice versa

	cmp edi, -2	; ( offset > -2) ?
	jg loopStart					; IF ( offset > -2 ), THEN loop again - we should only loop twice
									; each time offset is decremented by 4, so after two loops it will be -2


	mov eax, 0
	ret
main	ENDP

END
