# FPGA Pong core
A simple Pong core for FPGA, featuring:
- Single 25 MHz clock.
- Digital (not analog) input for each player.
- VGA output.
- No sound :(
- Allows human vs human, human vs machine and machine vs machine.
- Increasing speed as game progresses.
- Small in resources. Fits in a Basys FPGA trainer (683 LUTs, about 35% of available LUTs in a Spartan 3E-100 device).
- 100% Verilog.

## How to build
A FPGA board with at least a VGA output is needed. The core outputs 8 bits per primary colour, so if your board uses less than 8 bits, just use the most significant bits of each colour, according to your VGA interface capabilities (for example, Basys uses a RGB bit scheme of 3:3:2). Output timing is industry standard 640x480@60 Hz.

All user interface input signals are active high.

Create a TLD for your board and instantiate the **pong** module. Your TLD must supply a 25 MHz clock and route VGA output signals from the pong module to your VGA interface. Should your VGA output goes through a VGA DAC that needs a dot clock, the very same 25 MHz clock signal can be used for that. If the VGA DAC also needs a _video active_ signal, route the signal _active_area_ from **videosyncs module** all the way to the TLD and use it as such.

For zero/one/two player game, four buttons and two switches are needed. On the other hand, to build a demo system, in which the FPGA plays against itself (zero players), no buttons are needed, just the VGA output. In this case, to force a game start, tie buttons for P1 UP and P2 DOWN to logic one. Tie also P1_AUTO and P2_AUTO to logic one.

For one player game, against the computer, tie together signals for P1 UP and P2 UP to a button (UP), and P1 DOWN and P2 DOWN to another button (DOWN), so a game start can be initiated by pressing UP and DOWN. Tie P1_AUTO to zero, and P2_AUTO to one.

## How to play:
Choose desired play mode by putting signals _p1_auto_ and _p2_auto_ to appropiate levels. To start a game, press P1 UP and P2 DOWN at the same time. First player to get 9 points wins.
