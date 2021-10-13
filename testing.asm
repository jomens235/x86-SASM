%include "io.inc"
section .data

	; The output strings we will use
	prompt1 db "Please enter the size of the array: ",10,0
	prompt2 db "Enter an element of the array: ",10,0
	output  db "Element %d is %d",10,0
	
	; The input string we will use
	input	 db "%d",0
	
section .bss
	len		resd 1	; len will contain the length of the array
	ele		resd 1	; ele will contain the elements the user inputs

section .text
	global CMAIN ; makes asm_main accessible to the driver.c
	extern printf, scanf	; allows us to use printf and scanf from the c library
CMAIN:   ; The access point (starting label) for the program
	enter	0,0
	
	; Ask the user to enter the size of the array
	push		prompt1
	call		printf
	add		esp,4
	
	; Get the size from the user and store it in len
	push		len
	push		input
	call		scanf
	add		esp,8
	
	
	; allocate space on the stack (len * 4 bytes on the stack)
	mov		eax,[len]	; eax = len
	shl		eax,2		; eax = length * 4
	sub		esp,eax		; esp = esp - (len * 4)
	mov		ebx,esp 	; ebx = base address of the array
	
	mov		ecx,[len]; ecx = len (we will loop at most len times)
	
	push		ebx	; save ebx (the starting address of the array)

array1:
        mov             eax,0
        mov             ebx,[len]
        
        push            prompt2
        call            printf
        add             esp,4
        
        push            ele
        push            input
        call            scanf
        add             esp,8
        
        inc             eax
        cmp             eax,ebx
        jl              array1

	leave
	xor		eax,eax
	ret