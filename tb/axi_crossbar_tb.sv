`timescale 1ns/1ps

module axi_crossbar_tb;

    logic clk;
    logic rst_n;

    // M0 Write
    logic [31:0] m0_awaddr;
    logic        m0_awvalid;
    logic        m0_awready;
    logic [31:0] m0_wdata;
    logic        m0_wvalid;
    logic        m0_wready;
    logic [1:0]  m0_bresp;
    logic        m0_bvalid;
    logic        m0_bready;

    // M0 Read
    logic [31:0] m0_araddr;
    logic        m0_arvalid;
    logic        m0_arready;
    logic [31:0] m0_rdata;
    logic [1:0]  m0_rresp;
    logic        m0_rvalid;
    logic        m0_rready;

    // M1 Write
    logic [31:0] m1_awaddr;
    logic        m1_awvalid;
    logic        m1_awready;
    logic [31:0] m1_wdata;
    logic        m1_wvalid;
    logic        m1_wready;
    logic [1:0]  m1_bresp;
    logic        m1_bvalid;
    logic        m1_bready;

    // M1 Read
    logic [31:0] m1_araddr;
    logic        m1_arvalid;
    logic        m1_arready;
    logic [31:0] m1_rdata;
    logic [1:0]  m1_rresp;
    logic        m1_rvalid;
    logic        m1_rready;

    // S0 Write
    logic [31:0] s0_awaddr;
    logic        s0_awvalid;
    logic        s0_awready;
    logic [31:0] s0_wdata;
    logic        s0_wvalid;
    logic        s0_wready;
    logic [1:0]  s0_bresp;
    logic        s0_bvalid;
    logic        s0_bready;

    // S0 Read
    logic [31:0] s0_araddr;
    logic        s0_arvalid;
    logic        s0_arready;
    logic [31:0] s0_rdata;
    logic [1:0]  s0_rresp;
    logic        s0_rvalid;
    logic        s0_rready;

    // S1 Write
    logic [31:0] s1_awaddr;
    logic        s1_awvalid;
    logic        s1_awready;
    logic [31:0] s1_wdata;
    logic        s1_wvalid;
    logic        s1_wready;
    logic [1:0]  s1_bresp;
    logic        s1_bvalid;
    logic        s1_bready;

    // S1 Read
    logic [31:0] s1_araddr;
    logic        s1_arvalid;
    logic        s1_arready;
    logic [31:0] s1_rdata;
    logic [1:0]  s1_rresp;
    logic        s1_rvalid;
    logic        s1_rready;

    int s0_write_count;
    int s1_write_count;
    int m0_b_count;
    int m1_b_count;
    int m0_r_count;
    int m1_r_count;
    int error_count;

    axi_crossbar_2x2 dut (
        .clk(clk),
        .rst_n(rst_n),

        .m0_awaddr(m0_awaddr),
        .m0_awvalid(m0_awvalid),
        .m0_awready(m0_awready),
        .m0_wdata(m0_wdata),
        .m0_wvalid(m0_wvalid),
        .m0_wready(m0_wready),
        .m0_bresp(m0_bresp),
        .m0_bvalid(m0_bvalid),
        .m0_bready(m0_bready),
        .m0_araddr(m0_araddr),
        .m0_arvalid(m0_arvalid),
        .m0_arready(m0_arready),
        .m0_rdata(m0_rdata),
        .m0_rresp(m0_rresp),
        .m0_rvalid(m0_rvalid),
        .m0_rready(m0_rready),

        .m1_awaddr(m1_awaddr),
        .m1_awvalid(m1_awvalid),
        .m1_awready(m1_awready),
        .m1_wdata(m1_wdata),
        .m1_wvalid(m1_wvalid),
        .m1_wready(m1_wready),
        .m1_bresp(m1_bresp),
        .m1_bvalid(m1_bvalid),
        .m1_bready(m1_bready),
        .m1_araddr(m1_araddr),
        .m1_arvalid(m1_arvalid),
        .m1_arready(m1_arready),
        .m1_rdata(m1_rdata),
        .m1_rresp(m1_rresp),
        .m1_rvalid(m1_rvalid),
        .m1_rready(m1_rready),

        .s0_awaddr(s0_awaddr),
        .s0_awvalid(s0_awvalid),
        .s0_awready(s0_awready),
        .s0_wdata(s0_wdata),
        .s0_wvalid(s0_wvalid),
        .s0_wready(s0_wready),
        .s0_bresp(s0_bresp),
        .s0_bvalid(s0_bvalid),
        .s0_bready(s0_bready),
        .s0_araddr(s0_araddr),
        .s0_arvalid(s0_arvalid),
        .s0_arready(s0_arready),
        .s0_rdata(s0_rdata),
        .s0_rresp(s0_rresp),
        .s0_rvalid(s0_rvalid),
        .s0_rready(s0_rready),

        .s1_awaddr(s1_awaddr),
        .s1_awvalid(s1_awvalid),
        .s1_awready(s1_awready),
        .s1_wdata(s1_wdata),
        .s1_wvalid(s1_wvalid),
        .s1_wready(s1_wready),
        .s1_bresp(s1_bresp),
        .s1_bvalid(s1_bvalid),
        .s1_bready(s1_bready),
        .s1_araddr(s1_araddr),
        .s1_arvalid(s1_arvalid),
        .s1_arready(s1_arready),
        .s1_rdata(s1_rdata),
        .s1_rresp(s1_rresp),
        .s1_rvalid(s1_rvalid),
        .s1_rready(s1_rready)
    );

    always #5 clk = ~clk;

    task automatic clear_masters();
        begin
            m0_awaddr  = 32'h0;
            m0_awvalid = 1'b0;
            m0_wdata   = 32'h0;
            m0_wvalid  = 1'b0;
            m0_bready  = 1'b1;
            m0_araddr  = 32'h0;
            m0_arvalid = 1'b0;
            m0_rready  = 1'b1;

            m1_awaddr  = 32'h0;
            m1_awvalid = 1'b0;
            m1_wdata   = 32'h0;
            m1_wvalid  = 1'b0;
            m1_bready  = 1'b1;
            m1_araddr  = 32'h0;
            m1_arvalid = 1'b0;
            m1_rready  = 1'b1;
        end
    endtask

    task automatic write_m0(input logic [31:0] addr, input logic [31:0] data);
        begin
            m0_awaddr  <= addr;
            m0_wdata   <= data;
            m0_awvalid <= 1'b1;
            m0_wvalid  <= 1'b1;

            wait (m0_awready && m0_wready);
            @(posedge clk);

            m0_awvalid <= 1'b0;
            m0_wvalid  <= 1'b0;

            wait (m0_bvalid);
            @(posedge clk);
        end
    endtask

    task automatic write_m1(input logic [31:0] addr, input logic [31:0] data);
        begin
            m1_awaddr  <= addr;
            m1_wdata   <= data;
            m1_awvalid <= 1'b1;
            m1_wvalid  <= 1'b1;

            wait (m1_awready && m1_wready);
            @(posedge clk);

            m1_awvalid <= 1'b0;
            m1_wvalid  <= 1'b0;

            wait (m1_bvalid);
            @(posedge clk);
        end
    endtask

    task automatic read_m0(input logic [31:0] addr);
        begin
            m0_araddr  <= addr;
            m0_arvalid <= 1'b1;

            wait (m0_arready);
            @(posedge clk);

            m0_arvalid <= 1'b0;

            wait (m0_rvalid);
            @(posedge clk);
        end
    endtask

    task automatic read_m1(input logic [31:0] addr);
        begin
            m1_araddr  <= addr;
            m1_arvalid <= 1'b1;

            wait (m1_arready);
            @(posedge clk);

            m1_arvalid <= 1'b0;

            wait (m1_rvalid);
            @(posedge clk);
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 0;

        s0_write_count = 0;
        s1_write_count = 0;
        m0_b_count = 0;
        m1_b_count = 0;
        m0_r_count = 0;
        m1_r_count = 0;
        error_count = 0;

        clear_masters();

        s0_awready = 1'b1;
        s0_wready  = 1'b1;
        s0_bresp   = 2'b00;
        s0_bvalid  = 1'b0;

        s0_arready = 1'b1;
        s0_rdata   = 32'h0;
        s0_rresp   = 2'b00;
        s0_rvalid  = 1'b0;

        s1_awready = 1'b1;
        s1_wready  = 1'b1;
        s1_bresp   = 2'b00;
        s1_bvalid  = 1'b0;

        s1_arready = 1'b1;
        s1_rdata   = 32'h0;
        s1_rresp   = 2'b00;
        s1_rvalid  = 1'b0;

        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        fork
            write_m0(32'h0000_1000, 32'hAAAA_0000); // M0 -> S0
            write_m1(32'h0001_2000, 32'hBBBB_0000); // M1 -> S1
        join

        repeat (3) @(posedge clk);

        fork
            write_m0(32'h0000_3000, 32'hAAAA_1111); // M0 -> S0
            write_m1(32'h0000_4000, 32'hBBBB_1111); // M1 -> S0 contention
        join

        repeat (3) @(posedge clk);

        fork
            read_m0(32'h0000_5000); // M0 -> S0, expect 0000_5100
            read_m1(32'h0001_6000); // M1 -> S1, expect 0001_6200
        join

        repeat (3) @(posedge clk);

        fork
            read_m0(32'h0000_7000); // M0 -> S0 contention
            read_m1(32'h0000_8000); // M1 -> S0 contention
        join

        repeat (10) @(posedge clk);

        $finish;
    end

    // Slave 0 write response model
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s0_bvalid <= 1'b0;
            s0_bresp  <= 2'b00;
        end
        else begin
            if (s0_awvalid && s0_awready && s0_wvalid && s0_wready) begin
                s0_bvalid <= 1'b1;
                s0_bresp  <= 2'b00;
            end
            else if (s0_bvalid && s0_bready) begin
                s0_bvalid <= 1'b0;
            end
        end
    end

    // Slave 1 write response model
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_bvalid <= 1'b0;
            s1_bresp  <= 2'b00;
        end
        else begin
            if (s1_awvalid && s1_awready && s1_wvalid && s1_wready) begin
                s1_bvalid <= 1'b1;
                s1_bresp  <= 2'b00;
            end
            else if (s1_bvalid && s1_bready) begin
                s1_bvalid <= 1'b0;
            end
        end
    end

    // Slave 0 read response model
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s0_rvalid <= 1'b0;
            s0_rresp  <= 2'b00;
            s0_rdata  <= 32'h0;
        end
        else begin
            if (s0_arvalid && s0_arready) begin
                s0_rvalid <= 1'b1;
                s0_rresp  <= 2'b00;
                s0_rdata  <= s0_araddr + 32'h0000_0100;
            end
            else if (s0_rvalid && s0_rready) begin
                s0_rvalid <= 1'b0;
            end
        end
    end

    // Slave 1 read response model
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_rvalid <= 1'b0;
            s1_rresp  <= 2'b00;
            s1_rdata  <= 32'h0;
        end
        else begin
            if (s1_arvalid && s1_arready) begin
                s1_rvalid <= 1'b1;
                s1_rresp  <= 2'b00;
                s1_rdata  <= s1_araddr + 32'h0000_0200;
            end
            else if (s1_rvalid && s1_rready) begin
                s1_rvalid <= 1'b0;
            end
        end
    end

    // Monitors and checkers
    always @(posedge clk) begin
        if (s0_awvalid && s0_awready && s0_wvalid && s0_wready) begin
            s0_write_count++;
            $display("S0 WRITE: addr=%h data=%h", s0_awaddr, s0_wdata);
        end

        if (s1_awvalid && s1_awready && s1_wvalid && s1_wready) begin
            s1_write_count++;
            $display("S1 WRITE: addr=%h data=%h", s1_awaddr, s1_wdata);
        end

        if (m0_bvalid && m0_bready) begin
            m0_b_count++;
            if (m0_bresp !== 2'b00) begin
                error_count++;
                $display("M0 B FAIL: bresp=%b", m0_bresp);
            end
            else begin
                $display("M0 B PASS");
            end
        end

        if (m1_bvalid && m1_bready) begin
            m1_b_count++;
            if (m1_bresp !== 2'b00) begin
                error_count++;
                $display("M1 B FAIL: bresp=%b", m1_bresp);
            end
            else begin
                $display("M1 B PASS");
            end
        end

        if (m0_rvalid && m0_rready) begin
            m0_r_count++;

            if ((m0_rdata !== 32'h0000_5100) &&
                (m0_rdata !== 32'h0000_7100)) begin
                error_count++;
                $display("M0 R FAIL: data=%h", m0_rdata);
            end
            else begin
                $display("M0 R PASS: data=%h", m0_rdata);
            end
        end

        if (m1_rvalid && m1_rready) begin
            m1_r_count++;

            if ((m1_rdata !== 32'h0001_6200) &&
                (m1_rdata !== 32'h0000_8100)) begin
                error_count++;
                $display("M1 R FAIL: data=%h", m1_rdata);
            end
            else begin
                $display("M1 R PASS: data=%h", m1_rdata);
            end
        end
    end

    initial begin
        $dumpfile("axi_crossbar_full.vcd");
        $dumpvars(0, axi_crossbar_tb);
    end

    final begin
        $display("====================================");
        $display("AXI CROSSBAR FULL TEST RESULT");
        $display("S0 writes  = %0d", s0_write_count);
        $display("S1 writes  = %0d", s1_write_count);
        $display("M0 B count = %0d", m0_b_count);
        $display("M1 B count = %0d", m1_b_count);
        $display("M0 R count = %0d", m0_r_count);
        $display("M1 R count = %0d", m1_r_count);
        $display("Errors     = %0d", error_count);

        if (s0_write_count > 0 &&
            s1_write_count > 0 &&
            m0_b_count > 0 &&
            m1_b_count > 0 &&
            m0_r_count > 0 &&
            m1_r_count > 0 &&
            error_count == 0) begin
            $display("AXI CROSSBAR FULL TEST PASS");
        end
        else begin
            $display("AXI CROSSBAR FULL TEST FAIL");
        end

        $display("====================================");
    end

endmodule
