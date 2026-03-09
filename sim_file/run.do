

# compile RTL file
vlog ../rtl_file/uart_boud_rate.sv
vlog ../rtl_file/uart_tx.sv
vlog ../rtl_file/uart_rx.sv
vlog ../rtl_file/uart_top.sv

#compile Verification File

# Compile package first
vlog -sv ../sv_file/file_pkg.sv      
vlog -sv ../sv_file/transaction.sv 

# Compile interface
vlog -sv ../sv_file/interface.sv

# Compile all environment classes
vlog -sv ../sv_file/generator.sv
vlog -sv ../sv_file/driver.sv
vlog -sv ../sv_file/monitor.sv
vlog -sv ../sv_file/scoreboard.sv

# Compile environment container
vlog -sv ../sv_file/enviroment.sv

# Compile test module
vlog -sv ../sv_file/test.sv

# Compile testbench last
vlog -sv ../sv_file/testbench.sv


# Run simulation
vsim work.testbench

# Open waveform
view wave
add wave -r /*

# Run all
run -all


