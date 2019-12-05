`timescale 1ns / 1ps

module read#(parameter
    height = 120,             //change it accordingly
    width = 160,              //change it accordingly
    inFile = "/home/abhay/Downloads/dkodim.hex"
    )
    (
    input clk,
    output reg [7:0] data_r,
    output reg [7:0] data_g,
    output reg [7:0] data_b
    );
    
    reg start;
    localparam imageData = 57600;
    reg [7:0] inp [0:imageData-1];
    integer row;
    integer colmn;
    integer data;
    reg img [0:height*width*3-1];
    reg flag0,flag1,flag2;
    integer x;
    
    initial begin
        $readmemh(inFile,inp,0,imageData-1);
        flag0 <= 1'b0;
        flag1 <= 1'b0;
        flag2 <= 1'b0;
        data<=0;
        row<=0;
        colmn<=0;
        x<=161;
    end
    
    integer idx;
    always@(start) begin // reading data
        if(start == 1) begin
           for (idx=0;idx<height*width*3;idx=idx+1) begin
                img[idx] = inp[idx][7:0];
           end
           flag0 = 1'b1;
        end
    end
    
    reg [7:0] gray[0:height*width-1];
    integer i;
    always@(*) begin
        if(flag0) begin
            for(i=0;i<height*width*3;i=i+3) begin
                gray[i/3] = (img[0+i]>>2) + (img[0+i]>>5) + (img[1+i]>>1) + (img[1+i]>>4) + (img[2+i]>>4) + (img[2+i]>>5);
            end
            flag0 = 1'b0;
        end
    end
    
    
    always@(posedge clk) begin              //used to simulate the for loop
        if(x<(height*width)-161) begin
            x<=x+1;
        end
    end
    
    reg [7:0] sx,sy;      //stores the value of the filter
    reg signed [7:0] x1,x2; 
    reg result;
    always@(posedge clk) begin //takign the sobels
        if(flag1) begin
            sx <= ((gray[x-159]-gray[x-161])+(gray[x+1]-gray[x-1])+(gray[x+1]-gray[x-1])+(gray[x+161]-gray[x+159]));
            sy <= ((gray[x+159]-gray[x-161])+(gray[x+160]-gray[x-160])+(gray[x+160]-gray[x-160])+(gray[x+161]-gray[x-159]));
            x1 = x1[7] ? -x1 : x1;
            x2 = x2[7] ? -x2 : x2;
            result = x1 +x2;           //result is storing the gray value of the sobel
            data_r = result;
            data_g = result;
            data_b = result;
        end
        flag2 = 1;
    end
endmodule

