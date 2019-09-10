//module Digi_Clock (rst_sig, rst, clk_50, i_Sec, i_Min, i_Hour, o_Sec, o_Min, o_Hour);

module upscale_timer (rst, clk_50, i_Sec, i_Min, i_Hour, o_Sec, o_Min, o_Hour);

input rst, clk_50;
input[5:0] i_Sec, i_Min;
input[4:0] i_Hour;

output o_Sec, o_Min, o_Hour;
reg [5:0] o_Sec, o_Min, o_Hour;


reg [30:0] count;
reg [5:0] sec, min, hour;

/*
always @ (rst) //initialize values => only at once
begin 
	if (rst == 'b1)
		begin
			sec <= i_Sec; 
			min <= i_Min;
			hour <= i_Hour;
		end
end
*/

always @ (posedge clk_50)
	begin
	count <= count + 1;
	
	if (rst == 'b1)		//set rst signal to initializing values => only at once
		begin 
			sec <= i_Sec; 
			min <= i_Min;
			hour <= i_Hour;
		
		end
	
		 //(count == 'd50_000_000)
		if (count == 'd5)
			begin 
				count <= 'd0;
				sec <= sec + 'd1;
			end
		if (sec == 'd60)
			begin
				sec <= 'd0;
				min <= min + 'd1;
			end
		if (min == 'd60)
			begin
				min <= 'd0;
				hour <= hour +'d1;
			end
		
			
		o_Sec <= sec;
		o_Min <= min;
		o_Hour <= hour;
	end
endmodule

module FND_Inverter (clk, rst, data_1, data_2, data_3, fnd_1, fnd_2, fnd_3, fnd_4, fnd_5, fnd_6);

input clk, rst;
input [12:0] data_1, data_2, data_3;

output fnd_1, fnd_2, fnd_3, fnd_4, fnd_5, fnd_6;
reg [7:0] fnd_1, fnd_2, fnd_3, fnd_4, fnd_5, fnd_6;
always @ (posedge clk)
	begin
		if (data_1 >= 'd10)
			begin
				fnd_1 = data_1 / 'd10; // _0
				fnd_2 = data_1 % 'd10; // 0_
			end
		else fnd_1 = 'b1;

		if (data_2 >= 'd10)
			begin
				fnd_3 = data_2 / 'd10; // _0
				fnd_4 = data_2 % 'd10; // 0_
			end
		else fnd_3 = 'b1;

		if (data_3 >= 'd10)
			begin
				fnd_5 = data_3 / 'd10; // _0
				fnd_6 = data_3 % 'd10; // 0_
			end
		else fnd_5 = 'b1;
	end

endmodule


module clock_Modifier (clk, rst, up_btn, st_btn, mode_btn, in_Sec, in_Min, in_Hour, out_Sec, out_Min, out_Hour,);

input clk, rst, up_btn, st_btn, mode_btn;
input [5:0] in_Sec, in_Min, in_Hour;

output out_Sec, out_Min, out_Hour;

reg [5:0] out_Sec, out_Min, out_Hour;

reg [5:0] Sec, Min, Hour;
reg [2:0] state;

always @ (posedge clk)
begin
	
Sec <= in_Sec;
Min <= in_Min;
Hour <= in_Hour;


	if (rst == 1)
		begin
			state <= 3'b111; //initialize 
		end

	if (st_btn == 1) //how to work only at one time
		begin
			state <= state + 3'b1;
		
			if (state == 3'b011) //end number
				begin
					state <= 3'b000;
				end
		end


	if (up_btn == 1)
		begin
			case (state) //unit change
			3'b000 :	begin //End of Modify -> config to 7-segment
							out_Sec <= Sec;
							out_Min <= Min;
							out_Hour <= Hour;
							
						end
			3'b001 : begin //Modify Second 1
							Sec <= Sec + 'b1;
						end
						
			3'b010 : begin //Modify Minute 2
							Min <= Min + 'b1;
						end
						
			3'b011 : begin //Modify Hour 3
							Hour <= Hour + 'b1;
						end
						
			
			3'b111: begin
							state <= 3'b001;
						end
			endcase
		end
end

endmodule


module Digi_Clock (clk, rst, up_btn, st_btn, mode_btn, fnd1, fnd2, fnd3, fnd4, fnd5, fnd6);
//clock module
input clk, rst;
//input [5:0] in_Sec, in_Min, in_Hour;


output fnd1, fnd2, fnd3, fnd4, fnd5, fnd6;

reg [5:0] out_Sec, out_Min, out_Hour;

//wire [5:0] Sec, Min, Hour;
//wire [5:0] sec, min, hour;
reg [5:0] n_Sec, n_Min, n_Hour;
wire [7:0] fnd1, fnd2, fnd3, fnd4, fnd5, fnd6;
wire [5:0] data1, data2, data3;
wire [5:0] t2r_Sec, t2r_Min, t2r_Hour;
wire [5:0] r2t_Sec, r2t_Min, r2t_Hour;
wire [5:0] m2r_Sec, m2r_Min, m2r_Hour;
wire [5:0] r2m_Sec, r2m_Min, r2m_Hour;

upscale_timer ut (.rst(rst), .clk_50(clk), .i_Sec(r2t_Sec [5:0]), .i_Min(r2t_Min [5:0]), .i_Hour(r2t_Hour [5:0]), 
															.o_Sec(t2r_Sec [5:0]), .o_Min(t2r_Min [5:0]), .o_Hour(t2r_Hour [5:0]));

clock_Modifier cm (.clk(clk), .rst(rst), .up_btn(up_btn), .st_btn(st_btn), .mode_btn(mode_btn), .in_Sec(r2m_Sec [5:0]),
														
														.in_Min(r2m_Min [5:0]), .in_Hour(r2m_Hour [5:0]), .out_Sec(m2r_Sec [5:0]),
																	.out_Min(m2r_Min [5:0]), .out_Hour(m2r_Hour [5:0]));

always @ (posedge clk)
begin
//giving now time to timer
assign  r2t_Sec = n_Sec;
assign  r2t_Min = n_Min; 
assign  r2t_Hour = n_Hour;

//change register`s value with timer`s one
assign  n_Sec = t2r_Sec;
assign  n_Min = t2r_Min;
assign  n_Hour = t2r_Hour;

//give data to FND_inverter
assign data1 = n_Sec;
assign data1 = n_Min;
assign data1 = n_Hour;

//modify now time
assign n_Sec = m2r_Sec;
assign n_Min = m2r_Min;
assign n_Hour = m2r_Hour;

//give modifier now time
assign r2m_Sec = n_Sec;
assign r2m_Min = n_Min;
assign r2m_Hour = n_Hour;
end
FND_Inverter fin (.clk(clk), .rst(rst), .data_1(data1[5:0]), .data_2(data2[5:0]), .data_3(data3[5:0]),
 .fnd_1(fnd1 [7:0]), .fnd_2(fnd2 [7:0]), .fnd_3(fnd3 [7:0]), .fnd_4(fnd4 [7:0]), .fnd_5(fnd5 [7:0]), .fnd_6(fnd6 [7:0]));

endmodule