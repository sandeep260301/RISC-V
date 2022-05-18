module MEM_WB_STAGE(
	clk2,
	data_mem_addr,
	data_mem_write,
	data_mem_read,
	en_w,
	EX_MEM_ALUOUT,
	EX_MEM_type,
	MEM_WB_rs2,
	MEM_WB_ALUOUT,
	EX_MEM_IR,
	MEM_WB_IR,
	MEM_WB_type);
input [2:0] EX_MEM_type;
input clk2;
input [31:0] EX_MEM_ALUOUT,EX_MEM_IR;
input [31:0] MEM_WB_rs2;
output reg [31:0] MEM_WB_ALUOUT,MEM_WB_IR;
output reg [2:0] MEM_WB_type;
output reg en_w;
output reg [31:0] data_mem_write;
input [31:0] data_mem_read;
output [31:0] data_mem_addr;

assign data_mem_addr=EX_MEM_ALUOUT;



parameter R_type=3'b011, S_type=3'b010, B_type=3'b111, U_type=3'b101; 
parameter I_jump=3'b110,I_logic=3'b001,I_load=3'b000;

always @(posedge clk2)
begin
MEM_WB_type<=EX_MEM_type;
MEM_WB_IR<=EX_MEM_IR;
end

reg [31:0] data_in;

always @(*)
begin
if(EX_MEM_type==I_load)
case(EX_MEM_IR[14:12])
3'b000:data_in={{24{data_mem_read[7]}},data_mem_read[7:0]};//lb
3'b001:data_in={{16{data_mem_read[15]}},data_mem_read[15:0]};//lh
3'b010:data_in=data_mem_read;//lw
3'b100:data_in={{24{1'b0}},data_mem_read[7:0]};//lbu
3'b101:data_in={{16{1'b0}},data_mem_read[15:0]};//lhu
default:data_in=32'hxxxxxxxx;
endcase
end


always @(posedge clk2)
begin
case (EX_MEM_type)
R_type:begin
en_w<=0;
 MEM_WB_ALUOUT<=EX_MEM_ALUOUT;
end

I_logic:begin
en_w<=0;
MEM_WB_ALUOUT<=EX_MEM_ALUOUT;
end

U_type:begin
en_w<=0;
MEM_WB_ALUOUT<=EX_MEM_ALUOUT;
end

I_load: begin
MEM_WB_ALUOUT<=data_in;//lb //lh//lw//lbu//lhu
en_w<=0;
end

S_type: begin

case (EX_MEM_IR[14:12])
3'b000: begin 
data_mem_write<={{24{MEM_WB_rs2[7]}},MEM_WB_rs2[7:0]};//sb
en_w<=1;
end
3'b001:begin
data_mem_write<={{16{MEM_WB_rs2[15]}},MEM_WB_rs2[15:0]};//sh
en_w<=1;
end
3'b010:begin
data_mem_write<=MEM_WB_rs2;//sw
en_w<=1;
end
default: begin
data_mem_write<=32'hxxxxxxxx;
en_w<=0;
end
endcase
end


default:begin
en_w<=0;
MEM_WB_ALUOUT<=32'hxxxxxxxx;
data_mem_write<=32'hxxxxxxxx;
end
endcase
end
endmodule
