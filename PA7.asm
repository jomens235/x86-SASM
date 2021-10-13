;James S
%include "io.inc"

section .data
    ; put initialized data here
    promptHexH      db  "Enter the height of the hexagonal prism: ",0
    promptHexL      db  10,"Enter the length of sides(a) of the hexagonal prism: ",0
    outputHex       db  10,"The surface area of the hexagonal prism is: %.2f Units",0
    
    promptCylH      db  10,10,"Enter the height of the cylinder: ",0
    promptCylR      db  10,"Enter the radius of the cylinder: ",0
    outputCyl       db  10,"The surface area of the cylinder is: %.2lf",0
    
    inputF          db  "%f",0
    inputD          db  "%lf",0
    PI              dd  3.14159
    
section .bss
    ; put uninitialized data here
    sFloat	    resd 1	  ; length of side as float
    resFloat	    resd 1	  ; result as a Float
    resDouble	    resq 1	  ; result as a Double
    hFloat          resd 1        ; height as float
    rFloat	    resq 1        ; radius

section .text
global CMAIN
CMAIN:
    enter   0,0
    pusha
    ; put the code of the main program here
    
    push    promptHexH
    call    printf 
    add     esp,4
    
    ;Read in side of hexagonal prism
    push    sFloat
    push    inputF
    call    scanf
    add     esp,8
    
    push    promptHexL
    call    printf
    add     esp,4
    
    ;Read in height of hexagonal prism
    push    hFloat
    push    inputF
    call    scanf
    add     esp,8    
    
    ;Call hexagon
    push    dword[sFloat]
    push    dword[hFloat]
    call    hexagon
    add     esp,8
    fstp    dword[resFloat]     ;resFloat = st0
    
    ;Convert answer to double for printing
    fld	    dword[resFloat]
    fstp    qword[resDouble]
    
    ;Print hexagon answer
    push    dword[resDouble+4]	; pushing qword[resDouble]
    push    dword[resDouble]
    push    outputHex
    call    printf
    add	    esp,12
    
    ;Print prompt for cylinder
    push    promptCylH
    call    printf
    add     esp,4
    
    ;Read in cylinder height
    push    hFloat
    push    inputF
    call    scanf
    add     esp,8
    
    push    promptCylR
    call    printf
    add     esp,4
    
    ;Read in cylinder radius
    push    rFloat
    push    inputF
    call    scanf
    add     esp,8
    
    ;Call cylinder subprogram
    push    dword[hFloat]
    push    dword[rFloat]
    call    cylinder
    add     esp,8
    fstp    dword[resFloat]
    
    ;Convert answer to double for printing
    fld	    dword[resFloat]
    fstp    qword[resDouble]
    
    ;Print cylinder answer
    push    dword[resDouble+4]	; pushing qword[resDouble]
    push    dword[resDouble]
    push    outputCyl
    call    printf
    add	    esp,12
    
    popa
    leave
    ret
    
    
    ; subprograms go here
    
hexagon:
    enter   8,0
    
    mov     [ebp-4],dword 6 ;local var = 6
    mov     [ebp-8],dword 3 ;local var = 3
    
    fld     dword[ebp+8]    ;ST0 = side
    fmul    st0             ;side^2
    
    fild    dword[ebp-8]    ;st1 = (side^2); st0 = 3
    fld     st0             ;st2 = (side^2); st1 = 3; st0 = 3
    fsqrt                   ;st2 = (side^2); st1 = 3; st0 = sqrt(3)
    fmulp   st1             ;st1 = (side^2); st0 = 3*sqrt(3)
    fmulp   st1             ;st0 = ((side^2))*3*sqrt(3)
    
    fild   dword[ebp-4]     ;st0 = 6
    fmul   dword[ebp+8]     ;st0 = 6 * side
    fmul   dword[ebp+12]    ;st0 = 6 * side * height
    
    faddp   st1             ;st1 = ((side^2)*3*sqrt(3)) + 6(side)(height)
    
    ;Result should be in st0
    leave
    ret
    
cylinder:
    enter   4,0
    
    mov     [ebp-4],dword 2 ;local var = 2
    
    fld     dword[ebp+8]    ;st0 = radius
    fmul    st0             ;st0^2
    fild    dword[ebp-4]    ;st1 = r^2, st0 = 2
    fmulp   st1             ;st0 = (r^2) * 2
    fld     dword[PI]       ;st1 = above, st0 = PI
    fmulp   st1             ;st0 = ((r^2)*2) * PI
    
    fild    dword[ebp-4]    ;st0 = 2
    fmul    dword[PI]       ;st0 = PI * 2, st1 = ((r^2)*2) * PI
    fmul    dword[ebp+8]    ;st0 = PI * 2 * r
    fmul    dword[ebp+12]   ;st0 = PI * 2 * r * h
    
    faddp   st1             ;st0 = (((r^2)*2) * PI) + 2PIrh
    
    leave
    ret
    
    
    