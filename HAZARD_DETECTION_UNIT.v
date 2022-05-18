module HAZARD_DETECTION_UNIT (EX_MEM_ALUOUT,MEM_WB_ALUOUT,EX_MEM_FW,MEM_WB_FW,func,ID_EX_NPC,cond_stage,ID_EX_imm,HAZ_OUT,ID_EX_IR,ID_EX_type,ID_EX_rs1,ID_EX_rs2);
input [31:0] ID_EX_IR,ID_EX_NPC,ID_EX_imm,ID_EX_rs1,ID_EX_rs2,EX_MEM_ALUOUT,MEM_WB_ALUOUT;
output reg cond_stage;
input [2:0] ID_EX_type;
output reg [31:0] HAZ_OUT;
input [2:0] func;
input [1:0] EX_MEM_FW,MEM_WB_FW;
parameter R_type=3'b011, S_type=3'b010, B_type=3'b111, J_type=3'b100, U_type=3'b101; 
parameter I_jump=3'b110,I_logic=3'b001,I_load=3'b000;

wire [31:0] ID_EX_rs1_stage, ID_EX_rs2_stage;

assign ID_EX_rs1_stage= (EX_MEM_FW[1])?EX_MEM_ALUOUT:(MEM_WB_FW[1])?MEM_WB_ALUOUT:ID_EX_rs1;
assign ID_EX_rs2_stage=(EX_MEM_FW[0])?EX_MEM_ALUOUT:(MEM_WB_FW[0])?MEM_WB_ALUOUT:ID_EX_rs2;




always @(*)

begin
case (ID_EX_type)
B_type:
begin
HAZ_OUT=ID_EX_NPC+ID_EX_imm;
case(func)
3'b000:cond_stage=(ID_EX_rs1_stage==ID_EX_rs2_stage);//beq
3'b001:cond_stage=(ID_EX_rs1_stage!=ID_EX_rs2_stage);//bne
3'b100:cond_stage=(ID_EX_rs1_stage<ID_EX_rs2_stage);//blt
3'b101:cond_stage=(ID_EX_rs1_stage>=ID_EX_rs2_stage);//bge
3'b110:cond_stage=({1'b0,ID_EX_rs1_stage[30:0]}<{1'b0,ID_EX_rs2_stage[30:0]});//bltu
3'b111:cond_stage=({1'b0,ID_EX_rs1_stage[30:0]}>={1'b0,ID_EX_rs2_stage[30:0]});//bgeu
default:cond_stage=1'b0;
endcase
end

I_jump:begin
HAZ_OUT=ID_EX_rs1_stage+ID_EX_imm;
cond_stage=1;
end

J_type:begin
HAZ_OUT={ID_EX_imm[31:20],ID_EX_IR[19:12]};
cond_stage=1;
end

default: begin
cond_stage=0;
HAZ_OUT=32'h00000000;
end
endcase
end
endmodule 
