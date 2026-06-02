// dma_test.sv
class dma_test extends uvm_test;
  `uvm_component_utils(dma_test)
  
  dma_env    env;
  dma_config cfg;

  function new(string name, uvm_component parent); 
    super.new(name, parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    cfg = dma_config::type_id::create("cfg");
    
    if (!uvm_config_db#(virtual dma_if)::get(this, "", "vif", cfg.vif))
      `uvm_fatal("TEST", "Did not get vif from tb_top")
    
    uvm_config_db#(dma_config)::set(this, "env.agt*", "cfg", cfg);

    env = dma_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    dma_sequence seq;
    phase.raise_objection(this);
    seq = dma_sequence::type_id::create("seq");
    seq.start(env.agt.sqr);
    #50;
    phase.drop_objection(this);
  endtask
endclass
