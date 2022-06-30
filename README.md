# Parallel Compiler

## How to Build

Author built in OS Ubuntu 21.10 (Impish Indri)

*	[**Stack**](https://docs.haskellstack.org/en/stable/README/)

		curl -sSL https://get.haskellstack.org/ | sh

*	**gcc** and **g++** with [default](https://askubuntu.com/questions/26498/how-to-choose-the-default-gcc-and-g-version) 9.* version

		sudo apt install gcc-9

		sudo apt install g++-9

		sudo apt install build-essential

		sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 10

		sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 10

*	**llvm-9-dev**

		sudo apt install llvm-9-dev

*	**libffi7**

		sudo apt install libffi7

*	**cd** to directory of local repository and call **Stack** to build

		cd parallel-compiler
    
		stack build
    
		stack run

**Warning**: **Stack** occupies about 10 Gb of storage and first time compiles about 1 hour. Also if amount of RAM is less than 6 Gb, most probably during building the RAM will be run out because of multithreading. You have to either remove multithreading, or make several attempts.
