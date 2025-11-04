; lwasm game.asm -fbasic -ogame.bas --map
; a09 -fbasic -ogame.bas game.asm

ORGADDR     equ     $3f00       ; Where program loads in memory

            org     ORGADDR

;------------------------------------------------------------------------------
; Absolute addresses of items in RAM variables
;------------------------------------------------------------------------------
; Direct Page
DEVNUM      equ     $6f         ; device number being used for I/O
CURPOS      equ     $88         ; location of cursor position in RAM
EXECJP      equ     $9d         ; location of jump address for EXEC
; Others
VIDRAM      equ     $400        ; VIDEO DISPLAY AREA

;------------------------------------------------------------------------------
; Absolute addresses of ROM calls
;------------------------------------------------------------------------------
POLCAT      equ     $A000
CHROUT      equ	    $A002
INTCNV      equ     $B3ED
GIVABF      equ     $B4F4

;------------------------------------------------------------------------------
; This code can be called by EXEC/EXEC xxxx.
;------------------------------------------------------------------------------
start       leay    start,pcr   ; Y=start
            cmpx    #start      ; X=start? (called by "EXEC xxxx")
            beq     handler     ; if yes, goto handler
            cmpx    #$abab      ; X=ABAB? (called by "EXEC")
            bne     fromusr     ; if no, goto fromusr
            ldx     <EXECJP     ; else, load X with EXECJP address
            cmpx    #start      ; X=start? (called by "EXEC xxxx")
            beq     handler     ; if yes, goto handler
                                ; else, must be USR
fromusr     tsta                ; compare A to 0
            beq     donumber    ; if A=0, number passed in. goto donumber
            inca                ; inc A so if 255 (string) it will be 0 now
            beq     dostring    ; if A=0 (was 255), string. goto dostring
            bra     usrerror    ; else, goto unknown (this should never happen)

handler     rts

;------------------------------------------------------------------------------
; A=USRx(0)
; INTCNV will get the number parameter into the D register
;------------------------------------------------------------------------------
donumber    jsr     INTCNV      ; get passed in value in D
            cmpd    #VIDRAM     ; D=top left of screen
            blo     usrerror    ; if lower, goto offscreen
            cmpd    #VIDRAM+511 ; D=bottom right of screen
            bhi     usrerror    ; if higher, goto offscreen    

            tfr     d,x
            lda     #255
            sta     ,x

            ldd     #0
            bra     usrexit

usrerror    ldd     #-1         ; D=-1 for error
usrexit     jmp     GIVABF      ; return to BASIC

;------------------------------------------------------------------------------
; A=USRx("STRING")
; X will be VARPTER, B will be string length
;------------------------------------------------------------------------------
dostring    bra     usrexit

;------------------------------------------------------------------------------
; PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR
;------------------------------------------------------------------------------
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jmp     [CHROUT]        ; JMP CHROUT will do an rts.
            ;rts

;------------------------------------------------------------------------------
; Data storage for the string messages
;------------------------------------------------------------------------------
msginst     fcc     "INSTALLED"
            fcb     0

msguninst   fcc     "UNINSTALLED"
            fcb     0

            end
