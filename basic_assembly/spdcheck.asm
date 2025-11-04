ORGADDR EQU $3f00

GIVABF EQU $B4F4 *46324
INTCNV EQU $B3ED *46061

       org  ORGADDR
start  rts
*return jmp GIVABF * return to caller

* mamou -b coco.asm -otest.bin
* lwasm --decb -o lcase.bin lcase.asm
* decb copy -2 -r lcase.bin ../Xroar/dsk/DRIVE0.DSK,LCASE.BIN