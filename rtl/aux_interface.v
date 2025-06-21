module aux_interface(input sys_clk,sys_rst,input [31:0]aux_in,output reg [31:0]aux_i);
always@(posedge sys_clk)
begin
if(!sys_rst)
aux_i<=0;
else
aux_i<=aux_in;
end
endmodule
