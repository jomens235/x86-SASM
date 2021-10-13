;James S

%include "io.inc"

section.data
    mesg db "Hello Assmebly World!",10,0
section .text
    global CMAIN
CMAIN:
    ;write your code here
    enter 0,0
    pusha
    
    mov eax,mesg
    PRINT_STRING [eax]
    
    popa
    mov eax,0
    leave
    ret