module async_fifo_tb;

    reg clk1, clk2, rstn;
    reg wr_en, rd_en;
    reg [7:0] wr_data;
    wire [7:0] rd_data;
    wire full, empty;

    // DUT
    asyn_fifo DUT (
        .clk1(clk1),
        .clk2(clk2),
        .rstn(rstn),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // clocks
    always #5 clk1 = ~clk1;
    always #10 clk2 = ~clk2;

    initial begin

        #1 clk1 = 0;#1 clk2 = 0;
        rstn = 0;
        wr_en = 0; rd_en = 0;
        wr_data = 0;


        #20 rstn = 1;


        @(posedge clk1);
        wr_en = 1; wr_data = 8'hA1;

        @(posedge clk1);
        wr_data = 8'hB2;

        @(posedge clk1);
        wr_data = 8'hC3;

        @(posedge clk1);
        wr_data = 8'hD4;

        @(posedge clk1);
        wr_data = 8'hE5;

        @(posedge clk1);
        wr_data = 8'hF6;

        @(posedge clk1);
        wr_data = 8'hE7;

        @(posedge clk1);
        wr_data = 8'hD8;

        @(posedge clk1);
        wr_data = 8'hC9;
                                                

        @(posedge clk1);
        wr_en = 0;


        @(posedge clk2);
        rd_en = 1;

        @(posedge clk2);
        @(posedge clk2);
        @(posedge clk2);
        @(posedge clk2);
        @(posedge clk2);
        @(posedge clk2);
        @(posedge clk2);
        @(posedge clk2);
        @(posedge clk2);

        rd_en = 0;

        #50 $finish;
    end


    always @(posedge clk2) begin
        if (rd_en && !empty)
            $display("Read Data = %h", rd_data);
    end

endmodule
