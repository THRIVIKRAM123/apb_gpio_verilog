remove_design -all
set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

analyze -format verilog ../rtl/gpio_top.v  

elaborate gpio_top

link 

check_design

current_design  gpio_top

compile_ultra

write_file -f verilog -hier -output gpio_top.v


