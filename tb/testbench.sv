`timescale 1ns/1ps
`default_nettype none

module heichips25_CORDIC_tb;

    // Testbench signals
    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg        ena;
    reg        clk;
    reg        rst_n;

    // DUT instantiation
    heichips25_CORDIC dut (
        .ui_in   (ui_in),
        .uo_out  (uo_out),
        .uio_in  (uio_in),
        .uio_out (uio_out),
        .uio_oe  (uio_oe),
        .ena     (ena),
        .clk     (clk),
        .rst_n   (rst_n)
    );

    // Clock generation: 100 MHz (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset sequence
    initial begin
        ena   = 1'b1;
        rst_n = 1'b0;
        //ui_in = 8'h00;
        //uio_in = 8'h00;
        #1000;        // Hold reset for 100ns
        rst_n = 1'b1;
    end

    // Stimulus
    initial begin
        // Wait until reset is released
        //@(posedge rst_n);
	#1000;
        // Select sine wave (example: waveform_sel = 2'b00)
        uio_in[6:5] = 2'b00;

        // Apply some frequency values
        ui_in  = 8'hff;    // lower 8 bits
        uio_in[4:0] = 5'h1f; // upper 5 bits (13-bit freq input)

        #100000;
        rst_n = 1'b0;
        #1000;        // Hold reset for 100ns
	ui_in  = 8'hfe;    // lower 8 bits
        uio_in[4:0] = 5'h1f; // upper 5 bits (13-bit freq input)
        uio_in[6:5] = 2'b01;
        rst_n = 1'b1;
        // Change waveform selection to cosine/triangle/etc.



        #200000;
	rst_n = 1'b0;
        #1000;        // Hold reset for 100ns
	ui_in  = 8'hfd;    // lower 8 bits
        uio_in[4:0] = 5'h1f; // upper 5 bits (13-bit freq input)
        uio_in[6:5] = 2'b10;
        rst_n = 1'b1;


	#400000;
        rst_n = 1'b0;
        #1000;        // Hold reset for 100ns
	ui_in  = 8'hfc;    // lower 8 bits
        uio_in[4:0] = 5'h1f; // upper 5 bits (13-bit freq input)
        uio_in[6:5] = 2'b11;
        rst_n = 1'b1;


        #800000;
        rst_n = 1'b0;
        #1000;        // Hold reset for 100ns
        rst_n = 1'b1;
        // Finish simulation
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("heichips25_CORDIC_tb.vcd");
        $dumpvars(0, heichips25_CORDIC_tb);
    end

endmodule
