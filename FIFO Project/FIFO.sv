////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_if.DUT f_if);


localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);

reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

//---------------------
// Write Operation
//---------------------
always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		wr_ptr <= 0;
		f_if.wr_ack <= 0; //Fiexed Bug: Added Reset value to wr_ack
		f_if.overflow <= 0; //Fixed Bug: Added Reset value to overflow
	end
	else if (f_if.wr_en && count < f_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= f_if.data_in;
		f_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		f_if.wr_ack <= 0; 
		if (f_if.full & f_if.wr_en)
			f_if.overflow <= 1;
		else
			f_if.overflow <= 0;
	end
end
//---------------------
// Read Operation
//---------------------
always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		f_if.data_out <= 0;				//Fixed Bug: was f_if.data_out <= 0;
		rd_ptr <= 0;			
		f_if.underflow <= 0;		//Fixed Bug: Added Reset value to underflow							
	end
	else if (f_if.rd_en && count != 0) begin
		f_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin
		if (f_if.empty & f_if.rd_en)
			f_if.underflow <= 1;		//Fixed Bug: Underflow should be sequential
		else
			f_if.underflow <= 0;
	end
end

//---------------------
// Status Flags
//---------------------
always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({f_if.wr_en, f_if.rd_en} == 2'b10) && !f_if.full) 
			count <= count + 1;
		else if ( ({f_if.wr_en, f_if.rd_en} == 2'b01) && !f_if.empty)
			count <= count - 1;
		else if( ({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.full)	//Fixed Bug: Added cases when wr_en and rd_en are high simultaneously:
			count <= count - 1;
		else if( ({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.empty)	//Fixed Bug: Added cases when wr_en and rd_en are high simultaneously:
			count <= count + 1;
	end
end

assign f_if.full 		= (count == f_if.FIFO_DEPTH)? 1 : 0;
assign f_if.empty 		= (count == 0)? 1 : 0;
assign f_if.almostfull 	= (count == f_if.FIFO_DEPTH-1)? 1 : 0; 		//Fixed Bug: was f_if.FIFO_DEPTH - 1
assign f_if.almostempty = (count == 1)? 1 : 0;

`ifdef SIM
//==============================
//=========Assetions============
//==============================

// module FIFO_SVA(fifo_if.monitor f_if);
	//a. Reset Behavior
	always_comb begin
		if(~f_if.rst_n)begin
			assert final (f_if.full == 0);
			cover final (f_if.full == 0);
			
			assert final (f_if.empty == 1);
			cover final (f_if.empty == 1);
			
			assert final (f_if.almostfull == 0);
			cover final (f_if.almostfull == 0);
			
			assert final (f_if.almostempty == 0);
			cover final (f_if.almostempty == 0);
			
			assert final (wr_ptr == 0);
			cover final (wr_ptr == 0);
			
			assert final (rd_ptr == 0);
			cover final (rd_ptr == 0);
			
			assert final (count == 0);
			cover final (count == 0);
			
		end

	end

	//b. Write Acknowledge (wr_ack)
	property p_wr_ack;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (f_if.wr_en && !f_if.full) |=> (f_if.wr_ack);
	endproperty

	//c. Overflow Detection
	property p_overflow;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (f_if.wr_en && f_if.full) |=> (f_if.overflow);
	endproperty

	//d. Underflow Detection
	property p_underflow;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (f_if.rd_en && f_if.empty) |=> (f_if.underflow);
	endproperty

	//e. Empty Flag Assertion
	property p_empty;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (count == 0) |-> (f_if.empty);
	endproperty

	//f. Full Flag Assertion
	property p_full;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (count == f_if.FIFO_DEPTH) |-> (f_if.full);
	endproperty

	//g. Almost Full Condition
	property p_almostfull;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (count == f_if.FIFO_DEPTH -1) |-> (f_if.almostfull);
	endproperty

	//h. Almost Empty Condition
	property p_almostempty;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (count == 1) |-> (f_if.almostempty);
	endproperty

	//i. Pointer Wraparound
	property p_wr_ptr_Wraparound;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (f_if.wr_en && !f_if.full && wr_ptr == f_if.FIFO_DEPTH-1) |=> (wr_ptr == 0);
	endproperty

	property p_rd_ptr_Wraparound;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) (f_if.rd_en && !f_if.empty && rd_ptr == f_if.FIFO_DEPTH-1) |=> (rd_ptr == 0);
	endproperty

	property p_counter_Wraparond;
		@(posedge f_if.clk) disable iff(~f_if.rst_n) 
		(count == f_if.FIFO_DEPTH && f_if.wr_en && !f_if.full && wr_ptr == f_if.FIFO_DEPTH-1) |=> (count == 0);
	endproperty

	//j. Pointer threshold
	property p_wr_ptr_theshold;
		@(posedge f_if.clk) (wr_ptr < f_if.FIFO_DEPTH);
	endproperty
	
	property p_rd_ptr_theshold;
		@(posedge f_if.clk) (rd_ptr < f_if.FIFO_DEPTH);
	endproperty

	property p_count_theshold;
		@(posedge f_if.clk) (count <= f_if.FIFO_DEPTH);
	endproperty

	//============================================================
	// FIFO Assertion Properties & Coverage
	//============================================================

	// b. Write Acknowledge (wr_ack)
	p_wr_ack_assertion              : assert property (p_wr_ack);
	p_wr_ack_coverage               : cover  property (p_wr_ack);

	// c. Overflow Detection
	p_overflow_assertion            : assert property (p_overflow);
	p_overflow_coverage             : cover  property (p_overflow);

	// d. Underflow Detection
	p_underflow_assertion           : assert property (p_underflow);
	p_underflow_coverage            : cover  property (p_underflow);

	// e. Empty Flag Assertion
	p_empty_assertion               : assert property (p_empty);
	p_empty_coverage                : cover  property (p_empty);

	// f. Full Flag Assertion
	p_full_assertion                : assert property (p_full);
	p_full_coverage                 : cover  property (p_full);

	// g. Almost Full Condition
	p_almostfull_assertion          : assert property (p_almostfull);
	p_almostfull_coverage           : cover  property (p_almostfull);

	// h. Almost Empty Condition
	p_almostempty_assertion         : assert property (p_almostempty);
	p_almostempty_coverage          : cover  property (p_almostempty);

	// i. Pointer Wraparound (Write)
	p_wr_ptr_Wraparound_assertion   : assert property (p_wr_ptr_Wraparound);
	p_wr_ptr_Wraparound_coverage    : cover  property (p_wr_ptr_Wraparound);

	// i. Pointer Wraparound (Read)
	p_rd_ptr_Wraparound_assertion   : assert property (p_rd_ptr_Wraparound);
	p_rd_ptr_Wraparound_coverage    : cover  property (p_rd_ptr_Wraparound);

	// j. Pointer Threshold (Write)
	p_wr_ptr_theshold_assertion     : assert property (p_wr_ptr_theshold);
	p_wr_ptr_theshold_coverage      : cover  property (p_wr_ptr_theshold);

	// j. Pointer Threshold (Read)
	p_rd_ptr_theshold_assertion     : assert property (p_rd_ptr_theshold);
	p_rd_ptr_theshold_coverage      : cover  property (p_rd_ptr_theshold);

	// j. Count Threshold
	p_count_theshold_assertion      : assert property (p_count_theshold);
	p_count_theshold_coverage       : cover  property (p_count_theshold);
`endif
endmodule