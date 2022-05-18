
module RISC_TOP();
reg clk1=0,clk2=0,reset=0;

wire en_w,en_GPR,TAKEN_BRANCH,EX_MEM_cond;
wire [31:0] data_mem_addr,data_mem_read,data_mem_write,IF_ID_NPC,IF_ID_IR,rs1,rs2,data_in;
wire [31:0]ID_EX_rs1,ID_EX_rs2,ID_EX_IR,ID_EX_NPC,ID_EX_imm;
wire [31:0] EX_MEM_ALUOUT,EX_MEM_IR,MEM_WB_rs2,MEM_WB_ALUOUT,MEM_WB_LMD,MEM_WB_IR;
wire [4:0] rs1_addr,rs2_addr,data_addr;
wire [2:0] ID_EX_type,EX_MEM_type,MEM_WB_type;
wire [31:0] PC_ir_addr,IR,HAZ_OUT;
wire STALL_Fetch_decode,STALL,cond_stage;
assign STALL=0;

wire [1:0] EX_MEM_FW,MEM_WB_FW;
IR_MEM A0 (
	PC_ir_addr,
	IR);
	
DATA_MEM A1 (
	clk2,
	en_w,
	data_mem_addr,
	data_mem_read,
	data_mem_write);

GPR A2 (
	clk2,
	rs1_addr,
	rs2_addr,
	rs1,
	rs2,
	data_in,
	data_addr,
	en_GPR);

IF_ID_STAGE A3 (
	PC_ir_addr,
	IR,
	clk1,
	IF_ID_NPC,
	IF_ID_IR,
	reset,
	HAZ_OUT,
	cond_stage);

ID_EX_STAGE A4 (
	clk2,
	rs1,
	rs2,
	rs1_addr,
	rs2_addr,
	IF_ID_NPC,
	IF_ID_IR,
	ID_EX_rs1,
	ID_EX_rs2,
	ID_EX_IR,
	ID_EX_NPC,
	ID_EX_imm,
	ID_EX_type,
	cond_stage);

EX_MEM_STAGE A5 (
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

MEM_WB_STAGE A6 (
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

WB_END_STAGE A7 (
	en_GPR,
	data_in,
	data_addr,
	MEM_WB_ALUOUT,
	MEM_WB_IR,
	MEM_WB_type);
	

HAZARD_DETECTION_UNIT A8(
	EX_MEM_ALUOUT,
	MEM_WB_ALUOUT,
	EX_MEM_FW,
	MEM_WB_FW,
        ID_EX_IR[14:12],	
	ID_EX_NPC,
	cond_stage,
	ID_EX_imm,
	HAZ_OUT,
	ID_EX_IR,
	ID_EX_type,
	ID_EX_rs1,
	ID_EX_rs2);

FORWARD_UNIT A9(
	IF_ID_IR[19:15],
	IF_ID_IR[24:20],
	MEM_WB_IR[11:7],
	EX_MEM_IR[11:7],
	EX_MEM_FW,
	MEM_WB_FW,
	EX_MEM_type,
	MEM_WB_type);


integer i;
always 
begin
#5 clk1=1; #5 clk1=0;
#5 clk2=1; #5 clk2=0;
end

/*
initial 
begin
$monitor($time,"\n GPR[0]=%h,GPR[1]=%h,GPR[2]=%h, GPR[3]=%h,GPR[4]=%h,GPR[5]=%h,DATA[0]=%h,DATA[1]=%h,DATA[2]=%h,DATA[3]=%h,DATA[4]=%h,DATA[5]=%h",A2.GPR[0],A2.GPR[1],A2.GPR[2],A2.GPR[3],A2.GPR[4],A2.GPR[5],A1.DATA_MEM[0],A1.DATA_MEM[1],A1.DATA_MEM[2],A1.DATA_MEM[3],A1.DATA_MEM[4],A1.DATA_MEM[5]);
#1000
for (i=0;i<=9;i=i+1)
begin
$display("\n GPR[%1d]=%h,  Data[%1d]=%h",i,A2.GPR[i],i,A1.DATA_MEM[i]);
end
$finish;
end
*/
endmodule

