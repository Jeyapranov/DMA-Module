class dma_driver extends uvm_driver #(dma_txn);
  `uvm_component_utils(dma_driver)
  
  dma_config cfg;

  function new(string name, uvm_component parent); 
    super.new(name, parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(dma_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("DRV", "Failed to get Config Object")
  endfunction

  task run_phase(uvm_phase phase);

    cfg.vif.valid <= 0;
    wait(cfg.vif.rst_n == 1);
    forever begin
      seq_item_port.get_next_item(req);
      @(posedge cfg.vif.clk);
      cfg.vif.src_addr <= req.src_addr;
      cfg.vif.dst_addr <= req.dst_addr;
      cfg.vif.size     <= req.size;
      cfg.vif.valid    <= 1;

      `uvm_info("DRV", $sformatf("Driving -> %s", req.convert2string()), UVM_NONE)

      do begin
        @(posedge cfg.vif.clk);
      end while (cfg.vif.ready !== 1);

      cfg.vif.valid <= 0;
      seq_item_port.item_done();
    end
  endtask
endclass
