module Edge_Detector(clk, rst, inA, outA);

input clk, rst, inA;
output outA;

reg inA_delay;
reg outA;

always @ (posedge clk or negedge rst)
begin
	if (!rst)
		begin
			inA_delay <= 1'b0;
			outA <= 1'b0;
		end
	else
		begin
			inA_delay <= inA;
			outA <= outA_delay;
		end
end

assign outA_delay = (inA^inA_delay);

endmodule