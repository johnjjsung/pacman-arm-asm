# Pac-Man in ARM Assembly
A playable Pac-Man clone written in ARM assembly for the Cortex-M4 TM4C123GH6PM microcontroller. Board is fully colored using ANSI escape sequences, and Pac-Man is controlled by keyboard. Tested on TM4C123GH6PM using PuTTy terminal.

## Features
- Map rendered with colors using ANSI
- Pac-Man controlled by keyboard input via UART
- Four ghosts (Blinky, Clyde, Inky, Pinky) with pseudo-randomized movements and scared mode when power pellet is eaten
- Lives, scoring, and level progression
- Increasing difficulty (game speed increases by 0.1 seconds each level)

## Controls
W - Move up
A - Move left
S - Move down
D - Move right
