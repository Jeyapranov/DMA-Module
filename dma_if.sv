interface dma_if(input logic clk, input logic rst_n);
  logic [31:0] src_addr;
  logic [31:0] dst_addr;
  logic [15:0] size;
  logic        valid;
  logic        ready;

  property p_stable_data_until_ready;
    @(posedge clk) disable iff (!rst_n)
      (valid && !ready) |=> (valid && $stable(src_addr) && $stable(dst_addr) && $stable(size));
  endproperty

  assert_stable_data: assert property(p_stable_data_until_ready)
    else $error("SVA VIOLATION: Data or Valid changed before Ready was asserted!");
endinterface
