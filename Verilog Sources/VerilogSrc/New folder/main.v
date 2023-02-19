`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2020 09:06:51 AM
// Design Name: 
// Module Name: Riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module main( input clk, uart_in, output [15:0] LEDs, output [3:0] Anode, output [6:0] LED_out );
wire [7:0] out;
wire [12:0]num;


    UART_receiver_multiple_Keys uart (
        clk, // input clock
        uart_in, // input receiving data line
        out // output
     ); 
    RISCV_pipeline rv(out[7], out[6], out[5:4], out[3:0], LEDs[7:0], num);
    assign LEDs[15:8]= out;
    SevenSegDis sd(clk, num, Anode, LED_out);



endmodule