`timescale 1ns / 1ps
`define inpFile		 "/home/abhay/Downloads/dkodim.hex"          // Input file path
`define outFile		 "/home/abhay/Downloads/htke/sobelEdge.bmp"  //output file path

module test;
    reg clk;
    wire [ 7 : 0] data_R0;
    wire [ 7 : 0] data_G0;
    wire [ 7 : 0] data_B0;
    
    read #(.inFile(`inpFile))
	rd ( 
    .clk(clk),
    .data_r(data_R0 ),
    .data_g(data_G0 ),
    .data_b(data_B0 )
    ); 
    
    write #(.outFile(`outFile))
	wrt (
	.clk(clk),
   .dataPixel_r(data_R0),
   .dataPixel_g(data_G0),
   .dataPixel_b(data_B0),
    .Wdone()
    );	
    
    initial begin 
        clk = 0;
        forever #10 clk = ~clk;
    end

endmodule

