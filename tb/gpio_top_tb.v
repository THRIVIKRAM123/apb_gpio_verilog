module gpio_top_tb();

    reg pclk;
    reg preset;
    reg ext_clk_pad_i;
    reg psel;
    reg penable;
    reg pwrite;
    reg [31:0]paddr;
    reg [31:0]pwdata;
    reg [31:0]aux_in;
    wire pready;
    wire [31:0]prdata;
    wire IRQ;
    wire [31:0]io_pad;
    
   // wire [31:0] out_pad_o;
   // wire [31:0] oen_padoe_o;
    
	//internal varables
	reg [31:0]inp;
	reg [31:0]sig;

//	assign io_pad=(sig & inp) | (~sig & 1'bz);
	genvar j;
	generate
		for(j=0;j<32;j=j+1)
		begin:B1
			
			assign io_pad[j]=(sig[j])?inp[j]:1'bz;
		end
	endgenerate

    
    gpio_top DUT(pclk,ext_clk_pad_i,preset,psel,penable,pwrite,paddr,pwdata,aux_in,pready,prdata,IRQ,io_pad);
    //clock gneeration
    initial
    begin
        pclk=1'b0;
        forever
        #5 pclk=~pclk;
    end
    
    initial
    begin
       ext_clk_pad_i =1'b0;
        forever
        #10 ext_clk_pad_i=~ext_clk_pad_i;
    end
    
    task apb_write(input [31:0]addr,input [31:0]data);
        begin
            @(negedge pclk);
                psel <= 1;
                penable <= 0;
                pwrite <= 1;
                paddr <= addr;
                pwdata <= data;
                @(negedge pclk)
                penable <= 1;
                @(negedge pclk);
                @(negedge pclk);
                psel <=0;
                penable <=0;
          end
      endtask


    task apb_read(input [31:0] addr);
    begin
      @(negedge pclk);
          psel <= 1; penable <= 0; pwrite <= 0;
          paddr <= addr;
          @(negedge pclk);
          penable <= 1;
        @(negedge pclk);
        @(negedge pclk);
            psel <= 0; penable <= 0;
         $display("Read from %h = %h", addr, prdata);
        end
      endtask
	  
	task reset;
    	begin
		@(negedge pclk)
      		preset = 0;
      		psel = 0; penable = 0; pwrite = 0;
      		paddr = 0; pwdata = 0;
      		aux_in = 0;
      		@(negedge pclk);
		preset = 1;
	end
        endtask

	initial
	begin
	reset;

	
	// Set some GPIO pins as output
	sig=32'h00000000;
	apb_write(32'h08, 32'hFFFF0000); // rgpio_oe
	apb_write(32'h04, 32'hA5A5A5A5); // rgpio_out
	#50;
	apb_read(32'h04);

	

       
	// Test AUX output mux	
	sig=32'h00000000;
	apb_write(32'h08, 32'hFFFFFFFF); // rgpio_oe
    	aux_in = 32'hF0F0F0F0;
    	apb_write(32'h014, 32'hFFFFFFFF);//aux_reg
    	#40;
        apb_write(32'h014, 32'h00000000);
	
	
        $display("AUX out_pad_o = %h (expected F0F0F0F0)", io_pad);


	
	// Test reading GPIO input
	apb_write(32'h08, 32'h00000000); // rgpio_oe
	sig=32'hAAAAAAAA;
        inp = 32'h12345678;
 	inp = io_pad;
        #40;
	sig=32'h55555555;
        inp = 32'h12345678;
	#40;
	sig=32'hFFFFFFFF;
        inp = 32'h12345678;
	#40;
	sig=32'h00000000;
        inp = 32'h12345678;
	#40;
	//#40;
	sig=32'hFFFFFFFF;	

	

        //apb_read(32'h00); // rgpio_in
	

    
    // Test interrupt logic at polled input
    sig=32'hFFFFFFFF;
    inp = 32'h12345678;
    apb_write(32'h0C, 32'h000000FF); // rgpio_inte (enable lower 8 bits)
    apb_write(32'h10, 32'h000000FF); // rgpio_ptrig (rising edge)
    apb_write(32'h18, 32'h00000001); // rgpio_ctrl (INTE = 1)
    #40;
    inp = 32'h00000001;
    #10;
    apb_read(32'h01C);
	// Clear interrupt
    apb_write(32'h01C, 32'h00000000);
    #40;    
    inp = 32'h00000003;
    #40;
    //$display("Interrupt Status = %h", gpio_inta_o);
    apb_read(32'h01C); // rgpio_ints

    // Clear interrupt
    apb_write(32'h01C, 32'h00000000);
    apb_read(32'h01C);
    


   		
	// Test external clock sampling
sig=32'hFFFFFFFF;
 inp = 32'hCCCCCCCC;
	
   apb_write(32'h020, 32'hFFFFFFFF); // ECLK enable
   apb_write(32'h024, 32'h00000000); // NEC = 0 (rising edge)
    
	






	#50 $finish;


	end



endmodule
