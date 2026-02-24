module calc(
    input clk,               // Ρολόι
    input btnc,              // Κεντρικό πλήκτρο
    input btnl,              // Αριστερό πλήκτρο
    input btnu,              // Πάνω πλήκτρο (μηδενισμός accumulator)
    input btnr,              // Δεξί πλήκτρο
    input btnd,              // Κάτω πλήκτρο (ενημέρωση accumulator)
    input [15:0] sw,         // Διακόπτες για την εισαγωγή δεδομένων
    output reg [15:0] led    // LED για την έξοδο του συσσωρευτή
);

    // Καταχωρητής συσσωρευτή 16-bit
    reg [15:0] accumulator = 16'b0;

    // Επέκταση προσήμου για είσοδο στην ALU
    wire [31:0] sign_extended_accumulator = {{16{accumulator[15]}}, accumulator}; // Επέκταση προσήμου του accumulator
    wire [31:0] sign_extended_sw = {{16{sw[15]}}, sw};                           // Επέκταση προσήμου των διακοπτών

    // ALU θύρες
    wire [31:0] alu_op1 = sign_extended_accumulator;  // ALU op1
    wire [31:0] alu_op2 = sign_extended_sw;           // ALU op2
    wire [3:0] alu_op;                                // Επιλογή λειτουργίας της ALU
    wire [31:0] alu_result;                           // Αποτέλεσμα της ALU
    wire alu_zero;                                    // Zero flag της ALU

    // ALU Instance
    alu alu_instance (
        .op1(alu_op1),
        .op2(alu_op2),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );

    // Υπομονάδα calc_enc για τον υπολογισμό του alu_op
    calc_enc calc_encoder (
        .btnl(btnl),
        .btnc(btnc),
        .btnr(btnr),
        .alu_op(alu_op)
    );

    // Λογική του συσσωρευτή
    always @(posedge clk) begin
        if (btnu) begin
            // Μηδενισμός accumulator με το πάτημα του btnu
            accumulator <= 16'b0;
        end else if (btnd) begin
            // Ενημέρωση accumulator με το αποτέλεσμα της ALU (16 LSBs) όταν πατιέται το btnd
            accumulator <= alu_result[15:0];
        end
    end

    // Σύνδεση συσσωρευτή με τα LEDs
    always @(*) begin
        led = accumulator;
    end

endmodule
