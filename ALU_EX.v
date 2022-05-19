module ALU_EX(uimm,utype,status,ID_EX_type,ID_EX_func,ID_EX_NPC,ID_EX_imm,ID_EX_rs1,ID_EX_rs2,MEM_WB_rs2,EX_MEM_ALUOUT);
input [2:0] ID_EX_type,ID_EX_func;
input [31:0] ID_EX_imm,ID_EX_rs1,ID_EX_rs2,ID_EX_NPC;
input status;
output reg [31:0]MEM_WB_rs2,EX_MEM_ALUOUT;
input [2:0] utype;
input [7:0] uimm;
parameter R_type=3'b011, S_type=3'b010, B_type=3'b111,J_type=3'b100, U_type=3'b101; 
parameter I_jump=3'b110,I_logic=3'b001,I_load=3'b000;

always@(*)
begin
case (ID_EX_type)

R_type: begin
case(ID_EX_func)
3'b000: begin
if(status)EX_MEM_ALUOUT=ID_EX_rs1-ID_EX_rs2;
else EX_MEM_ALUOUT=ID_EX_rs1+ID_EX_rs2;
end
3'b001:EX_MEM_ALUOUT=ID_EX_rs1<<ID_EX_rs2;
3'b010:EX_MEM_ALUOUT=(ID_EX_rs1<ID_EX_rs2)?1:0;//slt
3'b011:EX_MEM_ALUOUT=({1'b0,ID_EX_rs1[30:0]}<{1'b0,ID_EX_rs2[30:0]})?1:0;//sltu
3'b100:EX_MEM_ALUOUT=ID_EX_rs1^ID_EX_rs2;
3'b101: begin
if(status)EX_MEM_ALUOUT=ID_EX_rs1>>>ID_EX_rs2;
else EX_MEM_ALUOUT=ID_EX_rs1>>ID_EX_rs2;
end
3'b110:EX_MEM_ALUOUT=ID_EX_rs1|ID_EX_rs2;
3'b111:EX_MEM_ALUOUT=ID_EX_rs1&ID_EX_rs2;
default:EX_MEM_ALUOUT=32'hxxxxxxxx;
endcase
MEM_WB_rs2=32'h00000000;
end

I_logic:begin
case(ID_EX_func)
3'b000:EX_MEM_ALUOUT=ID_EX_rs1+ID_EX_imm;//addi
3'b001:EX_MEM_ALUOUT=ID_EX_rs1<<ID_EX_imm[4:0];//slli
3'b010: EX_MEM_ALUOUT= (ID_EX_rs1<ID_EX_imm)?1:0;//slti
3'b011:EX_MEM_ALUOUT=({1'b0,ID_EX_rs1[30:0]}<{1'b0,ID_EX_imm[10:0]})?1:0;//sltiu
3'b100:EX_MEM_ALUOUT=ID_EX_rs1^ID_EX_imm;//xori
3'b101:begin
if(!status) EX_MEM_ALUOUT=ID_EX_rs1>>ID_EX_imm[4:0];//srli
else EX_MEM_ALUOUT=ID_EX_rs1>>>ID_EX_imm[4:0]; //srai(1)
end
3'b110:EX_MEM_ALUOUT=ID_EX_rs1|ID_EX_imm;//ori
3'b111:EX_MEM_ALUOUT=ID_EX_rs1&ID_EX_imm;//andi
default:EX_MEM_ALUOUT=32'hxxxxxxxx;
endcase
MEM_WB_rs2=32'h00000000;
end



I_load:begin
EX_MEM_ALUOUT=ID_EX_rs1+ID_EX_imm;//lb //lh //lw // lbu //lhu
MEM_WB_rs2=32'h00000000;
end

S_type:
begin
EX_MEM_ALUOUT=ID_EX_rs1+ID_EX_imm;//sb//sh//sw
MEM_WB_rs2=ID_EX_rs2;
end



U_type:begin
case(utype)
3'b011:EX_MEM_ALUOUT={{12{ID_EX_imm[31]}},ID_EX_imm[31:20],uimm};
3'b001:EX_MEM_ALUOUT=ID_EX_NPC+{ID_EX_imm[31:20],uimm};
default:EX_MEM_ALUOUT=32'hxxxxxxxx;
endcase
MEM_WB_rs2=32'h00000000;
end

default:begin
EX_MEM_ALUOUT=32'h000000000;
MEM_WB_rs2=32'h00000000;
end
endcase
end
endmodule
