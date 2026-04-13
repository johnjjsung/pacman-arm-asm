	.data

	.global ansi_red
	.global ansi_green
	.global ansi_blue
	.global ansi_yellow
	.global cursor_pos
	.global pacman_string
	.global lookup_table
	.global pacman_dir



; ANSI escape sequences for colors
ansi_red:		.string 0x1B, "[38;5;9m", 0
ansi_green:		.string 0x1B, "[38;5;10m", 0
ansi_blue:		.string 0x1B, "[38;5;12m", 0
ansi_yellow:	.string 0x1B, "[38;5;11m", 0

; ANSI escape sequence for cursor position
cursor_pos:		.string 0x1B, "[123;456H", 0


pacman_string:	.string 0x13, '<', 0


; Lookup table that references ANSI escape sequences
lookup_table:
		.word ansi_red
		.word ansi_green
		.word ansi_blue
		.word ansi_yellow


pacman_dir:		.byte 1		; Direction for pacman movement. 0=up, 1=right, 2=down 3=left


	.text
	.global lab7
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_string
	.global timer_interrupt_init
	.global int2str

	.global Timer_Handler
	.global UART0_Handler
	.global Switch_Handler

	.global lookup_table
	.global ptr_to_pacman_string


ptr_to_pacman_string:		.word pacman_string
ptr_to_pacman_dir:			.word pacman_dir
ptr_to_cursor_pos:			.word cursor_pos


; Offset used for indexing in lookup table
RED:		.equ 0x10
GREEN:		.equ 0x11
BLUE:		.equ 0x12
YELLOW:		.equ 0x13


lab7:
		PUSH {r4-r12, lr}

		; Initialization
		bl uart_init
		bl gpio_btn_and_LED_init

		; Move cursor
		mov r0, #24
		mov r1, #4
		bl move_cursor

		; Print pacman
		ldr r0, ptr_to_pacman_string
		bl output_string


		POP {r4-r12, lr}
		MOV pc, lr


Timer_Handler:
		PUSH {r4-r12, lr}




		POP {r4-r12, lr}
		BX lr


UART0_Handler:
        PUSH    {r4-r12, lr}
        POP     {r4-r12, lr}
        BX      lr


Switch_Handler:
        PUSH    {r4-r12, lr}
        POP     {r4-r12, lr}
        BX      lr


; Moves cursor to position (line, column) where line=r0, column=r1.
move_cursor:
		PUSH {r4-r12, lr}

		mov r4, r0		; Preserve line and column
		mov r5, r1		; r4=line, r5=column

		ldr r0, ptr_to_cursor_pos
		add r0, r0, #2		; Add 2 to skip ESC and '['
		mov r1, r4
		bl int2str			; Store line as string

		ldr r0, ptr_to_cursor_pos
		bl find_null		; r0 = address just after line
		mov r1, #0x3B		; 0x3B is the ASCII value for ';'
		strb r1, [r0], #1	; Store ';' after line and increment r0

		mov r1, r5			; r1 = column
		bl int2str			; Store column as string

		ldr r0, ptr_to_cursor_pos
		bl find_null		; r0 = address just after column
		mov r1, #0x48		; 0x48 is the ASCII value for 'H'
		strb r1, [r0], #1	; Store 'H' after column and increment r0
		mov r1, #0
		strb r1, [r0]		; Store null char at the end

		ldr r0, ptr_to_cursor_pos
		bl output_string	; Move cursor to position stored in memory

		POP {r4-r12, lr}
		MOV pc, lr


; Given the address of a string in r0, returns the address of the first null character.
; Used for move_cursor because int2str adds a null char at the end.
find_null:
		PUSH {lr}

find_null_loop:
		ldrb r1, [r0], #1		; Load character and increment r0
		cmp r1, #0				; If character != 0, keep looping
		bne find_null_loop
		sub r0, #1				; Decrement to counteract post-indexing

		POP {lr}
		MOV pc, lr

check_wall:
		PUSH {r4-r12, lr}



		POP {r4-r12, lr}
		MOV pc, lr

	.end
