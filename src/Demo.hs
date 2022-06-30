module Demo where

import Data.Array.Accelerate as A
import Data.Array.Accelerate.Interpreter as I
import qualified Data.Array.Accelerate.LLVM.Native as N

import Useful
import AccTree

fdLst :: [Int]
fdLst = [0, 1, 2, 3, 4, 4, 4, 2, 3]

ftLst :: [(Char, Int)]
ftLst = Prelude.zip "FEFEVPVAN" [0..]

fvLst :: [Char]
fvLst = ['f', '\0', '\0', '\0', 'w', '+', 'w', '\0', '7']

fd :: Vector Int
fd = fromList (Z:. (Prelude.length fdLst)) fdLst

ft :: Vector (Char, Int)
ft = fromList (Z:. (Prelude.length ftLst)) ftLst

fc :: Matrix Int
fc = run . constructNodeCoordinates . use $ fd

fp :: Matrix Int
fp = run $ chooseNodes (use fc) (use ft) (constant 'F')

fcp :: Matrix Int
fcp = run $ removeLastElementInRow (use fd) (use fc)

fca :: Matrix Bool
fca = run $ countAncestors (use fcp) (use fp)

fi :: Vector Int
fi = run $ buildClosestAncestor (use fca)

fk :: Matrix Int
fk = run $ buildClosestAncestorValue (use fi) (use fp)

demo :: Prelude.IO ()
demo = do
  putStrLn "Depth Vector of Tree"
  print fd
  putStrLn "Type and Index Vector of Tree"
  print ft
  putStrLn "Node Coordinates Matrix of Tree"
  print fc
  putStrLn "Node Coordinates of Vertices of Type \'F\'"
  print fp
  putStrLn "Node Parent Coordinates Matrix of Tree"
  print fcp
  putStrLn "Matrix of \"which Vertice of Type \'F\' is Ancestor\""
  print fca
  putStrLn "Matrix of \"which Vertice of Type \'F\' is the closest Ancestor by Index\""
  print fi
  putStrLn "Matrix of \"which Vertice of Type \'F\' is the closest Ancestor by Value\""
  print fk
