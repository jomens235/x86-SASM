%include "io.inc"

struc Pacman                    ;Creates a struct
    p_id:       resd 1
    p_name:     resb 10         ;Max size of 9 characters
    p_x:        resd 1
    p_y:        resd 1
endstruc                        ;Ends the struct

section .data
    prompt1     db  "Enter a name: ",0
    prompt2     db  10,"Enter an X coordinate: ",0
    prompt3     db  10,"Enter a Y coordinate: ",0
    
    inputD      db  "%d",0
    inputS      db  "%s",0
    
    output1     db  10,"ID: %d",10,0
    output2     db  "Name: %s",10,0
    output3     db  "X: %d",10,0
    output4     db  "Y: %d",10,0
    
section .bss

section .text
    global CMAIN
    extern  printf, scanf, malloc, free
CMAIN:
    enter 0,0
    ;write your code here
    
    push        dword 1
    call        CreatePacman
    add         esp,4
    
    push        eax
    call        PrintPacman
    add         esp,4
    
    push        dword 2
    call        CreatePacman
    add         esp,4
    
    push        eax
    call        PrintPacman
    add         esp,4
    
    leave
    xor eax, eax
    ret
    
; *void CreatePacman(int id);
CreatePacman:
    enter 0,0
    push        ebx
    
    mov         eax,Pacman_size     ;eax = size of pacman
    push        eax
    call        malloc              
                                    ;Malloc is used for heap instead of stack
    add         esp,4
    mov         ebx,eax             ;ebx = address of struct
    
    push        prompt1
    call        printf
    add         esp,4
    
    mov         eax,[ebp+4]
    mov         [ebx],eax           ;p_id = eaxs        Changes location of ebx
    
    lea         eax,[ebx+p_name]    ;Load Effective Address, eax = address of p_name in struct
    push        eax
    push        inputS
    call        scanf
    add         esp,8
    
    push        prompt2
    call        printf
    add         esp,4
    
    lea         eax,[ebx+p_x]
    push        eax
    push        inputD
    call        scanf
    add         esp,8
    
    push        prompt3
    call        printf
    add         esp,4
    
    lea         eax,[ebx+p_y]
    push        eax
    push        inputD
    call        scanf
    add         esp,8
    
    mov         eax,ebx             ;Returning result to eax
    
    pop         ebx
    leave
    ret

; void PrintPacman(*void);
PrintPacman:
    enter 0,0
    push        ebx
    mov         ebx,[ebp+8]         ;ebx = an instance of pacman
    
    mov         eax,[ebx+p_id]      ;No LEA needed since we don't need address
    push        eax
    push        output1
    call        printf
    add         esp,8
    
    lea         eax,[ebx+p_name]    ;Takes address of string and puts it in EAX
    push        eax
    push        output2
    call        printf
    add         esp,8
    
    mov         eax,[ebx+p_x]       ;It's a number so we can get a value, no lea needed
    push        eax
    push        output3
    call        printf
    add         esp,8
    
    mov         eax,[ebx+p_y]
    push        eax
    push        output4
    call        printf
    add         esp,8
    
    pop         ebx
    leave
    ret