module async_fifo( input            clk1,
                  input            clk2,
                  input            rstn,
                  input            wr_en,
                  input            rd_en,
                  input      [7:0] wr_data,
                  output reg [7:0] rd_data,
                  output           empty,
                  output           full
                );

                reg [3:0] b_wr_ptr;
                reg [3:0] b_rd_ptr;
                
                reg [3:0] g_wr_ptr;
                reg [3:0] g_rd_ptr;
                
                reg [3:0] sync1_g_wr_ptr;
                reg [3:0] sync2_g_wr_ptr;
                
                reg [3:0] sync1_g_rd_ptr;
                reg [3:0] sync2_g_rd_ptr;
                
                reg [7:0] mem [7:0];

                always@(posedge clk1 or negedge rstn) begin
                
                    if(!rstn) begin
                        b_wr_ptr <= 0;
                        g_wr_ptr <= 0;
                        sync1_g_rd_ptr <= 0;
                        sync2_g_rd_ptr <= 0;
                    end
                    
                    else begin
                    
                    if (wr_en && !full) begin
                        mem[b_wr_ptr[2:0]] <= wr_data;
                        b_wr_ptr <= b_wr_ptr + 1;
                    end
                    
                    sync1_g_rd_ptr <= g_rd_ptr;
                    sync2_g_rd_ptr <= sync1_g_rd_ptr;
                    
                    g_wr_ptr <= b_wr_ptr ^ (b_wr_ptr>>1);
                    
                    end
                
                end
                
                always@(posedge clk2 or negedge rstn) begin
                    if (!rstn) begin
                        b_rd_ptr <= 0;
                        g_rd_ptr <= 0;
                        sync1_g_wr_ptr <= 0;
                        sync2_g_wr_ptr <= 0;
                    end

                    else begin
                        
                        if (rd_en && !empty) begin
                            rd_data <= mem [b_rd_ptr[2:0]];
                            b_rd_ptr <= b_rd_ptr + 1;
                        end 
                        
                        sync1_g_wr_ptr <= g_wr_ptr;
                        sync2_g_wr_ptr <= sync1_g_wr_ptr;
                        
                        g_rd_ptr <= b_rd_ptr ^ (b_rd_ptr >> 1);
                    end   

                end
                
                assign full = (g_wr_ptr == ({~sync2_g_rd_ptr[3:2],sync2_g_rd_ptr[1:0]}))?1:0;
                assign empty = (g_rd_ptr == sync2_g_wr_ptr)?1:0;

endmodule
