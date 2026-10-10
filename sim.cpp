#include <iostream>
#include <bitset>
#include "verilated.h"
#include "Vuart_tx.h"


int main(int argc, char** argv) {

	Verilated::commandArgs(argc, argv);
	Vuart_tx* dut = new Vuart_tx;

        dut->data = 0b10100001;

	for(int cycle = 0; cycle < 12 ; cycle++) {

		dut->clk = 0;
		dut->eval();

		// Inputs change
		if(cycle == 1) {
			dut->start = 1;
		} else {
                        dut->start = 0;
		}


                
		

		dut->clk = 1;
		dut->eval();

		// Visualization and Testing
		std::cout << "* Cycle: " << cycle << std::endl;

		std::cout << "load = " << static_cast<int>(dut->start) << std::endl;
        	std::cout << "reset = " << static_cast<int>(dut->reset) << std::endl;
		
                
                
		std::cout << "data[7:0] = " << std::bitset<8>(dut->data) << std::endl;



		std::cout << "tx = " << static_cast<int>(dut->tx) << std::endl;
                std::cout << "busy = " << static_cast<int>(dut->busy) << std::endl;
		
	}



}

