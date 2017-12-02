//------------------------------------------------------------------------
// Input Conditioner test bench
// Because this is so dependent on time, we test the outputs
// of the input conditioner every 20 time units (one clock cycle)
//------------------------------------------------------------------------
`include "inputconditioner.v"

module outputTester (
    input conditioned,
    input rising,
    input falling,
    input expectedCond,
    input expectedRise,
    input expectedFall,
    output equivalent
);

assign equivalent = (conditioned == expectedCond) & (rising == expectedRise) & (falling == expectedFall);

endmodule


module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    
    inputconditioner #(1) dut(.clk(clk),
                 .noisysignal(pin),
             .conditioned(conditioned),
             .positiveedge(rising),
             .negativeedge(falling));

    // testing unit
    reg expectedCond, expectedRise, expectedFall;
    wire isEquivalent;
    outputTester tester(.conditioned(conditioned),
        .rising(rising),
        .falling(falling),
        .expectedCond(expectedCond),
        .expectedRise(expectedRise),
        .expectedFall(expectedFall),
        .equivalent(isEquivalent));

    // Generate clock (50MHz)
    initial begin 
    clk=0;
    pin=0;
    end
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
    $dumpfile("iconditioner.vcd");
    $dumpvars();

    //change pin to 1
    pin=1;

    expectedCond = 0;
    expectedRise = 0;
    expectedFall = 0;
    repeat (3) begin
        #20
        if (isEquivalent == 0) begin
            $display("Test 1 failed: expected %b %b %b, got %b %b %b", 
                expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
        end
    end
    
    expectedCond = 1;
    expectedRise = 1;
    #20
    if (isEquivalent == 0) begin
        $display("Test 2 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    expectedRise = 0;
    #20
    if (isEquivalent == 0) begin
        $display("Test 3 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    #40

    // change pin to 0
    pin=0;

    repeat (5) begin
        #20
        if (isEquivalent == 0) begin
            $display("Test 4 failed: expected %b %b %b, got %b %b %b", 
                expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
        end
    end

    expectedCond = 0;
    expectedFall = 1;
    #20
    if (isEquivalent == 0) begin
        $display("Test 5 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    expectedFall = 0;
    #20
    if (isEquivalent == 0) begin
        $display("Test 6 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    pin=1;

    #20
    if (isEquivalent == 0) begin
        $display("Test 7 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    // bouncing
    pin=0;

    #20
    if (isEquivalent == 0) begin
        $display("Test 8 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    pin=1;

    repeat (5) begin
        #20
        if (isEquivalent == 0) begin
            $display("Test 9 failed: expected %b %b %b, got %b %b %b", 
                expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
        end
    end

    expectedCond = 1;
    expectedRise = 1;
    #20
    if (isEquivalent == 0) begin
        $display("Test 10 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    expectedRise = 0;
    #20
    if (isEquivalent == 0) begin
        $display("Test 11 failed: expected %b %b %b, got %b %b %b", 
            expectedCond, expectedRise, expectedFall, conditioned, rising, falling);
    end

    $finish;
    end
    
endmodule