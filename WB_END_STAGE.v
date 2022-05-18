module WB_END_STAGE(
	en_GPR,
	data_in,
	data_addr,
	MEM_WB_ALUOUT,
	MEM_WB_IR,
	MEM_WB_type);
input [31:0] MEM_WB_ALUOUT,MEM_WB_IR;
input [2:0] MEM_WB_type;

output reg en_GPR;
output reg [31:0] data_in;
output [4:0] data_addr;

parameter R_type=3'b011, S_type=3'b010, B_type=3'b000,U_type=3'b101; 
parameter I_jump=3'b110,I_logic=3'b001,I_load=3'b000;

assign data_addr=MEM_WB_IR[11:7];

always @(*) // WB stage//////////////////////////////////////
begin

case(MEM_WB_type)

R_type: begin
en_GPR=1;
data_in=MEM_WB_ALUOUT;
end

U_type: begin
en_GPR=1;
data_in=MEM_WB_ALUOUT;
end

I_logic: begin
en_GPR=1;
data_in=MEM_WB_ALUOUT;
end

I_load:begin
en_GPR=1;
data_in=MEM_WB_ALUOUT;
end

default:begin 
en_GPR=0;
data_in=32'hxxxxxxxx;
end
endcase

end

endmodule
