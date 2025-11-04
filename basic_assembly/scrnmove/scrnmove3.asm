* SCRNMOVE.ASM v1.02
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* DEFUSRx() screen moving function
*
* INPUT:   direction (1=up, 2=down, 3=left, 4=right)
* RETURNS: 0 on success
*         -1 if invalid direction
*
* 1.01 better param parsing per L. Curtis Boyle
* 1.02 16-bit up/down moves, per William Astle
*
* EXAMPLE:
*   CLEAR 200,&H3F00
*   DEFUSR0=&H3F00
*   A=USR0(1)
*
ORGADDR EQU     $3f00

INTCNV  EQU     $B3ED   * 46061
GIVABF  EQU     $B4F4   * 46324

UP      EQU     1
DOWN    EQU     2
LEFT    EQU     3
RIGHT   EQU     4
SCREEN  EQU     1024+32 * top left of screen
END     EQU     1535-32 * bottom right of screen

        org     ORGADDR

start   jsr     INTCNV  * get incoming param in D
;        tsta            * see if A is zero
;        beq     error   * anything in A means >255
        decb            * decrement B
        beq     up      * if one DEC got us to zero
        decb            * decrement B
        beq     down    * if two DECs...
        decb            * decrement B
        beq     left    * if three DECs...
        decb            * decrement B
        beq     right   * if four DECs...
error   ldd     #-1     * load D with -1 for error code
        bra     exit

up      ldx     #SCREEN+32
loopup  ldd     ,x++    * load D with 2-bytes at X, inc++
        std     -34,x   * store
        cmpx    #END
        ble     loopup

        bra     return

down    ldx     #END-33
loopdown ldd    ,x
        std     32,x
        leax    -2,x
        cmpx    #SCREEN
        bge     loopdown
        bra     return

left    ldx     #SCREEN
        lda     ,x+
        pshs    a           * push A on user stack
loopleft ldd    ,x++
        std     -3,x
        cmpx    #END-1
        ble     loopleft
        lda     ,x
        sta     -1,x
        puls    a           * pull A from user stack
        sta     ,x
        bra     return

right   ldx     #END
        lda     ,x
        pshs    a
        leax    -2,x
loopright ldd   ,x
        std     1,x
        leax    -2,x
        cmpx    #SCREEN+1
        bge     loopright
        leax    1,x
        puls    a
        ldb     ,x
        std     ,x
    
return  ldd     #0      * return code (0=success)
exit    jmp     GIVABF  * return to BASIC

* lwasm --decb -9 -o SCRNMOV3.bin scrnmove3.asm
* lwasm --decb -f basic -o SCRNMOV3.BAS scrnmove3.asm
* decb copy -2 -r SCRNMOV3.BAS ../Xroar/dsk/DRIVE0.DSK,SCRNMOVE3.BIN
