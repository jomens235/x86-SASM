;James S
%include "io.inc"

section .data
    ; put initialized data here
    prompt1     db  "I don't think I could do this one",10,0
    prompt2     db  "Have a good break!",0
    
section .bss
    ; put uninitialized data here
    

section .text
global CMAIN
CMAIN:
    enter   0,0
    pusha
    ; put the code of the main program here
    
    push    prompt1
    call    printf
    add     esp,4
    
    push    prompt2
    call    printf
    add     esp,4
    
    popa
    leave
    ret
    
    
    ; subprograms go here