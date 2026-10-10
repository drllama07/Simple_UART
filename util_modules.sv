module ShiftRegister
# (
	parameter LENGTH = 8
  ) (
	input logic               clk,
	input logic               baud_tick,
	input logic               reset,
	input logic               load,
	input logic               bit_in,
	input logic [LENGTH-1:0]  data,

	output logic              bit_out,
	output logic [LENGTH-1:0] parallel_bits
  ); 

        logic [LENGTH-1:0] shifted_bits;

	always_ff @(posedge clk, posedge reset) begin
		if(reset) begin 
			shifted_bits <= {LENGTH{1'b0}};
		end else if(baud_tick) begin 
			shifted_bits <= load ? data : {bit_in, shifted_bits[LENGTH-1:1]};
		end 
	end

	assign bit_out = shifted_bits[0];
	assign parallel_bits = shifted_bits;

endmodule


module BaudGenerator
#(
	parameter CLK_FREQ = 50000000,
	parameter BAUD_RATE =  115200
) ( 
	input   logic      clk,
	input   logic      reset,

        output  logic      baud_tick
);

	localparam MAX_COUNTER = CLK_FREQ / BAUD_RATE;
	logic [31:0] count = 0; 

	always_ff @(posedge clk, posedge reset) begin 
		if(reset) begin 
			baud_tick <= 0;
			count <= 32'b0;
		end else if (count == MAX_COUNTER - 1) begin 
			baud_tick <= 1;
			count <= 32'b0;
		end else begin
			baud_tick <= 0;
			count <= count + 1;
		end 
	end 

endmodule 
