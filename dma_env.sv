class dma_env extends uvm_env;
  `uvm_component_utils(dma_env)
  dma_agent agt;

  function new(string name, uvm_component parent); 
    super.new(name, parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = dma_agent::type_id::create("agt", this);
  endfunction
endclass
