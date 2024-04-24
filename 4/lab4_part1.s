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

/*****************************************************************************/
/* Main Program                                                              */
/*  Reads a number from the switches, accumulates a sum and displays         */
/*  the sum on the green LEDs                                                */
/* r8  - Address of the new number (or switches)                             */
/* r9  - Address of the green LEDs                                           */
/* r16 - The new number from the switches                                    */
/* r17 - The accumulated sum                                                 */
/*****************************************************************************/
.global _start
_start:
	add	r17, r0, r0			/* Clear the sum register                */

	movia	r8,  NEW_NUMBER			/* Set up the switches address           */
	movia	r9,  GREEN_LEDS			/* Set up the green LED address          */

MAIN_LOOP:
    	ldwio   r16, 0(r8)			/* Read in the new number                */
  
    	add	r17, r17, r16			/* Add the new number to the sum         */
    	stwio   r17, 0(r9)			/* Display the new sum                   */
    
	br	MAIN_LOOP			/* Loop to the start of the main program */

.end
