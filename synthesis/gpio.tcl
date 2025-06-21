remove_design -all
set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

analyze -format verilog ../rtl/gpio_interface.v 

elaborate gpio_interface

link 

check_design

current_design  gpio_interface

compile_ultra

write_file -f verilog -hier -output gpio_interface.v


