#Liberty files are needed for logical and physical netlist designs
set search_path "./"
set link_library " "

set_app_var enable_lint true

configure_lint_setup -goal lint_rtl

analyze -verbose -format verilog {"../rtl/aux_interface.v "} 

elaborate aux_interface

check_lint 

report_lint -verbose -file report_lint_aux_interface.txt

