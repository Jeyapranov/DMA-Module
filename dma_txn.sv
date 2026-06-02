class dma_txn extends uvm_sequence_item;
  rand bit [31:0] src_addr;
  rand bit [31:0] dst_addr;
  rand bit [15:0] size;

  `uvm_object_utils(dma_txn)

  constraint c_align { src_addr[1:0] == 0; dst_addr[1:0] == 0; }
  constraint c_size  { size > 0; size <= 256; }

  function new(string name = "dma_txn"); super.new(name); endfunction

  virtual function string convert2string();
    return $sformatf("SRC: 0x%08h | DST: 0x%08h | SIZE: %0d", src_addr, dst_addr, size);
  endfunction
endclass
