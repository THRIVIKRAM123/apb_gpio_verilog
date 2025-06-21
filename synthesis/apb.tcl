remove_design -all
set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

analyze -format verilog ../rtl/apb_slave_interface.v 

elaborate apb_slave_interface

link 

check_design

current_design  apb_slave_interface

compile_ultra

write_file -f verilog -hier -output apb_slave_interface.v


 

