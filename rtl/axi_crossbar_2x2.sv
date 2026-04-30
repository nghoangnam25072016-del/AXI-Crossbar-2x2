module axi_crossbar_2x2 (
    input  logic clk,
    input  logic rst_n,

    // =========================
    // Master 0 Write Address/Data
    // =========================
    input  logic [31:0] m0_awaddr,
    input  logic        m0_awvalid,
    output logic        m0_awready,
    input  logic [31:0] m0_wdata,
    input  logic        m0_wvalid,
    output logic        m0_wready,

    // Master 0 Write Response
    output logic [1:0]  m0_bresp,
    output logic        m0_bvalid,
    input  logic        m0_bready,

    // Master 0 Read Address/Data
    input  logic [31:0] m0_araddr,
    input  logic        m0_arvalid,
    output logic        m0_arready,
    output logic [31:0] m0_rdata,
    output logic [1:0]  m0_rresp,
    output logic        m0_rvalid,
    input  logic        m0_rready,

    // =========================
    // Master 1 Write Address/Data
    // =========================
    input  logic [31:0] m1_awaddr,
    input  logic        m1_awvalid,
    output logic        m1_awready,
    input  logic [31:0] m1_wdata,
    input  logic        m1_wvalid,
    output logic        m1_wready,

    // Master 1 Write Response
    output logic [1:0]  m1_bresp,
    output logic        m1_bvalid,
    input  logic        m1_bready,

    // Master 1 Read Address/Data
    input  logic [31:0] m1_araddr,
    input  logic        m1_arvalid,
    output logic        m1_arready,
    output logic [31:0] m1_rdata,
    output logic [1:0]  m1_rresp,
    output logic        m1_rvalid,
    input  logic        m1_rready,

    // =========================
    // Slave 0 Write Address/Data
    // =========================
    output logic [31:0] s0_awaddr,
    output logic        s0_awvalid,
    input  logic        s0_awready,
    output logic [31:0] s0_wdata,
    output logic        s0_wvalid,
    input  logic        s0_wready,

    // Slave 0 Write Response
    input  logic [1:0]  s0_bresp,
    input  logic        s0_bvalid,
    output logic        s0_bready,

    // Slave 0 Read Address/Data
    output logic [31:0] s0_araddr,
    output logic        s0_arvalid,
    input  logic        s0_arready,
    input  logic [31:0] s0_rdata,
    input  logic [1:0]  s0_rresp,
    input  logic        s0_rvalid,
    output logic        s0_rready,

    // =========================
    // Slave 1 Write Address/Data
    // =========================
    output logic [31:0] s1_awaddr,
    output logic        s1_awvalid,
    input  logic        s1_awready,
    output logic [31:0] s1_wdata,
    output logic        s1_wvalid,
    input  logic        s1_wready,

    // Slave 1 Write Response
    input  logic [1:0]  s1_bresp,
    input  logic        s1_bvalid,
    output logic        s1_bready,

    // Slave 1 Read Address/Data
    output logic [31:0] s1_araddr,
    output logic        s1_arvalid,
    input  logic        s1_arready,
    input  logic [31:0] s1_rdata,
    input  logic [1:0]  s1_rresp,
    input  logic        s1_rvalid,
    output logic        s1_rready
);

    // ============================================================
    // Address Decode
    // ============================================================
    logic m0_aw_sel_s0, m0_aw_sel_s1;
    logic m1_aw_sel_s0, m1_aw_sel_s1;

    logic m0_ar_sel_s0, m0_ar_sel_s1;
    logic m1_ar_sel_s0, m1_ar_sel_s1;

    axi_addr_decoder u_dec_m0_aw (
        .addr(m0_awaddr),
        .sel_s0(m0_aw_sel_s0),
        .sel_s1(m0_aw_sel_s1)
    );

    axi_addr_decoder u_dec_m1_aw (
        .addr(m1_awaddr),
        .sel_s0(m1_aw_sel_s0),
        .sel_s1(m1_aw_sel_s1)
    );

    axi_addr_decoder u_dec_m0_ar (
        .addr(m0_araddr),
        .sel_s0(m0_ar_sel_s0),
        .sel_s1(m0_ar_sel_s1)
    );

    axi_addr_decoder u_dec_m1_ar (
        .addr(m1_araddr),
        .sel_s0(m1_ar_sel_s0),
        .sel_s1(m1_ar_sel_s1)
    );

    // ============================================================
    // Write Arbitration
    // ============================================================
    logic req_s0_m0, req_s0_m1;
    logic req_s1_m0, req_s1_m1;

    logic grant_s0_m0, grant_s0_m1;
    logic grant_s1_m0, grant_s1_m1;

    assign req_s0_m0 = m0_awvalid && m0_wvalid && m0_aw_sel_s0;
    assign req_s0_m1 = m1_awvalid && m1_wvalid && m1_aw_sel_s0;

    assign req_s1_m0 = m0_awvalid && m0_wvalid && m0_aw_sel_s1;
    assign req_s1_m1 = m1_awvalid && m1_wvalid && m1_aw_sel_s1;

    axi_rr_arbiter u_s0_aw_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req0(req_s0_m0),
        .req1(req_s0_m1),
        .grant0(grant_s0_m0),
        .grant1(grant_s0_m1)
    );

    axi_rr_arbiter u_s1_aw_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req0(req_s1_m0),
        .req1(req_s1_m1),
        .grant0(grant_s1_m0),
        .grant1(grant_s1_m1)
    );

    // ============================================================
    // Write Address/Data Routing
    // ============================================================
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

        // Slave 0
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

        // Slave 1
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

    // ============================================================
    // Write Response Ownership
    // ============================================================
    logic s0_b_to_m0, s0_b_to_m1;
    logic s1_b_to_m0, s1_b_to_m1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s0_b_to_m0 <= 1'b0;
            s0_b_to_m1 <= 1'b0;
            s1_b_to_m0 <= 1'b0;
            s1_b_to_m1 <= 1'b0;
        end
        else begin
            if (grant_s0_m0 && s0_awready && s0_wready) begin
                s0_b_to_m0 <= 1'b1;
                s0_b_to_m1 <= 1'b0;
            end
            else if (grant_s0_m1 && s0_awready && s0_wready) begin
                s0_b_to_m0 <= 1'b0;
                s0_b_to_m1 <= 1'b1;
            end

            if (grant_s1_m0 && s1_awready && s1_wready) begin
                s1_b_to_m0 <= 1'b1;
                s1_b_to_m1 <= 1'b0;
            end
            else if (grant_s1_m1 && s1_awready && s1_wready) begin
                s1_b_to_m0 <= 1'b0;
                s1_b_to_m1 <= 1'b1;
            end

            if (s0_bvalid && s0_bready) begin
                s0_b_to_m0 <= 1'b0;
                s0_b_to_m1 <= 1'b0;
            end

            if (s1_bvalid && s1_bready) begin
                s1_b_to_m0 <= 1'b0;
                s1_b_to_m1 <= 1'b0;
            end
        end
    end

    // ============================================================
    // Write Response Routing
    // ============================================================
    always_comb begin
        m0_bresp  = 2'b00;
        m0_bvalid = 1'b0;
        m1_bresp  = 2'b00;
        m1_bvalid = 1'b0;

        s0_bready = 1'b0;
        s1_bready = 1'b0;

        if (s0_b_to_m0) begin
            m0_bresp  = s0_bresp;
            m0_bvalid = s0_bvalid;
            s0_bready = m0_bready;
        end
        else if (s0_b_to_m1) begin
            m1_bresp  = s0_bresp;
            m1_bvalid = s0_bvalid;
            s0_bready = m1_bready;
        end

        if (s1_b_to_m0) begin
            m0_bresp  = s1_bresp;
            m0_bvalid = s1_bvalid;
            s1_bready = m0_bready;
        end
        else if (s1_b_to_m1) begin
            m1_bresp  = s1_bresp;
            m1_bvalid = s1_bvalid;
            s1_bready = m1_bready;
        end
    end

    // ============================================================
    // Read Arbitration
    // ============================================================
    logic ar_req_s0_m0, ar_req_s0_m1;
    logic ar_req_s1_m0, ar_req_s1_m1;

    logic ar_grant_s0_m0, ar_grant_s0_m1;
    logic ar_grant_s1_m0, ar_grant_s1_m1;

    assign ar_req_s0_m0 = m0_arvalid && m0_ar_sel_s0;
    assign ar_req_s0_m1 = m1_arvalid && m1_ar_sel_s0;

    assign ar_req_s1_m0 = m0_arvalid && m0_ar_sel_s1;
    assign ar_req_s1_m1 = m1_arvalid && m1_ar_sel_s1;

    axi_rr_arbiter u_s0_ar_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req0(ar_req_s0_m0),
        .req1(ar_req_s0_m1),
        .grant0(ar_grant_s0_m0),
        .grant1(ar_grant_s0_m1)
    );

    axi_rr_arbiter u_s1_ar_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req0(ar_req_s1_m0),
        .req1(ar_req_s1_m1),
        .grant0(ar_grant_s1_m0),
        .grant1(ar_grant_s1_m1)
    );

    // ============================================================
    // Read Address Routing
    // ============================================================
    always_comb begin
        s0_araddr  = 32'h0;
        s0_arvalid = 1'b0;
        s1_araddr  = 32'h0;
        s1_arvalid = 1'b0;

        m0_arready = 1'b0;
        m1_arready = 1'b0;

        // Slave 0
        if (ar_grant_s0_m0) begin
            s0_araddr  = m0_araddr;
            s0_arvalid = m0_arvalid;
            m0_arready = s0_arready;
        end
        else if (ar_grant_s0_m1) begin
            s0_araddr  = m1_araddr;
            s0_arvalid = m1_arvalid;
            m1_arready = s0_arready;
        end

        // Slave 1
        if (ar_grant_s1_m0) begin
            s1_araddr  = m0_araddr;
            s1_arvalid = m0_arvalid;
            m0_arready = s1_arready;
        end
        else if (ar_grant_s1_m1) begin
            s1_araddr  = m1_araddr;
            s1_arvalid = m1_arvalid;
            m1_arready = s1_arready;
        end
    end

    // ============================================================
    // Read Response Ownership
    // ============================================================
    logic s0_r_to_m0, s0_r_to_m1;
    logic s1_r_to_m0, s1_r_to_m1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s0_r_to_m0 <= 1'b0;
            s0_r_to_m1 <= 1'b0;
            s1_r_to_m0 <= 1'b0;
            s1_r_to_m1 <= 1'b0;
        end
        else begin
            if (ar_grant_s0_m0 && s0_arready) begin
                s0_r_to_m0 <= 1'b1;
                s0_r_to_m1 <= 1'b0;
            end
            else if (ar_grant_s0_m1 && s0_arready) begin
                s0_r_to_m0 <= 1'b0;
                s0_r_to_m1 <= 1'b1;
            end

            if (ar_grant_s1_m0 && s1_arready) begin
                s1_r_to_m0 <= 1'b1;
                s1_r_to_m1 <= 1'b0;
            end
            else if (ar_grant_s1_m1 && s1_arready) begin
                s1_r_to_m0 <= 1'b0;
                s1_r_to_m1 <= 1'b1;
            end

            if (s0_rvalid && s0_rready) begin
                s0_r_to_m0 <= 1'b0;
                s0_r_to_m1 <= 1'b0;
            end

            if (s1_rvalid && s1_rready) begin
                s1_r_to_m0 <= 1'b0;
                s1_r_to_m1 <= 1'b0;
            end
        end
    end

    // ============================================================
    // Read Response Routing
    // ============================================================
    always_comb begin
        m0_rdata  = 32'h0;
        m0_rresp  = 2'b00;
        m0_rvalid = 1'b0;

        m1_rdata  = 32'h0;
        m1_rresp  = 2'b00;
        m1_rvalid = 1'b0;

        s0_rready = 1'b0;
        s1_rready = 1'b0;

        if (s0_r_to_m0) begin
            m0_rdata  = s0_rdata;
            m0_rresp  = s0_rresp;
            m0_rvalid = s0_rvalid;
            s0_rready = m0_rready;
        end
        else if (s0_r_to_m1) begin
            m1_rdata  = s0_rdata;
            m1_rresp  = s0_rresp;
            m1_rvalid = s0_rvalid;
            s0_rready = m1_rready;
        end

        if (s1_r_to_m0) begin
            m0_rdata  = s1_rdata;
            m0_rresp  = s1_rresp;
            m0_rvalid = s1_rvalid;
            s1_rready = m0_rready;
        end
        else if (s1_r_to_m1) begin
            m1_rdata  = s1_rdata;
            m1_rresp  = s1_rresp;
            m1_rvalid = s1_rvalid;
            s1_rready = m1_rready;
        end
    end

endmodule
