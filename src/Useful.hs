module Useful where

import Data.Array.Accelerate as A
import Data.Array.Accelerate.Interpreter as I
import qualified Data.Array.Accelerate.LLVM.Native as N

-- Inner product of 2 matrices (general case of matrix multiplication with custom product and sum combinators)
innerProduct :: (Elt a, Elt b, Elt c)
    => (Exp a -> Exp b -> Exp c)  -- product function: how to combine 2 elements from two matrices
    -> (Exp c -> Exp c -> Exp c)  -- sum function: how to combine the row of results into single element
    -> Acc (Matrix a)             -- ma x x
    -> Acc (Matrix b)             -- x x nb 
    -> Acc (Matrix c)
innerProduct prodF sumF a b = fold1 sumF $ A.zipWith prodF aExt bExt
    where
        -- r1 == c2 - precondition
        (I2 r1 _) = shape a
        (I2 r2 _) = shape b

        aExt = A.replicate (lift (Z :. All :. r2 :. All)) a
        bExt = A.replicate (lift (Z :. r1 :. All :. All)) b

printMatrix :: [[Int]] -> Prelude.IO ()
printMatrix matrix = putStr . unlines . Prelude.map (unwords . Prelude.map show) $ matrix

maxInList :: [Int] -> Int
maxInList (x:xs) = Prelude.foldr (\x y -> if x Prelude.> y then x else y) x xs
