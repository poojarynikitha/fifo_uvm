 class f_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(fifo_seq_item , f_scoreboard) item_got_export;
  `uvm_component_utils(f_scoreboard)
    int counter;
  function new(string name = "f_scoreboard", uvm_component parent);
    super.new(name , parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
       bit [127:0] queue[$];
  
  function void write(input fifo_seq_item item_got);
    bit [127:0] examdata;
    if(item_got.i_wren == 'b1)begin
      if(queue.size()<1024) begin
        counter =counter + 1;
      queue.push_back(item_got.i_wrdata);
      `uvm_info("write Data", $sformatf("i_wren: %0b i_rden: %0b i_wrdata: %0h o_full: %0b  o_alm_full: %0b",item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full, item_got.o_alm_full), UVM_LOW);
    end
      else if(queue.size() >=1020 && queue.size() < 1024)
        begin
            
          $display("The reference fifo is  Almost full");
          if(item_got.o_alm_full==1)
            begin
              $display("Dut output is matched with reference model");
            end
          else
            $display("No match");
        counter =counter + 1;
      queue.push_back(item_got.i_wrdata);
      `uvm_info("write Data", $sformatf("i_wren: %0b i_rden: %0b i_wrdata: %0h o_full: %0b  o_alm_full: %0b",item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full, item_got.o_alm_full), UVM_LOW);
        end
          else 
            begin
            
        $display("The reference fifo is full");
            end
    end
    else if (item_got.i_rden == 'b1)begin
      if(queue.size() >= 'd1)begin
        counter= counter-1;
        examdata = queue.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0h o_rddata: %0h o_empty: %0b  o_alm_empty", examdata, item_got.o_rddata, item_got.o_empty , item_got.o_alm_empty), UVM_LOW);
        if(examdata == item_got.o_rddata)begin
          $display("-------- 		Pass! 		--------");
        end
        else begin
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
      end
      else if(queue.size() >0 && queue.size()<3 )
           begin
          
             $display("The reference fifo is  Almost empty");
             if(item_got.o_alm_empty==1)
            begin
              $display("Dut output is matched with reference model");
            end
          else
            $display("No match");
              counter= counter-1;
        examdata = queue.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0h o_rddata: %0h o_empty: %0b  o_alm_empty", examdata, item_got.o_rddata, item_got.o_empty , item_got.o_alm_empty), UVM_LOW);
           if(examdata == item_got.o_rddata)begin
          $display("-------- 		Pass! 		--------");
        end
        else begin
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
           end
              else 
            begin
              $display("The reference fifo is empty");
            end
                
    end
  endfunction
endclass
    
    
    
    
    
