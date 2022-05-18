module FORWARD_UNIT(
	ID_EX_r1,
	ID_EX_r2,
	MEM_WB_rd,
	EX_MEM_rd,
	EX_MEM_FW,
	MEM_WB_FW,
	EX_MEM_type,
	MEM_WB_type);
input [2:0] EX_MEM_type,MEM_WB_type;
input [4:0] MEM_WB_rd,EX_MEM_rd,ID_EX_r1,ID_EX_r2;
output reg [1:0] EX_MEM_FW,MEM_WB_FW;
parameter R_type=3'b011, S_type=3'b010, B_type=3'b111, J_type=3'b100, U_type=3'b101; 
parameter I_jump=3'b110,I_logic=3'b001,I_load=3'b000;


reg func_ex;
reg func_mem;





always@(*)
begin

if((EX_MEM_type==3'b011) || (EX_MEM_type==3'b101) || (EX_MEM_type==3'b001) || (EX_MEM_type==3'b111))
func_ex=1;
else
func_ex=0;

if((MEM_WB_type==3'b011) || (MEM_WB_type==3'b101) || (MEM_WB_type==3'b001) ||(MEM_WB_type==3'b000) || (EX_MEM_type==3'b111))
func_mem=1;
else
func_mem=0;



if((ID_EX_r1==MEM_WB_rd)&&(ID_EX_r2==MEM_WB_rd)&&(MEM_WB_rd!=5'b00000)&&(func_mem))
MEM_WB_FW=2'b11;
else if((ID_EX_r1==MEM_WB_rd)&&(MEM_WB_rd!=5'b00000)&&(func_mem))
MEM_WB_FW=2'b10;
else if((ID_EX_r2==MEM_WB_rd)&&(MEM_WB_rd!=5'b00000)&&(func_mem))
MEM_WB_FW=2'b01;
else
MEM_WB_FW=2'b00;

if((ID_EX_r1==EX_MEM_rd)&&(ID_EX_r2==EX_MEM_rd)&&(EX_MEM_rd!=5'b00000)&&(func_ex))
EX_MEM_FW=2'b11;
else if((ID_EX_r1==EX_MEM_rd)&&(EX_MEM_rd!=5'b00000)&&(func_ex))
EX_MEM_FW=2'b10;
else if((ID_EX_r2==EX_MEM_rd)&&(EX_MEM_rd!=5'b00000)&&(func_ex))
EX_MEM_FW=2'b01;
else
EX_MEM_FW=2'b00;

end
endmodule

