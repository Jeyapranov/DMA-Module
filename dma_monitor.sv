class dma_monitor extends uvm_monitor;
  `uvm_component_utils(dma_monitor)
  
  dma_config cfg;
  uvm_analysis_port #(dma_txn) ap;

  function new(string name, uvm_component parent); 
    super.new(name, parent); 
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(dma_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("MON", "Failed to get Config Object")
  endfunction

  task run_phase(uvm_phase phase);
    dma_txn txn;
    forever begin
      @(posedge cfg.vif.clk);
      if (cfg.vif.valid && cfg.vif.ready) begin
        txn = dma_txn::type_id::create("txn");
        txn.src_addr = cfg.vif.src_addr;
        txn.dst_addr = cfg.vif.dst_addr;
        txn.size     = cfg.vif.size;
        ap.write(txn);
      end
    end
  endtask
endclass
