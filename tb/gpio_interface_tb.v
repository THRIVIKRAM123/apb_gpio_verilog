module gpio_interface_tb();
reg sys_clk,sys_rst;
reg [31:0]gpio_dat_i;
reg [31:0]gpio_adr;
reg [31:0]aux_i;
reg gpio_we;
wire [1:0]gpio_dat_o;
wire gpio_inta_o;
wire [31:0]out_pad_o;
wire [31:0]oen_padoe_o;
reg [31:0]in_pad_i;
reg gpio_eclk;

gpio_interface dut(sys_clk,sys_rst,gpio_we,gpio_adr,gpio_dat_i,aux_i,gpio_dat_o, gpio_inta_o,out_pad_o,oen_padoe_o,in_pad_i,gpio_eclk);

initial
begin
	sys_clk=1'b0;
	forever #5
	sys_clk=~sys_clk;
end

    
    initial
    begin
       gpio_eclk =1'b1;
        forever
        #10 gpio_eclk=~gpio_eclk;
    end
    
    task write(input [31:0]addr,input [31:0]data);
    begin
        @(negedge sys_clk)
            gpio_adr <= addr;
            gpio_dat_i <= data;
            gpio_we <=1;
        @(negedge sys_clk)
            gpio_we <=0;
    end
    endtask
	
	 task read;
    input [31:0] addr;
    begin
      @(negedge sys_clk);
      gpio_adr <= addr;
      gpio_we <= 0;
     // @(negedge sys_clk);
      $display("Read @ %h = %h", addr, gpio_dat_o);
    end
  endtask

  task reset;
    begin
      sys_rst <= 1;
      gpio_we <= 0;
      gpio_adr <= 0;
      gpio_dat_i <= 0;
      aux_i <= 0;
      in_pad_i <= 0;
      @(negedge sys_clk);
      sys_rst <= 0;
    end
  endtask

  // Test Procedure
  initial begin
    sys_clk = 0;
    gpio_eclk = 0;
    reset();
    
    
      // Set some GPIO pins as output
    write(32'h08, 32'hFFFF0000); // rgpio_oe
    write(32'h04, 32'hA5A5A5A5); // rgpio_out
    #10;
    $display("out_pad_o = %h (expected A5A5A5A5)", out_pad_o);
    
     // Test reading GPIO input
     @(negedge sys_clk)
 @(negedge sys_clk)
    in_pad_i = 32'h12345678;
    #10;
    read(32'h00); // rgpio_in
    
 

    // Test interrupt logic
    write(32'h0C, 32'h000000FF); // rgpio_inte (enable lower 8 bits)
    write(32'h10, 32'h000000FF); // rgpio_ptrig (rising edge)
    write(32'h18, 32'h00000001); // rgpio_ctrl (INTE = 1)
    in_pad_i = 32'h00000001;
    #10;
	read(32'h01C);
	// Clear interrupt
    write(32'h01C, 32'h00000000);
	
    in_pad_i = 32'h00000003;
    #10;
    $display("Interrupt Status = %h", gpio_inta_o);
    read(32'h01C); // rgpio_ints

    // Clear interrupt
    write(32'h01C, 32'h00000000);
    read(32'h01C);


	
    // Test AUX output mux
    aux_i = 32'hF0F0F0F0;
    write(32'h014, 32'hFFFFFFFF);
    #10;
    $display("AUX out_pad_o = %h (expected F0F0F0F0)", out_pad_o);
	
	
	// Test external clock sampling
    write(32'h020, 32'hFFFFFFFF); // ECLK enable
    write(32'h024, 32'h00000000); // NEC = 0 (rising edge)
    in_pad_i = 32'hCAFEBABE;
    @(posedge gpio_eclk);
    read(32'h00); // Should latch new input
	#10;
reset();
#20;
	write(32'h020,32'hFFFFFFFF);
	write(32'h024,32'hFFFFFFFF);
	sys_rst=1'b1;
	in_pad_i = 32'hABCDABCD;
	@(posedge gpio_eclk);
	read(32'h00);
	write(32'h4B,32'h00);
	#10;
#50;
	$finish;
	
	end
endmodule

		
		


