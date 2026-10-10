module uartTx
#(
	parameter CLK_FREQ = 50000000,
	parameter BAUD_RATE =  115200
) (
	 input  logic      clk,
	 input  logic      reset,
	 input  logic      start,
         input  logic[7:0] data,

	 output logic      tx,
         output logic      busy
);

	typedef enum logic[1:0] {IDLE, START, DATA, STOP} statetype;

	statetype state, next_state;

	logic [2:0] bit_count = 0;
	logic       load;
	logic       bit_in    = 0;
	logic       bit_out;
	logic       baud_tick;


	BaudGenerator #(
		.CLK_FREQ(CLK_FREQ),
		.BAUD_RATE(BAUD_RATE)

	) baud (
		clk,
		reset,
		baud_tick
	);

	ShiftRegister serializer(
		clk,
		baud_tick,
		reset,
		load,
		bit_in,
		data,
		bit_out
	);


	always_ff @(posedge clk, posedge reset) begin 

		if(reset)          state <= IDLE;
		else if(baud_tick) state <= next_state;
                	
	end 

	always_ff @(posedge clk, posedge reset) begin

		if(reset)               bit_count <= 0;
		else if(baud_tick) begin 

			if(bit_count == 7) bit_count <= 0;
	        	else               bit_count <= bit_count + 1;
		end

	end 

	always_comb begin
		case(state)
			IDLE: begin 
			        next_state  = start ? START : IDLE;
			        tx = 1;
				busy = 0;
                        end

			START: begin 
			        next_state = DATA;
				tx = 0;
				busy = 1;
			end
			DATA: begin
				if(bit_count == 7) begin
					next_state = STOP;
					load = 0;
					tx = bit_out;
				end
				else if(bit_count == 0) begin
					next_state = DATA;
					load = 1;
					tx = bit_out;
				end
				else begin
					next_state = DATA;
					load = 0;
					tx = bit_out;
				end
				busy = 1;
			end 
			STOP: begin
				next_state =  IDLE;
				tx = 1;
				busy = 1;
			end
			default: begin 
				load = 0;
				busy = 0;
				tx   = 1;
				next_state = IDLE;
		        end
		endcase
	end
	
	

endmodule 


