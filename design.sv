module generic_dma (
  input logic clk,
  input logic rst_n,
  input logic [31:0]src_addr,
  input logic [31:0]dst_addr,
  input logic [15:0]size,
  input logic valid,
  output logic ready);

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
        ready <= 1'b0;
    else  
        ready <= $urandom_range(0, 1);
  end
endmodule
