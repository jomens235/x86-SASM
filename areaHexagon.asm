%include "io.inc"
section .data
    pA      db  "Enter the length of a side of a hexagon: ",0
    outputF db  10,"The area of the hexagon is: %f",10,0
    
    inputF  db  "%f",0
    three   dd  3.0
	
section .bss
    side    resd    1
    area    resd    1

section .text
    global CMAIN ; asm_main, CMAIN
    extern printf, scanf
CMAIN:
    mov ebp, esp; for correct debugging   
    enter	0,0
	
    push    pA
    call    printf
    add     esp,4
    
    push    side
    push    inputF
    call    scanf
    add     esp,8               ;Read in side length
    
    push    dword[side]
    call    hexagon
    add     esp,4
    
    push    dword[area]
    push    outputF
    call    printf
    add     esp,8

    leave
    xor	    eax,eax
    ret
    
    ;float Hexagon(float a);
hexagon:
    enter   4,0
    
    fld     dword[ebp+8]        ;st0 = [ebp+8]
    fmul    st0                 ;fmul is now st0 * source (st0)
    
    mov     [ebp-4],dword 2
    fild    dword[ebp-4]
    fdivp   st1,st0 
    
    fld     dword[three]
    fld     st0
    fsqrt
    fmulp   st1
    fmulp   st1
    
    fst     dword[area]
    
    leave
    ret