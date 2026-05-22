vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
coverage save top.ucdb -onexit -du work.WRAPPER
do wave.do
run -all
# coverage report -detail -cvg -comments -output SFC_cov_rprt.txt {}
# quit -sim
# vcover report top.ucdb -details -annotate -all -output CC_SVA_cov_rprt.txt
# vcover report top.ucdb -du=WRAPPER -recursive -assert -directive -cvg -codeAll -output cov_rprt_summary.txt