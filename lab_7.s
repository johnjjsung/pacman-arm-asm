	.data

	.global ansi_bold
	.global ansi_yellow
	.global ansi_red
	.global ansi_orange
	.global ansi_cyan
	.global ansi_pink
	.global cursor_pos
	.global pacman_string
	.global lookup_table
	.global pacman_pos
	.global pacman_dir
	.global blinky_string
	.global clyde_string
	.global inky_string
	.global pinky_string



; ANSI escape sequences for bold and colors
ansi_bold:		.string 0x1B, "[1m", 0
ansi_yellow:	.string 0x1B, "[38;5;11m", 0
ansi_red:		.string 0x1B, "[38;5;9m", 0
ansi_orange:	.string 0x1B, "[38;5;202m", 0
ansi_cyan:		.string 0x1B, "[38;5;25m", 0
ansi_pink:		.string 0x1B, "[38;5;207m", 0
ansi_blue:		.string 0x1B, "[38;5;12m", 0

; ANSI escape sequence for cursor position
cursor_pos:		.string 0x1B, "[123;456H", 0


pacman_string:	.string 0x10, 0x11, '<', 0
blinky_string:	.string 0x10, 0x12, 'A', 0	; red ghost
clyde_string:	.string 0x10, 0x13, 'A', 0	; orange ghost
inky_string:	.string 0x10, 0x14, 'A', 0	; cyan ghost
pinky_string:	.string 0x10, 0x15, 'A', 0	; pink ghost
scared_string:	.string 0x10, 0x16, 'W', 0	; scared ghosts


; Lookup table that references ANSI escape sequences
lookup_table:
		.word ansi_bold
		.word ansi_yellow
		.word ansi_red
		.word ansi_orange
		.word ansi_cyan
		.word ansi_pink
		.word ansi_blue


pacman_pos:		.byte 10, 4		; Pacman position in line, column format
pacman_dir:		.byte 0, 1		; Direction for pacman movement in line, column format to make cursor movement logic cleaner.

; Positions and directions for ghosts
blinky_pos:			.byte 11, 4
blinky_dir:			.byte 0, 1

clyde_pos:			.byte 12, 4
clyde_dir:			.byte 0, 1

inky_pos:			.byte 13, 4
inky_dir:			.byte 0, 1

pinky_pos:			.byte 14, 4
pinky_dir:			.byte 0, 1

; Coordinates for where each ghost will go when eaten by pacman
blinky_spawn:		.byte 15, 12
clyde_spawn:		.byte 15, 13
inky_spawn:			.byte 15, 16
pinky_spawn:		.byte 15, 17


lives:				.byte 4
is_game_over:		.byte 0
power_pellet_time:	.byte 0		; Time left until power pellet wears off in number of game ticks(not seconds)


	.text
	.global lab7
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_string
	.global gpio_interrupt_init
	.global uart_interrupt_init
	.global timer_interrupt_init
	.global int2str
	.global output_character
	.global simple_read_character

	.global Timer_Handler
	.global UART0_Handler
	.global Switch_Handler

	.global lookup_table
	.global ptr_to_pacman_string


ptr_to_cursor_pos:			.word cursor_pos
ptr_to_pacman_string:		.word pacman_string
ptr_to_pacman_pos:			.word pacman_pos
ptr_to_pacman_dir:			.word pacman_dir

ptr_to_blinky_string:		.word blinky_string
ptr_to_blinky_pos:			.word blinky_pos
ptr_to_blinky_dir:			.word blinky_dir
ptr_to_clyde_string:		.word clyde_string
ptr_to_clyde_pos:			.word clyde_pos
ptr_to_clyde_dir:			.word clyde_dir
ptr_to_inky_string:			.word inky_string
ptr_to_inky_pos:			.word inky_pos
ptr_to_inky_dir:			.word inky_dir
ptr_to_pinky_string:		.word pinky_string
ptr_to_pinky_pos:			.word pinky_pos
ptr_to_pinky_dir:			.word pinky_dir
ptr_to_scared_string:		.word scared_string

ptr_to_blinky_spawn:		.word blinky_spawn
ptr_to_clyde_spawn:			.word clyde_spawn
ptr_to_inky_spawn:			.word inky_spawn
ptr_to_pinky_spawn:			.word pinky_spawn

ptr_to_lives:				.word lives
ptr_to_is_game_over:		.word is_game_over
ptr_to_power_pellet_time:	.word power_pellet_time


; Offset used for indexing in lookup table
BOLD:		.equ 0x10
YELLOW:		.equ 0x11
RED:		.equ 0x12
ORANGE:		.equ 0x13
cyan:		.equ 0x14
PINK:		.equ 0x15


lab7:
		PUSH {r4-r12, lr}

		; Initialization
		bl uart_init
		bl gpio_btn_and_LED_init
		bl gpio_interrupt_init
		bl uart_interrupt_init
		bl timer_interrupt_init

		; Load pacman position
		ldr r2, ptr_to_pacman_pos	; Initialize pointer to pacman opsition
		ldrb r0, [r2], #1			; r0 = pacman line
		ldrb r1, [r2]				; r1 = pacman column

		bl move_cursor

		; Print pacman
		ldr r0, ptr_to_pacman_string
		bl output_string

lab7_main_loop:

		b lab7_main_loop


		POP {r4-r12, lr}
		MOV pc, lr


Timer_Handler:
		PUSH {r4-r12, lr}

		mov  r0, #0x0024		; Clear the interrupt pin
		movt r0, #0x4003
		ldr r1, [r0]
		orr r1, r1, #1
		str r1, [r0]

		bl move_ghosts		; Update ghosts' position and redraw
		bl check_ghost_coll
		bl move_pacman		; Update pacman position and redraw
		bl check_ghost_coll	; Checking twice to prevent jumping over


		;;;;;;;;;; Output lives count. For debugging
		mov r0, #35
		mov r1, #1
		bl move_cursor
		ldr r0, ptr_to_lives
		ldrb r1, [r0]
		add r0, r1, #48
		bl output_character
		;;;;;;;;;;

		POP {r4-r12, lr}
		BX lr


UART0_Handler:
        PUSH    {r4-r12, lr}

        ; clear UART receive interrupt by writing bit 4 to UARTICR
        MOV     r0, #0xC044                          ; UARTICR address
        MOVT    r0, #0x4000
        MOV     r1, #1                               ; start with 1
        LSL     r1, r1, #4                           ; shift to bit 4 => interrupt clear bit
        STR     r1, [r0]

		bl simple_read_character	; Stores pressed char in r0
		cmp r0, #0x77		; 'w'
		beq update_dir_up
		cmp r0, #0x61		; 'a'
		beq update_dir_left
		cmp r0, #0x73		; 's'
		beq update_dir_down
		cmp r0, #0x64		; 'd'
		beq update_dir_right
		b not_wasd

update_dir_up:
		ldr r0, ptr_to_pacman_dir
		mov r1, #-1
		mov r2, #0
		b store_new_dir
update_dir_left:
		ldr r0, ptr_to_pacman_dir
		mov r1, #0
		mov r2, #-1
		b store_new_dir
update_dir_down:
		ldr r0, ptr_to_pacman_dir
		mov r1, #1
		mov r2, #0
		b store_new_dir
update_dir_right:
		ldr r0, ptr_to_pacman_dir
		mov r1, #0
		mov r2, #1
		b store_new_dir
store_new_dir:
		strb r1, [r0]
		strb r2, [r0, #1]

not_wasd:

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


move_pacman:
		PUSH {r4-r12, lr}

		; Load pacman position
		ldr r2, ptr_to_pacman_pos
		ldrb r0, [r2]			; r0 = line pos
		ldrb r1, [r2, #1]		; r1 = column pos

		mov r6, r0		; Preserve r0, r1 before move_cursor
		mov r7, r1

		; Erase current pacman
		bl move_cursor
		mov r0, #0x20
		bl output_character

		; Load pacman direction
		ldr r3, ptr_to_pacman_dir
		ldrsb r4, [r3]			; r4 = line dir
		ldrsb r5, [r3, #1]		; r5 = column dir

		; Update pacman position based on direction
		add r0, r6, r4
		add r1, r7, r5

		bl check_pacman_wrap

		; Store final pacman position
		ldr r2, ptr_to_pacman_pos
		strb r0, [r2]
		strb r1, [r2, #1]

		; Print pacman
		bl move_cursor
		ldr r0, ptr_to_pacman_string
		bl output_string

		POP {r4-r12, lr}
		MOV pc, lr


; Checks if pacman collided with a ghost.
; r0 = pacman line pos, r1 = pacman column pos
check_ghost_coll:
		PUSH {r4-r12, lr}

		ldr r6, ptr_to_pacman_pos
		ldrb r4, [r6]		; r4 = pacman line pos
		ldrb r5, [r6, #1]	; r5 = pacman column pos

		ldr r0, ptr_to_blinky_pos
		ldrb r1, [r0]		; r1 = blinky line pos
		ldrb r2, [r0, #1]	; r2 = blinky col pos
		cmp r4, r1			; Check if positions match
		bne blinky_nocoll
		cmp r5, r2
		bne blinky_nocoll
		ldr r6, ptr_to_power_pellet_time	; Check if power pellet is active
		ldrb r6, [r6]
		cmp r6, #0			; If power pellet is not active, pacman dead. Otherwise ghost eaten
		beq normal_ghost_coll	; Pacman position = blinky position
		ldr r0, ptr_to_blinky_pos		; Pass pos, spawn, dir to ghost_eaten
		ldr r1, ptr_to_blinky_spawn
		ldr r2, ptr_to_blinky_dir
		bl ghost_eaten
		b exit_check_ghost_coll
blinky_nocoll:				; No collision with blinky
		ldr r0, ptr_to_clyde_pos
		ldrb r1, [r0]		; r1 = clyde line pos
		ldrb r2, [r0, #1]	; r2 = clyde col pos
		cmp r4, r1			; Check if positions match
		bne clyde_nocoll
		cmp r5, r2
		bne clyde_nocoll
		ldr r6, ptr_to_power_pellet_time	; Check if power pellet is active
		ldrb r6, [r6]
		cmp r6, #0			; If power pellet is not active, pacman dead. Otherwise ghost eaten
		beq normal_ghost_coll	; Pacman position = clyde position
		ldr r0, ptr_to_clyde_pos		; Pass pos, spawn, dir to ghost_eaten
		ldr r1, ptr_to_clyde_spawn
		ldr r2, ptr_to_clyde_dir
		bl ghost_eaten
		b exit_check_ghost_coll
clyde_nocoll:				; No collision with clyde
		ldr r0, ptr_to_inky_pos
		ldrb r1, [r0]		; r1 = inky line pos
		ldrb r2, [r0, #1]	; r2 = inky col pos
		cmp r4, r1			; Check if positions match
		bne inky_nocoll
		cmp r5, r2
		bne inky_nocoll
		ldr r6, ptr_to_power_pellet_time	; Check if power pellet is active
		ldrb r6, [r6]
		cmp r6, #0			; If power pellet is not active, pacman dead. Otherwise ghost eaten
		beq normal_ghost_coll	; Pacman position = inky position
		ldr r0, ptr_to_inky_pos		; Pass pos, spawn, dir to ghost_eaten
		ldr r1, ptr_to_inky_spawn
		ldr r2, ptr_to_inky_dir
		bl ghost_eaten
		b exit_check_ghost_coll
inky_nocoll:				; No collision with inky
		ldr r0, ptr_to_pinky_pos
		ldrb r1, [r0]		; r1 = pinky line pos
		ldrb r2, [r0, #1]	; r2 = pinky col pos
		cmp r4, r1			; Check if positions match
		bne pinky_nocoll
		cmp r5, r2
		bne pinky_nocoll
		ldr r6, ptr_to_power_pellet_time	; Check if power pellet is active
		ldrb r6, [r6]
		cmp r6, #0			; If power pellet is not active, pacman dead. Otherwise ghost eaten
		beq normal_ghost_coll	; Pacman position = pinky position
		ldr r0, ptr_to_pinky_pos		; Pass pos, spawn, dir to ghost_eaten
		ldr r1, ptr_to_pinky_spawn
		ldr r2, ptr_to_pinky_dir
		bl ghost_eaten
		b exit_check_ghost_coll
pinky_nocoll:				; No collision with pinky
		b exit_check_ghost_coll

normal_ghost_coll:			; Power pellet isn't active
		bl pacman_dead
exit_check_ghost_coll:

		POP {r4-r12, lr}
		MOV pc, lr


; Called when scared ghost collides with pacman
; r0 = ptr to ghost pos
; r1 = ptr to ghost spawn
; r2 = ptr to ghost dir
ghost_eaten:
		PUSH {r4-r12, lr}

		; Teleport ghost to its spawn
		ldrb r4, [r1]		; r4 = spawn line
		ldrb r5, [r1, #1]	; r5 = spawn column
		strb r4, [r0]
		strb r5, [r0, #1]

		; Make ghost move up (needs to move up and down within box)
		mov r4, #1
		mov r5, #0
		strb r4, [r2]
		strb r5, [r2, #1]

		POP {r4-r12, lr}
		MOV pc, lr


pacman_dead:
		PUSH {r4-r12, lr}

		; Decrement lives
		ldr r4, ptr_to_lives
		ldrb r5, [r4]
		sub r5, r5, #1
		strb r5, [r4]

		; If lives = 0, set game over flag. Otherwise reset board
		cmp r5, #0
		bne not_game_over
		mov r6, #1
		ldr r4, ptr_to_is_game_over
		strb r6, [r4]
		b exit_pacman_dead

not_game_over:
		bl reset_board
exit_pacman_dead:

		POP {r4-r12, lr}
		MOV pc, lr


reset_board:
		PUSH {r4-r12, lr}



		POP {r4-r12, lr}
		MOV pc, lr


; Checks if pacman needs to wrap-around map
; r0 = pacman line pos, r1 = pacman column pos
check_pacman_wrap:
		PUSH {lr}

		; If beyond right boundary, set column to 1
		cmp r1, #28
		ble pacman_no_rightwrap
		mov r1, #1
		b exit_pacman_wrap
		; If not beyond right boundary, check left boundary
pacman_no_rightwrap:
		cmp r1, #1
		bge exit_pacman_wrap
		mov r1, #28
		b exit_pacman_wrap
exit_pacman_wrap:

		POP {lr}
		MOV pc, lr


move_ghosts:
		PUSH {r4-r12, lr}

		ldr r0, ptr_to_blinky_pos
		ldr r1, ptr_to_blinky_dir
		ldr r2, ptr_to_blinky_string
		bl move_oneghost

		ldr r0, ptr_to_clyde_pos
		ldr r1, ptr_to_clyde_dir
		ldr r2, ptr_to_clyde_string
		bl move_oneghost

		ldr r0, ptr_to_inky_pos
		ldr r1, ptr_to_inky_dir
		ldr r2, ptr_to_inky_string
		bl move_oneghost

		ldr r0, ptr_to_pinky_pos
		ldr r1, ptr_to_pinky_dir
		ldr r2, ptr_to_pinky_string
		bl move_oneghost

		POP {r4-r12, lr}
		MOV pc, lr


; r0 = ghost pos address
; r1 = ghost dir address
; r2 = ghost string address
move_oneghost:
		PUSH {r4-r12, lr}

		mov r4, r0		; r4 = ghost pos address
		mov r9, r1		; r6 = ghost dir address

		ldrb r0, [r4]		; r0 = line pos
		ldrb r1, [r4, #1]	; r1 = column pos

		mov r5, r0		; Preserve r0, r1 before move_cursor
		mov r6, r1

		; Erase current ghost
		bl move_cursor
		;;;;;;;;;;;;;;;;; NEED TO CHANGE THIS LINE TO RESTORE PELLETS
		mov r0, #0x20
		;;;;;;;;;;;;;;;;;
		bl output_character

		; Load ghost direction
		ldrsb r7, [r9]		; r7 = line dir
		ldrsb r8, [r9, #1]	; r8 = column dir

		; Update ghost position based on direction
		add r0, r5, r7
		add r1, r6, r8

		; Wrap-around logic
		; If beyond right boundary, set column to 1
		cmp r1, #28
		ble ghost_no_rightwrap
		mov r1, #1
		b exit_ghost_wrap
		; If not beyond right boundary, check left boundary
ghost_no_rightwrap:
		cmp r1, #1
		bge exit_ghost_wrap
		mov r1, #28
		b exit_ghost_wrap
exit_ghost_wrap:

		; Store final ghost position
		strb r0, [r4]
		strb r1, [r4, #1]

		; Print ghost
		bl move_cursor
		ldr r4, ptr_to_power_pellet_time		; Load and check if power pellet is active
		ldrb r4, [r4]
		cmp r4, #0
		beq print_normal_ghost
		ldr r2, ptr_to_scared_string		; If power pellet active, print scared ghost
print_normal_ghost:
		mov r0, r2
		bl output_string

		POP {r4-r12, lr}
		MOV pc, lr


check_wall:
		PUSH {r4-r12, lr}



		POP {r4-r12, lr}
		MOV pc, lr

	.end
