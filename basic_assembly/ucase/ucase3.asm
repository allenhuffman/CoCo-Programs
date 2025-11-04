; UCASE3.ASM v1.02
; by Allen C. Huffman of Sub-Etha Software
; www.subethasoftware.com / alsplace@pobox.com
;
; 1.01 a bit smaller per Simon Jonassen
; 1.02 converted to allow passing a string in to USR
;
; DEFUSRx() uppercase output function
;
; INPUT:   string
; RETURNS: # chars converted or -1 if error
;
; EXAMPLE:
;   CLEAR 200,&H3F00
;   DEFUSR0=&H3F00
;   A$="Print this in uppercase."
;   PRINT A$
;   A=USR0(A$)
;   PRINT "CHARS CONVERTED:";A
;   A=USR0("This is another test");
;   PRINT "CHARS CONVERTED:";A
;
ORGADDR     EQU     $3f00

CHROUT      EQU     $A002
CHKSTR      EQU     $B146       ; Undocumented ROM call
INTCNV      EQU     $B3ED       ; 46061
GIVABF      EQU     $B4F4       ; 46324

            org     ORGADDR

start       jsr     CHKSTR      ; ?TM ERROR if not a string.
            ; X will be VARPTR, B will be string length
            tstb
            beq     reterror    ; exit if strlen is 0
            ldy     2,x         ; load string addr to Y
            ldx     #0          ; clear X (count of chars conv)

loop        lda     ,y+	        ; get next char, inc Y
            cmpa    #'a         ; compare to lowercase A
            blo     nextch      ; if less, no conv needed
            cmpa    #'z         ; compare to lowercase Z
            bhi     nextch      ; if greater, no conv needed
            suba    #32         ; subtract 32 to make uppercase
            leax    1,x         ; inc count of chars converted
nextch      jsr     [CHROUT]    ; call ROM output character routine
            decb                ; decrement counter
            bne	    loop        ; not done yet

            tfr     x,d         ; move chars conv count to D
            bra     return

reterror    ldd     #-1         ; load -1 as error
return      jmp     GIVABF      ; return to caller

            end

; lwasm --decb -o ucase3.bin ucase3.asm -l -m
; lwasm --decb -f basic -o ucase3.bas ucase3.asm -l -m
; lwasm --decb -f ihex -o ucase3.hex ucase3.asm -l -m
; decb copy -2 -r ucase3.bin ../Xroar/dsk/DRIVE0.DSK,UCASE3.BIN
; a09 -fbasic -oucase3_a09.bas ucase3.asm

