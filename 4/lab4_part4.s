.ifndef _nios2_macros_
.equ _nios2_macros_,1

    #--------------------
    # GEQU symbol, value
    #
    # Macro to define a global symbol
    .macro  GEQU sym,val
    .global \sym
    .equ \sym,\val
    .endm

    #--------------------
    # GFUNC symbol
    #
    # Macro to define a global function
    .macro  GFUNC sym
    .global \sym
    .type \sym, @function
    \sym:
    .endm

    #--------------------
    # MOVI32 $reg, imm32
    #
    # Macro to move a 32-bit immediate into a register.
    .macro  MOVI32 reg, val
    movhi \reg, %hi(\val)
    ori \reg, \reg, %lo(\val)
    .endm

	#--------------------
	# MOVIA $reg, address
	#
    # Macro to move a 32-bit address into a register.
    .macro  MOVIA reg, addr
    movhi \reg, %hi(\addr)
    ori \reg, \reg, %lo(\addr)
    .endm

# +----------------------------
# | MOVIK32 reg,value
# |
# | for constants only, no linker action
# | uses only one instruction if possible
# |

    .macro MOVIK32 _dst,_val
    .if   (\_val & 0xffff0000) == 0
        MOVUI \_dst,%lo(\_val)
    .elseif (\_val & 0x0000ffff) == 0
        MOVHI \_dst,%hi(\_val)
    .else
        MOVHI \_dst,%hi(\_val)
        ORI   \_dst,\_dst,%lo(\_val)
    .endif
    .endm


.endif # _nios2_macros_

# end of file


.equ	NEW_NUMBER,	0x10000040
.equ	GREEN_LEDS,	0x10000010
.equ	Pushbuttons,	0x10000050
.equ	HEX3to0,	0x10000020
.equ	INTERRUPT_MASK,	0x10000058
.equ	EDGE_CAPTURE,	0x1000005C
.equ	STACK,		0x1000


/******************************************************************************/
/* Start Location                                                             */
/*   Jumps to main program                                                    */
/******************************************************************************/
.global _start
_start:
	br	MAIN_PROGRAM
	
/******************************************************************************/
/* Interrupt Service Routine                                                  */
/*   Determines if an external interrupt occurred and in response reads       */
/*   a new number and displays the updated sum.                               */
/*                                                                            */
/* r16 - The new number from the switches                                     */
/* r17 - The accumulated sum                                                  */
/* r19 - Segment patterns for 7-segment displays                              */
/* et  - External interrupt pending                                           */
/* ea  - Exception return address                                             */
/*                                                                            */
/* Note: To keep the code short, this ISR does not save and restore registers */
/*****************************************************************************/
.org	0x0020
ISR:
	rdctl	et, ctl4
	beq	et, r0, XXXX			/* Error if not an external interrupt,   */
						/*    it is not handled in this example. */
	subi	ea, ea, 4			/* It is a hardware interrupt; decrement */
						/*   ea to execute the interrupted       */
						/*   instruction upon return to the      */
						/*   main program.                       */
	ldwio	r15, 12(r10)			/* Read Edge-capture register            */
	andi	r15, r15, 0x2			/* Check if KEY1 was pressed    	 */
	beq	XXXX, r0, ERROR			/* Error if bit 4 is not equal to 1	 */ 
	stwio	r0, 12(r10)			/* Clear the edge-capture register to    */
						/*   prevent the same interrupt request  */
						/*   from being serviced again.          */

MAIN_LOOP:
	ldwio	r16, 0(r8)			/* Read in the new number                */
    
	add	r17, r17, r16			/* Add the new number to the sum         */
	stwio	r17, 0(XXXX)			/* Display the new sum on green LEDs     */

/* This part computes the 7-segment display patterns for a given number            	 */
	add	r19, r0, r0			/* Clear r19                             */
	addi	r20, r0, 4			/* Initialize the LOOP2 counter          */
	mov	r21, r17			/* r21 holds the number being processed  */
LOOP2:
	andi	r22, r21, 0xf			/* Extract a hex digit                   */
	ldb	r23, 0x500(r22)			/* Look up the 7-segment pattern         */
	or	r19, r19, r23			/* Include the pattern in total display  */
	roli	r19, r19, 24			/* Make room for pattern of next digit   */
	srli	r21, r21, 4			/* Now consider the next hex digit       */
	subi	r20, r20, 1			/* Decrement the counter                 */
	bgt	r20, r0, LOOP2			/* Branch back if not done               */
	stwio	r19, 0(r11)			/* Display the sum on HEX display        */        

END_ISR:
	eret					/* Return to the interrupted program     */



/*****************************************************************************/
/* Main Program                                                              */
/*  Sets up the address pointers and initializes the interrupts.             */
/*                                                                           */
/* r8  - Address of the new number (or switches)                             */
/* r9  - Address of the green LEDs                                           */
/* r10 - Address of the Pushbuttons port                                     */
/* r11 - Address of the 7-segment displays HEX3 to HEX0                      */
/*****************************************************************************/

MAIN_PROGRAM:
	movia	r8,  NEW_NUMBER			/* Set up the switches address           */
	movia	r9,  GREEN_LEDS			/* Set up the green LED address          */
	movia	r10, Pushbuttons		/* Set up the pushbuttons port address   */
	movia	r11, HEX3to0			/* Set up the HEX display address	 */

	movia	sp, STACK			/* Setup the stack and                   */
	mov	fp, sp				/*  frame pointer registers.             */

	add	r17, r0, r0			/* Clear the sum register                */
	
	movi	r5, 2				/* Enable interrupts from the            */
	stw	r5, 8(r10)			/*   pushbutton KEY1.                    */
	movi	r5, 2				/* Enable level 1 external interrupts    */
	wrctl	ctl3, r5			/*  which correspond to the pushbutton   */
						/*  switch parallel port.                */ 				
	movi	r5, 1
	wrctl	ctl0, r5			/* Enable external interrupts            */
	
WAIT_HERE:
	br	WAIT_HERE			/* Wait for the next interrupt           */

ERROR:
	br	ERROR				/* Stop here if an error occurred        */

/* This is the hex-digit to 7-segment conversion table                             	 */ 
.org	0x500
.byte 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x67,0x77,0x7c,0x39,0x5e,0x79,0x71

.end
