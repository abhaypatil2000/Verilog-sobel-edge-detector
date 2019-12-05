`timescale 1ns / 1ps
module write#(parameter
    height = 120,             //change it accordingly
    width = 160,              //change it accordingly
    outFile = "/home/abhay/Downloads/htke/sobelEdge.bmp"   //the path of output image
    )

    (
    input clk,
    input [7:0] dataPixel_r,
    input [7:0] dataPixel_g,
    input [7:0] dataPixel_b,

    output reg Wdone
    );
    integer header[0:53];                        //this header file depends on the size of the image. pls check the specific header for your image size
    reg [7:0] outp [0:height*width*3-1];
    reg [16:0] data;
    reg Write;
    wire done;    
    
    //////////////////////////////////////////
    initial begin
        header[0] = 66;
        header[1] = 77;
        header[2] = 54;
        header[3] = 225;
        header[4] = 0;
        header[5] = 0;
        header[6] = 0;
        header[7] = 0;
        header[8] = 0;
        header[9] = 0;
        header[10] = 54;
        header[11] = 0;
        header[12] = 0;
        header[13] = 0;
        header[14] = 40;
        header[15] = 0;
        header[16] = 0;
        header[17] = 0;
        header[18] = 0;
        header[19] = 0;
        header[20] = 10;
        header[21] = 0;
        header[22] = 0;
        header[23] = 0;
        header[24] = 7;
        header[25] = 8;
        header[26] = 1;
        header[27] = 0;
        header[28] = 24;
        header[29] = 0;
        header[30] = 0;
        header[31] = 0;
        header[32] = 0;
        header[33] = 0;
        header[34] = 0;
        header[35] = 0;
        header[36] = 0;
        header[37] = 0;
        header[38] = 0;
        header[39] = 0;
        header[40] = 0;
        header[41] = 0;
        header[42] = 0;
        header[43] = 0;
        header[44] = 0;
        header[45] = 0;
        header[46] = 0;
        header[47] = 0;
        header[48] = 0;
        header[49] = 0;
        header[50] = 0;
        header[51] = 0;
        header[52] = 0;
        header[53] = 0;
    end
    
    //////////////////////////////////////////
    integer l,m,i; 
    initial begin
        l<=0;
        m<=0;
        
        for(i=0;i<height*width*3;i=i+1) begin
                outp[i] <= 0;
        end
        
        data <= 0;
        
        Wdone <= 0;
    end
    
    //////////////////////////////////////////
    always@(posedge clk) begin
        if(m == width-1) begin
                    m<=0;
                    l<=l+1;
                end
                else begin
                   m<=m+1;
                end
    end
    
    
    //////////////////////////////////////////
    always@(posedge clk) begin
                outp[width*(height-l-1)*3+3*m+2] <= dataPixel_r;
                outp[width*(height-l-1)*3+3*m+1] <= dataPixel_g;
                outp[width*(height-l-1)*3+3*m] <= dataPixel_b;
    end
    
    //////////////////////////////////////////
    always@(posedge clk) begin
        data <= data+1;
    end
    
    //////////////////////////////////////////
    assign done = (data == 19199)? 1:0;
    
    always @(posedge clk) begin
        Wdone <= done;
    end
    
    //////////////////////////////////////////
    reg file;
    initial begin
        file = $fopen(outFile, "wb+");
    end
    
    //////////////////////////////////////////
    integer idx;
    always@(Wdone) begin
        if(Wdone == 1) begin
            for(idx=0;idx<54;idx=idx+1) begin
                $fwrite(file, "%c", header[idx][7:0]);
            end
            
            for(idx=0;idx<width*height*3;idx=idx+3) begin
                $fwrite(file, "%c", outp[i][7:0]);
                $fwrite(file, "%c", outp[i+1][7:0]);
                $fwrite(file, "%c", outp[i+2][7:0]);
            end
        end
    end
            
endmodule

