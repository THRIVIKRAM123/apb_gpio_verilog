module apb_slave_interface_tb();
reg pclk,preset,psel,penable,pwrite;
	                 reg [31:0]pwdata;
			 reg [31:0]paddr;
			 wire pready;
			 wire[31:0]prdata;
			 wire IRQ;
			 wire sys_clk,sys_rst;
			 wire  gpio_we;
			 wire [31:0]gpio_addr;
			 wire [31:0]gpio_data_in;
			 reg [31:0]gpio_data_out;
			 reg gpio_inta_o;
apb_slave_interface dut(pclk,preset,psel,penable,pwrite,
	                  pwdata,
			  paddr,
			  pready,
			 prdata,
			  IRQ,
			  sys_clk,sys_rst,
			  gpio_we,
			 gpio_addr,
			 gpio_data_in,
			 gpio_data_out,
			 gpio_inta_o);

		 initial
		 begin
			 pclk<=1'b0;
			 forever #5
			 pclk<=~pclk;
		 end
		 task rsti();
			 begin
				 @(posedge pclk)
				 preset=1'b0;
				 @(posedge pclk)
				 preset=1'b1;
			 end
		 endtask
		 task write();
			 begin
				 psel=1'b0;penable=1'b0;
				 #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b0;
				 #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b1;penable=1'b1;
				 #10 pwrite=1'b1;pwdata=32'd45;
				 #10 psel=1'b0;
				 #10 psel=1'bx;
				 #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b1;penable=1'b1;
				 #10 psel=1'b0;
			 end
		 endtask
		 task read();
			 begin
				 psel=1'b0;penable=1'b0;
				 #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b0;
				 #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b1;penable=1'b1;
				 #10 pwrite=1'b0;gpio_data_out=32'd12;
				 #10 psel=1'b0;
				  #10 psel=1'b1;penable=1'b0;
				 #10 psel=1'b1;
				 #10 psel=1'bx;
				 #10 psel=1'b1;penable=1'b1;
				 #10 psel=1'b0;
			 end
		 endtask
		 initial
		 begin
			 rsti;
			 #15;
			 write;
			 #25;
			 read ;
			 #20 $finish();
		 end
		 initial
			 $monitor("pready=%d,prdata=%d,IRQ=%d,sys_clk=%d,sys_rst=%d,gpio_we=%d,gpio_addr=%d,gpio_data_in=%d",pready,prdata,IRQ,sys_clk,sys_rst,gpio_we,gpio_addr,gpio_data_in);
		 endmodule


