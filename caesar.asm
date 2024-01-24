.data
offset: .byte 1
max_length: .byte 254

start_message: .string "Offset: "
start_len: .byte 8

plaintext: .zero 255
ciphertext: .zero 255

.text
.globl _start

_start:
    movq $4, %rax   # sys_write
    movq $1, %rbx   # stdout
    movq $start_message, %rcx
    movq start_len, %rdx
    int $0x80
    
    movq $3, %rax   # sys_read
    movq $0, %rbx   # stdin
    movq $plaintext, %rcx
    movq max_length, %rdx
    int $0x80

    movq $4, %rax   # sys_write
    movq $1, %rbx   # stdout
    movq $plaintext, %rcx
    movq max_length, %rdx
    int $0x80

_exit:
    movq $1, %rax   # sys_exit
    xorq %rbx, %rbx # Exit code 0
    int $0x80

_encrypt:
    movq $plaintext, %rax

_a_strlen:
    movq %rdi, %rax
    movq $0, %rbx
L0:
    addq $1, %rax
    cmpb '\0', %rax
    jnz L0
    ret