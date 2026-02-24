module calc_tb;

    reg clk;
    reg btnu, btnd, btnl, btnc, btnr; // Buttons
    reg [15:0] sw;                   // Switches
    wire [15:0] led;                 // Output LEDs

    // Δημιουργία αντιγράφου της αριθμομηχανής για να τρέξω το testbench
    calc uut (
        .clk(clk),
        .btnu(btnu),
        .btnd(btnd),
        .btnl(btnl),
        .btnc(btnc),
        .btnr(btnr),
        .sw(sw),
        .led(led)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns περίοδος
    end

    // Testbench
    initial begin
        $display("Starting Testbench...");

        // Reset
        btnu = 1; btnd = 0; btnl = 0; btnc = 0; btnr = 0; sw = 16'h0000;
        @(posedge clk);
        btnu = 0;
        @(posedge clk);
        if (led !== 16'h0000) 
            $display("ERROR: RESET failed | Expected: 0x0000, Actual: 0x%h", led);
        else 
            $display("PASS: RESET | Expected: 0x0000, Actual: 0x%h", led);

        // ADD
        btnu = 0; btnl = 0; btnc = 1; btnr = 0; sw = 16'h354a;
        btnd = 1; // Ανανέωση συσσωρευτή όπου έχω btnd=1
        @(posedge clk); // Στη θετική ακμή του ρολογιού
        btnd = 0;
        @(posedge clk);
        if (led !== 16'h354a) 
            $display("ERROR: ADD failed | Expected: 0x354a, Actual: 0x%h", led);
        else 
            $display("PASS: ADD | Expected: 0x354a, Actual: 0x%h", led);

        // SUB
        btnu = 0; btnl = 0; btnc = 1; btnr = 1; sw = 16'h1234;
        btnd = 1; 
        @(posedge clk); 
        btnd = 0; 
        @(posedge clk);
        if (led !== 16'h2316) 
            $display("ERROR: SUB failed | Expected: 0x2316, Actual: 0x%h", led);
        else 
            $display("PASS: SUB | Expected: 0x2316, Actual: 0x%h", led);

        // OR
        btnu = 0; btnl = 0; btnc = 0; btnr = 1; sw = 16'h1001;
        btnd = 1; 
        @(posedge clk);
        btnd = 0;
        @(posedge clk); 
        if (led !== 16'h3317) 
            $display("ERROR: OR failed | Expected: 0x3317, Actual: 0x%h", led);
        else 
            $display("PASS: OR | Expected: 0x3317, Actual: 0x%h", led);

        // AND
        btnu = 0; btnl = 0; btnc = 0; btnr = 0; sw = 16'hf0f0;
        btnd = 1;
        @(posedge clk);
        btnd = 0;
        @(posedge clk);
        if (led !== 16'h3010) 
            $display("ERROR: AND failed | Expected: 0x3010, Actual: 0x%h", led);
        else 
            $display("PASS: AND | Expected: 0x3010, Actual: 0x%h", led);

        // XOR
        btnu = 0; btnl = 1; btnc = 1; btnr = 1; sw = 16'h1fa2;
        btnd = 1;
        @(posedge clk);
        btnd = 0;
        @(posedge clk);
        if (led !== 16'h2fb2) 
            $display("ERROR: XOR failed | Expected: 0x2fb2, Actual: 0x%h", led);
        else 
            $display("PASS: XOR | Expected: 0x2fb2, Actual: 0x%h", led);

        // ADD 
        btnu = 0; btnl = 0; btnc = 1; btnr = 0; sw = 16'h6aa2;
        btnd = 1;
        @(posedge clk);
        btnd = 0;
        @(posedge clk);
        if (led !== 16'h9a54) 
            $display("ERROR: ADD failed | Expected: 0x9a54, Actual: 0x%h", led);
        else 
            $display("PASS: ADD | Expected: 0x9a54, Actual: 0x%h", led);

        // Logical Shift Left
        btnu = 0; btnl = 1; btnc = 0; btnr = 1; sw = 16'h0004;
        btnd = 1; 
        @(posedge clk); 
        btnd = 0;
        @(posedge clk);
        if (led !== 16'ha540) 
            $display("ERROR: Logical Shift Left failed | Expected: 0xa540, Actual: 0x%h", led);
        else 
            $display("PASS: Logical Shift Left | Expected: 0xa540, Actual: 0x%h", led);

        // Shift Right Arithmetic
        btnu = 0; btnl = 1; btnc = 1; btnr = 0; sw = 16'h0001;
        btnd = 1;
        @(posedge clk);
        btnd = 0;
        @(posedge clk); 
        if (led !== 16'hd2a0) 
            $display("ERROR: Shift Right Arithmetic failed | Expected: 0xd2a0, Actual: 0x%h", led);
        else 
            $display("PASS: Shift Right Arithmetic | Expected: 0xd2a0, Actual: 0x%h", led);

        // Less Than
        btnu = 0; btnl = 1; btnc = 0; btnr = 0; sw = 16'h46ff;
        btnd = 1
        @(posedge clk);
        btnd = 0; 
        @(posedge clk);
        if (led !== 16'h0001) 
            $display("ERROR: Less Than failed | Expected: 0x0001, Actual: 0x%h", led);
        else 
            $display("PASS: Less Than | Expected: 0x0001, Actual: 0x%h", led);

        $finish;
    end

endmodule
