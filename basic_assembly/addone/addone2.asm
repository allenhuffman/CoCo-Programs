* ADDONE.ASM v1.01
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* 1.01 made less stupid per Simon Jonassen
*
* DEFUSRx() add one routine
*
* INPUT:   integer to add one to
* RETURNS: value +1
*
* EXAMPLE:
*   CLEAR 200,&H3F00
*   DEFUSR0=&H3F00
*   A=USR0(42)
*   PRINT A
*
ORGADDR EQU     $3f00

INTCNV  EQU     $B3ED   * 46061
GIVABF  EQU     $B4F4   * 46324

        org     ORGADDR

start   jsr     INTCNV  * get passed in value in D
;       tfr     d,x     * transfer D to X so we can manipulate it
;       leax    1,x     * add 1 to X
;       tfr     x,d     * transfer X back to D
        addd    #1      * add 1 to D
return  jmp     GIVABF  * return to caller

* lwasm --decb -o -9 addone2.bin addone2.asm
* lwasm --decb -f basic -o addone2.bas
* decb copy -2 -r addone2.bin ../Xroar/dsk/DRIVE0.DSK,ADDONE2.BIN