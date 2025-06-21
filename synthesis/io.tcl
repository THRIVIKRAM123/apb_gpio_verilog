remove_design -all
set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

analyze -format verilog ../rtl/io_interface.v 

elaborate io_interface

link 

check_design

current_design  io_interface

compile_ultra

write_file -f verilog -hier -output io_interface.v


