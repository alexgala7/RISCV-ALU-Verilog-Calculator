module alu(
    input [31:0] op1, // 32-bit τελεστής 1 σε συμπλήρωμα ως προς 2
    input [31:0] op2, // 32-bit τελεστής 2 σε συμπλήρωμα ως προς 2
    input [3:0] alu_op, // 4-bit κωδικοποίηση λειτουργίας
    output reg [31:0] result, // 32-bit αποτέλεσμα
    output reg zero // Flag για μηδενικό αποτέλεσμα
);

    // Παραμετροποίηση για τις λειτουργίες της ALU
    parameter [3:0] ALUOP_AND = 4'b0000;
    parameter [3:0] ALUOP_OR  = 4'b0001;
    parameter [3:0] ALUOP_ADD = 4'b0010;
    parameter [3:0] ALUOP_SUB = 4'b0110;
    parameter [3:0] ALUOP_SLT = 4'b0100; // Μικρότερο από
    parameter [3:0] ALUOP_SRL = 4'b1000; // Λογική ολίσθηση δεξιά
    parameter [3:0] ALUOP_SLL = 4'b1001; // Λογική ολίσθηση αριστερά
    parameter [3:0] ALUOP_SRA = 4'b1010; // Αριθμητική ολίσθηση δεξιά
    parameter [3:0] ALUOP_XOR = 4'b0101;

    always @(*) begin
        case (alu_op)
            ALUOP_AND: result = op1 & op2;
            ALUOP_OR: result = op1 | op2;
            ALUOP_ADD: result = op1 + op2;
            ALUOP_SUB: result = op1 - op2; 
            ALUOP_SLT: result = ($signed(op1) < $signed(op2)) ? 32'b1 : 32'b0; // Μικρότερο από (προσημασμένοι αριθμοί)
            ALUOP_SRL: result = op1 >> op2[4:0]; // Λογική ολίσθηση δεξιά
            ALUOP_SLL: result = op1 << op2[4:0]; // Λογική ολίσθηση αριστερά
            ALUOP_SRA: result = $signed(op1) >>> op2[4:0]; // Αριθμητική ολίσθηση δεξιά
            ALUOP_XOR: result = op1 ^ op2;
            default: result = 32'b0; // Default: 0
        endcase

        // Υπολογισμός του zero flag
        zero = (result == 32'b0) ? 1'b1 : 1'b0;
    end

endmodule
