#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition
#
#************************************************************

# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints

create_clock -name "CLOCK" -period 20.000ns [get_ports {clk_50MHz}] -waveform {0.000 10.000}
create_generated_clock -name "clk_1m" -divide_by 50000 -source [get_ports {clk_50MHz}] [get_nets {clk_gen|CLK1M}]
create_generated_clock -name "AUD_XCK" -source [get_ports {clk_50MHz}] -divide_by 2 [get_nets {audio|xck_div[1]}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family Cyclone II

set_false_path -from [get_ports {rst_n}]

# tsu/th constraints

	set_input_delay -clock "CLOCK" -max 3ns [get_ports {debug_mode}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {debug_mode}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {key3}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {key3}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {key_dec}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {key_dec}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {key_inc}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {key_inc}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {key_start}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {key_start}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {rst_n}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {rst_n}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {sw_12_24}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {sw_12_24}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {sw_london}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {sw_london}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {sw_ny}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {sw_ny}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {sw_set}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {sw_set}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {sw_stopwatch}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {sw_stopwatch}] 
	set_input_delay -clock "CLOCK" -max 3ns [get_ports {sw_timer}] 
	set_input_delay -clock "CLOCK" -min 1ns [get_ports {sw_timer}] 

	# Input delay constraints with -add_delay option
	set_input_delay -clock "clk_1m" -max 3ns -add_delay [get_ports {key_start}]
	set_input_delay -clock "clk_1m" -min 1ns -add_delay [get_ports {key_start}]
	set_input_delay -clock "clk_1m" -max 3ns -add_delay [get_ports {key3}]
	set_input_delay -clock "clk_1m" -min 1ns -add_delay [get_ports {key3}]

	# tco constraints

	set_output_delay -clock "CLOCK" -max 3ns [get_ports {ledg0}] 
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {ledg0}] 
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {led16}] 
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {led16}] 
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {led17}] 
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {led17}] 
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {AUD_BCLK}] 
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {AUD_BCLK}] 
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {AUD_DACDAT}] 
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {AUD_DACDAT}] 
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {AUD_DACLRCK}] 
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {AUD_DACLRCK}] 
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {AUD_XCK}] 
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {AUD_XCK}] 

	# seg_data0
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data0[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data0[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data0[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data0[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data0[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data0[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data0[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data0[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data0[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data0[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data0[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data0[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data0[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data0[6]}]

	# seg_data1
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data1[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data1[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data1[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data1[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data1[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data1[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data1[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data1[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data1[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data1[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data1[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data1[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data1[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data1[6]}]

	# seg_data2
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data2[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data2[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data2[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data2[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data2[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data2[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data2[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data2[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data2[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data2[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data2[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data2[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data2[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data2[6]}]

	# seg_data3
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data3[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data3[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data3[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data3[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data3[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data3[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data3[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data3[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data3[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data3[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data3[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data3[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data3[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data3[6]}]

	# seg_data4
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data4[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data4[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data4[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data4[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data4[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data4[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data4[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data4[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data4[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data4[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data4[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data4[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data4[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data4[6]}]

	# seg_data5
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data5[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data5[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data5[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data5[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data5[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data5[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data5[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data5[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data5[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data5[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data5[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data5[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data5[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data5[6]}]

	# seg_data6
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data6[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data6[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data6[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data6[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data6[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data6[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data6[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data6[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data6[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data6[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data6[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data6[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data6[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data6[6]}]

	# seg_data7
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data7[0]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data7[0]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data7[1]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data7[1]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data7[2]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data7[2]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data7[3]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data7[3]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data7[4]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data7[4]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data7[5]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data7[5]}]
	set_output_delay -clock "CLOCK" -max 3ns [get_ports {seg_data7[6]}]
	set_output_delay -clock "CLOCK" -min 1ns [get_ports {seg_data7[6]}]

	# tpd constraints
