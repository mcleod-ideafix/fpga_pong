`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
//    This file is pong
//    Creation date is 16:20:06 05/30/2014 by Miguel Angel Rodriguez Jodar
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

`include "macros.vh"

module pong (
    input wire clk,         // 25MHz

    input wire p1_btup,     // boton UP P1
    input wire p1_btdown,   // boton DOWN P1
    input wire p2_btup,     // boton UP P2
    input wire p2_btdown,   // boton DOWN P2
    
    input wire p1_auto,     // modo automático P1
    input wire p2_auto,     // modo automático P2

    output wire [7:0] r,    //
    output wire [7:0] g,    // Salida VGA
    output wire [7:0] b,    // 640x480, 24 bits
    output wire hs,         //
    output wire vs          //
    );

    // Coordenada X(hc),Y(vc) actual del cañón de electrones
    wire [10:0] hc,vc;

    // Marcadores (0 a 9)
    reg [3:0] scorep1 = 4'hF;  // valor fuera de rango para no mostrar marcadores
    reg [3:0] scorep2 = 4'hF;  // al arrancar el juego

    // Posición vertical de los dos sticks
    reg [8:0] stickp1 = 8'd240;
    reg [8:0] stickp2 = 8'd240;
    
    // Posición de la bola
    reg [9:0] ballx = 10'd640;  // inicialmente fuera de la pantalla
    reg [8:0] bally = 9'd240;
    
    // Dirección de la bola
    reg signed [9:0] incx = 10'd1;
    reg signed [8:0] incy = 9'd1;
    
    // Nivel de dificultad
    reg [3:0] difflevel = 4'd1;
	 
    playfield campo (
    .clk(clk),
    .stickp1(stickp1),
    .stickp2(stickp2),
    .ballx(ballx),
    .bally(bally),
    .scorep1(scorep1),
    .scorep2(scorep2),

    .hc(hc),
    .vc(vc),
    .r(r),
    .g(g),
    .b(b),
    .hs(hs),
    .vs(vs)
    );

    // Jugador automático P1
    reg p1_up,p1_down;
    always @* begin
        if (p1_auto) begin  // si se activa el modo automático para P1...
            p1_up = 0;
            p1_down = 0;
            if (ballx<320) begin
                if (bally<(stickp1+`STICKSIZE/3))
                    p1_up = 1;
                else if (bally>=(stickp1+2*`STICKSIZE/3))
                    p1_down = 1;
            end
        end
        else begin
            p1_up = p1_btup;
            p1_down = p1_btdown;
        end
    end

    // Jugador automático P2
    reg p2_up,p2_down;
    always @* begin
        if (p2_auto) begin   // si se activa el modo automático para P2...
            p2_up = 0;
            p2_down = 0;
            if (ballx>=320) begin
                if (bally<(stickp2+`STICKSIZE/3))
                    p2_up = 1;
                else if (bally>=(stickp2+2*`STICKSIZE/3))
                    p2_down = 1;
            end
        end
        else begin
            p2_up = p2_btup;
            p2_down = p2_btdown;
        end
    end

    always @(posedge clk) begin
        if ((hc>=0 && hc<4) && vc==480) begin  // Actualizar 4 veces por frame la posición de los sticks en el campo
            if (p1_up && stickp1 != 0)
                stickp1 <= stickp1 - 1;
            else if (p1_down && stickp1 != (480-`STICKSIZE))
                stickp1 <= stickp1 + 1;
            if (p2_up && stickp2 != 0)
                stickp2 <= stickp2 - 1;
            else if (p2_down && stickp2 != (480-`STICKSIZE))
                stickp2 <= stickp2 + 1;
        end

        if (hc>=0 && hc<={7'h00,difflevel[3:1]} && vc==481) begin  // Actualizar DIFFLEVEL veces por frame la posición de la bola
            if (ballx == 10'd640) begin  // Estado de GAME OVER. Sólo salimos de él si pulsamos P1UP + P2DOWN
                if (p1_btup && p2_btdown) begin
                    ballx <= 10'd320;
                    bally <= 9'd240;
                    incx <= 10'd1;
                    incy <= 9'd1;
                    scorep1 <= 4'd0;
                    scorep2 <= 4'd0;
                    difflevel <= 4'd1;
                end
            end
            else if (scorep1==4'd9 || scorep2==4'd9) begin  // Si alguno de los dos jugadores llegó a 9 puntos, Game Over
                ballx <= 10'd640;  // Ir a estado GAME OVER. Hacemos desaparecer la pelota y esperamos pulsación reset
            end
            else if (ballx==10'd1) begin   // Si la bola se salió por el lado izquierdo del campo, punto para P2
                ballx <= 10'd320;
                bally <= 9'd240;
                incx <= -10'd1;
                incy <= 9'd1;
                scorep2 <= scorep2 + 1;
                difflevel <= 4'd1;
            end
            else if (ballx==(10'd639-`BALLSIZE)) begin  // Si la bola se salió por el lado derecho del campo, punto para P1
                ballx <= 10'd320;
                bally <= 9'd240;
                incx <= 10'd1;
                incy <= 9'd1;
                scorep1 <= scorep1 + 1;
                difflevel <= 4'd1;
            end
            else begin   // Si la bola toca con alguno de los dos sticks, debe salir rebotada al campo contrario
                if (bally==1 && incy<0 || bally==(479-`BALLSIZE) && incy>0)
                    incy <= -incy;
                else if (ballx==(`STICKP1X+`STICKWIDTH+1) && bally>=stickp1 && bally<(stickp1+`STICKSIZE) && incx<0) begin  // si rebota contra el stick de P1...
                    difflevel <= (difflevel!=4'd15)? difflevel + 1 : difflevel;  // En cada devolución, el nivel de dificultad (=velocidad de la bola) aumenta
                    if (bally>=stickp1 && bally<(stickp1+`STICKSIZE/3)) begin  // tercio superior del stick
                        incx <= -incx;
                        if (incy>0)
                            incy <= -1;
                    end
                    else if (bally>=(stickp1+2*`STICKSIZE/3) && bally<(stickp1+`STICKSIZE)) begin  // tercio inferior del stick
                        incx <= -incx;
                        if (incy>0)
                            incy <= -1;
                    end
                    else begin   // parte media del stick (rebote "limpio")
                        incx <= -incx;
                    end
                end
                else if (ballx==(`STICKP2X-`BALLSIZE) && bally>=stickp2 && bally<(stickp2+`STICKSIZE) && incx>0) begin
                    difflevel <= (difflevel!=4'd15)? difflevel + 1 : difflevel;  // En cada devolución, el nivel de dificultad (=velocidad de la bola) aumenta
                    if (bally>=stickp2 && bally<(stickp2+`STICKSIZE/3)) begin
                        incx <= -incx;
                        if (incy>0)
                            incy <= -1;
                    end
                    else if (bally>=(stickp2+2*`STICKSIZE/3) && bally<(stickp2+`STICKSIZE)) begin
                        incx <= -incx;
                        if (incy>0)
                            incy <= -1;
                    end
                    else begin
                        incx <= -incx;
                    end
                end
                else begin  // Actualiza la posición de la bola
                    ballx <= ballx + incx;
                    bally <= bally + incy;
                end
            end
        end  
    end
endmodule
