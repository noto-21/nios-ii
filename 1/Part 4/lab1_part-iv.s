.equ FIB, 0x1000   /* Starting address of the list */

.global _start
_start:
    movia r4, FIB   /* r4 points to the starting point of the list */
	movia r10, test_number /* move the test number into r10 */
    ldw r5, (r10)    /* r5 is the input number (n) */
    ldw r6, 4(r4)   /* r6 points to the address where the next Fibonacci number will be stored */
    movi r7, 0       /* r7 holds the current Fibonacci number (F0) */
    movi r8, 1       /* r8 holds the next Fibonacci number (F1) */
	stw r7, (r4)	/* store r7 into 0x1000 */

LOOP:
    stw r7, (r6)    /* Store the current Fibonacci number at the current address */
    addi r6, r6, 4  /* Increment the list pointer */
    add r9, r7, r8  /* Calculate the next Fibonacci number (F2 = F0 + F1) */
    mov r7, r8      /* Update F0 to be F1 for the next iteration */
    mov r8, r9      /* Update F1 to be the calculated F2 for the next iteration */
    subi r5, r5, 1  /* Decrement the counter */
    bne r5, r0, LOOP /* Continue the loop if counter is not zero */

STOP:
    br STOP

.org 0x1000       /* Remain here if done */

.data
test_number:    .word 0x8    /* The decimal number 8 in hexadecimal */

.end
