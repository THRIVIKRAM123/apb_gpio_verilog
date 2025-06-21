module io_interface(input ext_clk_pad_i,input [31:0]out_pad,input [31:0]oen_padoe,output  [31:0]in_pad,output gpio_eclk,inout [31:0]io_pad);
genvar i;
generate for(i=0;i<32;i=i+1)
	begin:b1
		bufif1(io_pad[i],out_pad[i],oen_padoe[i]);
	end
endgenerate
assign in_pad=io_pad;
assign gpio_eclk=ext_clk_pad_i;
endmodule
