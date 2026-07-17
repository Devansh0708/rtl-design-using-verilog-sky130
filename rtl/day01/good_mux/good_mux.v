
module good_mux (input i0 , input i1 , input sel , output reg out);
always @ (*)
begin
	if(sel)
	        out <= i1;
	else 
		out <= i0;
end
endmodule
