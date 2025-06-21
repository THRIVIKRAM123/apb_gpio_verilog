module io_interface_tb();
reg ext_clk_pad_i;
reg [31:0]out_pad;
reg [31:0]oen_padoe;
wire [31:0]in_pad;
wire gpio_eclk;
wire [31:0]io_pad;
reg [31:0]temp;
reg dir;
io_interface dut(ext_clk_pad_i,out_pad,oen_padoe,in_pad,gpio_eclk,io_pad);
initial
begin
	ext_clk_pad_i=1'b0;
	forever #5
	ext_clk_pad_i=~ext_clk_pad_i;
end

assign io_pad=(dir)?temp:32'bz;

task out;
begin
	dir=1'b1;
	@(negedge ext_clk_pad_i)
      oen_padoe=32'h0;
      out_pad=32'h0;
	@(negedge ext_clk_pad_i)
	temp=32'h45;
    //  @(negedge ext_clk_pad_i)

      /* dir=1'b0;
       @(negedge ext_clk_pad_i)
      oen_padoe=32'h0;
      out_pad=32'h0;
	@(negedge ext_clk_pad_i)
	temp=32'h44;
	*/
end
endtask
task in;
	begin
	dir =1'b0;
		@(negedge ext_clk_pad_i)

	oen_padoe=32'hf0f0f0ff;
	//	@(negedge ext_clk_pad_i)
out_pad=32'h50;

end
endtask
task rw;
	begin
		dir=1'b1;
		dir=1'b1;
		@(negedge ext_clk_pad_i)
		oen_padoe=32'hf0f0f0f0;
		temp=32'h97;
		out_pad=32'h87;
	end
endtask

initial
begin
	out;
	#20;
	in;
	#20;
       rw;
#200       $finish;
end
endmodule

