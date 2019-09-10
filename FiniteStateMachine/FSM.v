module FSM (clk, reset, sel_btn, return_btn, coin, coin_val, confirm, coin_in, coin_out, product_make);
	input clk, reset;
	input sel_btn;
	input return_btn;
	input wire coin;
	input coin_val;
	
	output reg coin_in, coin_out, confirm;
	
	output reg product_make;
	
	
	reg [3:0] now_state, next_state;
	
	parameter idle = 0, selection_st = 1, ready_st = 2, product_out = 3, return_st = 5;
	parameter product_val = 1;
	
	always @(sel_btn, return_btn, coin)
	begin
		next_state = now_state;
		
		case(now_state)
		idle : if (coin == 1) next_state = selection_st;
		selection_st : begin
			if (return_btn == 1) next_state = return_st;
			else if (coin_val >= product_val) next_state = ready_st;
			end
		ready_st : begin
			if (return_btn == 1) next_state = return_st;
			else if (sel_btn == 1) next_state = product_out;
			end
		product_out : if (coin_val != 0) next_state = return_st;
		return_st : if (coin_val == 0) next_state = idle ;
		default : next_state = idle;
		endcase
	end
	
	always @(posedge clk)
	begin
	if (reset == 1) now_state <= idle;
	else now_state <= next_state;
	end
	
	always @ (now_state)
		begin
			coin_in=0;
			coin_out =0;
			confirm=0;
			product_make =0;
			
			case (now_state)
			idle: 			begin
									coin_in = 0;
									confirm = 0;
									coin_out = 0;
									product_make = 0;
								end
			selection_st: 		coin_in = 1;
			ready_st: 		begin 
									coin_in = 1; 
									confirm = 1;
								end
			product_out: 	begin
									coin_in = 1; 
									confirm = 1;
									product_make = 1;
								end
			return_st:		begin
									coin_in = 0;
									coin_out = 1;
								end
			default: ;
			endcase
		end
			
	
	endmodule