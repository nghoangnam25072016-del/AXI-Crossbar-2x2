`timescale 1ns/1ps

module axi_crossbar_tb;
    int pass_count;
int fail_count;
int write_count;
int read_count;

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


    // helper function decode slave
function automatic bit is_s0(input logic [31:0] addr);
    return (addr[31:16] == 16'h0000);
endfunction

function automatic bit is_s1(input logic [31:0] addr);
    return (addr[31:16] == 16'h0001);
endfunction


// Add scoreboard monitor cho WRITE routing
    always @(posedge clk) begin
    if (s0_awvalid && s0_awready && s0_wvalid && s0_wready) begin
        write_count++;

        if (!is_s0(s0_awaddr)) begin
            fail_count++;
            $display("WRITE FAIL: S0 received wrong addr=%h", s0_awaddr);
        end
        else begin
            pass_count++;
            $display("WRITE PASS: S0 addr=%h data=%h", s0_awaddr, s0_wdata);
        end
    end

    if (s1_awvalid && s1_awready && s1_wvalid && s1_wready) begin
        write_count++;

        if (!is_s1(s1_awaddr)) begin
            fail_count++;
            $display("WRITE FAIL: S1 received wrong addr=%h", s1_awaddr);
        end
        else begin
            pass_count++;
            $display("WRITE PASS: S1 addr=%h data=%h", s1_awaddr, s1_wdata);
        end
    end
end


    // Add scoreboard monitor cho READ data

    always @(posedge clk) begin
    if (m0_rvalid && m0_rready) begin
        read_count++;

        if ((m0_rdata[31:16] == 16'h0000 && m0_rdata[15:0] >= 16'h0100) ||
            (m0_rdata[31:16] == 16'h0001 && m0_rdata[15:0] >= 16'h0200)) begin
            pass_count++;
            $display("READ PASS: M0 data=%h", m0_rdata);
        end
        else begin
            fail_count++;
            $display("READ FAIL: M0 data=%h", m0_rdata);
        end
    end

    if (m1_rvalid && m1_rready) begin
        read_count++;

        if ((m1_rdata[31:16] == 16'h0000 && m1_rdata[15:0] >= 16'h0100) ||
            (m1_rdata[31:16] == 16'h0001 && m1_rdata[15:0] >= 16'h0200)) begin
            pass_count++;
            $display("READ PASS: M1 data=%h", m1_rdata);
        end
        else begin
            fail_count++;
            $display("READ FAIL: M1 data=%h", m1_rdata);
        end
    end
end

    // Random traffic task
task automatic random_write_read();
    logic [31:0] addr0;
    logic [31:0] addr1;

    begin
        addr0 = ($urandom_range(0,1)) ? 32'h0000_1000 : 32'h0001_1000;
        addr1 = ($urandom_range(0,1)) ? 32'h0000_2000 : 32'h0001_2000;

        m0_awaddr  <= addr0;
        m0_wdata   <= 32'hAAAA_0000 + $urandom_range(0,255);
        m0_awvalid <= 1'b1;
        m0_wvalid  <= 1'b1;

        m1_awaddr  <= addr1;
        m1_wdata   <= 32'hBBBB_0000 + $urandom_range(0,255);
        m1_awvalid <= 1'b1;
        m1_wvalid  <= 1'b1;

        m0_araddr  <= addr0;
        m0_arvalid <= 1'b1;

        m1_araddr  <= addr1;
        m1_arvalid <= 1'b1;

        repeat ($urandom_range(2,5)) @(posedge clk);

        m0_awvalid <= 1'b0;
        m0_wvalid  <= 1'b0;
        m1_awvalid <= 1'b0;
        m1_wvalid  <= 1'b0;

        m0_arvalid <= 1'b0;
        m1_arvalid <= 1'b0;

        repeat ($urandom_range(2,6)) @(posedge clk);
    end
endtask


    
    initial begin
        pass_count  = 0;
fail_count  = 0;
write_count = 0;
read_count  = 0;
        $dumpfile("axi_crossbar_full.vcd");
        $dumpvars(0, axi_crossbar_tb);
        
// Run random test
repeat (20) begin
    random_write_read();
end
        
    end

    final begin
      $display("====================================");
    $display("AXI CROSSBAR SCOREBOARD RESULT");
    $display("Writes checked = %0d", write_count);
    $display("Reads checked  = %0d", read_count);
    $display("Pass count     = %0d", pass_count);
    $display("Fail count     = %0d", fail_count);

    if (fail_count == 0 && pass_count > 0)
        $display("SCOREBOARD TEST PASS");
    else
        $display("SCOREBOARD TEST FAIL");

    $display("====================================");

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

    final begin
   $display("PASS=%0d FAIL=%0d", pass_count, fail_count);
end

endmodule
