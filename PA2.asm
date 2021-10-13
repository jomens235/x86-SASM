%include "io.inc"
; James S

section .data
    ; put initialized data here
    prompt1     db "Please enter the amount of cable per room: ",0
    prompt2     db "Please enter the number of rooms: ",0
    outmsg1     db "Feet of Cable: ",0
    outmsg2     db 10,"Workers: ",0     ;10, is the new line
    outmsg3     db 10,"Total Cost: ",0
    
section .bss
    ; put uninitialized data here
    input1      resd 1 ; Reserve 1 dword in mem
    input2      resd 1
    feet        resd 1
    totalWork   resd 1 ; Store # of workers
    total       resd 1 ; Store total cost

section .text
global CMAIN
CMAIN:
    enter   0,0     ; Setup routine
    pusha
    
    ; put the code of the main program here
    PRINT_STRING    prompt1         ;Print first prompt
    GET_DEC         4,eax           ;Read in the first input
    mov             [input1],eax    ;Store in input1
    
    NEWLINE
    
    PRINT_STRING    prompt2         ;Print second prompt
    GET_DEC         4,eax
    mov             [input2],eax    ;Store in input2
    
    NEWLINE
    
    mov             eax,[input1]    ;move input1 to eax
    mul             dword[input2]   ;eax *= input2
    mov             ebx,eax         ;move eax to ebx
    
    PRINT_STRING    outmsg1         ;Print feet of cable msg
    PRINT_DEC       4,ebx           ;Print total cable needed
    
    mov byte        [feet],50       ;Set feet to int 50
    mov             ecx,[feet]      ;Make divisor 50 ft
    div             ecx             ;Divide EAX by ECX
    mov             ecx,2           ;Make ECX = 2
    mul             ecx             ;Multiply to get workers needed
    
    PRINT_STRING    outmsg2         ;Print # of workers
    mov             [totalWork],eax ;Move workers needed to total workers
    PRINT_DEC       4,totalWork     ;Print workers needed
    
    mov             ecx,32          ;Set ecx to 32
    mul             ecx             ;ebx * eax
    add             [total],eax     ;total += eax
    mov             eax,2           ;Set eax to 2
    mul             ebx             ;multiply eax and ebx
    add             [total],eax     ;total += eax
    
    PRINT_STRING    outmsg3         ;Print total cost
    PRINT_DEC       4,[total]       ;Total
    
    
    popa
    leave
    ret