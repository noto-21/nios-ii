.equ LIST, 0x500 /*Starting address of the list*/
.global _start
_start:
	movia r4, LIST /*r4 points to the starting point of the list*/
	ldw r5,4(r4)  /*r5 is a counter, initialize it with n*/
	addi r6, r4, 8  /*r6 point s to the first number*/
	ldw r7,(r6)     /*r7 holds the largest number finds so far*/
LOOP:
	subi r5,r5,1    /*decrement the counter*/
	beq r5,r0,DONE  /* finihsed if r5 is equal to 0*/
	addi r6,r6,4    /*increment the list pointer*/
	ldw r8,(r6)     /*get the next number*/
	bge r7,r8,LOOP  /*check if larger number found*/
	add r7,r8,r0    /*update the largest number found*/
	br LOOP         
DONE:
	stw r7,(r4)    /* store the largest number into RESULT*/
STOP:
	br STOP
.org 0x500         /*remain here if done*/
RESULT:
.skip 4            /*space for the largest number found*/
N:
.word 7            /*number of the entries in the LIST*/
NUMBER:
.word 4,5,3,6,8,1,2 /*numbers in the LIST*/
.end
	
	