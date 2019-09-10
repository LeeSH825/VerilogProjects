module upscale_timer (rst_sig, rst, clk_50, i_Sec, i_Min, i_Hour, o_Sec, o_Min, o_Hour);

input rst, rst_sig, clk_50;
input[5:0] i_Sec, i_Min;
input[4:0] i_Hour;

output o_Sec, o_Min, o_Hour;
reg [5:0] o_Sec, o_Min, o_Hour;

reg [30:0] count;
reg [5:0] sec, min, hour;


always @ (posedge clk_50)
	begin
	count <= count + 1;
	
	if (rst_sig == 'b1) //stop
		begin
			count <= 'b0;
			sec <= 'b0;
			min <= 'b0;
			hour <= 'b0;
		end
	if (rst == 'b1)
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

module Clock (in_Sec, in_Min, in_Hour, in_Day, in_Mon, in_Year, clk, rst, change_unit, out_Sec, out_Min, out_Hour, out_Day, out_Mon, out_Year);

input clk, rst, change_unit;
input [5:0] in_Sec, in_Min, in_Hour;
input [4:0] in_Day, in_Mon;
input [12:0] in_Year;

output out_Sec, out_Min, out_Hour, out_Day, out_Mon, out_Year;
reg [5:0] out_Sec, out_Min, out_Hour;
reg [4:0] out_Day, out_Mon;
reg [12:0] out_Year;

//wire [5:0] Sec, Min, Hour;
wire [5:0] sec, min, hour;
reg [5:0] Sec, Min, Hour;
reg [4:0] Day, Mon;
reg [12:0] Year;

upscale_timer(.rst(rst), .clk_50(clk), .i_Sec(in_Sec), .i_Min(in_Min), .i_Hour(in_Hour), .o_Sec(sec [5:0]), .o_Min(min [5:0]), .o_Hour(hour [5:0]));

always @ (posedge clk)
	begin
	
		Sec <= sec [5:0];
		Min <= min [5:0];
		Hour <= hour [5:0];
	
		Sec <= in_Sec;
		Min <= in_Min;
		Hour <= in_Hour;
		Day <= in_Day;
		Mon <= in_Mon;
		Year <= in_Year;
		
		if (Hour >= 24)
			begin
				Hour <= Hour % 'd24;
				Day <= Day + 'd1;
			end
	
		case(Mon) //last day
		5'd1 : begin
					if (Day == 31)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd2 : begin
					if(0 == Year % 4 && 0 != Year % 100 || 0 == Year % 400) //if it's leap year
						begin
							if (Day == 29)
								begin
									Day <= 5'd0;
									Mon <= Mon + 5'd1;
								end
						end
					else
						begin
							if (Day == 28)
								begin
									Day <= 5'd0;
									Mon <= Mon + 5'd1;
								end
						end
				end
		5'd3 : begin
					if (Day == 31)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd4 : begin
					if (Day == 30)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd5 : begin
					if (Day == 31)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd6 : begin
					if (Day == 30)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd7 : begin
					if (Day == 31)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd8 : begin
					if (Day == 31)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd9 : begin
					if (Day == 30)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd10 : begin
					if (Day == 31)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd11 : begin
					if (Day == 30)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		5'd12 : begin
					if (Day == 31)
						begin
							Day <= 5'd0;
							Mon <= Mon + 5'd1;
						end
				end
		endcase
		
		if(Mon == 12)
			begin
				Mon <= 5'd1;
				Year <= Year +1;
			end
			
	out_Sec <= Sec;
	out_Min <= Min;
	out_Hour <= Hour;
	out_Day <= Day;
	out_Mon <= Mon;
	out_Year <= Year;
	
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

module clock_Modifier (clk, rst, up_btn, st_btn, mode_btn, in_Sec, in_Min, in_Hour, in_Day, in_Mon, in_Year, out_Sec, out_Min, out_Hour, out_Day, out_Mon, out_Year);

input clk, rst, up_btn, st_btn, mode_btn;

input [5:0] in_Sec, in_Min, in_Hour;
input [4:0] in_Day, in_Mon;
input [12:0] in_Year;

output out_Sec, out_Min, out_Hour, out_Day, out_Mon, out_Year;

reg [5:0] out_Sec, out_Min, out_Hour;
reg [4:0] out_Day, out_Mon;
reg [12:0] out_Year;

reg [5:0] Sec, Min, Hour;
reg [4:0] Day, Mon;
reg [12:0] Year;
reg [2:0] state;

/*
always @ (negedge rst)  
begin
	if (!rst)
		begin
			state <= 3'b111; //state initial set
		end
end


always @ (negedge st_btn)
begin
	if (!st_btn)
		begin
			state <= state + 3'b1;
		
			if (state == 3'b110) //end number
				begin
					state <= 3'b000;
				end
		end
end
*/

always @ (posedge clk)
begin
	
Sec <= in_Sec;
Min <= in_Min;
Hour <= in_Hour;
Day <= in_Day;
Mon <= in_Mon;
Year <= in_Year;

	if (rst == 1)
		begin
			state <= 3'b111; //initialize 
		end

	if (st_btn == 1) //how to work only at one time
		begin
			state <= state + 3'b1;
		
			if (state == 3'b110) //end number
				begin
					state <= 3'b000;
				end
		end


	if (up_btn == 1)
		begin
			case (state) //unit change
			3'b000 :	begin //End of Modify -> config to 7-segment
							out_Sec <= 'b110;
							out_Min <= 'b110;
							out_Hour <= 'b110;
							out_Day <= 'b110;
							out_Mon <= 'b110;
							out_Year <= 'b110;
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
						
			3'b100 : begin //Modify Day 4
							Day<= Sec + 'b1;
						end
						
			3'b101 : begin //Modify Month 5 
							Mon <= Mon + 'b1;
						end
						
			3'b110 : begin //Modify Year 6
							Year <= Year + 'b1;
						end
			3'b111: begin
							state <= 3'b001;
						end
			endcase
		end
		
	out_Sec <= Sec;
	out_Min <= Min;
	out_Hour <= Hour;
	out_Day <= Day;
	out_Mon <= Mon;
	out_Year <= Year;
end

endmodule

module up_counter (clk, rst, st_btn, out_Sec, out_Min, out_Hour);

input clk, st_btn;
input rst;
wire rst;

output out_Sec, out_Min, out_Hour;

//reg rst_sig;
reg [5:0] temp_sec, temp_min, temp_hour;

upscale_timer uc1 (.rst(rst), .clk_50(clk), .i_Sec(temp_sec), .i_Min(temp_min), .i_Hour(temp_hour), .o_Sec(out_Sec), .o_Min(out_Min), .o_Hour(out_Hour));

/*
always @ (negedge rst)
begin
	if (!rst) //initialize
		begin
			temp_sec = 6'b0;
			temp_min = 6'b0;
			temp_hour = 6'b0;
		end
end
*/
always @ (posedge clk)
begin
	if (rst == 1)
		begin
			temp_sec = 6'b0;
			temp_min = 6'b0;
			temp_hour = 6'b0;
		end
	temp_sec <= out_Sec;
	temp_min <= out_Min;
	temp_hour <= out_Hour;
	/*
	if (st_btn == 1)
		begin
			 //rst_sig = 'b1;
			 //rst <= rst_sig;\
			// rst <= 'b1;
		end
	*/
end

/*
always @ (posedge st_btn)
begin
	rst <= 'b1; //set all to 0
end
*/

	
endmodule

module alarm (clk, rst, up_btn, st_btn, mode_btn, in_Sec, in_Min, in_Hour, data1, data2, data3);

input clk, rst, up_btn, st_btn, mode_stn;
input in_Sec, in_Min, in_Hour;
wire [5:0] in_Sec, in_Min, in_Hour;

output [12:0] data1, data2, data3;

reg [5:0] Sec, Min, Hour;
reg [5:0] a_Sec, a_Min, a_Hour;

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
		
			if (state == 3'b110) //end number
				begin
					state <= 3'b000;
				end
		end


	if (up_btn == 1)
		begin
				
			case (state) //unit change
			3'b000 :	begin //End of Modify -> config to 7-segment
							if (mode_btn == 1)
								begin
									//??
								end
						end
			3'b001 : begin //Modify Second 1
							if (a_Sec !== Sec)
								begin
									a_Sec <= a_Sec + 'b1;
								end
							else
								
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
	if(Sec == in_Sec && Min == in_Min && Hour == in_Hour)
		begin
			
		end

endmodule

module Digital_Clock (clk_50, rst, up_btn, st_btn, mode_btn, FND_1, FND_2, FND_3, FND_4, FND_5, FND_6);

input clk_50, rst, up_btn, st_btn, mode_btn;

output FND_1, FND_2, FND_3, FND_4, FND_5, FND_6;
wire [2:0] FND_1, FND_2, FND_3, FND_4, FND_5, FND_6;

wire sec, min, hour, day, mon, year; //wire from outputs of clock
wire sec1, min1, hour1, day1, mon1, year1; //wire from outputs of modifier
wire data1, data2, data3; //choose what data can go to FND
reg [2:0] state;
reg modifying;


always @ (negedge rst)
begin
	if (!rst)
		begin
			state <= 3'b111; //state initial set
			modifying <= 'b0;
		end
end

always @ (posedge mode_btn) //mode change
begin

	state <= state + 3'b1;
	
	if (state == 3'b101 || state ==3'b111)
		begin
			state <= 3'b000;
		end
end

Clock c1 (.in_Sec(sec1), .in_Min(min1), .in_Hour(hour1), .in_Day(day1), .in_Mon(mon1), .in_Year(year1), .clk(clk_50), .rst(rst), .change_unit(st_btn), .out_Sec(sec), .out_Min(min), .out_Hour(hour), .out_Day(day), .out_Mon(mon), .out_Year(year));

clock_Modifier m1 (.clk(clk_50), .rst(rst), .up_btn(up_btn), .st_btn(st_btn), .mode_btn(mode_btn), .in_Sec(sec), .in_Min(min), .in_Hour(hour), .in_Day(day), .in_Mon(mon), .in_Year(year), .out_Sec(sec1), .out_Min(min1), .out_Hour(hour1), .out_Day(day1), .out_Mon(mon1), .out_Year(year1));

FND_Inverter i1 (.clk(clk_50), .rst(rst), .data_1(sec), .data_2(min), .data_3(hour), .fnd_1(FND_1 [2:0]), .fnd_2(FND_2 [2:0]), .fnd_3(FND_3 [2:0]), .fnd_4(FND_4 [2:0]), .fnd_5(FND_5 [2:0]), .fnd_6(FND_6 [2:0]));
//upper one: Sec, Min, Hour to FND

up_counter uc (.clk(clk_50), .rst(rst), .st_btn(st_btn), .out_Sec(data1), .out_Min(data2), .out_Hour(data3));


endmodule