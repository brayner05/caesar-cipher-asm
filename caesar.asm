.data
offset: .byte 1
max_length: .byte 254

msg: .asciz "Plaintext: "
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

    movq %rax, %rdx # The length of ciphertext
    movq $4, %rax   # sys_write
    movq $1, %rbx   # stdout
    movq $ciphertext, %rcx
    int $0x80

_exit:
    movq $1, %rax   # sys_exit
    xorq %rbx, %rbx
    int $0x80

_encrypt:
    movq $plaintext, %rax
    movq $ciphertext, %rcx
    jmp L1
L0:
    movb offset, %dl
    addb %dl, %bl
    movb %bl, (%rcx)
    addq $1, %rax
    addq $1, %rcx
L1:
    movb (%rax), %bl
    cmp $'\n', %bl
    jnz L0
    movb $'\n', (%rcx)
    addq $1, %rcx
    subq $ciphertext, %rcx
    movq %rcx, %rax
    ret
