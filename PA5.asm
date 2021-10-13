;James S
%include "io.inc"

section .data
    ; put initialized data here
    prompt1     db  "How many rows?: ",0
    prompt2     db  10,"How many columns?: ",0
    prompt3     db  10,"Enter a number for [%d][%d]: ",0
    input       db  "%d",0
    sum         db  10,"The sum is: %d",0
    
section .bss
    ; put uninitialized data here
    rows        resd    1;
    columns     resd    1;
    allElems    resd    1;
    element     resd    1;
    total       resd    1;
    currRow     resd    1;
    currCol     resd    1;
    

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    enter   0,0
    
    ; put the code of the main program here
    push        prompt1
    call        printf
    add         esp,4
    
    push        rows
    push        input
    call        scanf
    add         esp,8               ;Read in # rows
    
    push        prompt2
    call        printf
    add         esp,4
    
    push        columns
    push        input
    call        scanf
    add         esp,8               ;Read in # columns
    
    ;Make space on the stack for array
    mov         eax,[rows]          ;eax = rows
    mul         dword [columns]     ;eax = rows * columns
    
    mov         [allElems],eax      ;allElems = rows * columns
    
    shl         eax,2               ;rows * 4 bytes
    sub         esp,eax             ;esp = esp - (rows * 4 bytes)
    mov         ebx,esp             ;ebx = base of array
    
    mov         ecx,[allElems]      ;loop (rows) amount of times
    
    push        ebx
    mov         dword[currRow],0
    mov         dword[currCol],0
    mov         dword[total],0
    jmp         array2
    
    ;******************Two-D Arrays*********************
    ;mov        eax,[ebp-44]            ebp - 44 is i's location (array[i][j])
    ;sal        eax,1                   multiply i by 2
    ;add        eax,[ebp-48]            add j
    ;mov        eax,[ebp + 4 * eax - 40]    ebp - 40 is the address of array[0][0]
    ;mov        [ebp-52],eax            store result into x (at ebp-52)
    ;***************************************************
    
array1:
    inc         dword[currRow]
    mov         dword[currCol],0
    jmp         end
;Row-Major Indirect Address: Base + Factor x Row x CPR + Column x Factor
array2:
    push        ecx
    
    push        dword[currCol]
    push        dword[currRow]
    push        prompt3
    call        printf
    add         esp,12
    
    push        element
    push        input
    call        scanf
    add         esp,8               ;Read in the element
    
    mov         eax,[element]
    mov         [ebx],eax
    add         [total],eax
    mov         eax,[total]
    
    add         ebx,4
    
    mov         eax,[rows]
    cmp         eax,[currRow]
    je          end
    sub         eax,1
    cmp         eax,[currCol]
    je          array1
    inc         dword[currCol]
end:
    pop         ecx
    loop        array2
    
    pop         ebx
    
    pop         ebx
    push        ebx
print:
    push        ecx
    
    push        ebx
    push        input
    call        printf
    add         esp,8
    
    add         ebx,4               ;Move ebx to next element
    
    pop         ecx
    
    inc         ecx
    cmp         ecx,[allElems]
    jl          print
    pop         ebx
    
    
    push        dword[total]
    push        sum
    call        printf
    add         esp,8
    
    leave
    xor         eax,eax
    ret
    
    ; subprograms go here