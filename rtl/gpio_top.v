module gpio_top(input pclk,ext_clk_pad_i,preset,psel,penable,pwrite,input [31:0]paddr,pwdata,aux_in,output pready,output  [31:0]prdata,output IRQ,inout [31:0]io_pad);
wire sys_clk,sys_rst,gpio_we,gpio_inta_o,gpio_eclk;
wire [31:0]gpio_addr,gpio_dat_i,gpio_dat_o,aux_i,out_pad_o,oen_padoe_o,in_pad_i;

//apb
apb_slave_interface dut1(pclk,preset,psel,penable,pwrite,
	                  pwdata,
			  paddr,
			  pready,
			 prdata,
			  IRQ,
			  sys_clk,sys_rst,
			  gpio_we,
			 gpio_addr,
			 gpio_dat_i,
			 gpio_dat_o,
			 gpio_inta_o);

//aux
aux_interface dut2(sys_clk,sys_rst,aux_in,aux_i);

//io
io_interface dut3(ext_clk_pad_i,out_pad_o,oen_padoe_o,in_pad_i,gpio_eclk,io_pad);

//gpio
gpio_interface dut4(sys_clk,sys_rst,gpio_we,gpio_addr,gpio_dat_i,aux_i,gpio_dat_o, gpio_inta_o,out_pad_o,oen_padoe_o,in_pad_i,gpio_eclk);

endmodule

