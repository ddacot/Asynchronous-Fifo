`timescale 1ns/1ns
`include "dcfifo.v"

module dcfifo_tb;

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 2;

reg [DATA_WIDTH - 1:0] data_in;
reg wr_clk;
reg wr_req;
wire wr_full;

wire [DATA_WIDTH - 1:0] data_out;
reg rd_clk;
reg rd_req;
wire rd_empty;
reg rd_read_ptr;
reg wr_read_ptr;

reg rd_reset_n;
reg wr_reset_n;

always #3 wr_clk=~wr_clk;
always #7 rd_clk=~rd_clk;

dcfifo dcfifo1( .data_in(data_in),
                .wr_clk(wr_clk),
                .wr_req(wr_req),
                .wr_full(wr_full),
                .data_out(data_out),
                .rd_clk(rd_clk),
                .rd_req(rd_req),
                .rd_empty(rd_empty),
                .wr_reset_n(wr_reset_n),
                .rd_reset_n(rd_reset_n));

initial 
begin

    $dumpfile("dcfifo_tb.vcd");
    $dumpvars(0, dcfifo_tb);
    rd_reset_n = 1;
    wr_reset_n = 1;
    wr_clk = 0;
    rd_clk = 0;
    wr_req = 0;
    rd_req = 0;
    data_in = 0;
    #6;
    rd_reset_n = 0;
    wr_reset_n = 0;
    #3;
    rd_reset_n = 1;
    wr_reset_n = 1;
    wr_req = 1;
    data_in = 32'hAA;
    #3
    wr_req = 0;
    #3
    wr_req = 1;
    data_in = 32'hBB;
    #3
    wr_req = 0;
    #3
    wr_req = 1;
    data_in = 32'hCC;
    #3
    wr_req = 0;
    #3
    wr_req = 1;
    data_in = 32'hDD;
    #3
    wr_req = 0;
    #3
    wr_req = 1;
    data_in = 32'hEE;
    #3
    wr_req = 0;
    #3
    wr_req = 1;
    data_in = 32'hEE;
    #3
    wr_req = 0;
    #3
    wr_req = 1;
    data_in = 32'hEE;
    #3
    wr_req = 0;
    #3
    wr_req = 1;
    data_in = 32'hEE;
    #3
    wr_req = 0;
    #40;

    rd_req = 1;
    #100
    
    $display("test complete");
    $finish;
end


endmodule