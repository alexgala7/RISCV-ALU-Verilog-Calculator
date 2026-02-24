module regfile #(parameter DATAWIDTH = 32)(
    input clk,
    input [4:0] readReg1, // Διεύθυνση για τη θύρα ανάγνωσης 1
    input [4:0] readReg2, // Διεύθυνση για τη θύρα ανάγνωσης 2
    input [4:0] writeReg, // Διεύθυνση για τη θύρα εγγραφής
    input [DATAWIDTH-1:0] writeData, // Δεδομένα προς εγγραφή
    input write, // Σήμα ελέγχου εγγραφής
    output reg [DATAWIDTH-1:0] readData1, // Δεδομένα ανάγνωσης από τη θύρα 1
    output reg [DATAWIDTH-1:0] readData2  // Δεδομένα ανάγνωσης από τη θύρα 2
);

    // 32 DATAWIDTH-bit καταχωρητές
    reg [DATAWIDTH-1:0] registers [31:0];

    integer i;

    // Αρχικοποίηση σε μηδενικά
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 0;
        end
    end

    // Ανάγνωση δεδομένων
    always @(*) begin
        readData1 = registers[readReg1];
        readData2 = registers[readReg2];

        if (write) begin
            if (writeReg == readReg1) begin
                readData1 = writeData;
            end
            if (writeReg == readReg2) begin
                readData2 = writeData;
            end
        end
    end

    // Εγγραφή δεδομένων στον κατάλληλο καταχωρητή
    always @(posedge clk) begin
        if (write && writeReg != 0) begin
            registers[writeReg] <= writeData;
        end
    end

endmodule
