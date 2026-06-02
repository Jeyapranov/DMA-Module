class dma_sequence extends uvm_sequence #(dma_txn);
  `uvm_object_utils(dma_sequence)

  function new(string name = "dma_sequence"); 
    super.new(name); 
  endfunction

  task body();
    dma_txn req;
    `uvm_info("SEQ", "Pumping 100 Transactions (Starter Edition Bypass)...", UVM_NONE)
    
    repeat(100) begin
      req = dma_txn::type_id::create("req");
      start_item(req);
      
      req.src_addr = $urandom() & 32'hFFFFFFFC; 
      req.dst_addr = $urandom() & 32'hFFFFFFFC; 
      req.size     = $urandom_range(1, 256);
      
      finish_item(req);
    end
    `uvm_info("SEQ", "Finished pumping 100 transactions.", UVM_NONE)
  endtask
endclass
