module top_proc #(
    parameter INITIAL_PC = 32'h00400000
)(
    input wire clk,
    input wire rst,
    output wire [31:0] PC,
    output wire [31:0] dAddress,
    output wire [31:0] dWriteData,
    output wire [31:0] WriteBackData,
    output wire MemRead,
    output wire MemWrite
);

    // Ενδιάμεσα σήματα
    wire [31:0] instr;
    wire [31:0] dReadData;
    wire [8:0] instr_address;
    wire [8:0] data_address;

    // Υπολογισμός διευθύνσεων
    assign instr_address = PC[10:2]; // 9-bit διεύθυνση για τη μνήμη εντολών
    assign data_address = dAddress[10:2]; // 9-bit διεύθυνση για τη μνήμη δεδομένων

    // Αντίγραφο της INSTRUCTION_MEMORY
    INSTRUCTION_MEMORY instr_mem (
        .clk(clk),
        .addr(instr_address),
        .dout(instr)
    );

    // Αντίγραφο της DATA_MEMORY
    DATA_MEMORY data_mem (
        .clk(clk),
        .we(MemWrite),// Γράφουμε μόνο όταν MemWrite είναι ενεργό
        .addr(data_address),
        .din(dWriteData),
        .dout(dReadData)
    );

    // FSM σήματα
    reg PCSrc, RegWrite, loadPC;
    reg [3:0] ALUCtrl;
    reg mem_read, mem_write;

    // Ενδιάμεσα σήματα ελέγχου
    wire ALUSrc, MemToReg;
    wire Zero;

    // Αντίγραφο του Datapath για να τρέξει ο κώδικας
    datapath #(.INITIAL_PC(INITIAL_PC)) dp (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .dReadData(dReadData),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .ALUCtrl(ALUCtrl),
        .loadPC(loadPC),
        .PC(PC),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .WriteBackData(WriteBackData),
        .Zero(Zero)
    );

    // Ορισμός FSM Καταστάσεων
    parameter IF  = 3'b000;
    parameter ID  = 3'b001;
    parameter EX  = 3'b010;
    parameter MEM = 3'b011;
    parameter WB  = 3'b100;

    // Καταχωρητές για την τρέχουσα και την επόμενη κατάσταση
    reg [2:0] state, next_state;

    // FSM Λογική
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin // FSM λογική που ερμηνεύεται από την εκφώνηση
        // Προεπιλογή σημάτων
        PCSrc = 0;
        RegWrite = 0;
        loadPC = 1; // Πάντα ενημέρωση του PC
        mem_read = 0;
        mem_write = 0;
        ALUCtrl = 4'b0000;

        case (state)
            IF: begin
                next_state = ID;
            end
            ID: begin
                next_state = EX;
            end
            EX: begin
                case (instr[6:0])
                    7'b0000011: begin // LW
                        ALUCtrl = 4'b0010; // ADD
                        next_state = MEM;
                    end
                    7'b0100011: begin // SW
                        ALUCtrl = 4'b0010; // ADD
                        next_state = MEM;
                    end
                    7'b1100011: begin // BEQ
                        ALUCtrl = 4'b0110; // SUB
                        PCSrc = Zero;
                        next_state = IF;
                    end
                    7'b0110011: begin // R-type
                        case ({instr[31:25], instr[14:12]})
                            10'b0000000000: ALUCtrl = 4'b0010; // ADD
                            10'b0100000000: ALUCtrl = 4'b0110; // SUB
                            10'b0000000111: ALUCtrl = 4'b0000; // AND
                            10'b0000000110: ALUCtrl = 4'b0001; // OR
                        endcase
                        next_state = WB;
                    end
                    7'b0010011: begin // ALU Immediate
                        case (instr[14:12])
                            3'b000: ALUCtrl = 4'b0010; // ADDI
                            3'b111: ALUCtrl = 4'b0000; // ANDI
                            3'b110: ALUCtrl = 4'b0001; // ORI
                            3'b100: ALUCtrl = 4'b0101; // XORI
                        endcase
                        next_state = WB;
                    end
                endcase
            end
            MEM: begin
                if (instr[6:0] == 7'b0000011) begin // LW
                    mem_read = 1;
                    next_state = WB;
                end else if (instr[6:0] == 7'b0100011) begin // SW
                    mem_write = 1;
                    next_state = IF;
                end
            end
            WB: begin
                RegWrite = (instr[6:0] != 7'b0100011); // Όχι για SW
                next_state = IF;
            end
            default: begin
                next_state = IF;
            end
        endcase
    end

    // Σήματα MemRead και MemWrite
    assign MemRead = (state == MEM) && mem_read;
    assign MemWrite = (state == MEM) && mem_write;

endmodule
