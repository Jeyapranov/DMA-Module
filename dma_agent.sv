class dma_agent extends uvm_agent;
  `uvm_component_utils(dma_agent)

  dma_config               cfg;
  uvm_sequencer #(dma_txn) sqr;
  dma_driver               drv;
  dma_monitor              mon;

  function new(string name, uvm_component parent); super.new(name, parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(dma_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("AGT", "Failed to get Config Object")

    mon = dma_monitor::type_id::create("mon", this);
    
    if (cfg.is_active == UVM_ACTIVE) begin
      sqr = uvm_sequencer#(dma_txn)::type_id::create("sqr", this);
      drv = dma_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if (cfg.is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
endclass
