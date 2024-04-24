/* Possible solution for Part 3 of Lab 1 */

.include "nios_macros.s"

.equ	STACK, 0x10000

.text


/*****************************************************************************/
/* Main Program                                                              */
/*   Sorts a list of 32-bit numbers in memory.                               */
/*                                                                           */
/* r8  - Address of the size of the list of numbers                          */
/* r9  - Address of the first number in the list                             */
/*****************************************************************************/
.global _start
_start:
	movia	sp, XXXX				/* Setup the stack and frame pointer     */
	mov	fp, sp				/*  registers.                           */

	movia	r8, SIZE				/* Setup the size address                */
	movia	r9, LIST				/* Setup the first element address       */

	subi	sp, sp, 8				/* Make room on the stack for the params */
	ldwio	r2, 0(r8)				/* Set the subroutine parameter regs     */
	stw	r2, 4(sp)				/* Push the size into the stack          */
	stw	r9, 0(sp)				/* Push the address into the stack       */

	call	SORT					/* Call subroutine SORT                  */
	addi	sp, sp, 8				/* Remove parameters from the stack      */

END:
	br	END					/* Wait here once the program is done    */


/*****************************************************************************/
/* SORT - Subroutine                                                         */
/*   Sorts a list of 32-bits number in memory.                               */
/*                                                                           */
/* r8  - Address of the current element being checked                        */
/* r9  - Address of the first number in the list                             */
/* r16 - First number to be compared                                         */
/* r17 - Second number to be compared                                        */
/* r18 - Flag indicating that a swap of positions has occured                */
/* r19 - Counter to check when every element has been checked                */
/* r20 - Size of the list of numbers to be sorted                            */
/*****************************************************************************/
SORT:
	subi	sp, sp, XXXX				/* Save all used registers on the Stack  */
	stw	ra, 0(sp)
	stw	fp, 4(sp)
	stw	r8, 8(sp)
	stw	r9, 12(sp)
	stw	r16, 16(sp)
	stw	r17, 20(sp)
	stw	r18, 24(sp)
	stw	r19, 28(sp)
	stw	r20, 32(sp)
	addi	fp, sp, 36

BEGIN_SORT:
	ldw	r20, 4(fp)				/* Get the size from the stack           */
	ldw	r9, 0(fp)				/* Get the address from the stack        */
	
RESTART_SORT:
	mov	r18, r0				/* Clear the flag register               */
	movi	r19, 1				/* Reset the element counter             */
	mov	r8, r9				/* Start at the first element            */

SORT_LOOP:
    ldwio   r16, 0(r8)				/* Read in the first number              */
    ldwio   r17, 4(r8)				/* Read in the second number             */

	blt	r16, r17, XXXX		/* Are the numbers already sorted?       */

SWAP:
	stwio	r17, 0(r8)				/* Swap the numbers                      */
	stwio	r16, 4(r8)
	movi	r18, 1				/* Set flag                              */

SKIP_SWAP:
	addi	r19, r19, 1				/* Increament the element counter        */
	addi	r8, r8, 4				/* Move to the next element in the list  */
	bne	r19, r20, XXXX		/* Loop through all the elements         */

	bne	r18, r0, RESTART_SORT		/* Were there no changes on this loop?   */

END_SORT:
	ldw		ra, 0(sp)			/* Restore all used register to previous */
	ldw		fp, 4(sp)			/*   values                              */
	ldw		r8, 8(sp)
	ldw		r9, 12(sp)
	ldw		r16, 16(sp)
	ldw		r17, 20(sp)
	ldw		r18, 24(sp)
	ldw		r19, 28(sp)
	ldw		r20, 32(sp)
	addi		sp, sp, 36
	ret						/* Return from the subroutine            */


.org	0x01000
LIST_FILE:
SIZE:
.word	0
LIST:

.end

