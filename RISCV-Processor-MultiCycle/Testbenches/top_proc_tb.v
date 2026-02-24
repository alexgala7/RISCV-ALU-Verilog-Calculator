`timescale 1ns / 1ps

module top_proc_tb;

    // Ρολόι και reset
    reg clk;
    reg rst;

    // Είσοδοι και έξοδοι του top_proc
    wire [31:0] PC;
    wire [31:0] dAddress;
    wire [31:0] dWriteData;
    wire [31:0] WriteBackData;
    wire MemRead;
    wire MemWrite;

    // Instantiation του top_proc
    top_proc uut (
        .clk(clk),
        .rst(rst),
        .PC(PC),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .WriteBackData(WriteBackData),
        .MemRead(MemRead),
        .MemWrite(MemWrite)
    );

    // Ρολόι (περίοδος 10ns)
    always #5 clk = ~clk;

    // Αρχικοποίηση
    initial begin
        clk = 0;
        rst = 1;

        // Reset
        #10;
        rst = 0;

        // Εμφάνιση αποτελεσμάτων
        $monitor("Time: %0t | PC: %h | MemRead: %b | MemWrite: %b | dAddress: %h | dWriteData: %h | WriteBackData: %h",
                 $time, PC, MemRead, MemWrite, dAddress, dWriteData, WriteBackData);

        // Περιμένουμε για μερικούς κύκλους για να παρατηρήσουμε τη λειτουργία
        #200;

        // Τερματισμός προσομοίωσης
        $stop;
    end

endmodule
