* LCASE.ASM v1.00
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* DEFUSRx() string lowercase function
*
* INPUT:   VARPTR of a string (not in code space)
* RETURNS: # chars processed
*         -1 if in code space (not touched)
*         -2 NULL string
*
* EXAMPLE:
*   CLEAR 200,&H3F00
*   DEFUSR0=&H3F00
*   A$="Convert this to uppercase."
*   PRINT A$
*   A=USR0(VARPTR(A$))
*   PRINT A;A$
*
ORGADDR EQU $3f00
dir
GIVABF EQU $B4F4 *46324
INTCNV EQU $B3ED *46061

      org  ORGADDR
start jsr  INTCNV * get passed in value in D
      tfr  d,x    * move value (varptr) to X
      ldy  2,x    * load string addr to Y
                  * we don't want to modify string constants that are embedded
                  * in the actual BASIC code (i.e., A$="This is in the code").
                  * Find the end of BASIC and only proceed if the string is
                  * located after it in string memory.
      ldx  27     * get end of BASIC program at 27 & 28
      pshs d      * push D on the stack
      cmpx ,s++   * compare X to D on stack, move stack back
      blt  doit   * if end of BASIC is lower than var, good
      ldd  #-1    * else load -1 in to D
      bra  return * and return it as an error
                  * if here, we can proceed but need to reload X
doit  tfr  d,x    * move org value (varptr) to X again
foo   lda  ,x     * load string len to A
      beq  null   * exit if strlen is 0
      ldx  #0     * clear X (count of chars conv)
loop  ldb  ,y     * load char in B
      cmpb #'a    * compare to lowercase A
      blt  nextch * if less, no conv needed
      cmpb #'z    * compare to lowercase Z
      bgt  nextch * if greater, no conv needed
lcase subb #32    * subtract 32 to make uppercase
      stb  ,y     * store updated char
      leax 1,x    * inc count of chars converted
nextch leay 1,y   * increment Y pointer
cont  deca        * decrement counter
      beq  exit   * if 0, go to exit
      bra  loop   * go to loop
exit  tfr  x,d    * move chars conv count to D
      bra return  * return D to caller
null  ldd  #-2    * load -2 as error
return jmp GIVABF * return to caller

* mamou -b coco.asm -otest.bin
* lwasm --decb -o lcase.bin lcase.asm
* decb copy -2 -r lcase.bin ../Xroar/dsk/DRIVE0.DSK,LCASE.BIN