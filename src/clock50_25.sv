module clock50_25 (
    input logic clock50,
    input logic reset,
    output logic clock25
);
    logic [1:0] state;

    always_ff @(posedge clock50) begin
        if (reset)
            state <= 2'b00;
        else
            state <= state + 2'b01;
    end

    assign clock25 = (state == 2'b00 || state == 2'b10) ? 1'b1 : 1'b0;
endmodule
