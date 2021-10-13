; James S
%include "io.inc"

%define MAXSIZE 15
section .data
    ; put initialized data here
    prompt1     db  "String 1: ",0
    prompt2     db  10,"String 2: ",0
    input       db  "%s",0
    dispstrings db  10,"String 1 is %s and String 2 is %s",0
    areequal    db  10,"%s is equal to %s",0
    notequal    db  10,"%s is not equal to %s",0
    copymsg     db  10,"Copying String 1 to String 2",0
    submsg      db  10,"Making String 2 a substring of String 1",0
    fourthmsg   db  10,"Messing with the string...",0
    
section .bss
    ; put uninitialized data here
    string1     resb    MAXSIZE;
    string2     resb    MAXSIZE;

section .text
global CMAIN
CMAIN:
    mov         ebp,esp         ;Debugging
    enter       0,0
    pusha
    
    ; put the code of the main program here
    push        prompt1
    call        printf
    add         esp,4           ;Prints out first prompt
    
    push        string1
    push        input
    call        scanf
    add         esp,8           ;Reads in string
    
    push        string1
    call        printf 
    add         esp,4           ;Prints out entered string
    
    push        prompt2
    call        printf
    add         esp,4           ;Prints out second prompt
    
    push        string2
    push        input
    call        scanf
    add         esp,8           ;Reads in second string
    
    push        string2
    call        printf 
    add         esp,4           ;Prints out entered string
    
    push        string2
    push        string1
    push        dispstrings
    call        printf
    add         esp,12
    
    push        string1
    push        string2
    call        equal
    add         esp,8           ;Call equal function
    
    cmp         al,1
    je          samemsg         ;Jumps to equal
    push        string2         
    push        string1         
    push        notequal
    call        printf
    add         esp,12          ;Prints they aren't equal
    
return1:
    call        copy
    call        substring
    call        fourth
    
    jmp         finished        ;Ends program
    
samemsg:
    push        string2
    push        string1
    push        areequal
    call        printf
    add         esp,12
    jmp         return1
    ;End of samemsg
    
finished:
    popa
    leave
    xor         eax,eax
    ret
    
    ; subprograms go here
equal:
    enter 0,0
    
    mov         esi,[ebp+8]     ;Set ESI equal to string1
    mov         edi,[ebp+12]    ;Set EDI equal to string2
    mov         ecx,14          ;Make counter register 14
    
    repe        cmpsb    ;Compare ESI and EDI until different or counter empty
    setz        al       ;Set flag in AL for result: 1 if equal, 0 if not
    
    leave
    ret
    
copy:
    enter 0,0
    
    push        copymsg
    call        printf
    add         esp,4           ;Print copying msg
    
    lea         esi, [string1]
    lea         edi, [string2]
    mov         ecx,14
    
 copy1: mov     bl,[esi]
    mov         [edi],bl
    inc         esi
    inc         edi             ;Progresses thru string to c
    dec         ecx
    jnz         copy1
    
    push        string1
    push        string2
    push        dispstrings
    call        printf
    add         esp,12
    
    leave
    ret
    
substring:
    enter 0,0
    
    push        submsg
    call        printf
    add         esp,4
    
    lea         eax,[string1]
    mov         ebx, ' '
    mov         [eax],bl
    
    push        string1
    push        string2
    push        dispstrings
    call        printf
    add         esp,12
    
    leave
    ret
    
fourth:
    enter 0,0
    
    push        fourthmsg
    call        printf
    add         esp,4
    
    lea         eax,[string1]
    mov         ebx,'J'
    mov         [eax],bl
    mov         eax,[string1+2]
    mov         [string1],eax
    
    push        string1
    push        string2
    push        dispstrings
    call        printf
    add         esp,12
    
    leave
    ret