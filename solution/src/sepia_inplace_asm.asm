default rel
extern _GLOBAL_OFFSET_TABLE_
global sepia_asm_inplace:function

section .rodata
mat11: dd 0.131, 0.168, 0.189, 0.131
mat12: dd 0.543, 0.686, 0.769, 0.543
mat13: dd 0.272, 0.349, 0.393, 0.272

mat21: dd 0.168, 0.189, 0.131, 0.168
mat22: dd 0.686, 0.769, 0.543, 0.686
mat23: dd 0.349, 0.393, 0.272, 0.349

mat31: dd 0.189, 0.131, 0.168, 0.189
mat32: dd 0.769, 0.543, 0.686, 0.769
mat33: dd 0.393, 0.272, 0.349, 0.393

section .bss
temp: RESD 1

section .text
sepia_asm_inplace:
    stmxcsr     [temp]
    or          dword [temp], 0x4000
    ldmxcsr     [temp]
    mov         rax,    [rdi]
    mov         rcx,    [rdi+8]
    imul        rcx
    mov         rdx,    [rdi+16]
    movdqu      xmm7,   [mat11]
    movdqu      xmm8,   [mat12]
    movdqu      xmm9,   [mat13]
    movdqu      xmm10,  [mat21]
    movdqu      xmm11,  [mat22]
    movdqu      xmm12,  [mat23]
    movdqu      xmm13,  [mat31]
    movdqu      xmm14,  [mat32]
    movdqu      xmm15,  [mat33]
    .load:
        pmovzxbd    xmm0,   dword   [rdx]
        cvtdq2ps    xmm0,   xmm0
        pmovzxbd    xmm1,   dword   [rdx+4]
        cvtdq2ps    xmm1,   xmm1
        pmovzxbd    xmm2,   dword   [rdx+8]
        cvtdq2ps    xmm2,   xmm2
        vpshufd     xmm3,   xmm0,   0b11000000
        vpshufd     xmm4,   xmm0,   0b01010101
        blendps     xmm4,   xmm1,   0b00000001
        vpshufd     xmm4,   xmm4,   0b00111111
        vpshufd     xmm5,   xmm0,   0b10101010
        blendps     xmm5,   xmm1,   0b00000010
        vpshufd     xmm5,   xmm5,   0b01111111
        mulps       xmm3,   xmm7
        mulps       xmm4,   xmm8
        mulps       xmm5,   xmm9
        xorps       xmm6,   xmm6
        addps       xmm6,   xmm3
        addps       xmm6,   xmm4
        addps       xmm6,   xmm5
        cvttps2dq   xmm6,   xmm6
        packusdw    xmm6,   xmm6
        packuswb    xmm6,   xmm6
        movd        dword   [rdx],  xmm6
        vpshufd     xmm3,   xmm0,   0b11111111
        blendps     xmm3,   xmm1,   0b00000100
        vpshufd     xmm3,   xmm3,   0b10100000
        vpshufd     xmm4,   xmm1,   0b11110000
        vpshufd     xmm5,   xmm1,   0b01010101
        blendps     xmm5,   xmm2,   0b00000001
        vpshufd     xmm5,   xmm5,   0b00000101
        mulps       xmm3,   xmm10
        mulps       xmm4,   xmm11
        mulps       xmm5,   xmm12
        xorps       xmm6,   xmm6
        addps       xmm6,   xmm3
        addps       xmm6,   xmm4
        addps       xmm6,   xmm5
        cvttps2dq   xmm6,   xmm6
        packusdw    xmm6,   xmm6
        packuswb    xmm6,   xmm6
        movd        dword   [rdx+4], xmm6
        vpshufd     xmm3,   xmm1,   0b10101010
        blendps     xmm3,   xmm2,   0b00000010
        vpshufd     xmm3,   xmm3,   0b01010100
        vpshufd     xmm4,   xmm1,   0b11111111
        blendps     xmm4,   xmm2,   0b00000100
        vpshufd     xmm4,   xmm4,   0b10101000
        vpshufd     xmm5,   xmm2,   0b11111100
        mulps       xmm3,   xmm13
        mulps       xmm4,   xmm14
        mulps       xmm5,   xmm15
        xorps       xmm6,   xmm6
        addps       xmm6,   xmm3
        addps       xmm6,   xmm4
        addps       xmm6,   xmm5
        cvttps2dq   xmm6,   xmm6
        packusdw    xmm6,   xmm6
        packuswb    xmm6,   xmm6
        movd        dword   [rdx+8], xmm6
        sub         rax,    4
        add         rdx,    12
    cmp         rax,    4
    jg          .load
    ret
