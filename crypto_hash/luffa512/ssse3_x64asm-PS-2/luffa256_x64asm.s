/*
 * luffa256_x64asm.s
 * Luffa Specification Version 2.0.1 (Oct 2nd 2009)
 *
 * Implementation of Luffa-256: Oliveira, Lopez approach
 * Method: Perfect Shuffle
 * Programmed by Hitachi Ltd.
 * 
 *
 * Copyright (C) 2008-2010 Hitachi, Ltd. All rights reserved.
 *
 * Hitachi, Ltd. is the owner of this software and hereby grant
 * the U.S. Government and any interested party the right to use
 * this software for the purposes of the SHA-3 evaluation process,
 * notwithstanding that this software is copyrighted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

.intel_syntax

	.macro	ROUND m0,m1,m2,m3,m4,m5,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9
	MI_IS	\m0,\m1,\m2,\m3,\m4,\m5,\t5,\t6,\t2,\t3,\t4
	PSHFL	\t0,\t1,\t2,\t3,\t4,\t5,\t6,\t7
	pxor	\m0,\t0
	pxor	\m1,\t1
	movdqa	\t4,XMMWORD PTR mult2mask[0]
	MULT2_1	\t0,\t1,\t2,\t3,\t4
	pxor	\m2,\t0
	pxor	\m3,\t1
	MULT2_1	\t0,\t1,\t2,\t3,\t4
	pxor	\m4,\t0
	pxor	\m5,\t1
	PERM	\m0,\m1,\m2,\m3,\m4,\m5,\t0,\t1,\t2,\t3,\t4,\t5,\t6,\t7,\t8,\t9
	.endm

	.macro	OUTPUT m0,m1,m2,m3,m4,m5,t0,t1,rout
	pxor	\m0,\m2
	pxor	\m1,\m3
	pxor	\m0,\m4
	pxor	\m1,\m5
	UNPSHFL	\m0,\m1,\m2,\m3,\m4,\m5,\t0,\t1
	movdqa	XMMWORD PTR [\rout], \m0
	movdqa	XMMWORD PTR [\rout+16], \m1
	.endm

	.macro	UNPSHFL m0,m1,t0,t1,r0,r1,r2,r3
	movdqa	\r0, XMMWORD PTR psmask[0]
	SHFL_PART \m0,\m1,\t0,\t1, 2,psmask[32]
	SHFL_PART \m0,\m1,\t0,\t1, 4,psmask[16]
	pshufb	\m0,\r0
	pshufb	\m1,\r0
	pshufhw	\m0,\m0,0xd8
	pshufhw	\m1,\m1,0xd8
	pshuflw	\m0,\m0,0xd8
	pshuflw	\m1,\m1,0xd8
	pshufd	\m0,\m0,0xd8
	pshufd	\m1,\m1,0xd8
	SHFL_PART \m0,\m1,\t0,\t1, 1,psmask[48]
	SHFL_PART \m0,\m1,\t0,\t1, 2,psmask[32]
	SHFL_PART \m0,\m1,\t0,\t1, 4,psmask[16]
	pshufb	\m0,\r0
	pshufb	\m1,\r0
	pshufhw	\m0,\m0,0xd8
	pshufhw	\m1,\m1,0xd8
	pshuflw	\m0,\m0,0xd8
	pshuflw	\m1,\m1,0xd8
	.endm

	.macro	MI_IS m0,m1,m2,m3,m4,m5,t0,t1,t2,t3,r0
	movdqa	\t0,\m0
	movdqa	\t1,\m1
	pxor	\t0,\m2
	pxor	\t1,\m3
	pxor	\t0,\m4
	pxor	\t1,\m5
	movdqa	\r0, XMMWORD PTR mult2mask[0]
	MULT2_1	\t0,\t1,\t2,\t3,\r0
	pxor	\m0,\t0
	pxor	\m1,\t1
	pxor	\m2,\t0
	pxor	\m3,\t1
	pxor	\m4,\t0
	pxor	\m5,\t1
	.endm

	.macro	MULT2_1 m0,m1,t0,t1,r0
	movdqa	\t0,\m0
	movdqa	\t1,\m1
	pand	\t0,\r0
	pand	\t1,\r0
	pxor	\m0,\t0
	pxor	\m1,\t1
	pslld	\m0,1
	pslld	\m1,1
	psrld	\t0,3
	pxor	\m1,\t0
	pxor	\m0,\t1
	psrld	\t1,2
	pxor	\m0,\t1
	psrld	\t1,1
	pxor	\m1,\t1
	pxor	\m0,\t1
	.endm

	.macro	PERM m0,m1,m2,m3,m4,m5,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9
	TWEAK	\m3,\m5,\t0
	movdqa	\t8, XMMWORD PTR sbox[48]
	STEP	\m0,\m1,\m2,\m3,\m4,\m5,\t0,\t1,\t2,\t3,\t4,\t5,\t6,\t7,\t8,\t9,RND_CNS
	STEP	\t0,\t1,\t2,\t3,\t4,\t5,\m0,\m1,\m2,\m3,\m4,\m5,\t6,\t7,\t8,\t9,RND_CNS+96
	STEP	\m0,\m1,\m2,\m3,\m4,\m5,\t0,\t1,\t2,\t3,\t4,\t5,\t6,\t7,\t8,\t9,RND_CNS+192
	STEP	\t0,\t1,\t2,\t3,\t4,\t5,\m0,\m1,\m2,\m3,\m4,\m5,\t6,\t7,\t8,\t9,RND_CNS+288
	STEP	\m0,\m1,\m2,\m3,\m4,\m5,\t0,\t1,\t2,\t3,\t4,\t5,\t6,\t7,\t8,\t9,RND_CNS+384
	STEP	\t0,\t1,\t2,\t3,\t4,\t5,\m0,\m1,\m2,\m3,\m4,\m5,\t6,\t7,\t8,\t9,RND_CNS+480
	STEP	\m0,\m1,\m2,\m3,\m4,\m5,\t0,\t1,\t2,\t3,\t4,\t5,\t6,\t7,\t8,\t9,RND_CNS+576
	STEP	\t0,\t1,\t2,\t3,\t4,\t5,\m0,\m1,\m2,\m3,\m4,\m5,\t6,\t7,\t8,\t9,RND_CNS+672
	.endm

	.macro	TWEAK m3,m5,t0
	pshufd	\t0,\m3,0x39
	pslld	\m3,4
	pshufb	\m5,XMMWORD PTR mwmask[0]
	psrld	\t0,28
	por		\m3,\t0
	.endm

	.macro	STEP m0,m1,m2,m3,m4,m5,t0,t1,t2,t3,t4,t5,t6,t7,t8,r0,cns
	SUB_CRUMB	\m0,\m1,\m2,\m3,\m4,\m5,\t0,\t1,\t2,\t3,\t4,\t5,\t6,\t7,\t8,\r0
	MIX_WORD	\t0,\t1,\t2,\t3,\t4,\t5,\m0,\m1,\m2,\m3,\m4,\m5,\t6,\cns
	.endm

	.macro	SUB_CRUMB m0,m1,m2,m3,m4,m5,t0,t1,t2,t3,t4,t5,t6,t7,t8,r0
	movdqa	\t0, XMMWORD PTR sbox[0]
	movdqa	\t1, XMMWORD PTR sbox[16]
	movdqa	\r0, XMMWORD PTR smask[0]
	movdqa	\t3, \m0
	pand	\m0, \r0
	psrld	\t3, 4
	pshufb	\t0, \m0
	pand	\t3, \r0
	pshufb	\t1, \t3
	pxor	\t0, \t1

	movdqa	\t2, XMMWORD PTR sbox[0]
	movdqa	\m0, XMMWORD PTR sbox[16]
	movdqa	\t3, \m2
	pand	\m2, \r0
	psrld	\t3, 4
	pshufb	\t2, \m2
	pand	\t3, \r0
	pshufb	\m0, \t3
	pxor	\t2, \m0

	movdqa	\t4, XMMWORD PTR sbox[0]
	movdqa	\m2, XMMWORD PTR sbox[16]
 	movdqa	\m0, \m4
	pand	\m4, \r0
	psrld	\m0, 4
	pshufb	\t4, \m4
	pand	\m0, \r0
	pshufb	\m2, \m0
	pxor	\t4, \m2

	movdqa	\t1, XMMWORD PTR sbox[32]
	movdqa	\m0, XMMWORD PTR sbox[48]
	movdqa	\m2, \m1
	pand	\m1, \r0
	psrld	\m2, 4
	pshufb	\t1, \m1
	pand	\m2, \r0
	pshufb	\m0, \m2
	pxor	\t1, \m0

	movdqa	\t3, XMMWORD PTR sbox[32]
	movdqa	\m2, \t8
	movdqa	\m0, \m3
	pand	\m3, \r0
	psrld	\m0, 4
	pshufb	\t3, \m3
	pand	\m0, \r0
	pshufb	\m2, \m0
	pxor	\t3, \m2

	movdqa	\t5, XMMWORD PTR sbox[32]
	movdqa	\m0, \t8
	movdqa	\m2, \m5
	pand	\m5, \r0
	psrld	\m2, 4
	pshufb	\t5, \m5
	pand	\m2, \r0
	pshufb	\m0, \m2
	pxor	\t5, \m0
	.endm

	.macro	MIX_WORD m0,m1,m2,m3,m4,m5,t0,t1,t2,r0,r1,r2,r3,cns
	movdqa	\r0,XMMWORD PTR mwmask[0]
	movdqa	\r1,XMMWORD PTR mwmask[16]
	movdqa	\r2,XMMWORD PTR mwmask[32]
	pxor	\m1,\m0
	pshufb	\m0,\r0
	pxor	\m0,\m1
	pshufb	\m1,\r1
	pxor	\m1,\m0
	pshufb	\m0,\r2
	pxor	\m0,\m1
	pshufd	\t0,\m1,0x39
	pxor	\m3,\m2
	pshufb	\m2,\r0
	pslld	\m1,4
	pxor	\m2,\m3
	pshufb	\m3,\r1
	psrld	\t0,28

	pxor	\m3,\m2
	pshufb	\m2,\r2
	pxor	\m0, XMMWORD PTR [\cns+0]
	pxor	\m2,\m3
	pshufd	\t1,\m3,0x39
	pslld	\m3,4
	pxor	\m5,\m4
	pshufb	\m4,\r0
	psrld	\t1,28
	pxor	\m4,\m5

 	pxor	\m2, XMMWORD PTR [\cns+32]
	pshufb	\m5,\r1
	pxor	\m5,\m4
	pshufb	\m4,\r2
	pxor	\m4,\m5
	pshufd	\t2,\m5,0x39
	pslld	\m5,4
	por		\m1,\t0
	pxor	\m4, XMMWORD PTR [\cns+64]
	por		\m3,\t1
	psrld	\t2,28
	por		\m5,\t2
	pxor	\m1, XMMWORD PTR [\cns+16]
	pxor	\m3, XMMWORD PTR [\cns+48]
	pxor	\m5, XMMWORD PTR [\cns+80]
	.endm

	.macro	PSHFL m0,m1,t0,t1,r0,r1,r2,r3
	pshufhw	\m0,\m0,0xd8
	pshuflw	\m0,\m0,0xd8
	pshufb	\m0, XMMWORD PTR psmask[0]

	pshufhw	\m1,\m1,0xd8
	pshuflw	\m1,\m1,0xd8
	pshufb	\m1, XMMWORD PTR psmask[0]
	SHFL_PART \m0,\m1,\t0,\t1, 4,psmask[16]
	SHFL_PART \m0,\m1,\t0,\t1, 2,psmask[32]
	SHFL_PART \m0,\m1,\t0,\t1, 1,psmask[48]

	pshufd	\m0,\m0,0xd8
	pshufhw	\m0,\m0,0xd8
	pshuflw	\m0,\m0,0xd8
	pshufb	\m0, XMMWORD PTR psmask[0]

	pshufd	\m1,\m1,0xd8
	pshufhw	\m1,\m1,0xd8
	pshuflw	\m1,\m1,0xd8
	pshufb	\m1, XMMWORD PTR psmask[0]
	SHFL_PART \m0,\m1,\t0,\t1, 4,psmask[16]
	SHFL_PART \m0,\m1,\t0,\t1, 2,psmask[32]
	.endm

	.macro	SHFL_PART m0,m1,t0,t1,sh,r
	movdqa	\t0, \m0
	psrlq	\t0, \sh
	pxor	\t0, \m0
	pand	\t0, XMMWORD PTR \r
	pxor	\m0, \t0
	psllq	\t0, \sh
	pxor	\m0, \t0

	movdqa	\t1, \m1
	psrlq	\t1, \sh
	pxor	\t1, \m1
	pand	\t1, XMMWORD PTR \r
	pxor	\m1, \t1
	psllq	\t1, \sh
	pxor	\m1, \t1
	.endm


.text
	.globl	luffa256_init
	.type	luffa256_init, @function
	.align	16
luffa256_init:
	movdqa	%xmm0, [IV   ]
	movdqa	%xmm1, [IV+16]
	movdqa	%xmm2, [IV+32]
	movdqa	%xmm3, [IV+48]
	movdqa	%xmm4, [IV+64]
	movdqa	%xmm5, [IV+80]
	movdqu	[%rdi   ], %xmm0
	movdqu	[%rdi+16], %xmm1
	movdqu	[%rdi+32], %xmm2
	movdqu	[%rdi+48], %xmm3
	movdqu	[%rdi+64], %xmm4
	movdqu	[%rdi+80], %xmm5
	ret
	.size	luffa256_init, .-luffa256_init


//luffa-256 round function
	.globl	luffa256
	.type	luffa256, @function
	.align	16
luffa256:
	mov	%rax, 0 
	movdqu	%xmm0, [%rdi   ]
	movdqu	%xmm1, [%rdi+16]
	movdqu	%xmm2, [%rdi+32]
	movdqu	%xmm3, [%rdi+48]
	movdqu	%xmm4, [%rdi+64]
	movdqu	%xmm5, [%rdi+80]

.RND256:
	movdqu	%xmm6, [%rsi   ]
	movdqu	%xmm7, [%rsi+16]

	ROUND	%xmm0,%xmm1,%xmm2,%xmm3,%xmm4,%xmm5,%xmm6,%xmm7,%xmm8,%xmm9,%xmm10,%xmm11,%xmm12,%xmm13,%xmm14,%xmm15
	add	%rsi, 32
	add	%rax, 1
	cmp	%rax, %rdx
	jl	.RND256

	movdqu	[%rdi   ], %xmm0
	movdqu	[%rdi+16], %xmm1
	movdqu	[%rdi+32], %xmm2
	movdqu	[%rdi+48], %xmm3
	movdqu	[%rdi+64], %xmm4
	movdqu	[%rdi+80], %xmm5
	ret
	.size	luffa256, .-luffa256


	.globl	luffa256_final
	.type	luffa256_final, @function
	.align	16
luffa256_final:
	movdqu	%xmm0, [%rdi   ]
	movdqu	%xmm1, [%rdi+16]
	movdqu	%xmm2, [%rdi+32]
	movdqu	%xmm3, [%rdi+48]
	movdqu	%xmm4, [%rdi+64]
	movdqu	%xmm5, [%rdi+80]

	pxor	%xmm6, %xmm6
	movdqa	%xmm7, %xmm6
	ROUND	%xmm0,%xmm1,%xmm2,%xmm3,%xmm4,%xmm5,%xmm6,%xmm7,%xmm8,%xmm9,%xmm10,%xmm11,%xmm12,%xmm13,%xmm14,%xmm15
	OUTPUT	%xmm0,%xmm1,%xmm2,%xmm3,%xmm4,%xmm5,%xmm6,%xmm7,%rsi
	ret
	.size	luffa256_final, .-luffa256_final


	.section	.rodata
	.globl	m2mask
	.align	32
	.type	m2mask, @object
	.size	m2mask, 32
m2mask:	
	.long	0xffffffff,0xffffffff,0x00000000,0xffffffff
	.long	0xffffffff,0x00000000,0x00000000,0x00000000
mult2mask:
	.long	0x88888888,0x88888888,0x88888888,0x88888888
sbox:
	.byte	0x0d,0x0e,0x00,0x01,0x05,0x0a,0x07,0x06
	.byte	0x0b,0x03,0x09,0x0c,0x0f,0x08,0x02,0x04
	.byte	0xd0,0xe0,0x00,0x10,0x50,0xa0,0x70,0x60
	.byte	0xb0,0x30,0x90,0xc0,0xf0,0x80,0x20,0x40
	.byte	0x0b,0x07,0x0d,0x06,0x00,0x03,0x02,0x09
	.byte	0x0a,0x0f,0x05,0x01,0x0e,0x04,0x0c,0x08
	.byte	0xb0,0x70,0xd0,0x60,0x00,0x30,0x20,0x90
	.byte	0xa0,0xf0,0x50,0x10,0xe0,0x40,0xc0,0x80
smask:
	.long	0x0f0f0f0f,0x0f0f0f0f,0x0f0f0f0f,0x0f0f0f0f
mwmask:
	.byte	0x7,0x0,0x1,0x2,0xb,0x4,0x5,0x6
	.byte	0xf,0x8,0x9,0xa,0x3,0xc,0xd,0xe
	.byte	0x9,0xa,0xb,0x4,0xd,0xe,0xf,0x8
	.byte	0x1,0x2,0x3,0xc,0x5,0x6,0x7,0x0
	.byte	0xb,0x4,0x5,0x6,0xf,0x8,0x9,0xa
	.byte	0x3,0xc,0xd,0xe,0x7,0x0,0x1,0x2
	.long	0xf0000000,0xf0000000,0xf0000000,0xf0000000
psmask:
	.long	0x03010200,0x07050604,0x0b090a08,0x0f0d0e0c
	.long	0x00f000f0,0x00f000f0,0x00f000f0,0x00f000f0
	.long	0x0c0c0c0c,0x0c0c0c0c,0x0c0c0c0c,0x0c0c0c0c
	.long	0x22222222,0x22222222,0x22222222,0x22222222
	.long	0x05040100,0x07060302,0x0d0c0908,0x0f0e0b0a

	.align	32
	.type	IV, @object
	.size	IV, 96
IV:
	.byte 0xc9,0xd7,0x18,0x8f,0xc9,0x49,0xfa,0xe8
	.byte 0x56,0x5d,0x43,0x86,0x09,0x1c,0xf4,0x6b
	.byte 0xd0,0xdd,0x5a,0xed,0x87,0x1e,0x9a,0x88
	.byte 0x06,0x22,0x38,0x40,0x8d,0xc2,0xef,0xa2
	.byte 0x93,0xa8,0x4e,0xbf,0x68,0xc5,0x53,0x76
	.byte 0xbd,0xd8,0x6a,0xe7,0xa9,0x03,0xc3,0xd2
	.byte 0x67,0x7f,0x89,0x6d,0x13,0xfc,0x85,0x3a
	.byte 0x4d,0x4f,0x08,0xce,0x7b,0x45,0x23,0xa1
	.byte 0x1b,0xaf,0x93,0x93,0x3d,0x39,0xb2,0x39
	.byte 0x22,0xde,0x4a,0x97,0x0f,0x1d,0x41,0x74
	.byte 0xb9,0x86,0x60,0x82,0xd2,0x6b,0xe0,0x42
	.byte 0xc5,0xb0,0x43,0x08,0xf9,0x5b,0xa2,0x89

RND_CNS:
	.byte 0x00,0x00,0x11,0x00,0x01,0x10,0x11,0x00
	.byte 0x00,0x01,0x01,0x10,0x10,0x01,0x10,0x10
	.byte 0x00,0x00,0x10,0x11,0x11,0x00,0x11,0x00
	.byte 0x00,0x10,0x11,0x01,0x00,0x10,0x01,0x00
	.byte 0x10,0x01,0x11,0x10,0x10,0x11,0x01,0x11
	.byte 0x00,0x00,0x01,0x00,0x01,0x11,0x10,0x11
	.byte 0x01,0x00,0x00,0x00,0x00,0x10,0x10,0x01
	.byte 0x11,0x11,0x01,0x01,0x01,0x11,0x11,0x00
	.byte 0x00,0x11,0x11,0x11,0x00,0x00,0x10,0x00
	.byte 0x01,0x10,0x01,0x11,0x10,0x00,0x01,0x11
	.byte 0x10,0x00,0x10,0x11,0x10,0x11,0x01,0x01
	.byte 0x10,0x00,0x11,0x01,0x01,0x00,0x00,0x11

	.byte 0x00,0x00,0x00,0x11,0x10,0x01,0x10,0x11
	.byte 0x10,0x00,0x01,0x01,0x01,0x10,0x01,0x10
	.byte 0x00,0x01,0x00,0x01,0x11,0x10,0x01,0x00
	.byte 0x01,0x10,0x10,0x10,0x01,0x11,0x00,0x00
	.byte 0x00,0x00,0x11,0x01,0x00,0x01,0x11,0x11
	.byte 0x10,0x10,0x11,0x01,0x10,0x11,0x10,0x10
	.byte 0x01,0x01,0x00,0x00,0x01,0x00,0x10,0x10
	.byte 0x00,0x11,0x11,0x01,0x00,0x01,0x11,0x11
	.byte 0x00,0x01,0x11,0x00,0x01,0x01,0x01,0x01
	.byte 0x10,0x11,0x10,0x00,0x01,0x01,0x10,0x00
	.byte 0x10,0x01,0x10,0x11,0x11,0x00,0x10,0x00
	.byte 0x11,0x10,0x11,0x10,0x10,0x00,0x11,0x01

	.byte 0x00,0x11,0x10,0x01,0x11,0x00,0x00,0x11
	.byte 0x10,0x10,0x11,0x00,0x10,0x00,0x01,0x00
	.byte 0x11,0x11,0x11,0x01,0x00,0x01,0x11,0x00
	.byte 0x00,0x01,0x01,0x11,0x10,0x00,0x00,0x01
	.byte 0x11,0x01,0x00,0x00,0x11,0x01,0x00,0x00
	.byte 0x11,0x00,0x10,0x10,0x00,0x01,0x01,0x11
	.byte 0x01,0x11,0x11,0x10,0x01,0x10,0x00,0x00
	.byte 0x10,0x10,0x00,0x11,0x10,0x10,0x00,0x11
	.byte 0x10,0x10,0x11,0x01,0x00,0x10,0x01,0x11
	.byte 0x01,0x00,0x00,0x10,0x11,0x11,0x00,0x10
	.byte 0x00,0x11,0x01,0x01,0x00,0x10,0x01,0x01
	.byte 0x00,0x01,0x10,0x10,0x00,0x01,0x10,0x10

	.byte 0x00,0x11,0x01,0x11,0x10,0x01,0x01,0x01
	.byte 0x00,0x10,0x01,0x10,0x10,0x11,0x11,0x00
	.byte 0x11,0x00,0x01,0x10,0x01,0x10,0x00,0x10
	.byte 0x01,0x00,0x10,0x00,0x11,0x11,0x11,0x01
	.byte 0x00,0x11,0x01,0x00,0x10,0x11,0x01,0x00
	.byte 0x11,0x11,0x00,0x10,0x01,0x00,0x01,0x01
	.byte 0x00,0x01,0x11,0x11,0x11,0x01,0x10,0x00
	.byte 0x11,0x10,0x10,0x00,0x00,0x10,0x10,0x00
	.byte 0x00,0x01,0x00,0x10,0x00,0x10,0x11,0x00
	.byte 0x10,0x01,0x11,0x01,0x10,0x10,0x00,0x01
	.byte 0x10,0x11,0x01,0x00,0x00,0x10,0x11,0x00
	.byte 0x10,0x00,0x10,0x11,0x11,0x01,0x10,0x11

	.byte 0x10,0x11,0x01,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x01,0x00,0x11,0x11,0x00,0x10
	.byte 0x01,0x01,0x10,0x11,0x00,0x10,0x10,0x10
	.byte 0x00,0x11,0x11,0x10,0x10,0x01,0x10,0x11
	.byte 0x00,0x00,0x11,0x01,0x10,0x10,0x11,0x01
	.byte 0x01,0x11,0x11,0x00,0x01,0x01,0x00,0x01
	.byte 0x00,0x01,0x01,0x00,0x10,0x10,0x00,0x01
	.byte 0x01,0x01,0x10,0x11,0x00,0x11,0x00,0x11
	.byte 0x11,0x10,0x11,0x10,0x01,0x11,0x10,0x01
	.byte 0x00,0x00,0x10,0x11,0x10,0x00,0x11,0x00
	.byte 0x00,0x10,0x11,0x01,0x11,0x00,0x10,0x11
	.byte 0x11,0x10,0x00,0x10,0x01,0x11,0x01,0x10

	.byte 0x00,0x10,0x11,0x01,0x00,0x00,0x00,0x00
	.byte 0x10,0x00,0x00,0x01,0x01,0x11,0x11,0x00
	.byte 0x10,0x00,0x01,0x01,0x00,0x01,0x11,0x01
	.byte 0x10,0x10,0x11,0x10,0x00,0x01,0x11,0x11
	.byte 0x10,0x11,0x10,0x10,0x10,0x00,0x11,0x10
	.byte 0x01,0x01,0x00,0x10,0x10,0x00,0x10,0x01
	.byte 0x10,0x10,0x11,0x11,0x11,0x01,0x10,0x10
	.byte 0x10,0x11,0x10,0x10,0x11,0x10,0x10,0x00
	.byte 0x01,0x11,0x10,0x11,0x11,0x01,0x11,0x10
	.byte 0x00,0x00,0x00,0x10,0x00,0x10,0x00,0x11
	.byte 0x11,0x01,0x10,0x00,0x00,0x10,0x01,0x01
	.byte 0x11,0x01,0x10,0x01,0x01,0x10,0x01,0x00

	.byte 0x11,0x11,0x00,0x10,0x11,0x10,0x01,0x01
	.byte 0x00,0x10,0x11,0x01,0x10,0x00,0x00,0x10
	.byte 0x10,0x01,0x10,0x00,0x00,0x10,0x00,0x10
	.byte 0x11,0x10,0x01,0x10,0x11,0x01,0x10,0x10
	.byte 0x10,0x10,0x11,0x10,0x10,0x10,0x00,0x11
	.byte 0x01,0x01,0x01,0x00,0x01,0x10,0x00,0x10
	.byte 0x10,0x11,0x10,0x00,0x00,0x10,0x00,0x01
	.byte 0x01,0x00,0x11,0x11,0x01,0x00,0x00,0x11
	.byte 0x01,0x10,0x01,0x11,0x00,0x01,0x00,0x10
	.byte 0x11,0x00,0x11,0x01,0x10,0x01,0x01,0x01
	.byte 0x10,0x01,0x11,0x00,0x01,0x11,0x10,0x11
	.byte 0x01,0x01,0x10,0x10,0x11,0x11,0x11,0x01

	.byte 0x10,0x01,0x01,0x10,0x01,0x00,0x10,0x11
	.byte 0x11,0x10,0x01,0x11,0x10,0x00,0x01,0x00
	.byte 0x10,0x10,0x01,0x10,0x10,0x00,0x10,0x00
	.byte 0x10,0x11,0x10,0x01,0x01,0x11,0x01,0x10
	.byte 0x00,0x00,0x00,0x01,0x00,0x01,0x10,0x10
	.byte 0x11,0x11,0x10,0x01,0x10,0x11,0x11,0x00
	.byte 0x01,0x10,0x11,0x10,0x11,0x00,0x10,0x00
	.byte 0x11,0x01,0x00,0x11,0x00,0x01,0x00,0x00
	.byte 0x10,0x00,0x10,0x10,0x11,0x01,0x00,0x11
	.byte 0x00,0x01,0x00,0x10,0x00,0x01,0x11,0x00
	.byte 0x00,0x00,0x11,0x01,0x10,0x10,0x11,0x00
	.byte 0x00,0x11,0x10,0x10,0x11,0x01,0x10,0x11

