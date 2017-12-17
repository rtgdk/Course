module decoder2_4(Out, In);
  input [1:0] In;
  output  [3:0] Out;
  assign  Out[0] = (~In[1] & ~In[0]),
          Out[1] = (~In[1] & In[0]),
          Out[2] = (In[1] & ~In[0]),
          Out[3] = (In[1] & In[0]);
endmodule

/*module tb_decoder2_4;
	reg [1:0] In;
	wire [3:0] Out;
	decoder2_4 dec(Out, In);
	
	initial
		begin
			$monitor($time, "output = %d, input = %d", Out, In);
			#5 In = 2'b01;
			#5 In = 2'b00;
			#5 In = 2'b10;
			#5 In = 2'b11;
			#5 $finish;
		end
endmodule*/