module apb_slave_interface(input pclk,preset,psel,penable,pwrite,
	                 input [31:0]pwdata,
			 input [31:0]paddr,
			 output reg pready,
			 output reg [31:0]prdata,
			 output IRQ,
			 output sys_clk,sys_rst,
			 output reg gpio_we,
			 output[31:0]gpio_addr,
			 output reg[31:0]gpio_data_in,
			 input [31:0]gpio_data_out,
			 input gpio_inta_o);
      parameter idle=2'b00,
	        setup=2'b01,
		enable=2'b10;
	reg [1:0]state,next_state;
        wire t;
	always@(posedge pclk)
	begin
		if(!preset)
			state<=0;
		else
			state<=next_state;
	end
	always@(*)
	begin
		next_state=idle;
                 case(state)
                  idle:begin
			  if(psel&&!penable)
				  next_state=setup;
			  else 
				  next_state=idle;
		  end
		 setup:begin
			 if(psel&&penable)
				 next_state=enable;
			 else if(psel&&!penable)
				 next_state=setup;
			 else
				 next_state=idle;
		 end
		 enable:begin
			 if(!psel)
				 next_state=idle;
			 else
				 next_state=setup;
		 end
	//	 default:next_state=idle;
	 endcase
 end
  always@(*)
  begin
	  if(pwrite&&state==enable)
	  begin
		  gpio_we =1'b1;
                  gpio_data_in=pwdata;
                  prdata=32'b0;
	  end
	  else if(!pwrite&&state==enable)
          begin 
	           gpio_we=1'b0;
		   prdata=gpio_data_out;
		   gpio_data_in=32'b0;
	   end
	   else
	   begin
		   gpio_we=1'b0;
	           gpio_data_in=32'b0;
		   prdata=32'b0;
	   end

   end
   always@(posedge pclk)
   begin
	   pready<=t;
end

	   assign t=(state==enable)?1'b1:1'b0;
	   assign sys_clk=pclk;
	   assign sys_rst=preset;
	   assign gpio_addr=paddr;
	   assign IRQ=gpio_inta_o;
  
   endmodule


                   





