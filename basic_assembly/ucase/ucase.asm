* UCASE.ASM v1.00
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* DEFUSRx() uppercase output function
*
* INPUT:   VARPTR of a string
* RETURNS: # chars processed
*
* EXAMPLE:
*   CLEAR 200,&H3F00
*   DEFUSR0=&H3F00
*   A$="Print this in uppercase."
*   PRINT A$
*   A=USR0(VARPTR(A$))
*
ORGADDR EQU $3f00
dir
GIVABF EQU $B4F4 *46324
INTCNV EQU $B3ED *46061
CHROUT EQU $A002

      org  ORGADDR
start jsr  INTCNV * get passed in value in D
      tfr  d,x    * move value (varptr) to X
foo   ldb  ,x     * load string len to B
      ldy  2,x    * load string addr to Y
      beq  null   * exit if strlen is 0
      ldx  #0     * clear X (count of chars conv)
loop  lda  ,y     * load char in A
      cmpa #'a    * compare to lowercase A
      blt  nextch * if less, no conv needed
      cmpa #'z    * compare to lowercase Z
      bgt  nextch * if greater, no conv needed
lcase suba #32    * subtract 32 to make uppercase
      leax 1,x    * inc count of chars converted
nextch jsr [CHROUT] * call ROM output character routine
	  leay 1,y    * increment Y pointer
cont  decb        * decrement counter
      beq  exit   * if 0, go to exit
      bra  loop   * go to loop
exit  tfr  x,d    * move chars conv count to D
      bra return  * return D to caller
null  ldd  #-1    * load -2 as error
return jmp GIVABF * return to caller

* lwasm --decb -o ucase.bin ucase.asm
* decb copy -2 -r ucase.bin ../Xroar/dsk/DRIVE0.DSK,UCASE.BIN