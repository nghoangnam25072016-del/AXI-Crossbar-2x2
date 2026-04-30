module axi_crossbar_2x2 (
    input  logic clk,
    input  logic rst_n,

    // M0 Write
    input  logic [31:0] m0_awaddr,
    input  logic        m0_awvalid,
    output logic        m0_awready,
    input  logic [31:0] m0_wdata,
    input  logic        m0_wvalid,
    output logic        m0_wready,

    // M1 Write
    input  logic [31:0] m1_awaddr,
    input  logic        m1_awvalid,
    output logic        m1_awready,
    input  logic [31:0] m1_wdata,
    input  logic        m1_wvalid,
    output logic        m1_wready,

    // S0 Write
    output logic [31:0] s0_awaddr,
    output logic        s0_awvalid,
    input  logic        s0_awready,
    output logic [31:0] s0_wdata,
    output logic        s0_wvalid,
    input  logic        s0_wready,

    // S1 Write
    output logic [31:0] s1_awaddr,
    output logic        s1_awvalid,
    input  logic        s1_awready,
    output logic [31:0] s1_wdata,
    output logic        s1_wvalid,
    input  logic        s1_wready
);

    logic m0_sel_s0, m0_sel_s1;
    logic m1_sel_s0, m1_sel_s1;

    axi_addr_decoder u_dec_m0 (
        .addr(m0_awaddr),
        .sel_s0(m0_sel_s0),
        .sel_s1(m0_sel_s1)
    );

    axi_addr_decoder u_dec_m1 (
        .addr(m1_awaddr),
        .sel_s0(m1_sel_s0),
        .sel_s1(m1_sel_s1)
    );

    logic req_s0_m0, req_s0_m1;
    logic req_s1_m0, req_s1_m1;

    logic grant_s0_m0, grant_s0_m1;
    logic grant_s1_m0, grant_s1_m1;

    assign req_s0_m0 = m0_awvalid && m0_wvalid && m0_sel_s0;
    assign req_s0_m1 = m1_awvalid && m1_wvalid && m1_sel_s0;

    assign req_s1_m0 = m0_awvalid && m0_wvalid && m0_sel_s1;
    assign req_s1_m1 = m1_awvalid && m1_wvalid && m1_sel_s1;

    axi_rr_arbiter u_s0_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req0(req_s0_m0),
        .req1(req_s0_m1),
        .grant0(grant_s0_m0),
        .grant1(grant_s0_m1)
    );

    axi_rr_arbiter u_s1_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req0(req_s1_m0),
        .req1(req_s1_m1),
        .grant0(grant_s1_m0),
        .grant1(grant_s1_m1)
    );

    always_comb begin
        s0_awaddr  = 32'h0;
        s0_awvalid = 1'b0;
        s0_wdata   = 32'h0;
        s0_wvalid  = 1'b0;

        s1_awaddr  = 32'h0;
        s1_awvalid = 1'b0;
        s1_wdata   = 32'h0;
        s1_wvalid  = 1'b0;

        m0_awready = 1'b0;
        m0_wready  = 1'b0;
        m1_awready = 1'b0;
        m1_wready  = 1'b0;

        // Route to Slave 0
        if (grant_s0_m0) begin
            s0_awaddr   = m0_awaddr;
            s0_awvalid  = m0_awvalid;
            s0_wdata    = m0_wdata;
            s0_wvalid   = m0_wvalid;
            m0_awready  = s0_awready;
            m0_wready   = s0_wready;
        end
        else if (grant_s0_m1) begin
            s0_awaddr   = m1_awaddr;
            s0_awvalid  = m1_awvalid;
            s0_wdata    = m1_wdata;
            s0_wvalid   = m1_wvalid;
            m1_awready  = s0_awready;
            m1_wready   = s0_wready;
        end

        // Route to Slave 1
        if (grant_s1_m0) begin
            s1_awaddr   = m0_awaddr;
            s1_awvalid  = m0_awvalid;
            s1_wdata    = m0_wdata;
            s1_wvalid   = m0_wvalid;
            m0_awready  = s1_awready;
            m0_wready   = s1_wready;
        end
        else if (grant_s1_m1) begin
            s1_awaddr   = m1_awaddr;
            s1_awvalid  = m1_awvalid;
            s1_wdata    = m1_wdata;
            s1_wvalid   = m1_wvalid;
            m1_awready  = s1_awready;
            m1_wready   = s1_wready;
        end
    end

endmodule
