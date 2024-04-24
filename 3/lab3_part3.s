/* Possible solution for Part 3 of Lab 3  */

.include "nios_macros.s"

.equ TEST_NUM, 0x90abcdef		/* The number to be tested */
/**************************************************************************/
/* Main Program                                                           */
/*   Determines the maximum number of consecutive 1s in a data word.      */
/*                                                                        */
/* r8   - Contains the test data                                          */
/* r9   - Indicates the longest string of 1s found to date                */
/* r10  - Counts the number of consecutive 1s                             */
/* r11  - Holds the result of testing the rightmost bit                   */
/**************************************************************************/

.global _start
_start:
	movia	r8, XXXX		/* Load r8 with the number to be tested  */
	mov	r9, r0			/* Initial maximum is 0                  */
	mov	r10, r0			/* Clear the substring counter to zero   */
LOOP:
	andi	r11, r8, 0x1		/* Test the rightmost bit                */
	bgt	r11, r0, XXXX		/* If 1, go to increment                 */
	bgt	r9, r10, CLEAR		/* Check substring against previous max  */
	mov	r9, r10			/* Current substring is longer           */
CLEAR:
	mov	r10, r0			/* Clear the substring counter to zero   */
	br	XXXX
INC:
	addi	r10, r10, 1			/* Increment the substring counter       */
SHIFT:
	srli	r8, XXXX, 0x1			/* Shift the remaining bits of test data */
	bgt	r8, r0, LOOP		/*   and loop back if all bits are not 0 */
	bge	r9, r10, END		/* Check if new substring is longer      */
	mov	r9, r10			/* New substring is longer               */
END:
	br	END				/* Wait here when the program has completed */
.end
