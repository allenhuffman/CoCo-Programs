; lwasm exectest.asm -fbasic -oexectest.bas --map --list
; decb copy -2 exectest.bin drive0.dsk,CONSMOVE.BIN

; Test to see what EXEC does.

ORGADDR     equ     $3f00       ; Where program loads in memory
;ORGADDR     equ     $0       ; Where program loads in memory

;------------------------------------------------------------------------------
; Definitions
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Absolute addresses of items in RAM variables
;------------------------------------------------------------------------------
; Direct Page
EXECJP      equ     $9d         ; location of jump address for EXEC
; Others
VIDRAM      equ     $400        ; VIDEO DISPLAY AREA

;------------------------------------------------------------------------------
; Absolute addresses of ROM calls
;------------------------------------------------------------------------------
CHROUT      equ	    $A002
GIVABF      equ     $B4F4

            org     ORGADDR

;------------------------------------------------------------------------------
; This code can be called by EXEC or EXEC xxxx.
;------------------------------------------------------------------------------
start       leay    start,pcr   ; Y=address of start
            pshs    y           ; push Y onto the stack
            cmpx    ,s++        ; compare X to Y value on stack and pop
            beq     fromexec    ; if X=Y, goto fromexec
            cmpx    #$abab      ; X=ABAB? called by "EXEC"
            bne     fromusr     ; if no, goto fromusr
            ldy     <EXECJP     ; else, load Y with EXECJP address
            pshs    y           ; push Y onto the stack
            cmpx    ,s++        ; compare X to Y value on stack and pop
            beq     fromexec    ; if yes, goto fromexec
fromexec    leax    msgexec,pcr ; X point to message
            jmp     print       ; print and return

unknown     leax    msgunknown,pcr
            jmp     print

fromusr     tsta                ; compare A to 0
            beq     donumber    ; if A=0, number passed in. goto donumber
            inca                ; inc A so if 255 (string) it will be 0 now
            beq     dostring    ; if A=0 (was 255), string. goto dostring
            bra     unknown     ; else, goto unknown (this should never happen)

donumber    leax    msgusrnum,pcr
            jsr     print
            bra     exitsuccess

dostring    leax    msgusrstr,pcr
            jsr     print
exitsuccess ldd     #0          ; return 0 as an error code
return      jmp     GIVABF      ; return value back to USRx()


;------------------------------------------------------------------------------
; PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR
;------------------------------------------------------------------------------
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jmp     [CHROUT]    ; JMP CHROUT will do an rts.

;------------------------------------------------------------------------------
; Data storage for the string messages
;------------------------------------------------------------------------------
msgexec     fcc     "EXEC"
            fcb     0

msgunknown  fcc     "UNKNOWN"
            fcb     0

msgusrnum   fcc     "USRX(#)"
            fcb     0

msgusrstr   fcc     /USRX("STRING")/
            fcb     0

            end
    