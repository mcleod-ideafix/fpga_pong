//////////////////////////////////////////////////////////////////////////////////
//    This file is macros
//    Creation date is 18:32:50 05/31/2014 by Miguel Angel Rodriguez Jodar
//    (c)2014 Miguel Angel Rodriguez Jodar. ZXProjects
//
//    This core is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This core is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this core.  If not, see <https://www.gnu.org/licenses/>.
//
//    All copies of this file must keep this notice intact.
//
//////////////////////////////////////////////////////////////////////////////////

// Colores de los distintos elementos
`define FONDO  24'h008000
`define BALL   24'hFFFF00
`define STICK1 24'h800000
`define STICK2 24'h0000FF
`define SCORE1 24'hFF8080
`define SCORE2 24'h8080FF
`define BORDE  24'hFFFFFF
`define NEGRO  24'h000000

// Tamaños de los sticks y la bola
`define BALLSIZE 4
`define STICKSIZE (`BALLSIZE*8)
`define STICKWIDTH (`BALLSIZE*2)

// Posicion X de los dos sticks
`define STICKP1X (`BALLSIZE*2)
`define STICKP2X (640-`BALLSIZE*2-`STICKWIDTH)

// Posición de cada segmento para formar marcador, relativo a la esquina sup. izq.
`define SEGW (`BALLSIZE)
`define SEGH (`SEGW*4)

// Digitos del marcador
/*
     A
   -----
F |     | B
  |  G  |
   -----
E |     | C
  |     |
   -----
     D
*/

// Segmento A
`define SEGA_X1 `SEGW
`define SEGA_Y1 0
`define SEGA_X2 (`SEGA_X1 + `SEGH)
`define SEGA_Y2 (`SEGA_Y1 + `SEGW)

// Segmento B
`define SEGB_X1 `SEGA_X2
`define SEGB_Y1 `SEGA_Y2
`define SEGB_X2 (`SEGB_X1 + `SEGW)
`define SEGB_Y2 (`SEGB_Y1 + `SEGH)

// Segmento C
`define SEGC_X1 `SEGB_X1
`define SEGC_Y1 (`SEGB_Y2 + `SEGW)
`define SEGC_X2 `SEGB_X2
`define SEGC_Y2 (`SEGC_Y1 + `SEGH)

// Segmento D
`define SEGD_X1 `SEGA_X1
`define SEGD_Y1 `SEGC_Y2
`define SEGD_X2 `SEGC_X1
`define SEGD_Y2 (`SEGC_Y2 + `SEGW)

// Segmento E
`define SEGE_X1 0
`define SEGE_Y1 `SEGC_Y1
`define SEGE_X2 `SEGA_X1
`define SEGE_Y2 `SEGC_Y2

// Segmento F
`define SEGF_X1 0
`define SEGF_Y1 `SEGB_Y1
`define SEGF_X2 `SEGE_X2
`define SEGF_Y2 `SEGB_Y2

// Segmento G
`define SEGG_X1 `SEGF_X2
`define SEGG_Y1 `SEGF_Y2
`define SEGG_X2 `SEGC_X1
`define SEGG_Y2 `SEGC_Y1

// Posición inicial marcador P1 y P2
`define SCOREP1X (320-10*`SEGW-`SEGH)
`define SCOREP1Y (`SEGW*2)
`define SCOREP2X (320+8*`SEGW)
`define SCOREP2Y (`SEGW*2)
