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

## Implementation Functions

* constructNodeCoordinates

Gets Vector of depths of vertices and builds Matrix of nodes. Each node is a Vector. Root node is vector $1 \\ 0 \\ 0 \dots$. If node $A$ is parent of node $B$, then node $B$'s Vector is node $A$'s Vector, with the most left zero changed to identifier of this child (e.g. for first child - 1, for second - 2).

* removeLastElementInRow

Gets Matrix and removes last non-zero element in all rows.

* chooseNodes

Gets Matrix, types of nodes and type, and return Matrix with only rows with corresponding type.

* isAncestor

Gets two Vectors and checks if one is an ancestor of another.

* countAncestors

Gets Matrix and Matrix of some nodes, and return Matrix, which value is if corresponding vertex in tree has corresponding vertex as ancestor.

* buildClosestAncestor

Gets Matrix of ancestors and returns for every node in tree the identifier of closest ancestor.

* buildClosestAncestorValue

Gets Matrix of some nodes and Vector of closest ancestors out of them and returns for every node the value of closest ancestor.
