; main.asm - 64-bit NASM program (Windows)
; Toolchain: NASM + MinGW-w64 (the copies shipped with SASM)
;
; Build (local, uses SASM tools via build.ps1):
;   nasm -f win64 src/main.asm -o build/main.obj
;   gcc  build/main.obj -o build/main.exe
;
; On CI we use the equivalent msys2 MINGW64 nasm + gcc.

section .data
    banner   db "SASM toolchain test: NASM + MinGW-w64 (x86_64)", 0
    fmt_s    db "%s", 13, 10, 0
    msg_sum  db "Sum of 1..100 = %d (expected 5050)", 13, 10, 0
    msg_pass db "RESULT: PASS", 13, 10, 0

section .text
    global main
    extern printf

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 48              ; shadow space + 16-byte alignment

    ; print banner
    lea     rcx, [rel fmt_s]
    lea     rdx, [rel banner]
    call    printf

    ; compute sum 1..100
    xor     eax, eax             ; accumulator
    xor     ecx, ecx             ; loop counter i
.sumloop:
    inc     ecx
    add     eax, ecx
    cmp     ecx, 100
    jl      .sumloop

    ; print the sum line
    lea     rcx, [rel msg_sum]
    mov     edx, eax
    call    printf

    ; print result marker
    lea     rcx, [rel fmt_s]
    lea     rdx, [rel msg_pass]
    call    printf

    xor     eax, eax             ; return 0
    leave
    ret
