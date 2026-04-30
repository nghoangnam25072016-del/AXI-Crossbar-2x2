`timescale 1ns/1ps

module axi_crossbar_tb;

    logic clk;
    logic rst_n;

    // Master 0
    logic [31:0] m0_awaddr;
    logic        m0_awvalid;
    logic        m0_awready;
    logic [31:0] m0_wdata;
    logic        m0_wvalid;
    logic        m0_wready;

    // Master 1
    logic [31:0] m1_awaddr;
    logic        m1_awvalid;
    logic        m1_awready;
    logic [31:0] m1_wdata;
    logic        m1_wvalid;
    logic        m1_wready;

    // Slave 0
    logic [31:0] s0_awaddr;
    logic        s0_awvalid;
    logic        s0_awready;
    logic [31:0] s0_wdata;
    logic        s0_wvalid;
    logic        s0_wready;

    // Slave 1
    logic [31:0] s1_awaddr;
    logic        s1_awvalid;
    logic        s1_awready;
    logic [31:0] s1_wdata;
    logic        s1_wvalid;
    logic        s1_wready;

    int s0_count;
    int s1_count;

    axi_crossbar_2x2 dut (
        .clk(clk),
        .rst_n(rst_n),

        .m0_awaddr(m0_awaddr),
        .m0_awvalid(m0_awvalid),
        .m0_awready(m0_awready),
        .m0_wdata(m0_wdata),
        .m0_wvalid(m0_wvalid),
        .m0_wready(m0_wready),

        .m1_awaddr(m1_awaddr),
        .m1_awvalid(m1_awvalid),
        .m1_awready(m1_awready),
        .m1_wdata(m1_wdata),
        .m1_wvalid(m1_wvalid),
        .m1_wready(m1_wready),

        .s0_awaddr(s0_awaddr),
        .s0_awvalid(s0_awvalid),
        .s0_awready(s0_awready),
        .s0_wdata(s0_wdata),
        .s0_wvalid(s0_wvalid),
        .s0_wready(s0_wready),

        .s1_awaddr(s1_awaddr),
        .s1_awvalid(s1_awvalid),
        .s1_awready(s1_awready),
        .s1_wdata(s1_wdata),
        .s1_wvalid(s1_wvalid),
        .s1_wready(s1_wready)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;

        s0_count = 0;
        s1_count = 0;

        m0_awaddr  = 32'h0;
        m0_awvalid = 0;
        m0_wdata   = 32'h0;
        m0_wvalid  = 0;

        m1_awaddr  = 32'h0;
        m1_awvalid = 0;
        m1_wdata   = 32'h0;
        m1_wvalid  = 0;

        s0_awready = 1;
        s0_wready  = 1;
        s1_awready = 1;
        s1_wready  = 1;

        repeat (3) @(posedge clk);
        rst_n = 1;

        // =====================================
        // Case 1: Parallel access
        // M0 -> S0, M1 -> S1
        // =====================================
        @(posedge clk);

        m0_awaddr  = 32'h0000_1000; // Slave 0
        m0_wdata   = 32'hAAAA_0000;
        m0_awvalid = 1;
        m0_wvalid  = 1;

        m1_awaddr  = 32'h0001_2000; // Slave 1
        m1_wdata   = 32'hBBBB_0000;
        m1_awvalid = 1;
        m1_wvalid  = 1;

        repeat (4) @(posedge clk);

        m0_awvalid = 0;
        m0_wvalid  = 0;
        m1_awvalid = 0;
        m1_wvalid  = 0;

        repeat (3) @(posedge clk);

        // =====================================
        // Case 2: Contention
        // M0 -> S0, M1 -> S0
        // arbiter should alternate
        // =====================================
        m0_awaddr  = 32'h0000_3000; // Slave 0
        m0_wdata   = 32'hAAAA_1111;
        m0_awvalid = 1;
        m0_wvalid  = 1;

        m1_awaddr  = 32'h0000_4000; // Slave 0
        m1_wdata   = 32'hBBBB_1111;
        m1_awvalid = 1;
        m1_wvalid  = 1;

        repeat (8) @(posedge clk);

        m0_awvalid = 0;
        m0_wvalid  = 0;
        m1_awvalid = 0;
        m1_wvalid  = 0;

        repeat (5) @(posedge clk);

        $finish;
    end

    always @(posedge clk) begin
        if (s0_awvalid && s0_awready && s0_wvalid && s0_wready) begin
            s0_count++;
            $display("S0 WRITE: addr=%h data=%h", s0_awaddr, s0_wdata);
        end

        if (s1_awvalid && s1_awready && s1_wvalid && s1_wready) begin
            s1_count++;
            $display("S1 WRITE: addr=%h data=%h", s1_awaddr, s1_wdata);
        end
    end

    initial begin
        $dumpfile("axi_crossbar.vcd");
        $dumpvars(0, axi_crossbar_tb);
    end

    final begin
        $display("====================================");
        $display("AXI CROSSBAR 2x2 TEST RESULT");
        $display("S0 writes = %0d", s0_count);
        $display("S1 writes = %0d", s1_count);

        if (s0_count > 0 && s1_count > 0)
            $display("AXI CROSSBAR TEST PASS");
        else
            $display("AXI CROSSBAR TEST FAIL");

        $display("====================================");
    end

endmodule
