* HELLO.ASM v1.00
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* HELLO WORLD with colorful top/bottom borders.
* Runs until a key is pressed.
*
ORGADDR equ     $3f00

POLCAT  equ     $a000   * ROM input routine
CHROUT  equ     $a002   * ROM output routine

curpos  equ     $88

screen  equ     $400
end     equ     $5ff

initcl  equ     $9F

        org     ORGADDR
*
* Clear screen to black.
*
start   ldx     #screen * x points to start of screen
cloop   ldd     #$8080  * D is two black blocks
        std     ,x++    * store D at X, increment X
        cmpx    #end    * compare X to end of screen
        ble     cloop   * if not there yet, loop
*
* Move BASIC cursor position.
*
        ldd     #screen+256+10
        ldx     #curpos * BASIC's cursor position
        std     ,x      * store new location
*
* Print message.
*
        ldx     #msg    * X points to message
mloop   lda     ,x+     * load A with character, inc X
        beq     borders * if char is 0, go to borders
        jsr     [CHROUT] * call ROM character out
        bra     mloop   * go back to message loop
*
* Draw colorful top and bottom borders.
*
borders ldb     #initcl * initial color block char
        stb     startc  * store it for later
        
breset  ldx     #$400   * start of screen
        ldy     #$5ff   * end of screen

        ldb     startc  * start-of-line color
        cmpb    #240    * is in last color?
        blt     bskip   * no, skip reset
        ldb     #initcl * load initial color
        stb     startc  * store it for later
        bra     bloop   * go to border loop
bskip   addb    #16     * increment color
        stb     startc  * store next start color

        sync            * wait for next 50hz/60hz IRQ

bloop   stb     ,x+     * store color block at X, inc X
        stb     ,y      * store color block at Y
        leay    -1,y    * decrement Y
        cmpx    #screen+31 * end of first line
        beq     eol     * yes, go to end of line
       
        cmpb    #240    * compare to start of last color
        bge     bcreset * if in that range, go to border color reset
        addb    #16     * inc block char to next color
        bra     bloop   * go to border loop

bcreset ldb     #initcl * reload initial color
        bra     bloop   * go to border loop

eol     jsr     [POLCAT] * call ROM check key routine
        bne     done    * key? go to done

        lda     #2      * do this two times
dloop   sync            * wait for screen IQR
        deca            * decrement A counter
        bne     dloop   * not 0? go back to delay loop

        bra     breset  * go to border reset

done    rts             * return from subroutine

msg     fcc     /HELLO WORLD!/  * message text
        fcb     0               * 0 terminator

startc  rmb     1       * store start color here
        end

* lwasm --decb -o hello2.bin hello2.asm -l
* lwasm --decb -f basic -o hello2.bas hello2.asm -l
* lwasm --decb -f ihex -o hello2.hex hello2.asm -l
* decb copy -2 -r hello2.bin ../Xroar/dsk/DRIVE0.DSK,HELLO2.BIN
