;James S
%include "io.inc"

section .data
    ; put initialized data here
    prompt1     db "Please enter the amount of cable per room: ",10,0
    prompt2     db "Please enter the number of rooms: ",10,0
    outmsg1     db "Feet of Cable: %d",0
    outmsg2     db 10,"Workers: %d",0     ;10, is the new line
    outmsg3     db 10,"Total Cost: %d",0
    input       db "%d",0
    
section .bss
    ; put uninitialized data here
    input1      resd 1          ; Reserve 1 dword in mem
    input2      resd 1
    feet        resd 1
    hold        resd 1
    totalFt     resd 1
    totalWork   resd 1          ; Store # of workers
    total       resd 1          ; Store total cost

section .text
global CMAIN
CMAIN:
    enter   0,0
    pusha                       ;Program set up
    
    ; put the code of the main program here
    
    push        prompt1
    call        printf      
    add         esp,4           ;Print first prompt
    
    push        input1
    push        input
    call        scanf
    add         esp,8           ;Read in input1
    
    push        prompt2
    call        printf
    add         esp,4           ;Print second prompt
    
    push        input2
    push        input
    call        scanf
    add         esp,8           ;Read in input2
    
    push        dword[input1]
    push        dword[input2]
    call        getCable
    add         esp,8           ;Call getCable subprogram
    
    mov         [hold],eax
    mov         [totalFt],eax
    push        eax
    push        outmsg1
    call        printf
    add         esp,8           ;Display feet of cable needed
    
    mov         eax,[hold]
    push        eax             ; ebp + 12
    push        input           ; ebp + 8
    call        getWorkers
    add         esp,8           ;Call getWorkers subprogram
    
    mov         [hold],eax
    push        eax
    push        outmsg2
    call        printf
    add         esp,8           ;Display workers needed
    
    mov         eax,[hold]
    push        eax
    push        input
    call        getTotal
    add         esp,8           ;Call getTotal subprogram
    
    push        eax
    push        outmsg3
    call        printf
    add         esp,8           ;Display total cost
    
    popa
    leave
    ret
    
    ; subprograms go here
    
;Calculate how much cable is needed
getCable:
    enter       0,0
    mov         eax,[ebp+8]         ; eax = input2
    mul         dword[ebp+12]       ; eax = input2 * input1
    
    leave
    ret
    
;Calculate how many workers are needed
getWorkers:
    enter           0,0
    xor             edx,edx         ;Set edx to 0
    mov dword       [feet],50       ;Set feet to int 50
    mov             ebx,[feet]      ;Make divisor 50 ft
    div             ebx             ;Divide EAX by EBX
    shl             eax,1           ;Same as multiplying by 2
    mov             [totalWork],eax
    
    leave
    ret
    
;Calculate total cost of project
getTotal:
    enter           0,0
    mov             ecx,32          ;Set ecx to 32
    mul             ecx             ;ecx * eax
    add             [total],eax     ;total += eax
    mov             eax,2           ;Set eax to 2
    mov             ecx,[totalFt]
    mul             ecx             ;multiply eax and ebx
    add             [total],eax     ;total += eax
    mov             eax,[total]
    
    
    leave
    ret