	.text
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global str2int
	.global int2str
	.global unsigned_division
	.global signed_division
	.global mod
	.global line_break
	.global gpio_interrupt_init
	.global uart_interrupt_init
	.global timer_interrupt_init
	.global simple_read_character
	.global lookup_table

U0FR: 	.equ 0x18	; UART0 Flag Register
ptr_to_lookup_table:	.word lookup_table


uart_init:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r0, #0xE618
    MOVT r0, #0x400F
    MOV  r1, #1
    STR  r1, [r0]

wait_uart_power:
    MOV r0, #0xEA18
    MOVT r0, #0x400F
    LDR  r1, [r0]
    MVN  r1, r1
    AND  r1, r1, #1
    CMP  r1, #0
    BNE  wait_uart_power

    MOV r0, #0xE608
    MOVT r0, #0x400F
    MOV  r1, #1
    STR  r1, [r0]

    MOV r0, #0xC030
    MOVT r0, #0x4000
    MOV  r1, #0
    STR  r1, [r0]

    MOV r0, #0xC024
    MOVT r0, #0x4000
    MOV  r1, #8
    STR  r1, [r0]

    MOV r0, #0xC028
    MOVT r0, #0x4000
    MOV  r1, #44
    STR  r1, [r0]

    MOV r0, #0xCFC8
    MOVT r0, #0x4000
    MOV  r1, #0
    STR  r1, [r0]

    MOV r0, #0xC02C
    MOVT r0, #0x4000
    MOV  r1, #0x60
    STR  r1, [r0]

    MOV r0, #0xC030
    MOVT r0, #0x4000
    MOV r1, #0x0301
    MOVT r1, #0x0000
    STR  r1, [r0]

    MOV r0, #0x451C
    MOVT r0, #0x4000
    LDR  r1, [r0]
    ORR  r1, r1, #0x03
    STR  r1, [r0]

    MOV r0, #0x4420
    MOVT r0, #0x4000
    LDR  r1, [r0]
    ORR  r1, r1, #0x03
    STR  r1, [r0]

    MOV r0, #0x452C
    MOVT r0, #0x4000
    LDR  r1, [r0]
    ORR  r1, r1, #0x11
    STR  r1, [r0]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

gpio_btn_and_LED_init:
    PUSH {r4-r12, lr}              ; Save callee-saved registers and return address

    MOV  r4, #0xE608               ; Load low 16 bits of RCGCGPIO address
    MOVT r4, #0x400F               ; r4 = 0x400FE608 (GPIO clock gating control)
    LDRB r5, [r4]                  ; Read current GPIO clock enable value
    ORR  r5, r5, #0x2A             ; Enable clocks for Port B (bit1), Port D (bit3), Port F (bit5)
    STRB r5, [r4]                  ; Write updated value back to enable clocks

    NOP                            ; Small delay to allow clock to stabilize
    NOP                            ; Delay
    NOP                            ; Delay

    MOV  r4, #0x5400               ; Load low 16 bits of GPIO_PORTB_DIR address
    MOVT r4, #0x4000               ; r4 = 0x40005400 (Port B direction register)
    LDRB r5, [r4]                  ; Read current Port B direction settings
    ORR  r5, r5, #0x0F             ; Set PB3–PB0 as outputs for Alice LEDs
    STRB r5, [r4]                  ; Write updated direction settings

    MOV  r4, #0x551C               ; Load low 16 bits of GPIO_PORTB_DEN address
    MOVT r4, #0x4000               ; r4 = 0x4000551C (Port B digital enable)
    LDRB r5, [r4]                  ; Read current digital enable settings
    ORR  r5, r5, #0x0F             ; Enable digital function on PB3–PB0
    STRB r5, [r4]                  ; Write updated digital enable settings

    MOV  r4, #0x7400               ; Load low 16 bits of GPIO_PORTD_DIR address
    MOVT r4, #0x4000               ; r4 = 0x40007400 (Port D direction register)
    LDRB r5, [r4]                  ; Read current Port D direction settings
    BIC  r5, r5, #0x0F             ; Clear PD3–PD0 to configure them as inputs
    STRB r5, [r4]                  ; Write updated direction settings

    MOV  r4, #0x751C               ; Load low 16 bits of GPIO_PORTD_DEN address
    MOVT r4, #0x4000               ; r4 = 0x4000751C (Port D digital enable)
    LDRB r5, [r4]                  ; Read current digital enable settings
    ORR  r5, r5, #0x0F             ; Enable digital function on PD3–PD0
    STRB r5, [r4]                  ; Write updated digital enable settings

    ;MOV  r4, #0x7510               ; Load low 16 bits of GPIO_PORTD_PUR address
    ;MOVT r4, #0x4000               ; r4 = 0x40007510 (Port D pull-up register)
    ;LDRB r5, [r4]                  ; Read current pull-up settings
    ;ORR  r5, r5, #0x0F             ; Enable pull-up resistors on PD3–PD0
    ;STRB r5, [r4]                  ; Write updated pull-up settings

    MOV  r4, #0x5400               ; Load low 16 bits of GPIO_PORTF_DIR address
    MOVT r4, #0x4002               ; r4 = 0x40025400 (Port F direction register)
    LDRB r5, [r4]                  ; Read current Port F direction settings
    ORR  r5, r5, #0x0E             ; Set PF3–PF1 as outputs for RGB LED
    BIC  r5, r5, #0x10             ; Clear PF4 to configure it as input (SW1)
    STRB r5, [r4]                  ; Write updated direction settings

    MOV  r4, #0x551C               ; Load low 16 bits of GPIO_PORTF_DEN address
    MOVT r4, #0x4002               ; r4 = 0x4002551C (Port F digital enable)
    LDRB r5, [r4]                  ; Read current digital enable settings
    ORR  r5, r5, #0x1E             ; Enable digital on PF4–PF1
    STRB r5, [r4]                  ; Write updated digital enable settings

    MOV  r4, #0x5510               ; Load low 16 bits of GPIO_PORTF_PUR address
    MOVT r4, #0x4002               ; r4 = 0x40025510 (Port F pull-up register)
    LDRB r5, [r4]                  ; Read current pull-up settings
    ORR  r5, r5, #0x10             ; Enable pull-up resistor on PF4 (SW1)
    STRB r5, [r4]                  ; Write updated pull-up settings

    POP  {r4-r12, lr}              ; Restore saved registers
    MOV  pc, lr                    ; Return to caller

output_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r4, #0xC000		; Initialize r1 to base data address
	MOVT r4, #0x4000

output_loop:	; Wait while TxFF in flag register is 1
	LDRB r5, [r4, #U0FR]		; These three lines are for reading
	LSR r5, r5, #5		; the 5th bit in the flag register
	AND r5, r5, #1
	CMP r5, #1
	BEQ output_loop

	STRB r0, [r4]		; Store value in r0 to the data register

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr


read_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r4, #0xC000		; Initialize r1 to base data address
	MOVT r4, #0x4000

read_char_loop:		; Wait while RxFE in flag register is 1
	LDRB r5, [r4, #U0FR]		; These three lines are for reading
	LSR r5, r5, #4		; the 4th bit in the flag register
	AND r5, r5, #1
	CMP r5, #1
	BEQ read_char_loop

	LDRB r0, [r4]		; Load value entered via putty to r0

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

read_string:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r4, r0		; Initialize cursor
	MOV r5, r0		; Preserve initial pointer
read_str_loop:
	BL read_character

	CMP r0, #13		; Did the user press enter?
	BEQ input_enter

	CMP r0, #8		; Did the user press backspace?
	BEQ input_bs

; If user didn't press enter,
	CMP r0, #48		; Following 7 lines compare char with
	BGE ge_zero		; the ascii code of 0 and 9 to determine
	BL skip_char	; if char is a number. If it's not, don't store it in memory.
ge_zero:
	CMP r0, #57
	BLE is_number
	BL skip_char
is_number:
	STRB r0, [r4]		; Store character to cursor
	ADD r4, #1		; Increment cursor

skip_char:
	BL output_character
	BL read_str_loop

input_bs:		; Changes the last character to null char.
	CMP r4, r5		; If cursor at beginning don't do anything
	BEQ read_str_loop

	BL output_character
	MOV r0, #32		; Backspace only sends the terminal cursor back.
	BL output_character		; Need to output space(32) to erase char then
	MOV r0, #8		; output backspace again to set cursor to new line end.
	BL output_character

	SUB r4, #1
	MOV r0, #0
	STRB r0, [r4]
	BL read_str_loop

input_enter:
	MOV r0, #0
	STRB r0, [r4]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

output_string:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r4, r0		; Initialize cursor
output_str_loop:
	LDRB r5, [r4]		; Load character at cursor to r5

	cmp r5, #0x10		; Check if we need to go to lookup table
	blt not_ansi
	cmp r5, #0x1A		; Need to keep update this as we add escape sequences
	bgt not_ansi

	sub r5, r5, #0x10	; Calculate index for lookup table
	ldr r6, ptr_to_lookup_table
	lsl r5, r5, #2		; Multiply r5 by 4 because a .word is 4 bytes long
	ldr r0, [r6, r5]	; r0 holds address to ANSI escape sequence
	bl output_ansi_string
	add r4, r4, #1		; Increment cursor
	b output_str_loop

not_ansi:
	MOV r0, r5		; Store character in r0 for output_character
	BL output_character
	ADD r4, #1		; Increment cursor
	CMP r0, #0		; Is character a null terminator?
	BNE output_str_loop

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

output_ansi_string:
	PUSH {r4-r12, lr}

	mov r4, r0		; Initialize cursor
ansi_loop:
	ldrb r0, [r4], #1		; Load character and increment cursor
	cmp r0, #0
	beq exit_output_ansi_string		; If char is null terminator, exit subroutine
	bl output_character		; Otherwise output character
	b ansi_loop
exit_output_ansi_string:

	POP {r4-r12, lr}
	MOV pc, lr

read_from_push_btns:
    PUSH {r4-r12, lr}

    MOV  r4, #0x73FC           ; Load low 16 bits
    MOVT r4, #0x4000           ; Load upper 16 bits

    LDRB r5, [r4]              ; Read 8-bit value from Port D DATA register

    AND  r5, r5, #0x0F         ; Clear all bits except lowest 4 bits

    EOR  r5, r5, #0x0F         ; Invert only the 4 button bits

    MOV  r0, r5                ; Move final 4-bit button value into r0

    POP  {r4-r12, lr}
    MOV  pc, lr

illuminate_LEDs:
	PUSH {r4-r12,lr}	; Spill registers to stack
          ; Your code is placed here
    MOV r4, #0x53FC		; Initialize pointer to port B
    MOVT r4, #0x4000
    LDRB r5, [r4]		; Load current state of port B

    AND r5, r5, #0xF0		; Clear bits 0 to 4
    ORR r5, r5, r0		; Apply new LED bits
	STRB r5, [r4]		; Store value to port B

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

illuminate_RGB_LED:
	PUSH {r4-r12, lr}            ; Save registers

    AND  r0, r0, #0x07           ; Keep only RGB bits (0-2)
    LSL  r0, r0, #1              ; Shift into PF1-3 positions

    MOV r4, #0x53FC             ; Load low 16 bits of DATA address
    MOVT r4, #0x4002             ; r4 = 0x400253FC (GPIO_PORTF_DATA)
    LDRB r5, [r4]                ; Read current Port F output state

    AND  r5, r5, #0xF1         ; Clear PF1-3 bits (turn off old LED)
    ORR  r5, r5, r0              ; Apply new LED bits
    STRB r5, [r4]                ; Write new value to hardware

    POP  {r4-r12, lr}            ; Restore registers
    MOV  pc, lr                  ; Return to caller

read_tiva_push_button:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    MOV r4, #0x53FC		; Initialize pointer to Port F data
    MOVT r4, #0x4002
    LDRB r5, [r4]

    AND r5, r5, #0x10		; Apply mask for 5th bit
    LSR r5, #4		; Make the 5th bit LSB
    EOR r5, #1		; Flip the bit because it's 0 when SW is closed

    MOV r0, r5		; Return result in r0

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr


str2int:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    mov r4, r0          ; initialize pointer
	mov r5, #0			; initialize result
	mov r6, #1			; sign flag

	LDRB r7, [r4]		; load first char

	cmp r7, #45		; see if first char is negative

	BNE str2int_loop		; if not skip to loop
	mov r6, #-1         ; if it is set flag
	add r4, r4, #1		; move the pointer

str2int_loop:

	LDRB r7, [r4] ; load the next digit

	cmp r7, #0 ;null terminator check
	BEQ str2int_done ; if it is then done

	cmp r7, #"," ; check if char is a comma
	BEQ str2int_skip ;if so skip it

	sub r7, r7, #48 ; subtract ascii of 0 from acsii of digit to get the actual digit

	mov r0, r5 ; move result into r0 for mult
	mov r1, #10 ; get var ready for mult

	mul r5, r0, r1 ; mult result by ten cause in decimal
	add r5, r5, r7 ; add the digit to the result

str2int_skip:

	add r4, r4, #1 ; add tp the pointer to get next digit
	B str2int_loop ; loop

str2int_done:

	cmp r6, #1 ; check the flag
	BEQ str2int_return
	RSBS r5, r5, #0 ; flip if neg

str2int_return:

	MOV r0, r5 ; move into r0

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

int2str:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    mov r4, r0 ; initialize the output pointer
	mov r5, r1 ; initialize the number copy

	cmp r5, #0 ;check if its negative
	bge positive_num

	mov r6, #45	;temp store for negative sign
	STRB r6, [r4]   ; mvoe the negative sign into the output
	add r4, r4, #1  ; move the pointer past the negation
	RSBS r5, r5, #0 ;make it positive if it was initially negative


positive_num:
	cmp r5, #0 ; check if its negative
	bne convert ; if not just 0 then have to convert

	mov r6, #48 ; if just 0 then move the 0 into the output
	STRB r6, [r4] ;store the 0 in the pointer
	ADD r4, r4, #1 ; move the pointer to next address
	mov r6, #0 ; move the term char into temp
	STRB r6, [r4] ; put term chr at the end of output
	B finish ; move to finish


convert:
	mov r7, r4 ; initialize buffer
	mov r8, #0 ; initialize counter

digit:
	mov r0, r5 ; put the copy into the output
	mov r1, #10; get num rdy for div
	SDIV r6, r0, r1 ;r6 = r5/10
	MUL r0, r6, r1 ; set up remainder
	sub r0, r5, r0 ;remainder

	add r0, r0, #48 ; add the ascii to it
	STRB r0, [r4] ; store the ascii in the address
	add r4, r4, #1 ; move the pointer

	mov r5, r6   ; update the number
	add r8, r8, #1 ; increment the counter

	cmp r5, #0 ;check if its 0
	BNE digit ; if not then loop

	mov r8, r4 ; pointer to end of string to add null char
	sub r4, r4, #1 ; move the pointer back to last digit

reverse:
	cmp r8, #0 ;check if counter is 0
	BEQ end_null ; if so then end

	cmp r4, r7	; if second cursor and first cursor passed end routine
	BLE end_null

	LDRB r0, [r4] ; else pull last value put into address
	LDRB r1, [r7] ; load upper value to swap
	STRB r0, [r7] ; make that fisrt value in return
	STRB r1, [r4] ; put first value in last
	add r7, r7, #1 ; move to next address
	sub r4, r4, #1 ; move backwords to previous address
	;sub r8, r8, #1 ; decrement ccounter
	B reverse ; loop

end_null:
	mov r0, #0 ; null char
	STRB r0, [r8] ; store it in address to end num


finish:

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

unsigned_division:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
	MOV r4, #15             ; Initialize counter to 15
	MOV r3, #0              ; Initialize quotient to 0
	LSL r0, #15             ; Logical left shift divisor 15 places
	MOV r2, r1              ; Initialize remainder to dividend
div_loop:
	SUB r2, r2, r0          ; Remainder := Remainder - Divisor
	CMP r2, #0
	BLT neg_rem             ; Is Remainder < 0?

	LSL r3, #1              ; Logical left shift quotient
	ORR r3, r3, #1  ; Set quotient LSB to 1
	CMP r2, #0
	BGE udiv_continue
neg_rem:
	ADD r2, r2, r0  ; Remainder := Remainder + Divisor
	LSL r3, #1              ; Logical left shift quotient
udiv_continue:
	LSR r0, #1              ; Logical right shift divisor
	CMP r4, #0
	BLE stop_unsigned_division      ; Is Counter > 0?
	SUB r4, r4, #1  ; Decrement counter
	BL div_loop

stop_unsigned_division:
	MOV r0, r3              ; Returns quotient in r0

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

signed_division:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
	MOV r5, r1              ; Create copy of dividend
	LSR r5, #31             ; Logical right shift copy of dividend until MSB is LSB
	CMP r5, #1              ; Is copy of dividend = 1? This checks if dividend is
                                        ; negative.
	BNE dividend_pos

	EOR r1, r1, #0xFFFFFFFF         ; Turns a negative dividend into a positive
	ADD r1, r1, #1                          ; integer.

dividend_pos:
	MOV r6, r0              ; Create copy of divisor
	LSR r6, #31             ; Logical right shift copy of divisor until MSB is LSB
	CMP r6, #1              ; Is copy of divisor = 1? This checks if divisor is
                                        ; negative.
	BNE divisor_pos

	EOR r0, r0, #0xFFFFFFFF         ; Turns a negative divisor into a positive
	ADD r0, r0, #1                          ; integer.

divisor_pos:
	BL unsigned_division    ; Run unsigned division on positive dividend
                                                        ; and divisor.
	EOR r5, r5, r6          ; Copy of dividend :=
                                                ; Copy of dividend EOR Copy of divisor.
                                                ; This checks if either one is negative.
	CMP r5, #1
	BNE stop_signed_division        ; Is copy of dividend = 1?
                                                                ; If yes, result needs to be negative.

	EOR r0, r0, #0xFFFFFFFF         ; Flip sign of quotient.
	ADD r0, r0, #1                          ; Only does this when dividend
                                                                ; xor divisor is negative.

stop_signed_division:           ; Stop signed division. Quotient is
                                                        ; already in r0 from unsigned division.

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

mod:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    ; Your code for the mod routine goes here.
	BL unsigned_division
	MOV r0, r2              ; Remainder is already stored in r2 from
							; unsigned division.

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr


line_break:
	PUSH {r4-r12,lr}

	MOV r0, #13		; Carriage return
	BL output_character
	MOV r0, #10		; New line
	BL output_character

	POP {r4-r12,lr}
	MOV pc, lr



gpio_interrupt_init:
		PUSH {r4-r12, lr}
		;GPIOIS init
		mov r0, #0x5404
		movt r0, #0x4002
		LDR r1, [r0]
		;and r1, r1, ~(1 << 3)
		mov r4, #1
		lsl r4, r4, #4
		mvn r4, r4
		and r1, r1, r4
		STR r1, [r0]


		;GPIOIBE init
		mov r0, #0x5408
		movt r0, #0x4002
		LDR r1, [r0]
		;and r1, r1, ~(1 << 3)
		mov r4, #1
		lsl r4, r4, #4
		mvn r4, r4
		and r1, r1, r4
		STR r1, [r0]

		;GPIOIV init
		mov r0, #0x540C
		movt r0, #0x4002
		LDR r1, [r0]
		;and r1, r1, ~(1 << 3)
		mov r4, #1
		lsl r4, r4, #4
		mvn r4, r4
		and r1, r1, r4
		STR r1, [r0]

		;GPIO_interrupt_ability init
		mov r0, #0x5410
		movt r0, #0x4002
		LDR r1, [r0]
		;orr r1, r1, (1 << 3)
		mov r4, #1
		lsl r4, r4, #4
		orr r1, r1, r4
		STR r1, [r0]

		;PortF_to_interrupt init
		mov r0, #0xE100
		movt r0, #0xE000
		LDR r1, [r0]
		;and r1, r1, ~(1 << 29)
		mov r4, #1
		lsl r4, r4, #30
		orr r1, r1, r4
		STR r1, [r0]

		POP {r4-r12, lr}
		MOV pc, lr



uart_interrupt_init:
		PUSH {r4-r12, lr}
		;UARTIM init
		mov r0, #0xC038
		movt r0, #0x4000
		LDRB r1, [r0]
		;orr r1, r1, (1 << 3)
		mov r4, #1
		lsl r4, r4, #4
		orr r1, r1, r4
		STRB r1, [r0]

		;PortF_to_interrupt_UART init
		mov r0, #0xE100
		movt r0, #0xE000
		LDRB r1, [r0]
		;and r1, r1, ~(1 << 4)
		mov r4, #1
		lsl r4, r4, #5
		orr r1, r1, r4
		STRB r1, [r0]

		POP {r4-r12, lr}
		MOV pc, lr



timer_interrupt_init:
		PUSH {r4-r12, lr}

		mov  r0, #0xE604		; Connect clock to Timer 0
		movt r0, #0x400F
		ldr r1, [r0]
		orr r1, r1, #1
		str r1, [r0]

		mov  r0, #0xEA04		; Wait for Timer 0 to be ready
		movt r0, #0x400F
wait_timer_clock:
		ldr r1, [r0]
		tst r1, #1		; If bit 0 is 0, keep looping
		beq wait_timer_clock

		mov  r0, #0x000C		; Disable Timer via GPTMCTL
		movt r0, #0x4003
		ldr r1, [r0]
		bic r1, r1, #1
		str r1, [r0]

		mov  r0, #0x0000		; Put Timer in 32-bit mode via GPTMCFG
		movt r0, #0x4003
		ldr r1, [r0]
		mov r4, #7		; Mask for bits 0-2
		bic r1, r1, r4
		str r1, [r0]

		mov  r0, #0x0004		; Put Timer into Periodic Mode via GPTMTAMR
		movt r0, #0x4003
		ldr r1, [r0]
		orr r1, r1, #2		; Set bit 1 to 1
		bic r1, r1, #1		; Clear bit 0
		str r1, [r0]

		mov  r0, #0x0028		; Setup interval period via GPTMTAILR
		movt r0, #0x4003
		mov  r1, #0x0900		; 4,000,000 in hex. 0.25 second period
		movt r1, #0x003D
		str r1, [r0]

		mov  r0, #0x0018		; Enable timer to interrupt processor via GPTMIMR
		movt r0, #0x4003
		ldr r1, [r0]
		orr r1, r1, #1
		str r1, [r0]

		mov  r0, #0xE100		; Configure processor to allow timer to interrupt processor
		movt r0, #0xE000
		ldr r1, [r0]
		mov  r4, #0x0000
		movt r4, #0x0008		; Mask for bit 19
		orr r1, r1, r4
		str r1, [r0]

		mov  r0, #0x000C		; Enable timer via GPTMCTL
		movt r0, #0x4003
		ldr r1, [r0]
		orr r1, r1, #1
		str r1, [r0]


		POP {r4-r12, lr}
		MOV pc, lr



simple_read_character:
		PUSH {r4-r12, lr}

		mov  r1, #0xC000	; Simply load what is in UART data register and return to r0
		movt r1, #0x4000
		ldrb r0, [r1]

		POP {r4-r12, lr}
		MOV pc, lr





	.end
