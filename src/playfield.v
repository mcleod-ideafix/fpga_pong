`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
//    This file is playfield
//    Creation date is 01:05:01 05/30/2014 by Miguel Angel Rodriguez Jodar
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

module playfield (
    input wire clk,

    // Elementos moviles del playfield
    input wire [8:0] stickp1,
    input wire [8:0] stickp2,
    input wire [9:0] ballx,
    input wire [8:0] bally,
    input wire [3:0] scorep1,
    input wire [3:0] scorep2,

    // Salida de video
    output wire [10:0] hc,
    output wire [10:0] vc,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b,
    output wire hs,
    output wire vs
    );
	 
	 reg [7:0] rojo;
	 reg [7:0] verde;
	 reg [7:0] azul;
	 
	 videosyncs syncs (
		.clk(clk),
		.rin(rojo),
		.gin(verde),
		.bin(azul),
		.rout(r),
		.gout(g),
		.bout(b),
		.hs(hs),
		.vs(vs),
		.hc(hc),
		.vc(vc)
		);
		
	always @* begin
		{rojo,verde,azul} = `NEGRO;  // color por defecto, si no estamos pintando realmente el playfield
		if (vc>=0 && vc<480 && hc>=0 && hc<640) begin
            {rojo,verde,azul} = `FONDO;  // color por defecto, si no se pinta otra cosa encima
            // ------------------------------ RED Y BORDE ------------------------------------
            if (vc==0 || vc==479) begin
                {rojo,verde,azul} = `BORDE;
            end

            if (hc==320 && vc[2]) begin
                {rojo,verde,azul} = `BORDE;
            end

            // --------------------------------- STICKS --------------------------------------
            if (vc>=stickp1 && vc<(stickp1+`STICKSIZE) && hc>=`STICKP1X && hc<(`STICKP1X+`STICKWIDTH)) begin
                {rojo,verde,azul} = `STICK1;        
            end

            if (vc>=stickp2 && vc<(stickp2+`STICKSIZE) && hc>=`STICKP2X && hc<(`STICKP2X+`STICKWIDTH)) begin
                {rojo,verde,azul} = `STICK2;        
            end

            // ------------------------------- MARCADORES-------------------------------------
            // Segmento A para P1
            if (hc>=(`SCOREP1X + `SEGA_X1) && 
                hc<(`SCOREP1X + `SEGA_X2) && 
                vc>=(`SCOREP1Y + `SEGA_Y1) 
                && vc<(`SCOREP1Y + `SEGA_Y2) 
                && (scorep1==4'd0 || scorep1==4'd2 || scorep1==4'd3 || scorep1==4'd5 || scorep1==4'd6 || scorep1==4'd7 || scorep1==4'd8 || scorep1==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE1;
            end

            // Segmento A para P2
            if (hc>=(`SCOREP2X + `SEGA_X1) && 
                hc<(`SCOREP2X + `SEGA_X2) && 
                vc>=(`SCOREP2Y + `SEGA_Y1) 
                && vc<(`SCOREP2Y + `SEGA_Y2) 
                && (scorep2==4'd0 || scorep2==4'd2 || scorep2==4'd3 || scorep2==4'd5 || scorep2==4'd6 || scorep2==4'd7 || scorep2==4'd8 || scorep2==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE2;
            end

            // Segmento B para P1
            if (hc>=(`SCOREP1X + `SEGB_X1) && 
                hc<(`SCOREP1X + `SEGB_X2) && 
                vc>=(`SCOREP1Y + `SEGB_Y1) 
                && vc<(`SCOREP1Y + `SEGB_Y2) 
                && (scorep1==4'd0 || scorep1==4'd1 || scorep1==4'd2 || scorep1==4'd3 || scorep1==4'd4 || scorep1==4'd7 || scorep1==4'd8 || scorep1==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE1;
            end

            // Segmento B para P2
            if (hc>=(`SCOREP2X + `SEGB_X1) && 
                hc<(`SCOREP2X + `SEGB_X2) && 
                vc>=(`SCOREP2Y + `SEGB_Y1) 
                && vc<(`SCOREP2Y + `SEGB_Y2) 
                && (scorep2==4'd0 || scorep2==4'd1 || scorep2==4'd2 || scorep2==4'd3 || scorep2==4'd4 || scorep2==4'd7 || scorep2==4'd8 || scorep2==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE2;
            end

            // Segmento C para P1
            if (hc>=(`SCOREP1X + `SEGC_X1) && 
                hc<(`SCOREP1X + `SEGC_X2) && 
                vc>=(`SCOREP1Y + `SEGC_Y1) 
                && vc<(`SCOREP1Y + `SEGC_Y2) 
                && (scorep1==4'd0 || scorep1==4'd1 || scorep1==4'd3 || scorep1==4'd4 || scorep1==4'd5 || scorep1==4'd6 || scorep1==4'd7 || scorep1==4'd8 || scorep1==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE1;
            end

            // Segmento C para P2
            if (hc>=(`SCOREP2X + `SEGC_X1) && 
                hc<(`SCOREP2X + `SEGC_X2) && 
                vc>=(`SCOREP2Y + `SEGC_Y1) 
                && vc<(`SCOREP2Y + `SEGC_Y2) 
                && (scorep2==4'd0 || scorep2==4'd1 || scorep2==4'd3 || scorep2==4'd4 || scorep2==4'd5 || scorep2==4'd6 || scorep2==4'd7 || scorep2==4'd8 || scorep2==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE2;
            end

            // Segmento D para P1
            if (hc>=(`SCOREP1X + `SEGD_X1) && 
                hc<(`SCOREP1X + `SEGD_X2) && 
                vc>=(`SCOREP1Y + `SEGD_Y1) 
                && vc<(`SCOREP1Y + `SEGD_Y2) 
                && (scorep1==4'd0 || scorep1==4'd2 || scorep1==4'd3 || scorep1==4'd5 || scorep1==4'd6 || scorep1==4'd8 || scorep1==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE1;
            end

            // Segmento D para P2
            if (hc>=(`SCOREP2X + `SEGD_X1) && 
                hc<(`SCOREP2X + `SEGD_X2) && 
                vc>=(`SCOREP2Y + `SEGD_Y1) 
                && vc<(`SCOREP2Y + `SEGD_Y2) 
                && (scorep2==4'd0 || scorep2==4'd2 || scorep2==4'd3 || scorep2==4'd5 || scorep2==4'd6 || scorep2==4'd8 || scorep2==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE2;
            end

            // Segmento E para P1
            if (hc>=(`SCOREP1X + `SEGE_X1) && 
                hc<(`SCOREP1X + `SEGE_X2) && 
                vc>=(`SCOREP1Y + `SEGE_Y1) 
                && vc<(`SCOREP1Y + `SEGE_Y2) 
                && (scorep1==4'd0 || scorep1==4'd2 || scorep1==4'd6 || scorep1==4'd8)
               ) begin
                {rojo,verde,azul} = `SCORE1;
            end

            // Segmento E para P2
            if (hc>=(`SCOREP2X + `SEGE_X1) && 
                hc<(`SCOREP2X + `SEGE_X2) && 
                vc>=(`SCOREP2Y + `SEGE_Y1) 
                && vc<(`SCOREP2Y + `SEGE_Y2) 
                && (scorep2==4'd0 || scorep2==4'd2 || scorep2==4'd6 || scorep2==4'd8)
               ) begin
                {rojo,verde,azul} = `SCORE2;
            end

            // Segmento F para P1
            if (hc>=(`SCOREP1X + `SEGF_X1) && 
                hc<(`SCOREP1X + `SEGF_X2) && 
                vc>=(`SCOREP1Y + `SEGF_Y1) 
                && vc<(`SCOREP1Y + `SEGF_Y2) 
                && (scorep1==4'd0 || scorep1==4'd4 || scorep1==4'd5 || scorep1==4'd6 || scorep1==4'd8 || scorep1==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE1;
            end

            // Segmento F para P2
            if (hc>=(`SCOREP2X + `SEGF_X1) && 
                hc<(`SCOREP2X + `SEGF_X2) && 
                vc>=(`SCOREP2Y + `SEGF_Y1) 
                && vc<(`SCOREP2Y + `SEGF_Y2) 
                && (scorep2==4'd0 || scorep2==4'd4 || scorep2==4'd5 || scorep2==4'd6 || scorep2==4'd8 || scorep2==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE2;
            end

            // Segmento G para P1
            if (hc>=(`SCOREP1X + `SEGG_X1) && 
                hc<(`SCOREP1X + `SEGG_X2) && 
                vc>=(`SCOREP1Y + `SEGG_Y1) 
                && vc<(`SCOREP1Y + `SEGG_Y2) 
                && (scorep1==4'd2 || scorep1==4'd3 || scorep1==4'd4 || scorep1==4'd5 || scorep1==4'd6 || scorep1==4'd8 || scorep1==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE1;
            end

            // Segmento G para P2
            if (hc>=(`SCOREP2X + `SEGG_X1) && 
                hc<(`SCOREP2X + `SEGG_X2) && 
                vc>=(`SCOREP2Y + `SEGG_Y1) 
                && vc<(`SCOREP2Y + `SEGG_Y2) 
                && (scorep2==4'd2 || scorep2==4'd3 || scorep2==4'd4 || scorep2==4'd5 || scorep2==4'd6 || scorep2==4'd8 || scorep2==4'd9)
               ) begin
                {rojo,verde,azul} = `SCORE2;
            end

            // --------------------------------- BOLA --------------------------------------
            if (hc>=ballx && hc<(ballx+`BALLSIZE) && vc>=bally && vc<(bally+`BALLSIZE)) begin
                {rojo,verde,azul} = `BALL;        
            end
		end
	end
endmodule
