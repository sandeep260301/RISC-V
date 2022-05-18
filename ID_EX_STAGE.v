module ID_EX_STAGE (clk2,
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
input [31:0] IF_ID_IR, IF_ID_NPC;
input clk2,cond_stage;
output reg [2:0] ID_EX_type;
output reg [31:0] ID_EX_IR, ID_EX_NPC,ID_EX_imm,ID_EX_rs1,ID_EX_rs2;

parameter R_type=3'b011, S_type=3'b010, B_type=3'b111, J_type=3'b100, U_type=3'b101; 
parameter I_jump=3'b110,I_logic=3'b001,I_load=3'b000;


output [4:0] rs1_addr,rs2_addr;
input [31:0] rs1, rs2;
assign rs1_addr= IF_ID_IR[19:15];
assign rs2_addr=IF_ID_IR[24:20];

always @(negedge clk2)
begin
case (IF_ID_IR[6:0])

7'b0110011: ID_EX_type<=R_type;

7'b0010011,7'b0000011,7'b1100111,7'b1110011: 
begin
case(IF_ID_IR[6:4])
I_logic:ID_EX_type<=I_logic;
I_jump:ID_EX_type<=I_jump;
I_load:ID_EX_type<=I_load;
default:ID_EX_type<=3'bxxx;
endcase
ID_EX_imm<={{20{IF_ID_IR[31]}},{IF_ID_IR[31:20]}};
end

7'b0100011: begin
ID_EX_type<=S_type;
ID_EX_imm<={{20{IF_ID_IR[31]}},{IF_ID_IR[31:25]},{IF_ID_IR[11:7]}};
end

7'b1100011: begin
ID_EX_type<=B_type;
ID_EX_imm={{20{IF_ID_IR[31]}},{IF_ID_IR[31]},{IF_ID_IR[7]},{IF_ID_IR[30:25]},{IF_ID_IR[11:8]}};
end

7'b1101111: begin
ID_EX_type<=J_type;
ID_EX_imm<={{20{IF_ID_IR[31]}},{IF_ID_IR[31:20]}};
end

7'b0010111,7'b0110111: begin
ID_EX_type<=U_type;
ID_EX_imm<={{20{IF_ID_IR[31]}},{IF_ID_IR[31:20]}};

end
default : begin
ID_EX_type<=3'bxxx;
ID_EX_imm<=32'hxxxxxxxx;
end


endcase


ID_EX_rs1<=rs1;
ID_EX_rs2<=rs2;
ID_EX_NPC<=IF_ID_NPC;
if(cond_stage==0)
ID_EX_IR<=IF_ID_IR;
else
ID_EX_IR<=32'h00000000;
end
endmodule