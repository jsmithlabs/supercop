inline void P1024ASM(u64 *x) {
asm (
	"\n	### load input state from memory to 16 low halves of XMM registers xmm0...xmm15"
	"\n	movaps	0(%0), %%xmm0"
	"\n	movhlps	%%xmm0, %%xmm1"
	"\n	movaps	16(%0), %%xmm2"
	"\n	movhlps	%%xmm2, %%xmm3"
	"\n	movaps	32(%0), %%xmm4"
	"\n	movhlps	%%xmm4, %%xmm5"
	"\n	movaps	48(%0), %%xmm6"
	"\n	movhlps	%%xmm6, %%xmm7"
	"\n	movaps	64(%0), %%xmm8"
	"\n	movhlps	%%xmm8, %%xmm9"
	"\n	movaps	80(%0), %%xmm10"
	"\n	movhlps	%%xmm10, %%xmm11"
	"\n	movaps	96(%0), %%xmm12"
	"\n	movhlps	%%xmm12, %%xmm13"
	"\n	movaps	112(%0), %%xmm14"
	"\n	movhlps	%%xmm14, %%xmm15"
	"\n	xorq	%%rbx, %%rbx"
	"\n	1: # beginning of the loop"

	"\n	### process 1st special pair of input words, words x[2], x[11]"
	"\n	movq	%%xmm2, %%rax"
	"\n xorq	$0x20, %%rax	#xor column dependent constant to x[2]"
	"\n xorq	%%rbx, %%rax	#xor round counter"
	"\n	movq	%%xmm11, %%rcx"
	"\n	shrq	$32, %%rcx		#no need add constants to x[11] since it's shifted by 32 bits"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movq	T0(,%%rdx,8), %%mm2"
	"\n	movq	T4(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	movq	T1(,%%rdx,8), %%mm1"
	"\n	movq	T5(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movq	T2(,%%rdx,8), %%mm0"
	"\n	movq	T6(,%%rdi,8), %%mm5"
	"\n	shrq	$40,%%rax"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	pxor	T7(,%%rdx,8), %%mm7"
	"\n	pxor	T7(,%%rdi,8), %%mm0"

	"\n	### process the third pair of input words, words x[4], x[9]"
	"\n	movq	%%xmm9, %%rcx"
	"\n	movq	%%xmm4, %%rax"
	"\n	xorq	$0x40, %%rax	#xor column dependent constant to x[4]"
	"\n	xorq	%%rbx, %%rax	#xor round counter"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movq	T0(,%%rdx,8), %%mm4"
	"\n	pxor	T2(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	movq	T1(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T4(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm3"

	"\n	### process 2nd special pair of input words, words x[1], x[12]"
	"\n	movq	%%xmm12, %%rcx"
	"\n	movq	%%xmm1, %%rax"
	"\n	xorq	$0x10, %%rax	#xor column dependent constant to x[1]"
	"\n xorq	%%rbx, %%rax	#xor round counter"
	"\n	shrq	$40, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	pxor	T1(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm6"
	"\n	shrq	$56, %%rax"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movzbl	%%al, %%edx"
	"\n	pxor	T7(,%%rdx,8), %%mm6"
	"\n	pxor	T7(,%%rdi,8), %%mm1"

	"\n	### process the fourth pair of input words, words x[3], x[10]"
	"\n	movq	%%xmm10, %%rcx"
	"\n	movq	%%xmm3, %%rax"
	"\n	xorq	$0x30, %%rax	#xor column dependent constant to x[3]"
	"\n	xorq	%%rbx, %%rax	#xor round counter"
	"\n	shrq	$24, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T1(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"

	"\n	### process 3rd special pair of input words, words x[0], x[13]"
	"\n	movq	%%xmm13, %%rcx"
	"\n	movq	%%xmm0, %%rax"
	"\n	xorq	%%rbx, %%rax	#xor round counter to x[0], column dependent const =0"
	"\n	shrq	$48, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm7"
	"\n	shrq	$48, %%rax"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	pxor	T7(,%%rdx,8), %%mm5"
	"\n	pxor	T7(,%%rdi,8), %%mm2"

	"\n	### process the second pair of input words, words x[5], x[8]"
	"\n	movq	%%xmm8, %%rcx"
	"\n	movq	%%xmm5, %%rax"
	"\n	xorq	$0x50, %%rax	#xor column dependent constant to x[5]"
	"\n	xorq	%%rbx, %%rax	#xor round counter to x[5]"
	"\n	shrq	$8, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm5"
	"\n	pxor	T1(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T1(,%%rdx,8), %%mm4"
	"\n	pxor	T2(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T4(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm3"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T5(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm2"
	"\n	shrq	$16, %%rcx"

	"\n	### process 4th special pair of input words, words x[14], x[15]"
	"\n	movq	%%xmm15, %%rcx"
	"\n	movq	%%xmm14, %%rax"
	"\n	shrq	$56, %%rcx"
	"\n	shrq	$56, %%rax"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T7(,%%rdx,8), %%mm3"
	"\n	pxor	T7(,%%rdi,8), %%mm4"

	"\n	### process the first pair of input words, words x[6], x[7]"
	"\n	movq	%%xmm6, %%rax"
	"\n	movq	%%xmm7, %%rcx"
	"\n	xorq	$0x60, %%rax	#xor column dependent constant to x[6]"
	"\n xorq	$0x70, %%rcx	#xor column dependent constant to x[7]"
	"\n	xorq	%%rbx, %%rax	#xor round counter to x[6]"
	"\n	xorq	%%rbx, %%rcx	#xor round counter to x[7]"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm6"
	"\n	pxor	T0(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T1(,%%rdx,8), %%mm5"
	"\n	pxor	T1(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm4"
	"\n	pxor	T2(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T4(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm3"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T5(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm2"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T6(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm1"

	"\n	### writes contents of MM0..MM7 to memory "
	"\n	movq %%mm7, 56(%0)"
	"\n	movq %%mm6, 48(%0)"
	"\n	movq %%mm5, 40(%0)"
	"\n	movq %%mm4, 32(%0)"
	"\n	movq %%mm3, 24(%0)"
	"\n	movq %%mm2, 16(%0)"
	"\n	movq %%mm1, 8(%0)"
	"\n	movq %%mm0, 0(%0)"
	"\n #use the remaining data in ah, ch to process"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	movq	T7(,%%rdx,8), %%mm3"
	"\n	movq	T7(,%%rdi,8), %%mm4"

	"\n	### process the first pair of input words, words x[14], x[15]"
	"\n	movq	%%xmm14, %%rax"
	"\n	movq	%%xmm15, %%rcx"
	"\n	xorq	$0xe0, %%rax	#xor column dependent constant to x[14]"
	"\n	xorq	$0xf0, %%rcx	#xor column dependent constant to x[15]"
	"\n	xorq	%%rbx, %%rax	#xor round counter to x[14]"
	"\n	xorq	%%rbx, %%rcx	#xor round counter to x[15]"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movq	T0(,%%rdx,8), %%mm6"
	"\n	movq	T0(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	movq	T1(,%%rdx,8), %%mm5"
	"\n	pxor	T1(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm4"
	"\n	pxor	T2(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movq	T4(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm3"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	movq	T5(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm2"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movq	T6(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm1"

	"\n	### process 3rd special pair of input words, words x[8], x[5]"
	"\n	movq	%%xmm5, %%rcx"
	"\n	movq	%%xmm8, %%rax"
	"\n	xorq	$0x80, %%rax	#xor column dependent constant to x[8]"
	"\n	xorq	%%rbx, %%rax	#xor round counter"
	"\n	shrq	$48, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm7"
	"\n	shrq	$48, %%rax"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	pxor	T7(,%%rdx,8), %%mm5"
	"\n	pxor	T7(,%%rdi,8), %%mm2"

	"\n	### process the second pair of input words, words x[13], x[0]"
	"\n	movq	%%xmm0, %%rcx"
	"\n	movq	%%xmm13, %%rax"
	"\n	xorq	$0xd0, %%rax	#xor column dependent constant to x[13]"
	"\n	xorq	%%rbx, %%rax	#xor round counter"
	"\n	shrq	$8, %%rcx		#no column constant and after shift no round counter either"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm5"
	"\n	pxor	T1(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T1(,%%rdx,8), %%mm4"
	"\n	pxor	T2(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T4(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm3"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T5(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm2"
	"\n	shrq	$16, %%rcx"

	"\n	### process the third pair of input words, words x[12], x[1]"
	"\n	movq	%%xmm1, %%rcx"
	"\n	movq	%%xmm12, %%rax"
	"\n	xorq	$0xc0, %%rax	#xor column dependent constant to x[12]"
	"\n	xorq	%%rbx, %%rax	#xor round counter to x[12]"
	"\n	shrq	$16, %%rcx		#constant disappears after shift"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm4"
	"\n	pxor	T2(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T1(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T4(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm3"

	"\n	### process 2nd special pair of input words, words x[9], x[4]"
	"\n	movq	%%xmm4, %%rcx"
	"\n	movq	%%xmm9, %%rax"
	"\n	xorq	$0x90, %%rax	#xor round dependent constant to x[9]"
	"\n	xorq	%%rbx, %%rax	#xor round counter to x[9]"
	"\n	shrq	$40, %%rcx		#constant disappears after shift in x[4]"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	pxor	T1(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm6"
	"\n	shrq	$56, %%rax"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%cl, %%edi"
	"\n	movzbl	%%al, %%edx"
	"\n	pxor	T7(,%%rdx,8), %%mm6"
	"\n	pxor	T7(,%%rdi,8), %%mm1"

	"\n	### process the fourth pair of input words, words x[11], x[2]"
	"\n	movq	%%xmm2, %%rcx"
	"\n	movq	%%xmm11, %%rax"
	"\n	xorq	$0xb0, %%rax	#xor column dependent constant to x[11]"
	"\n	xorq	%%rbx, %%rax	#xor round counter to x[11]"
	"\n	shrq	$24, %%rcx		#constants disappear after shift in x[2]"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm3"
	"\n	pxor	T3(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T1(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm5"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T3(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm4"
	"\n	shrq	$16, %%rcx"

	"\n	### process 1st special pair of input words, words x[10], x[3]"
	"\n	movq	%%xmm10, %%rax"
	"\n	movq	%%xmm3, %%rcx"
	"\n	xorq	$0xa0, %%rax	#xor column dependent constant"
	"\n	xorq	%%rbx, %%rax	#xor round counter"
	"\n	shrq	$32, %%rcx		#constants disappear after shift"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T0(,%%rdx,8), %%mm2"
	"\n	pxor	T4(,%%rdi,8), %%mm7"
	"\n	movzbl	%%ah, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	shrq	$16, %%rax"
	"\n	pxor	T1(,%%rdx,8), %%mm1"
	"\n	pxor	T5(,%%rdi,8), %%mm6"
	"\n	shrq	$16, %%rcx"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%cl, %%edi"
	"\n	pxor	T2(,%%rdx,8), %%mm0"
	"\n	pxor	T6(,%%rdi,8), %%mm5"
	"\n	shrq	$40,%%rax"
	"\n	movzbl	%%al, %%edx"
	"\n	movzbl	%%ch, %%edi"
	"\n	pxor	T7(,%%rdx,8), %%mm7"
	"\n	pxor	T7(,%%rdi,8), %%mm0"

	"\n	incq	%%rbx"
	"\n	cmp	$14, %%rbx"
	"\n	je 2f"


	"\n	### move 8 MMX registers to low halves of XMM registers"
	"\n	movq2dq %%mm0, %%xmm8"
	"\n	movq2dq %%mm1, %%xmm9"
	"\n	movq2dq %%mm2, %%xmm10"
	"\n	movq2dq %%mm3, %%xmm11"
	"\n	movq2dq %%mm4, %%xmm12"
	"\n	movq2dq %%mm5, %%xmm13"
	"\n	movq2dq %%mm6, %%xmm14"
	"\n	movq2dq %%mm7, %%xmm15"

	"\n	### read back 8 words of input state from memory to 8 low halves of XMM registers xmm0...xmm15"
	"\n	movaps	0(%0), %%xmm0"
	"\n	movhlps	%%xmm0, %%xmm1"
	"\n	movaps	16(%0), %%xmm2"
	"\n	movhlps	%%xmm2, %%xmm3"
	"\n	movaps	32(%0), %%xmm4"
	"\n	movhlps	%%xmm4, %%xmm5"
	"\n	movaps	48(%0), %%xmm6"
	"\n	movhlps	%%xmm6, %%xmm7"
	"\n	jmp 1b"

	"\n	2:  # finalization"

	"\n	### writes contents of MM0..MM7 to memory "
	"\n	movq %%mm7, 120(%0)"
	"\n	movq %%mm6, 112(%0)"
	"\n	movq %%mm5, 104(%0)"
	"\n	movq %%mm4, 96(%0)"
	"\n	movq %%mm3, 88(%0)"
	"\n	movq %%mm2, 80(%0)"
	"\n	movq %%mm1, 72(%0)"
	"\n	movq %%mm0, 64(%0)"
: /*no output, only memory is modifed */
: "r"(x)
: "%rax", "%rbx", "%rcx", "%rdx", "%rdi", "memory", "%mm0", "%mm1", "%mm2", "%mm3", "%mm4", "%mm5", "%mm6", "%mm7"  , "%xmm0" , "%xmm1" , "%xmm2" , "%xmm3" , "%xmm4" , "%xmm5" , "%xmm6" , "%xmm7" , "%xmm8" , "%xmm9" , "%xmm10" , "%xmm11" , "%xmm12" , "%xmm13" , "%xmm14" , "%xmm15" );
}//P1024ASM()

