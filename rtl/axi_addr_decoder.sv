module axi_addr_decoder (
    input  logic [31:0] addr,
    output logic        sel_s0,
    output logic        sel_s1
);

    always_comb begin
        sel_s0 = 1'b0;
        sel_s1 = 1'b0;

        if (addr[31:16] == 16'h0000)
            sel_s0 = 1'b1;
        else if (addr[31:16] == 16'h0001)
            sel_s1 = 1'b1;
    end

endmodule
