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
ansi_yellow:	.string 0x1B, "[38;5;226m", 0
ansi_red:		.string 0x1B, "[38;5;196m", 0
ansi_orange:	.string 0x1B, "[38;5;202m", 0
ansi_cyan:		.string 0x1B, "[38;5;25m", 0
ansi_pink:		.string 0x1B, "[38;5;207m", 0
ansi_blue:		.string 0x1B, "[38;5;26m", 0
ansi_path:		.string 0x1B, "[48;5;110m", 0
ansi_gate:		.string 0x1B, "[48;5;51m", 0
ansi_wall:		.string 0x1B, "[48;5;16m", 0
ansi_white:		.string 0x1B, "[38;5;231m", 0

; ANSI escape sequence for cursor position
cursor_pos:		.string 0x1B, "[123;456H", 0


pacman_string:	.string 0x10, 0x11, '<', 0
blinky_string:	.string 0x10, 0x12, 'A', 0	; red ghost
clyde_string:	.string 0x10, 0x13, 'A', 0	; orange ghost
inky_string:	.string 0x10, 0x14, 'A', 0	; cyan ghost
pinky_string:	.string 0x10, 0x15, 'A', 0	; pink ghost
scared_string:	.string 0x10, 0x16, 'W', 0	; scared ghosts
path_string:	.string 0x10, 0x17, 0		; path
gate_string:	.string 0x10, 0x18, ' ', 0	; ghost spawn gate
wall_string:	.string 0x10, 0x19, ' ', 0	; wall(black background)
white_string:	.string 0x10, 0x1A, 0		; white foreground
black_bg:		.string 0x10, 0x19, 0		; black background


; Lookup table that references ANSI escape sequences
lookup_table:
		.word ansi_bold
		.word ansi_yellow
		.word ansi_red
		.word ansi_orange
		.word ansi_cyan
		.word ansi_pink
		.word ansi_blue
		.word ansi_path
		.word ansi_gate
		.word ansi_wall
		.word ansi_white


pacman_pos:		.byte 26, 15	; Pacman position in line, column format
pacman_dir:		.byte 0, 1		; Direction for pacman movement in line, column format to make cursor movement logic cleaner.

; Positions and directions for ghosts
blinky_pos:			.byte 15, 12
blinky_dir:			.byte 0, 1

clyde_pos:			.byte 15, 13
clyde_dir:			.byte 0, 1

inky_pos:			.byte 15, 16
inky_dir:			.byte 0, 1

pinky_pos:			.byte 15, 17
pinky_dir:			.byte 0, 1

; Coordinates for where each ghost will go when eaten by pacman
blinky_spawn:		.byte 15, 12
clyde_spawn:		.byte 15, 13
inky_spawn:			.byte 15, 16
pinky_spawn:		.byte 15, 17


lives:				.byte 4
is_game_over:		.byte 0
game_paused:		.byte 1

score:				.word 0
score_string:		.string "000000", 0
score_buffer:		.string "000000", 0

timer_interval:		.word 0x003D0900	; Interval between ticks
power_pellet_time:	.byte 0				; Time left until power pellet wears off in seconds
tick_count:			.byte 0				; How many ticks passed in current second
ghosts_eaten:		.byte 0


; Initial board setup
board_initial:
	.string "############################"
	.string "############################"
	.string "############################"
	.string "#............##............#"
	.string "#.####.#####.##.#####.####.#"
	.string "#O####.#####.##.#####.####O#"
	.string "#.####.#####.##.#####.####.#"
	.string "#..........................#"
	.string "#.####.##.########.##.####.#"
	.string "#.####.##.########.##.####.#"
	.string "#......##....##....##......#"
	.string "######.##### ## #####.######"
	.string "######.##          ##.######"
	.string "######.## ###--### ##.######"
	.string "######.## #      # ##.######"
	.string "######.## #      # ##.######"
	.string "      .   #      #   .      "
	.string "######.## #      # ##.######"
	.string "######.## #      # ##.######"
	.string "######.## ######## ##.######"
	.string "######.##          ##.######"
	.string "######.## ######## ##.######"
	.string "#............##............#"
	.string "#.####.#####.##.#####.####.#"
	.string "#.####.#####.##.#####.####.#"
	.string "#O..##................##..O#"
	.string "###.##.##.########.##.##.###"
	.string "###.##.##.########.##.##.###"
	.string "#......##....##....##......#"
	.string "#.##########.##.##########.#"
	.string "#.##########.##.##########.#"
	.string "#..........................#"
	.string "############################", 0

; Real-time board state
board_current:
	.string "############################"
	.string "############################"
	.string "############################"
	.string "#............##............#"
	.string "#.####.#####.##.#####.####.#"
	.string "#O####.#####.##.#####.####O#"
	.string "#.####.#####.##.#####.####.#"
	.string "#..........................#"
	.string "#.####.##.########.##.####.#"
	.string "#.####.##.########.##.####.#"
	.string "#......##....##....##......#"
	.string "######.##### ## #####.######"
	.string "######.##          ##.######"
	.string "######.## ###--### ##.######"
	.string "######.## #      # ##.######"
	.string "######.## #      # ##.######"
	.string "      .   #      #   .      "
	.string "######.## #      # ##.######"
	.string "######.## #      # ##.######"
	.string "######.## ######## ##.######"
	.string "######.##          ##.######"
	.string "######.## ######## ##.######"
	.string "#............##............#"
	.string "#.####.#####.##.#####.####.#"
	.string "#.####.#####.##.#####.####.#"
	.string "#O..##................##..O#"
	.string "###.##.##.########.##.##.###"
	.string "###.##.##.########.##.##.###"
	.string "#......##....##....##......#"
	.string "#.##########.##.##########.#"
	.string "#.##########.##.##########.#"
	.string "#..........................#"
	.string "############################", 0

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
	.global illuminate_RGB_LED

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
ptr_to_game_paused:			.word game_paused

ptr_to_score:				.word score
ptr_to_score_string:		.word score_string
ptr_to_score_buffer:		.word score_buffer

ptr_to_board_initial:		.word board_initial
ptr_to_board_current:		.word board_current

ptr_to_path_string:			.word path_string
ptr_to_wall_string:			.word wall_string
ptr_to_gate_string:			.word gate_string
ptr_to_white_string:		.word white_string
ptr_to_black_bg:			.word black_bg

ptr_to_timer_interval:		.word timer_interval
ptr_to_power_pellet_time:	.word power_pellet_time
ptr_to_tick_count:			.word tick_count
ptr_to_ghosts_eaten:		.word ghosts_eaten


; Offset used for indexing in lookup table
BOLD:		.equ 0x10
YELLOW:		.equ 0x11
RED:		.equ 0x12
ORANGE:		.equ 0x13
CYAN:		.equ 0x14
PINK:		.equ 0x15
PATH:		.equ 0x17
GATE:		.equ 0x18
WALL:		.equ 0x19

BOARD_HEIGHT:	.equ 33
BOARD_WIDTH:	.equ 28


lab7:
		PUSH {r4-r12, lr}

		; Initialization
		bl uart_init
		bl gpio_btn_and_LED_init
		bl gpio_interrupt_init
		bl uart_interrupt_init
		bl timer_interrupt_init

		; Initialize and draw board
		bl init_board
		bl draw_board

		bl resume_game		; Game needs to be paused when drawing board, so resume after drawing

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


; Initializes real time board with board_init data
init_board:
		PUSH {r4-r12, lr}

		ldr r0, ptr_to_board_initial	; Initialize pointers
		ldr r1, ptr_to_board_current
init_board_loop:
		ldrb r2, [r0], #1		; Load a char and increment pointer
		cmp r2, #0				; If null char, exit subroutine
		beq init_board_exit
		strb r2, [r1], #1		; Store to real time board
		b init_board_loop
init_board_exit:

		POP {r4-r12, lr}
		MOV pc, lr


; Draw entire board
draw_board:
		PUSH {r4-r12, lr}

		ldr r4, ptr_to_board_current
		mov r5, #1		; line pos
		mov r6, #1		; column pos
draw_board_line_loop:
		mov r0, r5		; Move cursor
		mov r1, #1
		bl move_cursor
		mov r6, #1
draw_board_col_loop:
		ldrb r7, [r4], #1
		cmp r7, #0			; if null char, exit
		beq draw_board_exit
		cmp r7, #0x23		; '#'
		beq draw_board_wall
		cmp r7, #0x2D		; '-'
		beq draw_board_gate
draw_board_path:			; color background and output char
		ldr r0, ptr_to_path_string
		bl output_string
		ldr r0, ptr_to_white_string
		bl output_string
		mov r0, r7
		bl output_character
		b draw_board_cursor_update
draw_board_wall:			; output wall
		ldr r0, ptr_to_wall_string
		bl output_string
		b draw_board_cursor_update
draw_board_gate:			; output ghost spawn gate
		ldr r0, ptr_to_gate_string
		bl output_string
draw_board_cursor_update:	; Increment col, line counter
		add r6, r6, #1
		cmp r6, #29
		blt draw_board_col_loop
		add r5, r5, #1		; If col over bound, increment line
		cmp r5, #34			; Make sure everything within bound
		bge draw_board_exit
		b draw_board_line_loop
draw_board_exit:
		mov r0, #2			; Pos for score on board
		mov r1, #12
		bl move_cursor
		ldr r0, ptr_to_black_bg
		bl output_string
		ldr r0, ptr_to_score_string
		bl output_string

		POP {r4-r12, lr}
		MOV pc, lr


; Draw tile at position with current board data
; r0 = line pos
; r1 = column pos
draw_tile:
		PUSH {r4-r12, lr}

		mov r5, r0			; preserve pos to use for move_cursor
		mov r6, r1

		sub r0, r0, #1		; Subtract 1 because ansi coords start at 1
		sub r1, r1, #1
		mov r2, #BOARD_WIDTH
		mul r4, r0, r2		; Calculate position in board_current
		add r4, r4, r1

		ldr r0, ptr_to_board_current
		ldrb r4, [r0, r4]	; r4 = board_current tile char

		cmp r4, #0			; if null char, exit
		beq draw_tile_exit
		cmp r4, #0x23		; if '#', output wall
		beq draw_tile_wall
		cmp r4, #0x2D		; if '-', output gate
		beq draw_tile_gate
draw_tile_path:				; else, draw path
		mov r0, r5					; move cursor to pos
		mov r1, r6
		bl move_cursor
		ldr r0, ptr_to_path_string	; output blue background
		bl output_string
		ldr r0, ptr_to_white_string	; prepare pellet output
		bl output_string
		mov r0, r4
		bl output_character	; output pellet
		b draw_tile_exit
draw_tile_wall:
		mov r0, r5					; move cursor to pos
		mov r1, r6
		bl move_cursor
		ldr r0, ptr_to_wall_string	; output black background
		bl output_string
		b draw_tile_exit
draw_tile_gate:
		mov r0, r5					; move cursor to pos
		mov r1, r6
		bl move_cursor
		ldr r0, ptr_to_gate_string	; output cyan background
		bl output_string
draw_tile_exit:

		POP {r4-r12, lr}
		MOV pc, lr


pause_game:
		PUSH {r4-r12, lr}

		ldr r0, ptr_to_game_paused
		mov r1, #1
		strb r1, [r0]

		POP {r4-r12, lr}
		MOV pc, lr


resume_game:
		PUSH {r4-r12, lr}

		ldr r0, ptr_to_game_paused
		mov r1, #0
		strb r1, [r0]

		POP {r4-r12, lr}
		MOV pc, lr


Timer_Handler:
		PUSH {r4-r12, lr}

		mov  r0, #0x0024		; Clear the interrupt pin
		movt r0, #0x4003
		ldr r1, [r0]
		orr r1, r1, #1
		str r1, [r0]

		ldr r0, ptr_to_game_paused		; If paused, skip tick
		ldrb r0, [r0]
		cmp r0, #1
		beq timer_handler_exit

		bl update_power_pellet

		bl erase_entities	; Erase everyone first to prevent graphical error

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

timer_handler_exit:

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

		; Load pacman direction
		ldr r3, ptr_to_pacman_dir
		ldrsb r4, [r3]			; r4 = line dir
		ldrsb r5, [r3, #1]		; r5 = column dir

		; Update pacman position based on direction
		add r0, r6, r4
		add r1, r7, r5

		bl check_pacman_wrap	; Applies wrap and returns pos to r0, r1

		; Store final pacman position
		ldr r2, ptr_to_pacman_pos
		strb r0, [r2]
		strb r1, [r2, #1]

		; Print pacman
		bl move_cursor
		ldr r0, ptr_to_path_string		; output path background because pacman will always be on path
		bl output_string
		ldr r0, ptr_to_pacman_string
		bl output_string

		bl check_pellet

		POP {r4-r12, lr}
		MOV pc, lr


; Checks if pacman's position is on a pellet then updates game state
check_pellet:
		PUSH {r4-r12, lr}

		ldr r0, ptr_to_pacman_pos	; Load pacman position
		ldrb r1, [r0]				; r5 = line
		ldrb r2, [r0, #1]			; r6 = column

		; Find corresponding location in board_current
		sub r1, r1, #1		; Subtract 1 becuase putty position starts with 1
		sub r2, r2, #1
		mov r0, #BOARD_WIDTH
		mul r1, r1, r0		; Calculate pacman position within board_current
		add r1, r1, r2		; r1 = offset from board_current pointer

		ldr r0, ptr_to_board_current
		ldrb r2, [r0, r1]	; Load board char at pacman pos
		cmp r2, #0x2E		; is char = '.'?
		beq eat_normal_pellet
		cmp r2, #0x4F		; is char = 'O'?
		beq eat_power_pellet
		b check_pellet_exit	; if neither, exit

eat_normal_pellet:
		mov r2, #0x20				; 0x20 = ' '
		strb r2, [r0, r1]			; Store space to pellet pos
		ldr r0, ptr_to_score		; Load score
		ldr r1, [r0]
		add r0, r1, #10				; Update score
		bl update_score
		b check_pellet_exit
eat_power_pellet:
		mov r2, #0x20				; 0x20 = ' '
		strb r2, [r0, r1]			; Store space to pellet pos
		ldr r0, ptr_to_score		; Load score
		ldr r1, [r0]
		add r0, r1, #50				; Update score
		bl update_score

		ldr r0, ptr_to_power_pellet_time	; Set remaining power pellet time to 15
		mov r1, #15
		strb r1, [r0]

		ldr r0, ptr_to_tick_count			; Initialize tick counter to 0
		mov r1, #0
		strb r1, [r0]

		ldr r0, ptr_to_ghosts_eaten			; Initialize ghosts eaten count to 0
		strb r1, [r0]
check_pellet_exit:

		POP {r4-r12, lr}
		MOV pc, lr


; Updates score string in memory to given score
; r0 = new score
update_score:
		PUSH {r4-r12, lr}
		mov  r1, #0x423F			; 0xF423F = 999999
		movt r1, #0x000F
		cmp r0, r1					; If score greater than 999999, set score to 999999(max score)
		it ge
		movge r0, r1

		ldr r1, ptr_to_score		; Update int score first
		str r0, [r1]

		mov r1, r0					; move to r1 for int2str
		ldr r0, ptr_to_score_buffer	; Score buffer pointer
		bl int2str					; Store score in buffer as string

		ldr r0, ptr_to_score_buffer
		bl find_null				; Find end address of buffer
		ldr r1, ptr_to_score_buffer
		sub r2, r0, r1				; Calculate number of digits

		ldr r0, ptr_to_score_string
		mov r1, #0x30				; 0x30 = '0'
		strb r1, [r0]				; Fill score_string with '0's
		strb r1, [r0, #1]
		strb r1, [r0, #2]
		strb r1, [r0, #3]
		strb r1, [r0, #4]
		strb r1, [r0, #5]

		mov r1, #6					; Score string length is 6
		sub r1, r1, r2				; Calculate starting pos
		add r0, r0, r1				; Move pointer to starting pos

		ldr r1, ptr_to_score_buffer
update_score_loop:			; Copy buffer to score_string
		ldrb r2, [r1], #1
		cmp r2, #0					; If null char, exit loop
		beq update_score_done
		strb r2, [r0], #1
		b update_score_loop
update_score_done:
		mov r0, #2					; pos for score on board
		mov r1, #12
		bl move_cursor
		ldr r0, ptr_to_black_bg		; make background black
		bl output_string
		ldr r0, ptr_to_white_string	; make foreground white
		bl output_string
		ldr r0, ptr_to_score_string	; print score
		bl output_string

		POP {r4-r12, lr}
		MOV pc, lr


update_power_pellet:
		PUSH {r4-r12, lr}

		; Power pellet time update
		ldr r0, ptr_to_power_pellet_time	; Load remaining power pellet time
		ldrb r1, [r0]
		cmp r1, #0							; If time=0, skip power pellet calculation
		beq update_power_pellet_exit

		ldr r2, ptr_to_tick_count		; Load tick count
		ldrb r3, [r2]
		add r3, r3, #1					; Increment tick count
		strb r3, [r2]

		; RGB LED logic
		cmp r1, #5			; If above 5 seconds left, illuminate blue
		ble power_pellet_blink
		mov r0, #2			; 2 = blue
		bl illuminate_RGB_LED
		b skip_blink

power_pellet_blink:
		mov r0, #1			; 1 = red
		lsl r4, r3, #1		; Divide tick count by 2
		cmp r4, #2			; If above 2, illuminate red. Otherwise blue
		it le
		movle r0, #0
		bl illuminate_RGB_LED

skip_blink:
		cmp r3, #4			; If not at 4 ticks yet, exit
		blt update_power_pellet_exit

		mov r3, #0			; Reset tick count to 0
		strb r3, [r2]
		sub r1, r1, #1		; Decrement remaining time
		ldr r0, ptr_to_power_pellet_time
		strb r1, [r0]

		cmp r1, #0			; If time at 0, turn off LED. Otherwise exit
		bne update_power_pellet_exit
		mov r0, #0
		bl illuminate_RGB_LED

update_power_pellet_exit:
		POP {r4-r12, lr}
		MOV pc, lr


; Need to erase pacman and ghosts before moving to prevent overwriting ghost or pacman
erase_entities:
		PUSH {r4-r12, lr}

		ldr r2, ptr_to_pacman_pos	; Erase pacman
		ldrb r0, [r2]
		ldrb r1, [r2, #1]
		bl draw_tile

		; Erase ghosts
		ldr r2, ptr_to_blinky_pos
		ldrb r0, [r2]			; r0 = line pos
		ldrb r1, [r2, #1]		; r1 = col pos
		bl draw_tile			; erase ghost at pos

		ldr r2, ptr_to_clyde_pos
		ldrb r0, [r2]			; r0 = line pos
		ldrb r1, [r2, #1]		; r1 = col pos
		bl draw_tile			; erase ghost at pos

		ldr r2, ptr_to_inky_pos
		ldrb r0, [r2]			; r0 = line pos
		ldrb r1, [r2, #1]		; r1 = col pos
		bl draw_tile			; erase ghost at pos

		ldr r2, ptr_to_pinky_pos
		ldrb r0, [r2]			; r0 = line pos
		ldrb r1, [r2, #1]		; r1 = col pos
		bl draw_tile			; erase ghost at pos

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
		ldr r0, ptr_to_blinky_pos		; Pass pos, spawn, dir to eat_ghost
		ldr r1, ptr_to_blinky_spawn
		ldr r2, ptr_to_blinky_dir
		bl eat_ghost
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
		ldr r0, ptr_to_clyde_pos		; Pass pos, spawn, dir to eat_ghost
		ldr r1, ptr_to_clyde_spawn
		ldr r2, ptr_to_clyde_dir
		bl eat_ghost
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
		ldr r0, ptr_to_inky_pos		; Pass pos, spawn, dir to eat_ghost
		ldr r1, ptr_to_inky_spawn
		ldr r2, ptr_to_inky_dir
		bl eat_ghost
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
		ldr r0, ptr_to_pinky_pos		; Pass pos, spawn, dir to eat_ghost
		ldr r1, ptr_to_pinky_spawn
		ldr r2, ptr_to_pinky_dir
		bl eat_ghost
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
eat_ghost:
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

		; Update score
		ldr r0, ptr_to_ghosts_eaten
		ldrb r1, [r0]		; r1 = number of ghosts eaten

		mov r2, #100		; Calculate ghost point
		lsl r2, r2, r1
		add r1, r1, #1		; Increment ghost eaten count
		strb r1, [r0]

		ldr r1, ptr_to_score	; Load score
		ldr r0, [r1]
		add r0, r0, r2			; Update and store new score
		bl update_score

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
		;bl move_cursor
		;;;;;;;;;;;;;;;;; NEED TO CHANGE THIS LINE TO RESTORE PELLETS
		;mov r0, #0x20
		;;;;;;;;;;;;;;;;;
		;bl output_character

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
		ldr r0, ptr_to_path_string			; Output path background because ghosts will be on path
		bl output_string
		ldr r4, ptr_to_power_pellet_time	; Load and check if power pellet is active
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
