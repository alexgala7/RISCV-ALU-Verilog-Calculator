module calc_enc(
    input btnl, // Αριστερό πλήκτρο
    input btnc, // Κεντρικό πλήκτρο
    input btnr, // Δεξί πλήκτρο
    output [3:0] alu_op // Κωδικοποίηση λειτουργιών ALU
);

    // Υπολογισμός των alu_op bits σύμφωνα με τα λογικά διαγράμματα

    // Σχήμα 2: alu_op[0]
    assign alu_op[0] = (~btnc & btnr) | (btnl & btnr);

    // Σχήμα 3: alu_op[1]
    assign alu_op[1] = (~btnl & btnc) | (btnc & ~btnr);

    // Σχήμα 4: alu_op[2]
    assign alu_op[2] = (btnc & btnr) | ((btnl & ~btnc) & ~btnr);

    // Σχήμα 5: alu_op[3]
    assign alu_op[3] = ((btnl & ~btnc) & btnr) | ((btnl & btnc) & ~btnr);

endmodule
