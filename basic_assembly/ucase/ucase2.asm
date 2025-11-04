* UCASE.ASM v1.01
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* 1.01 a bit smaller per Simon Jonassen
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
ORGADDR     EQU     $3f00

GIVABF      EQU     $B4F4   * 46324
INTCNV      EQU     $B3ED   * 46061
CHROUT      EQU     $A002

            opt	    6809    * 6809 instructions only
            opt	    cd      * cycle counting

            org     ORGADDR

start       jsr     INTCNV  * get passed in value in D
            tfr     d,x     * move value (varptr) to X
            ldy     2,x     * load string addr to Y
            beq     null    * exit if strlen is 0
            ldb     ,x      * load string len to B
            ldx     #0      * clear X (count of chars conv)

loop        lda     ,y+	    * get next char, inc Y
;	        lda     ,y      * load char in A
            cmpa    #'a     * compare to lowercase A
            blt     nextch  * if less, no conv needed
            cmpa    #'z     * compare to lowercase Z
            bgt     nextch  * if greater, no conv needed
lcase       suba    #32     * subtract 32 to make uppercase
            leax    1,x     * inc count of chars converted
nextch      jsr     [CHROUT] * call ROM output character routine
;           leay    1,y     * increment Y pointer
cont        decb            * decrement counter
            bne	    loop    * not done yet
;           beq     exit    * if 0, go to exit
;           bra     loop    * go to loop

exit        tfr     x,d     * move chars conv count to D
            jmp     GIVABF  * return to caller

null        ldd     #-1     * load -2 as error
return      jmp     GIVABF  * return to caller

* lwasm --decb -o ucase2.bin ucase2.asm -l
* lwasm --decb -f basic -o ucase2.bas ucase2.asm -l
* lwasm --decb -f ihex -o ucase2.hex ucase2.asm -l
* decb copy -2 -r ucase2.bin ../Xroar/dsk/DRIVE0.DSK,UCASE2.BIN
