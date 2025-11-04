; USRSTR.ASM

ORGADDR     EQU     $3f00

CHKSTR      EQU     $B146       ; Undocumented ROM call
GIVABF      EQU     $B4F4       ; 46324

            org     ORGADDR

start       jsr     CHKSTR      ; ?TM ERROR if not a string.

            ldd     #-1         ; load -1 as error
            jmp     GIVABF      ; return to caller

            end

; lwasm --decb -o usrstr.bin usrstr.asm -l -m
; lwasm --decb -f basic -o usrstr.bas usrstr.asm -l -m
; lwasm --decb -f ihex -o usrstr.hex usrstr.asm -l -m
; decb copy -2 -r usrstr.bin ../Xroar/dsk/DRIVE0.DSK,usrstr.BIN
; a09 -fbasic -ousrstr_a09.bas usrstr.asm

