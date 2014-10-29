//LEDs interface with JTAG
//harrym 2014

//INSTRUCTION:
//00: bypass
//01: read dip-switch
//10: update LEDs
//11: not used (=bypass)

module connect(
	tck, tdi, aclr, ir_in, v_sdr, v_udr, v_cdr, v_uir, 
	s1, s2, s3, s4,
	d0, d1, d2, d3, d4, d5, d6, d7, tdo
	);

localparam BYPASS = 2'b00;
localparam DIP		= 2'b01;
localparam LED  	= 2'b10;

input tck, tdi, aclr, v_sdr, v_udr, v_cdr, v_uir;
input [1:0]ir_in;
input s1, s2, s3, s4;
output wire  tdo, d0, d1, d2, d3, d4, d5, d6, d7;

reg [1:0]DR0;
reg [7:0]DR1;
reg [7:0]out = 8'b00000000;
	
assign tdo = (ir_in == BYPASS) ? DR0[0] : DR1[0];

assign d0 = out[0];
assign d1 = out[1];
assign d2 = out[2];
assign d3 = out[3];
assign d4 = out[4];
assign d5 = out[5];
assign d6 = out[6];
assign d7 = out[7];

always @ (posedge tck) 
begin
	if(!aclr) begin
		DR0 <= 1'b0;
		DR1 <= 8'b00000000;
	end
	else begin
		case(ir_in)
			DIP: begin
						if(v_cdr) begin
							DR1 = {4'b0000,s4,s3,s2,s1};
						end
						else 
						begin
							if(v_sdr) begin
								DR1 = {tdi,DR1[7:1]};
							end
						end
					end
					
			LED: begin
						if(v_sdr) begin
							DR1 = {tdi,DR1[7:1]};
						end
					end
						
			BYPASS: begin
							if(v_sdr) begin
									DR0 = {tdi,DR0[1:1]};
							end
						end
							
			default: begin
							if(v_sdr) begin
								DR0 = {tdi,DR0[1:1]};
							end
						end
							
		endcase
	end
end

always @ (v_udr)
begin
	if(ir_in == LED) begin
		out = DR1;
	end
end
	
endmodule