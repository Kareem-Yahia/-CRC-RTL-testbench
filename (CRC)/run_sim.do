vlib work
vlog CRC.v CRC_TB.v +cover
vsim -voptargs=+acc work.CRC_TB -cover
add wave *
add wave -position insertpoint  \
sim:/CRC_TB/c1/LFSR \
sim:/CRC_TB/c1/counter \
sim:/CRC_TB/c1/Done_Flag \
sim:/CRC_TB/c1/operation_start
#coverage save alu_seq_tb.ucdb -onexit -du alu_seq
run -all
#coverage report -output functional_coverage_rpt.txt -srcfile=* -detail -all -dump -annotate -directive -cvg
#coverage report -output assertion_coverage.txt -detail -assert 
#quit -sim
#vcover report alu_seq_tb.ucdb -details -annotate -all -output code_coverage_rpt.txt

#you can add -option to functional coverage
#you can add -classdebug in vsim command to access the classes in waveform

 