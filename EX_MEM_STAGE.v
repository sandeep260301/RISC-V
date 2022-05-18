module EX_MEM_STAGE(
	MEM_WB_ALUOUT,
	EX_MEM_FW,
	MEM_WB_FW,
	clk1,
	ID_EX_IR,
	 ID_EX_NPC,
	ID_EX_imm,
	ID_EX_rs1,
	ID_EX_rs2,
	ID_EX_type,
	EX_MEM_ALUOUT,
	EX_MEM_IR,
	EX_MEM_type,
	MEM_WB_rs2,
	STALL);
input [2:0] ID_EX_type;
output reg [2:0] EX_MEM_type;
input clk1,STALL;
input [31:0] ID_EX_IR, ID_EX_NPC,ID_EX_imm,ID_EX_rs1,ID_EX_rs2,MEM_WB_ALUOUT;
wire [31:0] EX_MEM_ALUOUT_stage;
output reg [31:0] EX_MEM_ALUOUT,EX_MEM_IR;
wire [2:0] ID_EX_func;
assign ID_EX_func = ID_EX_IR[14:12];
output reg [31:0] MEM_WB_rs2;
wire [31:0] MEM_WB_rs2_stage;
wire status;
assign status = ID_EX_IR[30];
input [1:0]EX_MEM_FW,MEM_WB_FW;
wire [2:0] utype;
assign utype=ID_EX_IR[6:4];
wire [7:0] uimm;
assign uimm=ID_EX_IR[19:12];
wire [31:0] ID_EX_r1_stage,ID_EX_r2_stage;

assign ID_EX_r1_stage= (EX_MEM_FW[1])?EX_MEM_ALUOUT:(MEM_WB_FW[1])?MEM_WB_ALUOUT:ID_EX_rs1;
assign ID_EX_r2_stage=(EX_MEM_FW[0])?EX_MEM_ALUOUT:(MEM_WB_FW[0])?MEM_WB_ALUOUT:ID_EX_rs2;


ALU_EX m1 (
	uimm,
	utype,
	status,
	ID_EX_type,
	ID_EX_func,
	ID_EX_NPC,
	ID_EX_imm,
	ID_EX_r1_stage,
	ID_EX_r2_stage,
	MEM_WB_rs2_stage,
	EX_MEM_ALUOUT_stage);

always @(posedge clk1)
begin

if(STALL)
begin
EX_MEM_type<= EX_MEM_type;
EX_MEM_IR<=EX_MEM_IR;
EX_MEM_ALUOUT<=EX_MEM_ALUOUT;
MEM_WB_rs2<=MEM_WB_rs2;
end
else
begin
EX_MEM_type<= ID_EX_type;
EX_MEM_IR<=ID_EX_IR;
EX_MEM_ALUOUT<=EX_MEM_ALUOUT_stage;
MEM_WB_rs2<=MEM_WB_rs2_stage;
end
end
endmodule