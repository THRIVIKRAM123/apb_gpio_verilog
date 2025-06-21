module aux_interface_tb();
reg sys_clk,sys_rst;
reg [31:0]aux_in;
wire [31:0]aux_i;

aux_interface dut(sys_clk,sys_rst,aux_in,aux_i);

initial
begin
sys_clk=1'b0;
forever #5
sys_clk=~sys_clk;
end

task rsti;
begin
@(negedge sys_clk)
sys_rst=0;
@(negedge sys_clk)
sys_rst=1;
end
endtask

task ip(input [31:0]j);
begin
@(negedge sys_clk)
aux_in=j;
#5;
end
endtask

initial
begin
rsti;
ip(35);
ip(36);
rsti;
ip(40);
#70 $finish();
end
initial
begin
$monitor("sys_rst=%d,aux_in=%d,aux_i=%d",sys_rst,aux_in,aux_i);
end
endmodule
