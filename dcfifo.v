module dcfifo(
    
    input [DATA_WIDTH - 1:0] data_in,
    input wr_clk,
    input wr_req,
    output wr_full,

    output reg [DATA_WIDTH - 1:0] data_out,
    input rd_clk,
    input rd_req,
    output rd_empty,

    input wr_reset_n,
    input rd_reset_n
);

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 2;

reg [DATA_WIDTH-1:0] mem [(1 << ADDR_WIDTH) - 1 : 0];

reg [ADDR_WIDTH:0] wr_write_ptr;
reg [ADDR_WIDTH:0] rd_write_ptr_gray; 
reg [ADDR_WIDTH:0] wr_write_ptr_gray;

reg [ADDR_WIDTH:0] rd_read_ptr;
reg [ADDR_WIDTH:0] wr_read_ptr_gray;      
reg [ADDR_WIDTH:0] rd_read_ptr_gray;

reg [ADDR_WIDTH:0] sync_w2r;
reg [ADDR_WIDTH:0] sync_r2w;

function [ADDR_WIDTH:0] gray_conv;
input [ADDR_WIDTH:0] in;
begin
	gray_conv = {in[ADDR_WIDTH], in[ADDR_WIDTH-1:0] ^ in[ADDR_WIDTH:1]};
end
endfunction

assign wr_full = (wr_write_ptr_gray == {~wr_read_ptr_gray[ADDR_WIDTH:ADDR_WIDTH-1], wr_read_ptr_gray[ADDR_WIDTH - 2: 0]});
assign rd_empty = (rd_write_ptr_gray == rd_read_ptr_gray);

// sync read ptr into write clock domain
always @(posedge wr_clk or negedge wr_reset_n) 
begin
    if(!wr_reset_n)
    begin
        { wr_read_ptr_gray, sync_r2w } <= 0;
    end
    else begin
        { wr_read_ptr_gray, sync_r2w } <= { sync_r2w, rd_read_ptr_gray };
    end
end

// sync write ptr into read clock domain
always @(posedge rd_clk or negedge rd_reset_n) 
begin
    if(!rd_reset_n)
    begin
        { rd_write_ptr_gray, sync_w2r } <= 0;
    end
    else begin
        { rd_write_ptr_gray, sync_w2r } <= { sync_w2r , wr_write_ptr_gray };
    end
end

//incrementing write pointer in the current clock domain
always @(posedge wr_clk or negedge wr_reset_n) 
begin
    if(!wr_reset_n)
    begin
        wr_write_ptr <= 0;
        wr_write_ptr_gray <= 0;
    end
    else if((wr_req) && (!wr_full))
    begin
        wr_write_ptr <= wr_write_ptr + 1;
        wr_write_ptr_gray <= gray_conv(wr_write_ptr + 1);
        mem[wr_write_ptr] <= data_in;
    end
end

//incrementing write pointer in the current clock domain
always @(posedge rd_clk or negedge rd_reset_n) 
begin
    if(!rd_reset_n)
    begin
        rd_read_ptr <= 0;
        rd_read_ptr_gray <= 0;
    end
    else if((rd_req) && (!rd_empty))
    begin
        rd_read_ptr <= rd_read_ptr + 1;
        rd_read_ptr_gray <= gray_conv(rd_read_ptr + 1);
        data_out <= mem[rd_read_ptr];
    end
end


endmodule