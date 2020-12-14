# FPGA Pong core
A simple Pong core for FPGA, featuring:
- Single 25 MHz clock.
- Digital (not analog) input for each player
- VGA output
- No sound :(
- Allows human vs humanm, human vs machine and machine vs machine
- Small in resources. Fits in a Basys FPGA trainer (683 LUTs, about 35% of available LUTs in a Spartan 3E-100 device)
- 100% Verilog

## How to play:
Choose desired play mode (for example, tying p1_auto or p2_auto signals to switches. All user interface input signals are active high. To start a game, press P1 UP and P2 DOWN at the same time. First player to get 9 points wins.
