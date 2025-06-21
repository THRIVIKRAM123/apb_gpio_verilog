`define  GPIO_RGPIO_OUT 32'h04
`define  GPIO_RGPIO_OE  32'h08
`define  GPIO_RGPIO_PTRIG 32'h010
`define  GPIO_RGPIO_AUX   32'h014
`define  GPIO_RGPIO_ECLK  32'h020
`define  GPIO_RGPIO_NEC 32'h024
`define  GPIO_RGPIO_CTRL 32'h18
`define  GPIO_RGPIO_CTRL_INTE 1'b0
`define  GPIO_RGPIO_CTRL_INTS 1'b1
`define  GPIO_RGPIO_IN  32'h00
`define  GPIO_RGPIO_INTE  32'h0C
`define  GPIO_RGPIO_INTS  32'h01C

module gpio_interface(input sys_clk,sys_rst,gpio_we,input [31:0]gpio_adr,input [31:0]gpio_dat_i,input [31:0]aux_i,output reg [31:0]gpio_dat_o,output reg gpio_inta_o,output [31:0]out_pad_o,output [31:0]oen_padoe_o,input [31:0]in_pad_i,input gpio_eclk);
reg [31:0]rgpio_out;
reg [31:0]rgpio_oe;
reg [31:0]rgpio_aux;
reg [31:0]rgpio_ptrig;
reg [31:0]rgpio_eclk;
reg [31:0]rgpio_nec;
reg [31:0]rgpio_in;
reg [1:0]rgpio_ctrl;
reg [31:0]rgpio_ints;
reg [31:0]rgpio_inte;
reg [31:0]data_reg;
wire [31:0]a,b,c,d,e,f,g;

//=========================rgpio_out===============================
assign a=(gpio_adr==`GPIO_RGPIO_OUT && gpio_we)?gpio_dat_i:rgpio_out;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_out<=32'h0;
	else
		rgpio_out<=a;
end  
//=========================rgpio_oe=================================
assign b=(gpio_adr==`GPIO_RGPIO_OE&&gpio_we)?gpio_dat_i:rgpio_oe;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_oe<=32'h0;
	else
		rgpio_oe<=b;
end
assign oen_padoe_o=rgpio_oe;
//=========================rgpio_ptrig=================================
assign c=(gpio_adr==`GPIO_RGPIO_PTRIG&&gpio_we)?gpio_dat_i:rgpio_ptrig;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_ptrig<=32'h0;
	else
		rgpio_ptrig<=c;
end
//=========================rgpio_aux=================================
assign d=(gpio_adr==`GPIO_RGPIO_AUX&&gpio_we)?gpio_dat_i:rgpio_aux;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_aux<=32'h0;
	else
		rgpio_aux<=d;
end
//=========================rgpio_eclk=================================
assign e=(gpio_adr==`GPIO_RGPIO_ECLK&&gpio_we)?gpio_dat_i:rgpio_eclk;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_eclk<=32'h0;
	else
		rgpio_eclk<=e;
end
//=========================rgpio_nec=================================
assign f=(gpio_adr==`GPIO_RGPIO_NEC&&gpio_we)?gpio_dat_i:rgpio_nec;
always@(posedge sys_clk)
begin									
	if(sys_rst)
		rgpio_nec<=32'h0;
	else
		rgpio_nec<=f;
end
//=========================rgpio_inte==============================
assign g=(gpio_adr==`GPIO_RGPIO_INTE&&gpio_we)?gpio_dat_i:rgpio_inte;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_inte<=32'h0;
	else
		rgpio_inte<=g;
end

//=======================gpio_inta_o==============================
//assign gpio_inta_o=(rgpio_ints&rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE])|(~rgpio_ints&32'h0);
always@(posedge sys_clk)
begin
	if(|rgpio_ints)
		gpio_inta_o<=rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE];
	else
		gpio_inta_o<=1'b0;
end
//=======================out_pad_o================================
wire [31:0]w1,w2;
assign w1=rgpio_out&(~rgpio_aux);
assign w2=aux_i&rgpio_aux;
assign out_pad_o=w1|w2;
//======================rgpio_in================================
reg [31:0]pextc_sampled;
reg [31:0]nextc_sampled;
wire [31:0]extc_in;
wire [31:0]in_mux;
always@(posedge gpio_eclk)
begin
	if(sys_rst)
		pextc_sampled<=32'h0;
	else
		pextc_sampled<=in_pad_i;
end
always@(negedge	gpio_eclk)
begin
	if(sys_rst)
		nextc_sampled<=32'h0;
	else
		nextc_sampled<=in_pad_i;
end
assign extc_in=(rgpio_nec&nextc_sampled)|(~rgpio_nec&pextc_sampled);
assign in_mux=(rgpio_eclk&extc_in)|(~rgpio_eclk&in_pad_i);
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_in<=32'h0;
	else
		rgpio_in<=in_mux;
end
//===================rgpio_ctrl==================================
wire [1:0]w3,w4;
assign w3=(rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE])?({rgpio_ctrl[`GPIO_RGPIO_CTRL_INTS]|gpio_inta_o,rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE]}):rgpio_ctrl;
assign w4=((gpio_adr==`GPIO_RGPIO_CTRL)&&gpio_we)?gpio_dat_i[1:0]:w3;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_ctrl<=2'h0;
	else
		rgpio_ctrl<=w4;
end
//==================rgpio_ints=================================
wire [31:0]w5,w6,w7,w8,w9,w10;
assign w5=rgpio_in^in_mux;
assign w6=rgpio_ptrig^~in_mux;
assign w7=w5&w6&(rgpio_inte);
assign w8=rgpio_ints|w7;
assign w9=(rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE])?w8:rgpio_ints;
assign w10=((gpio_adr==`GPIO_RGPIO_INTS)&&gpio_we)?gpio_dat_i[31:0]:w9;
always@(posedge sys_clk)
begin
	if(sys_rst)
		rgpio_ints<=32'h0;
	else
		rgpio_ints<=w10;
end
//==================data_reg=================================
always@(*)
begin
	case(gpio_adr)
`GPIO_RGPIO_OUT:data_reg=rgpio_out;
`GPIO_RGPIO_OE:data_reg=rgpio_oe;
`GPIO_RGPIO_PTRIG:data_reg=rgpio_ptrig;
`GPIO_RGPIO_AUX:data_reg=rgpio_aux;
`GPIO_RGPIO_ECLK:data_reg=rgpio_eclk;
`GPIO_RGPIO_NEC:data_reg=rgpio_nec;
`GPIO_RGPIO_CTRL:data_reg=rgpio_ctrl;
`GPIO_RGPIO_IN:data_reg=rgpio_in;
`GPIO_RGPIO_INTE:data_reg=rgpio_inte;

`GPIO_RGPIO_INTS:data_reg=rgpio_ints;
default:data_reg=32'h00;
endcase
end
//==============gpio_data_o=================================
always@(posedge sys_clk)
begin
	if(sys_rst)
		gpio_dat_o<=32'h0;
	else
		gpio_dat_o<=data_reg;
end
endmodule
