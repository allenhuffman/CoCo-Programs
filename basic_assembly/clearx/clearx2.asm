* CLEARX.ASM v1.01
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* 1.01 use TSTA instead of CMPD per L. Curtis Boyle
*
* DEFUSRx() clear screen to character routine
*
* INPUT:   ASCII character to clear screen to
* RETURNS: 0 is successful
*         -1 if error
*
* EXAMPLE:
*   CLEAR 200,&H3F00
*   DEFUSR0=&H3F00
*   A=USR0(42)
*   PRINT A
*
ORGADDR EQU $3f00

INTCNV EQU $B3ED *46061
GIVABF EQU $B4F4 *46324

       org  ORGADDR
start  jsr  INTCNV * get passed in value in D
*	   cmpd #255   * compare passed in value to 255
*	   bgt  error  * if greater, error
                   * D is made up of A and B, so if
                   * A has anything in it, it must be
				   * greater than 255.
       tsta        * test for zero
	   bne  error  * branch if it is not zero
       ldx  #$400  * load X with start of 
loop   stb  ,x+    * store B register at X and increment X
	   cmpx #$600  * compare X to end of screen
	   bne  loop   * if not there, keep looping
	   bra  return * done
error  ldd  #-1    * load D with -1 for error code
return jmp  GIVABF * return to caller

* lwasm --decb -o clearx2.bin clearx2.asm
* lwasm --decb -f basic -o clearx2.bas clearx2.asm
* decb copy -2 -r clearx2.bin ../Xroar/dsk/DRIVE0.DSK,CLEARX2.BIN