; ASM addition to SYScard to log when CD is read
;

	.nomlist
	.list

	.include "my_EQU.inc"

RAW_PARMS = 0	; sets whether to output additional info @ end of line

	.zp
	.bss

;----- CODE AREA -------
	.code
	.bank	0

	.incbin	"syscard3.pce"


;======= SYSCARD hacking starts here ================

	.bank	0	; E000-FFFF
	.org	$E009
	JMP	LOGPAGE	; redirect

	.org	$FEC8	; end of first segment
LOGPAGE:
	PHA
	TMA	#6
	PHA
	LDA	#$20
	TAM	#6
	JSR	LOGCD
	PLA
	TAM	#6
	PLA

	JMP	$EC05	; go to original target


;======= SYSCARD paged-out code starts here ================
	
	.bank	$20	; C000-DFFF
	.org	$C000

; code below may seem wasteful, but for now it is
; working without using any RAM other than stack

LOGCD:	
	PHX
	CLX
.secloop:
	LDA	SEC_txt,X
	BEQ	.out1
	JSR	FT245_Out
	INX
	BRA	.secloop
.out1:
	LDA	<_cl
	JSR	OUT_HEX
	LDA	<_ch
	JSR	OUT_HEX
	LDA	<_dl
	JSR	OUT_HEX
	LDA	#$20
	JSR	FT245_Out

	LDA	<_dh
	CMP	#$FE
	BEQ	.prtbyt
	JSR	NUM_SEC
	BRA	.loc
.prtbyt:
	JSR	NUM_BYT
.loc:
	CMP	#1
	BEQ	.local
	CMP	#$FE
	BEQ	.VRAM
	CMP	#$FF
	BEQ	.VRAM

	JSR	BANK_NUM
	BRA	.bank

.VRAM:
	JSR	VRAM_out
.local:
	LDA	<_bh		; address in BH/BL
	JSR	OUT_HEX
.bank:
	LDA	<_bl		; or bank in BL
	JSR	OUT_HEX

.EOL:				; if enabled, this will print raw parameters
				; for debug purposes
	IF	RAW_PARMS=1

	LDA	#$20
	JSR	FT245_Out
	LDA	#$20
	JSR	FT245_Out
	LDA	<_dh
	JSR	OUT_HEX
	LDA	<_bl
	JSR	OUT_HEX
	LDA	<_bh
	JSR	OUT_HEX
	LDA	#$20
	JSR	FT245_Out
	LDA	<_al
	JSR	OUT_HEX
	LDA	<_ah
	JSR	OUT_HEX

	ENDIF

	LDA	#$0D
	JSR	FT245_Out
	LDA	#$0A
	JSR	FT245_Out
	PLX

	RTS

VRAM_out:
	PHA
	PHX
	CLX
.vramlp:
	LDA	VRAM_txt,X
	BEQ	.out1
	JSR	FT245_Out
	INX
	BRA	.vramlp
.out1:
	PLX
	PLA
	RTS

BANK_NUM:
	PHA
	PHX
	CLX
.banklp:
	LDA	BANK_txt,X
	BEQ	.out1
	JSR	FT245_Out
	INX
	BRA	.banklp
.out1:
	PLX
	PLA
	RTS

NUM_SEC:
	PHA
	PHX
	LDA	<_al
	JSR	OUT_HEX
	CLX
.secnumlp:
	LDA	SECNUM_txt,X
	BEQ	.out1
	JSR	FT245_Out
	INX
	BRA	.secnumlp
.out1:
	PLX
	PLA
	RTS

NUM_BYT:
	PHA
	PHX
	LDA	<_ah
	JSR	OUT_HEX
	LDA	<_al
	JSR	OUT_HEX
	CLX
.bytnumlp:
	LDA	BYTNUM_txt,X
	BEQ	.out1
	JSR	FT245_Out
	INX
	BRA	.bytnumlp
.out1:
	PLX
	PLA
	RTS

OUT_HEX:
	PHX
	PHA
	LSR	A
	LSR	A
	LSR	A
	LSR	A
	TAX
	LDA	HEXCHAR,X
	JSR	FT245_Out
	PLA
	AND	#$0F
	TAX
	LDA	HEXCHAR,X
	JSR	FT245_Out
	PLX
	RTS

HEXCHAR:
	.db	"0123456789ABCDEF"
	
SEC_txt:
	.db	"SECTOR# "
	.db	0

SECNUM_txt:
	.db	" Sectors @ "
	.db	0

BYTNUM_txt:
	.db	" BYTES @ "
	.db	0

VRAM_txt:
	.db	"VRAM "
	.db	0

BANK_txt:
	.db	"BANK "
	.db	0

	.include "FT245_lowlevel.asm"
