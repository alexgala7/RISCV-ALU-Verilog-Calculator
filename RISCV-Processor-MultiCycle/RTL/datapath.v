module datapath #(
    parameter INITIAL_PC = 32'h00400000
) (
    input wire clk,
    input wire rst,
    input wire PCSrc,
    input wire ALUSrc,
    input wire RegWrite,
    input wire MemToReg,
    input wire [3:0] ALUCtrl,
    input wire loadPC,
    input wire [31:0] dReadData,
    input wire [31:0] instr,
    output reg [31:0] PC,
    output wire Zero,
    output wire [31:0] dAddress,
    output wire [31:0] dWriteData,
    output wire [31:0] WriteBackData
);

    // Εσωτερικά Σήματα
    reg [31:0] nextPC;
    wire [31:0] branchOffset;
    wire [31:0] ALUResult;
    wire [31:0] regReadData1, regReadData2;
    wire [31:0] aluSrcB;
    wire [31:0] immGenOut;
    wire [31:0] writeData;

    // Immediate generation σύμφωνα με το εγχειρίδιο εντολών RISC-V
    assign immGenOut = (instr[6:0] == 7'b0010011) ? {{20{instr[31]}}, instr[31:20]} : // I-type
                       (instr[6:0] == 7'b0100011) ? {{20{instr[31]}}, instr[31:25], instr[11:7]} : // S-type
                       (instr[6:0] == 7'b1100011) ? {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0} : // B-type
                       32'b0;

    // PC λογική
    always @(posedge clk or posedge rst) begin
        if (rst)
            PC <= INITIAL_PC;
        else if (loadPC)
            PC <= nextPC;
    end

    // Υπολογισμός του Branch target
    always @(*) begin
        nextPC = PCSrc ? (PC + immGenOut) : (PC + 4);
    end

    // Register file
    regfile rf (
        .clk(clk),
        .readReg1(instr[19:15]),
        .readReg2(instr[24:20]),
        .writeReg(instr[11:7]),
        .writeData(writeData),
        .write(RegWrite),
        .readData1(regReadData1),
        .readData2(regReadData2)
    );

    // Επιλογή του op2 της ALU, σύμφωνα με το σήμα ALUSrc
    assign aluSrcB = ALUSrc ? immGenOut : regReadData2;

    // ALU instance
    alu alu_inst (
        .op1(regReadData1),
        .op2(aluSrcB),
        .alu_op(ALUCtrl),
        .result(ALUResult),
        .zero(Zero)
    );

    // Data memory address and write data
    assign dAddress = ALUResult;
    assign dWriteData = regReadData2;

    // Write back logic
    assign writeData = MemToReg ? dReadData : ALUResult;

    // Write back data output
    assign WriteBackData = writeData;

endmodule
