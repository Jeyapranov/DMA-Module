import uvm_pkg::*;
import dma_pkg::*;

module tb_top;
  logic clk = 0;
  logic rst_n = 0;
  
  always #5 clk = ~clk;

  dma_if vif(clk, rst_n);
  
  generic_dma dut (
    .clk(vif.clk),
    .rst_n(vif.rst_n),
    .src_addr(vif.src_addr),
    .dst_addr(vif.dst_addr),
    .size(vif.size),
    .valid(vif.valid),
    .ready(vif.ready)
  );

  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  initial begin
    uvm_config_db#(virtual dma_if)::set(null, "uvm_test_top", "vif", vif);
    run_test("dma_test");
  end
endmodule
