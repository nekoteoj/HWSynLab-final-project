# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.cache/wt [current_project]
set_property parent.project_path C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog {
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/exec_module.vh
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/temp_wires.vh
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/exec_zero.vh
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/exec_matrix_compiled.vh
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/core.vh
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/globals.vh
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/coremodules.vh
}
read_mem {
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/work/ram.mif
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/punnisa/ping.list
}
read_verilog -library xil_defaultlib {
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/hdl/PS2Receiver.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/address_latch.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/address_mux.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/address_pins.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_bit_select.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_control.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_core.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_flags.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_mux_2.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_mux_2z.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_mux_3z.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_mux_4.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_mux_8.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_prep_daa.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_select.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_shifter_core.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/alu_slice.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/hdl/bin2ascii.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/bus_control.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/bus_switch.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/clk_delay.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/new/clock_divider.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/new/clock_generator.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/control_pins_n.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/data_pins.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/data_switch.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/data_switch_mask.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/hdl/debouncer.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/decode_state.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/execute.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/new/hex_to_seven_seg.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/inc_dec.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/inc_dec_2bit.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/interrupts.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/ir.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/new/ledDisplay.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/memory_ifc.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/pin_control.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/pla_decode.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/new/ram.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/new/readBG.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/reg_control.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/reg_file.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/reg_latch.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/resets.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/sequencer.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/new/seven_seg_display.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/hdl/uart_buf_con.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/hdl/uart_tx.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/new/vga.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/imports/z80/z80_top_direct_n.v
  C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/sources_1/new/system.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/constrs_1/imports/VivadoProjects/Basys-3-Master.xdc
set_property used_in_implementation false [get_files C:/Users/Pawin/Desktop/punnisa/HWSynLab-final-project/final-project.srcs/constrs_1/imports/VivadoProjects/Basys-3-Master.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top system -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef system.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file system_utilization_synth.rpt -pb system_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
