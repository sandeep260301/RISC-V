module DATA_MEM(clk2,en_w,data_mem_addr,data_mem_read,data_mem_write);
input en_w,clk2;
input [31:0] data_mem_addr,data_mem_write;
output [31:0] data_mem_read;
reg [31:0] DATA_MEM [0:1023];
assign data_mem_read =DATA_MEM[data_mem_addr];


 integer i;
    initial begin
        for(i = 0; i <=1023; i = i + 1) begin
			DATA_MEM[i] = 0;
		end
    end
	 


always @(negedge clk2)
begin
if(en_w)
DATA_MEM[data_mem_addr]=data_mem_write;
end
endmodule