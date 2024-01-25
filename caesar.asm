.data
offset: .byte 1
max_length: .byte 254

msg: .string "Plaintext: "
msg_len = . - msg

plaintext: .zero 255
ciphertext: .zero 255

.text
.globl _start

_start:
    movq $4, %rax   # sys_write
    movq $1, %rbx   # stdout
    movq $msg, %rcx
    movq $msg_len, %rdx
    int $0x80
    
    movq $3, %rax   # sys_read
    movq $0, %rbx   # stdin
    movq $plaintext, %rcx
    movq max_length, %rdx
    int $0x80

    call _encrypt

    movq $4, %rax   # sys_write
    movq $1, %rbx   # stdout
    movq $ciphertext, %rcx
    movq $5, %rdx
    int $0x80

_exit:
    movq $1, %rax   # sys_exit
    xorq %rbx, %rbx
    int $0x80

_encrypt:
    movq $plaintext, %rax
    jmp L1
    ret
L0:
    movq $ciphertext, %rcx
    addq %rax, %rcx
    movb %bl, (%rcx)
    addq $1, %rax
L1:
    movb (%rax), %bl
    testb %bl, %bl
    jne L0
    ret
