module GPR (clk2,rs1_addr,rs2_addr,rs1,rs2,data_in,data_addr,en_GPR);
input [4:0] rs1_addr,rs2_addr,data_addr;
input [31:0] data_in;
input en_GPR;
input clk2;
output [31:0] rs1, rs2;
reg [31:0] GPR [0:31];

integer i;
    initial begin
        for(i = 0; i <= 31; i = i + 1) begin
			GPR[i] = 0;
		end
    end

assign rs1= GPR[rs1_addr];
assign rs2= GPR[rs2_addr];


initial 
begin
GPR[0]=0;
GPR[1]=32'h00000001;
GPR[2]=32'h00000002;
GPR[3]=32'h00000005;

end


always @(negedge clk2)
begin
if(en_GPR)
GPR[data_addr]<=data_in;
end

endmodule
