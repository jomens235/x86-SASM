;James S
%include "io.inc"

struc Job
    job_id:         resd    1       ;ID of job
    job_name:       resb    11      ;Max size of 10 chars
    job_time:       resd    1       ;# hours worked
    job_pay:        resd    1       ;Amount to be paid
    next_job:       resd    1       ;Pointer to next job
endstruc

section .data
    ; put initialized data here
    prompt1         db  "How many jobs are there? ",0
    promptname      db  10,"Enter the name for job %d: ",0    
    prompttime      db  10,"Enter a time for job %d: ",0    
    promptpay       db  10,"Enter the pay for job %d: ",10,0
    
    inputD          db  "%d",0
    inputS          db  "%s",0
    
    outputid        db  10,"Job ID: %d",0
    outputname      db  10,"Job name: %s",0
    outputtime      db  10,"Job time: %d Hours",0
    outputpay       db  10,"Job pay: $%d",10,0
    totalpay        db  10,"Total Pay: $%d",0
    
section .bss
    ; put uninitialized data here
    jobs            resd    1;  # of jobs
    count           resd    1;  Counter for job #
    total           resd    1;  Total $ pay
    pJob            resd    1;  Job Address Pointer

section .text
global CMAIN
extern printf, scanf, malloc, free
CMAIN:
    enter   0,0
    pusha
    ; put the code of the main program here
    
    push    prompt1
    call    printf
    add     esp,4
    
    push    jobs
    push    inputD
    call    scanf
    add     esp,8               ;Read in # of jobs
    
    mov     dword[count],1
    ;Call Subprograms
    
create:
    push    dword[count]
    call    CreateJobs
    add     esp,4
    
    push    eax
    call    PrintJobs
    add     esp,4
    
    inc     dword[count]
    mov     eax,dword[count]
    dec     eax
    cmp     dword[jobs],eax
    jg      create
    
    push    dword[pJob]
    call    TotalPay
    add     esp,4
        
    popa
    leave
    ret
    ; subprograms go here
    
CreateJobs:
    enter   0,0
    push    ebx
    
    mov     eax,Job_size
    push    eax
    call    malloc
    add     esp,4
    mov     dword[pJob],eax
    mov     ebx,eax             ;ebx = address of struct
    
    push    dword[count]
    push    promptname
    call    printf
    add     esp,8
    
    mov     eax,[ebp+4]         
    mov     [ebx],eax           ;job_id = eax
    
    lea     eax,[ebx+job_name]  ;eax = address of job_name
    push    eax
    push    inputS
    call    scanf
    add     esp,8
    
    push    dword[count]
    push    prompttime
    call    printf
    add     esp,8               ;Prompt for job time
    
    lea     eax,[ebx+job_time]
    push    eax
    push    inputD
    call    scanf
    add     esp,8               ;Move input into job time
    
    push    dword[count]
    push    promptpay
    call    printf
    add     esp,8               ;Prompt for job pay
    
    lea     eax,[ebx+job_pay]
    push    eax
    push    inputD
    call    scanf
    add     esp,8               ;Move pay into job pay
    
    mov     eax,ebx             ;Returning address to eax
    
    pop     ebx
    leave
    ret
    
PrintJobs:
    enter   0,0
    push    ebx
    mov     ebx,[ebp+8]         ;ebx = instance of Job
    
    mov     eax,dword[count]    ;Display job ID
    push    eax                 ;Put job ID into eax and print
    push    outputid
    call    printf
    add     esp,8
    
    lea     eax,[ebx+job_name]  ;Load address of string into eax
    push    eax
    push    outputname
    call    printf
    add     esp,8
    
    mov     eax,[ebx+job_time]  ;Display job time
    push    eax
    push    outputtime
    call    printf
    add     esp,8
    
    mov     eax,[ebx+job_pay]   ;Display job pay
    add     dword[total],eax
    push    eax
    push    outputpay
    call    printf
    add     esp,8
    
    pop     ebx
    leave
    ret
    
TotalPay:
    enter   0,0
    push    ebx
    mov     ebx,[ebp+8]         ;Moving pushed item into ebx
    
    push    dword[total]
    push    totalpay
    call    printf
    add     esp,8
    
    pop     ebx
    leave
    ret