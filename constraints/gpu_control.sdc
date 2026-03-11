create_clock -name clk -period 10.0 [get_ports clk]

set_input_transition 0.05 [all_inputs]
set_load 0.01 [all_outputs]

set_input_delay 1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1.0 -clock clk [all_outputs]
