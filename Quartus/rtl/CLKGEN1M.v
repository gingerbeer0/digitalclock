module CLKGEN1M(/*AUTOARG*/
                 // Outputs
                 CLK1M,
                 // Inputs
                 CLK, RSTN
                 );
   input CLK;
   input RSTN;
   output reg CLK1M;

   reg [14:0] CNT;

   reg [14:0] NEXT_CNT;
   reg [14:0] NEXT_CLK1M;

   always@(posedge CLK, negedge RSTN) begin
		  if(!RSTN)begin
		     CNT <= 15'd1;
		     CLK1M <= 1'b0;
		  end
		  else begin
		     CNT <= NEXT_CNT;
		     CLK1M <= NEXT_CLK1M;
		  end
   end

   always@(*) begin
		  NEXT_CNT = (CNT == 15'd25000) ? 15'd1 : CNT + 15'd1;
		  NEXT_CLK1M = (CNT == 15'd25000) ? ~CLK1M : CLK1M;
   end
endmodule
