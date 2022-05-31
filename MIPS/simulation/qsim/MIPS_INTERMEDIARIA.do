onerror {exit -code 1}
vlib work
vcom -work work MIPS_INTERMEDIARIA.vho
vcom -work work output_files/Waveform3.vwf.vht
vsim -c -t 1ps -L cyclonev -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.MIPS_INTERMEDIARIA_vhd_vec_tst
vcd file -direction MIPS_INTERMEDIARIA.msim.vcd
vcd add -internal MIPS_INTERMEDIARIA_vhd_vec_tst/*
vcd add -internal MIPS_INTERMEDIARIA_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f

