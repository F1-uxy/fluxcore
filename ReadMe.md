# 8-bit CPU in SystemVerilog

Verification done in verilator using gtkwave to 

### Generate Waveforms:
Use the following code template to generate waveforms using verilator using the testbenches supplied
```
verilator -Wall --trace --cc rtl/module.sv --exe rtl/tb/testbench.cpp -Irtl

make -C obj_dir -f Vmodule.mk Vmodule

./obj_dir/Vmodule
```
