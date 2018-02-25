proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config  -ruleid {1}  -id {Labtools 27-3123}  -string {{WARNING: [Labtools 27-3123] The debug hub core was not detected at User Scan Chain 1 or 3.
Resolution: 
1. Make sure the clock connected to the debug hub (dbg_hub) core is a free running clock and is active OR
2. Manually launch hw_server with -e "set xsdb-user-bscan <C_USER_SCAN_CHAIN scan_chain_number>" to detect the debug hub at User Scan Chain of 2 or 4. To determine the user scan chain setting, open the implemented design and use: get_property C_USER_SCAN_CHAIN [get_debug_cores dbg_hub].}}  -suppress 

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.cache/wt [current_project]
  set_property parent.project_path /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.xpr [current_project]
  set_property ip_repo_paths /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.cache/ip [current_project]
  set_property ip_output_repo /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.cache/ip [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files -quiet /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.runs/synth_1/top_VGA.dcp
  add_files -quiet /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.srcs/sources_1/ip/rom1/rom1.dcp
  set_property netlist_only true [get_files /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.srcs/sources_1/ip/rom1/rom1.dcp]
  read_xdc /home/helmutresch/WorkDir/VHDL_VGA_controller/impl/VGA_Controller.srcs/constrs_1/new/vga_constrs.xdc
  link_design -top top_VGA -part xc7a35tcpg236-1
  write_hwdef -file top_VGA.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force top_VGA_opt.dcp
  report_drc -file top_VGA_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force top_VGA_placed.dcp
  report_io -file top_VGA_io_placed.rpt
  report_utilization -file top_VGA_utilization_placed.rpt -pb top_VGA_utilization_placed.pb
  report_control_sets -verbose -file top_VGA_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force top_VGA_routed.dcp
  report_drc -file top_VGA_drc_routed.rpt -pb top_VGA_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file top_VGA_timing_summary_routed.rpt -rpx top_VGA_timing_summary_routed.rpx
  report_power -file top_VGA_power_routed.rpt -pb top_VGA_power_summary_routed.pb -rpx top_VGA_power_routed.rpx
  report_route_status -file top_VGA_route_status.rpt -pb top_VGA_route_status.pb
  report_clock_utilization -file top_VGA_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force top_VGA.mmi }
  write_bitstream -force top_VGA.bit 
  catch { write_sysdef -hwdef top_VGA.hwdef -bitfile top_VGA.bit -meminfo top_VGA.mmi -file top_VGA.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

