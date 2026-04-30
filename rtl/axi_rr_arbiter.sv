module axi_rr_arbiter (
    input  logic clk,
    input  logic rst_n,

    input  logic req0,
    input  logic req1,

    output logic grant0,
    output logic grant1
);

    logic last_grant;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            last_grant <= 1'b0;
        else if (grant0)
            last_grant <= 1'b0;
        else if (grant1)
            last_grant <= 1'b1;
    end

    always_comb begin
        grant0 = 1'b0;
        grant1 = 1'b0;

        case ({req1, req0})
            2'b01: grant0 = 1'b1;
            2'b10: grant1 = 1'b1;
            2'b11: begin
                if (last_grant == 1'b0)
                    grant1 = 1'b1;
                else
                    grant0 = 1'b1;
            end
            default: begin
                grant0 = 1'b0;
                grant1 = 1'b0;
            end
        endcase
    end
// Slave 0
axi_rr_arbiter u_s0_arb (
    .clk(clk),
    .rst_n(rst_n),
    .req0(req_s0_m0),
    .req1(req_s0_m1),
    .grant0(grant_s0_m0),
    .grant1(grant_s0_m1)
);

// Slave 1
    axi_rr_arbiter u_s1_arb (
    .clk(clk),
    .rst_n(rst_n),
    .req0(req_s1_m0),
    .req1(req_s1_m1),
    .grant0(grant_s1_m0),
    .grant1(grant_s1_m1)
);
endmodule

