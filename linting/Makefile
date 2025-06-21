help:
	-@echo "######################################################################"
	-@echo "make lint 	=> Run VC Static on current testcase"
	-@echo "make clean  	=> Clean up current testcase directory"
	-@echo "make help   	=> Generate this help menu      "
	-@echo "######################################################################"

lint:
	$(VC_STATIC_HOME)/bin/vc_static_shell -mode64 -f gpiot_lint.tcl
lint1:
	$(VC_STATIC_HOME)/bin/vc_static_shell -mode64 -f gpio_lint.tcl
lint2:
	$(VC_STATIC_HOME)/bin/vc_static_shell -mode64 -f apb_lint.tcl
lint3:
	$(VC_STATIC_HOME)/bin/vc_static_shell -mode64 -f aux_lint.tcl
lint4:
	$(VC_STATIC_HOME)/bin/vc_static_shell -mode64 -f io_lint.tcl





clean:
	 rm -rf novas* vcst* *.txt



