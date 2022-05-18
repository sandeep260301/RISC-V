module IF_ID_STAGE(
	PC_ir_addr,
	IR,
	clk1,
	IF_ID_NPC,
	IF_ID_IR,
	reset,
        HAZ_OUT,
	cond_stage);
input clk1,reset,cond_stage;
input [31:0] HAZ_OUT;
output reg [31:0] IF_ID_IR, IF_ID_NPC;
input [31:0]IR;
reg [31:0] PC=0;
output [31:0] PC_ir_addr;
reg br=0;

assign PC_ir_addr=(br)?HAZ_OUT:PC;





always @(posedge clk1)
begin

if(cond_stage)
begin
IF_ID_IR<=IR;
PC<=HAZ_OUT;
IF_ID_NPC<=HAZ_OUT;
end
else
begin
IF_ID_IR<=IR;
IF_ID_NPC<=PC;
PC<=PC+1;
end


end


endmodule 
