# Simple Memory Model Verification Environment Using **Register Level Abstraction**

Development UVM Verification Environment for Memory DUT Using [**RAL Verification**](https://verificationguide.com/uvm-ral/uvm-ral-methods/) .

## Setting in EDAPlayground

* Open [EDAPlayground](https://www.edaplayground.com/)

* Choose `SystemVerilog/Verilog` in **Testbench + Design**

* Choose `UVM 1.2 ` in  **OVM / UVM**

* Choose  ``Synopsys VCS 2020.03`` in **Tools and Simulator** 

* Add below code in **Compile options** 

    * `-timescale=1ns/1ns +vcs+flush+all +warn=all

* Add below code in **Run options**

    * `+UVM_TESTNAME=b_test`

#

### FOR REFERENCE CHECKOUT THIS LINK ---> [Master Reference](https://www.edaplayground.com/x/VGuc)
#
