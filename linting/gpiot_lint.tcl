#Liberty files are needed for logical and physical netlist designs
set search_path "./"
set link_library " "

set_app_var enable_lint true

configure_lint_setup -goal lint_rtl

analyze -verbose -format verilog {"../rtl/gpio_top.v ../rtl/apb_slave_interface.v ../rtl/aux_interface.v ../rtl/io_interface.v ../rtl/gpio_interface.v"} 

elaborate gpio_top

check_lint 

report_lint -verbose -file report_lint_gpiot_top_lint.txt

