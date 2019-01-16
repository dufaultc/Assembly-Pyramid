%include "asm_io.inc"

SECTION .data

msg1: db "incorrect number of command line arguments",0,10
msg2: db "incorrect input value",0,10
bottomx: db "XXXXXXXXXXXXXXXXXXXXXXX",0,10
finalcon: db "final config",0,10
initialcon: db "initial config",0,10


SECTION .bss

peg: resd 9

SIZE: resd 1

SECTION .text
	global asm_main


showp:
	enter 0,0
	pusha

	mov ebx, [ebp+8]
	mov ecx, [ebp+12]

	add ebx, 32



	mov esi, 0
	mov edi, 0
	
	L1:
		cmp esi, 9
		je L1END

		cmp dword[ebx], dword 0
		je nextnextpeg

		mov eax, ' '
		call print_char
		call print_char
		mov edx, 9
		sub edx, [ebx]

		mov edi,0
		
		LSPACE:
			cmp  edi, edx
			je LPRINT
			mov eax, ' '
			call print_char
			inc edi
			jmp LSPACE

		LPRINT:
			cmp edi, 9
			je HALF
			mov eax, 'o'
			call print_char
			inc edi
			jmp LPRINT

		HALF:
			mov eax, '|'
			call print_char
			mov edi,0

		LPRINT2:
			cmp edi, [ebx]
			je ALMOST
			mov eax, 'o'
			call print_char
			inc edi
			jmp LPRINT2

		ALMOST:
			mov edi, [ebx]

		LSPACE2:
			cmp edi, 9
			je nextpeg
			mov eax, ' '
			call print_char
			inc edi
			jmp LSPACE2



		nextpeg:
		
		mov eax, ' '
		call print_char 
		call print_char
		call print_nl
			
		nextnextpeg:

		sub ebx, 4
		inc esi
		jmp L1	

	L1END:

	mov eax, bottomx
	call print_string
	call print_nl
	call read_char

	popa
	leave
	ret
sorthem:
	enter 0,0
	pusha
	
	mov ebx,[ebp+8]
	mov ecx, [ebp+12]		

	cmp ecx,1
	je toEND

	sub ecx,1
	add ebx,4
	push ecx
	push ebx
	call sorthem
	add esp,8


	sub ebx,4
	 
	mov edi,0
	mov esi,0
	LOOP:
		

		cmp edi, ecx
		je loopend
		mov edx, [ebx+4]
		cmp [ebx], edx
		ja loopend
		
		inc esi
		mov eax, edx
		mov edx, [ebx]
		mov [ebx], eax
		mov [ebx+4],edx
		inc edi
		add ebx,4
		jmp LOOP

	loopend:
	add ecx, 1
	
	cmp esi,0
	je toEND
	push ecx
	push peg
	call showp
	add esp,8
	toEND:
	
	


	popa
	leave
	ret


asm_main:
	enter 0,0

	mov eax,[ebp+8]
	cmp eax, 2
	jne ERR1

	mov ebx,[ebp+12]
	mov ecx,[ebx+4]

	cmp byte[ecx], byte '2'
	jb ERR2
	cmp byte[ecx], byte '9'
	ja ERR2

	cmp byte[ecx+1], byte 0
	jne ERR2

	mov al, byte[ecx]
	sub eax, dword '0'
	mov [SIZE], eax

	push dword [SIZE]
	push peg
	call rconf
	add esp, 8 
	
	mov eax, initialcon
	call print_string
	call print_nl

	push dword [SIZE]
	push peg
	call showp
	add esp, 8


	push dword [SIZE]
	push peg
	call sorthem
	add esp,8

	mov eax, finalcon
	call print_string
	call print_nl

	push dword[SIZE]
	push peg
	call showp
	add esp,8


	jmp asm_main_end
	

	ERR1:
		mov eax,msg1
		call print_string
		call print_nl
		jmp asm_main_end
	ERR2:
		mov eax,msg2
		call print_string
		call print_nl
		jmp asm_main_end
		
	asm_main_end:
		leave
		ret
