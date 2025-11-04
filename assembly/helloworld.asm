        org     $3f00
start   ldx     #msg
loop    lda     ,x+
        beq     done
        jsr     [$a002]
        bra     loop
done    rts
msg     fcc     /HELLO WORLD/
        fcb     13
        fcb     0
        end

* lwasm --decb -o HELLO.BIN helloworld.asm -l
* lwasm --decb -f basic -o HELLO.BAS helloworld.asm -l
* lwasm --decb -f ihex -o helloworld.hex helloworld.asm -l
* decb copy -2 -r helloworld.bin ../Xroar/dsk/DRIVE0.DSK,HELLO.BIN
