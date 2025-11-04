* SCRNMOVE.ASM v1.00
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* DEFUSRx() screen moving function
*
* INPUT:   direction (1=up, 2=down, 3=left, 4=right)
* RETURNS: 0 on success
*         -1 if invalid direction
*
* EXAMPLE:
*   CLEAR 200,&H3F00
*   DEFUSR0=&H3F00
*   A=USR0(1)
*
ORGADDR EQU $3f00

INTCNV EQU $B3ED * 46061
GIVABF EQU $B4F4 * 46324

UP     EQU 1
DOWN   EQU 2
LEFT   EQU 3
RIGHT  EQU 4
SCREEN EQU 1024 * top left of screen
END    EQU 1535 * bottom right of screen

    org     ORGADDR

start jsr   INTCNV * get incoming param in D
      cmpb  #UP
      beq   up
      cmpb  #DOWN
      beq   down
      cmpb  #LEFT
      beq   left
      cmpb  #RIGHT
      beq   right
      bra   error

up    ldx   #SCREEN+32
loopup lda  ,x
     sta    -32,x
     leax   1,x
     cmpx   #END
     ble    loopup
     bra    return

down ldx    #END-32
loopdown    lda ,x
     sta    32,x
     leax   -1,x
     cmpx   #SCREEN
     bge    loopdown
     bra    return

left ldx    #SCREEN+1
loopleft    lda ,x
     sta    -1,x
     leax   1,x
     cmpx   #END
     ble    loopleft
     bra    return

right ldx   #END-1
loopright   lda ,x
     sta    1,x
     leax   -1,x
     cmpx   #SCREEN
     bge    loopright
     bra    return

error ldd   #-1    * load D with -1 for error code
     bra    exit
    
return ldd  #0
exit   jmp  GIVABF      

* lwasm --decb -9 -o scrnmove.bin scrnmove.asm
* lwasm --decb -f basic -o scrnmove.bas
* decb copy -2 -r scrnmove.bin ../Xroar/dsk/DRIVE0.DSK,SCRNMOVE.BIN
