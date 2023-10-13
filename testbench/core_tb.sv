//***********************************************************
// ECE 3058 Architecture Concurrency and Energy in Computation
//
// MIPS Processor System Verilog Behavioral Model
//
// School of Electrical & Computer Engineering
// Georgia Institute of Technology
// Atlanta, GA 30332
//
//  Engineer:   Zou, Ivan
//  Module:     core_tb
//  Functionality:
//      This is the testbed for the Single cycle RISCV processor
//
//***********************************************************
`timescale 1ns / 1ns

module Core_tb;

// Clock and Reset signals to simulate as input into core
	logic clk = 1;
	logic mem_enable;
	logic reset;

	// local variables to display for testbench
	logic[6:0] cycle_count;
	
	integer i;
	initial
	begin
		cycle_count = 0;

		// do the simulation
		$dumpfile("Core_Simulation.vcd");

		// dump all the signals into the vcd waveforem file
		$dumpvars(0, Core_tb);

		reset = 1'b1;
		mem_enable = 1'b1;

		// Set the Test instructions and preset MEM and Regfile here if desired

		// Some sample test instructions to get you started 
        // Test for Single cylce processor

		#10
    // NOP since first instruction is skipped 
    core_proc.MainMemory.data_RAM[0] = 8'h00;
    core_proc.MainMemory.data_RAM[1] = 8'h00;
    core_proc.MainMemory.data_RAM[2] = 8'h00;
    core_proc.MainMemory.data_RAM[3] = 8'h00;

    // addi x20, x0, 100 0x06400a13 (100)
    core_proc.MainMemory.data_RAM[4] = 8'h06;
    core_proc.MainMemory.data_RAM[5] = 8'h40;
    core_proc.MainMemory.data_RAM[6] = 8'h0A;
    core_proc.MainMemory.data_RAM[7] = 8'h13;

    // addi x21, x20, -20  0xfeca0a93 (80)
	core_proc.MainMemory.data_RAM[8] = 8'hfe;
    core_proc.MainMemory.data_RAM[9] = 8'hca;
    core_proc.MainMemory.data_RAM[10] = 8'h0a;
    core_proc.MainMemory.data_RAM[11] = 8'h93;

    // addi x22, x0, 80 0x05000b13 (0)
    core_proc.MainMemory.data_RAM[12] = 8'h05;
    core_proc.MainMemory.data_RAM[13] = 8'h00;
    core_proc.MainMemory.data_RAM[14] = 8'h0b;
    core_proc.MainMemory.data_RAM[15] = 8'h13;

    // addi x23, x21, -120 0xf88a8b93 (-40)
    core_proc.MainMemory.data_RAM[16] = 8'hf8;
    core_proc.MainMemory.data_RAM[17] = 8'h8a;
    core_proc.MainMemory.data_RAM[18] = 8'h8b;
    core_proc.MainMemory.data_RAM[19] = 8'h93;

	// addi x24, x23, -120 0xf88b8c13 (-160)
	core_proc.MainMemory.data_RAM[20] = 8'hf8;
    core_proc.MainMemory.data_RAM[21] = 8'h8b;
    core_proc.MainMemory.data_RAM[22] = 8'h8c;
    core_proc.MainMemory.data_RAM[23] = 8'h13;

	 // add x15, x15, x23 0x017787b3 (-40)
    core_proc.MainMemory.data_RAM[24] = 8'h01;
    core_proc.MainMemory.data_RAM[25] = 8'h77;
    core_proc.MainMemory.data_RAM[26] = 8'h87;
    core_proc.MainMemory.data_RAM[27] = 8'hb3;

	// sw x23, 100(x23) 0x077ba223  
    core_proc.MainMemory.data_RAM[28] = 8'h07;
    core_proc.MainMemory.data_RAM[29] = 8'h7b;
    core_proc.MainMemory.data_RAM[30] = 8'ha2;
    core_proc.MainMemory.data_RAM[31] = 8'h23;
	
	// addi x23, x23, 1000 0x3e8b8b93
    core_proc.MainMemory.data_RAM[32] = 8'h3e;
    core_proc.MainMemory.data_RAM[33] = 8'h8b;
    core_proc.MainMemory.data_RAM[34] = 8'h8b;
    core_proc.MainMemory.data_RAM[35] = 8'h93;

    // lw x23, 100(x15) 0x0647ab83
    core_proc.MainMemory.data_RAM[36] = 8'h06;
    core_proc.MainMemory.data_RAM[37] = 8'h47;
    core_proc.MainMemory.data_RAM[38] = 8'hab;
    core_proc.MainMemory.data_RAM[39] = 8'h83;

	
    // ADDI x23, x23, -20 0xfecb8b93
    core_proc.MainMemory.data_RAM[40] = 8'hfe;
    core_proc.MainMemory.data_RAM[41] = 8'hcb;
    core_proc.MainMemory.data_RAM[42] = 8'h8b;
    core_proc.MainMemory.data_RAM[43] = 8'h93;

    // slt x2, x24, x23 (0x017c2133)
    core_proc.MainMemory.data_RAM[44] = 8'h01;
    core_proc.MainMemory.data_RAM[45] = 8'h7c;
    core_proc.MainMemory.data_RAM[46] = 8'h21;
    core_proc.MainMemory.data_RAM[47] = 8'h33;

	// addi x15, x15, -20 0xfec78793
	core_proc.MainMemory.data_RAM[48] = 8'hfe;
    core_proc.MainMemory.data_RAM[49] = 8'hc7;
    core_proc.MainMemory.data_RAM[50] = 8'h87;
    core_proc.MainMemory.data_RAM[51] = 8'h93;	

    // JAL x10, -24 0xfe9ff56f
	core_proc.MainMemory.data_RAM[52] = 8'hfe;
    core_proc.MainMemory.data_RAM[53] = 8'h9f;
    core_proc.MainMemory.data_RAM[54] = 8'hf5;
    core_proc.MainMemory.data_RAM[55] = 8'h6f;	
	

		#5 reset = 1'b0;

		#50 $finish;
	end

	always
		#1 clk <= clk + 1;

	always @(posedge clk) begin
		if (~reset)
			cycle_count <= cycle_count + 1;
	end

	Core core_proc(
		// Inputs
		.clock(clk),
		.reset(reset),
		.mem_en(mem_enable)
	);

endmodule
