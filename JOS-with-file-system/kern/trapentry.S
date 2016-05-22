/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <kern/macro.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushq $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushq $0;							\
	pushq $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
   Find the PUSHA,POPA macros in kern/macro.h. Since amd64 doesn't support
   pusha,popa so you will find these macros handy.
 */

	TRAPHANDLER_NOEC(XTRPX_divzero, T_DIVIDE)
	TRAPHANDLER_NOEC(XTRPX_Debug, T_DEBUG)
	TRAPHANDLER_NOEC(XTRPX_NonMaskI, T_NMI)
	TRAPHANDLER_NOEC(XTRPX_Brkpt, T_BRKPT)
	TRAPHANDLER_NOEC(XTRPX_OFlow, T_OFLOW)
	TRAPHANDLER_NOEC(XTRPX_Bound, T_BOUND)
	TRAPHANDLER_NOEC(XTRPX_Illop, T_ILLOP)
	TRAPHANDLER_NOEC(XTRPX_Device, T_DEVICE)
	TRAPHANDLER(XTRPX_DblFlt, T_DBLFLT)
	TRAPHANDLER(XTRPX_Tss, T_TSS)
	TRAPHANDLER(XTRPX_Segnp, T_SEGNP)
	TRAPHANDLER(XTRPX_Stack, T_STACK)
	TRAPHANDLER(XTRPX_Gpflt, T_GPFLT)
	TRAPHANDLER(XTRPX_Pgflt, T_PGFLT)
	TRAPHANDLER_NOEC(XTRPX_FpErr, T_FPERR)
	TRAPHANDLER(XTRPX_Align, T_ALIGN)
	TRAPHANDLER_NOEC(XTRPX_Mchk, T_MCHK)
	TRAPHANDLER_NOEC(XTRPX_SimdErr, T_SIMDERR)
	TRAPHANDLER_NOEC(XTRPX_Syscall, T_SYSCALL)
	TRAPHANDLER_NOEC(XTRPX_Default, T_DEFAULT)
	TRAPHANDLER_NOEC(XTRPX_IRQ0, IRQ_OFFSET+IRQ_TIMER)
	TRAPHANDLER_NOEC(XTRPX_IRQ1, IRQ_OFFSET+IRQ_KBD)
	TRAPHANDLER_NOEC(XTRPX_IRQ2, IRQ_OFFSET+2)
	TRAPHANDLER_NOEC(XTRPX_IRQ3, IRQ_OFFSET+3)
	TRAPHANDLER_NOEC(XTRPX_IRQ4, IRQ_OFFSET+IRQ_SERIAL)
	TRAPHANDLER_NOEC(XTRPX_IRQ5, IRQ_OFFSET+5)
	TRAPHANDLER_NOEC(XTRPX_IRQ6, IRQ_OFFSET+6)
	TRAPHANDLER_NOEC(XTRPX_IRQ7, IRQ_OFFSET+IRQ_SPURIOUS)
	TRAPHANDLER_NOEC(XTRPX_IRQ8, IRQ_OFFSET+8)
	TRAPHANDLER_NOEC(XTRPX_IRQ9, IRQ_OFFSET+9)
	TRAPHANDLER_NOEC(XTRPX_IRQa, IRQ_OFFSET+10)
	TRAPHANDLER_NOEC(XTRPX_IRQb, IRQ_OFFSET+11)
	TRAPHANDLER_NOEC(XTRPX_IRQc, IRQ_OFFSET+12)
	TRAPHANDLER_NOEC(XTRPX_IRQd, IRQ_OFFSET+13)
	TRAPHANDLER_NOEC(XTRPX_IRQe, IRQ_OFFSET+IRQ_IDE)
	TRAPHANDLER_NOEC(XTRPX_IRQf, IRQ_OFFSET+15)

/*
 * Lab 3: Your code here for _alltraps
 *
 * Hint: Be sure to review the x64 calling convention from lab1
 *       for how to pass a pointer to the trapframe.
 */
    _alltraps:
    	/* Since ES and DS registers can't be pushed in x86-64. So moving them to r15 first */
		xor %r15, %r15
		movw %ds,%r15 
		pushq %r15
		movw %es, %r15
		pushq %r15
		/* Now push all registers onto the stack */
		PUSHA
		/* Far pointer addressing*/
		mov %rsp, %rdi
		/* filling es and ds now */
		xor %r15, %r15
		movw $(GD_KD), %r15
		movw %r15, %es
		movw %r15, %ds
		call trap
		POPA_
		/*Now make the stack same as we got from CPU*/
		xor %r15, %r15
		popq %r15
		movw %r15, %es
		popq %r15
		movw %r15, %ds
		iret 

