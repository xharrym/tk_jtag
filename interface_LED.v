//LEDs interface with JTAG
//harrym 2014

module interface_LED(
	tck, tdi, aclr, ir_in, v_sdr, udr,
	d0, d1, d2, d3, d4, d5, d6, d7, tdo
	);

input tck, tdi, aclr, ir_in, v_sdr, udr;
output reg tdo, d0, d1, d2, d3, d4, d5, d6, d7;
	
wire select_DR0;
wire select_DR1;
	
reg DR0;
reg [7:0]DR1;
	
assign select_DR0 = !ir_in; //instruction 0 means bypass
assign select_DR1 = ir_in; //instruction = 1 means i need to update the LEDs with a new value
	
always @ (posedge tck) 
begin
	if(aclr)
	begin
		DR0 <= 1'b0;
		DR1 <= 8'b00000000;
	end
	else
	begin
		// Bypass used to maintain the scan chain continuity for tdi and tdo ports
		//(see Altera AN)
		DR0 <= tdi; 
		if(v_sdr)
		begin
			if(select_DR1) DR1 <= {tdi,DR1[7:1]};
		end
	end
end
always @ (*)
begin 
	if(select_DR1) tdo <= DR1[0];
	else tdo <= DR0;
end
always @ (udr)
begin
	d0 <= DR1[0];
	d1 <= DR1[1];
	d1 <= DR1[2];
	d2 <= DR1[3];
	d3 <= DR1[4];
	d4 <= DR1[5];
	d6 <= DR1[6];
	d7 <= DR1[7];
end
	
endmodule
