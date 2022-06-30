module AccTree where

import Data.Array.Accelerate as A
import Data.Array.Accelerate.Interpreter as I
import qualified Data.Array.Accelerate.LLVM.Native as N

import Useful

constructNodeCoordinates :: Acc (Vector Int) -> Acc (Matrix Int)
constructNodeCoordinates depthVec = nodeCoordinates
  where
    maxDepth = the $ A.maximum depthVec
    nodeCount = size depthVec

    depthMatrix = generate
      (I2 nodeCount (maxDepth + 1))
      (\(I2 i j) -> boolToInt (depthVec A.!! i A.== j))

    cumulativeMatrix = transpose $ A.scanl1 (+) $ transpose depthMatrix

    dropExtraNumbers (I2 i j) e = boolToInt (j A.<= depthVec A.!! i) * e
    nodeCoordinates = imap dropExtraNumbers cumulativeMatrix

removeLastElementInRow :: Acc (Vector Int) -> Acc (Matrix Int) -> Acc (Matrix Int)
removeLastElementInRow depthVec nodeCoordinates = nodeMatrix
  where
    (I2 height width) = shape nodeCoordinates

    nodeMatrix = generate
      (I2 height width)
      (\(I2 i j) -> 
        (boolToInt $ (depthVec A.!! i) A./= j) * 
        (nodeCoordinates A.!! (i * width + j))
      )

chooseNodes :: Acc (Matrix Int) -> Acc (Vector (Char, Int)) -> Exp Char -> Acc (Matrix Int)
chooseNodes nodeCoordinates charVec nodeType = nodeMatrix
  where
    (I2 _ width) = shape nodeCoordinates

    posList = use . Prelude.fst . run $ A.filter (\x -> A.fst x A.== nodeType) charVec

    listSize = size posList
    
    nodeMatrix = generate
      (I2 listSize width)
      (\(I2 i j) -> nodeCoordinates A.!! ((A.snd $ posList A.!! i) * width + j))

isAncestor :: Acc (Vector Int) -> Acc (Vector Int) -> Exp Bool
isAncestor descendant ancestor = result
  where
    compVec :: Acc (Vector (Int, Int))
    compVec = A.zip descendant ancestor

    checkedVec = A.map (\x -> A.ifThenElse ((A.snd x) A.== 0) (constant True) ((A.fst x) A.== (A.snd x))) compVec

    result = constant $ (A.toList . run $ (A.and checkedVec)) Prelude.!! 0

countAncestors :: Acc (Matrix Int) -> Acc (Matrix Int) -> Acc (Matrix Bool)
countAncestors nodeParentCoordinates nodesChosen = ancestorsMatrix
  where
    ancestorsMatrix = 
      innerProduct
      (\a b -> a A.== b A.|| b A.== 0)
      (A.&&)
      nodeParentCoordinates nodesChosen

buildClosestAncestor :: Acc (Matrix Bool) -> Acc (Vector Int)
buildClosestAncestor ancestorsMatrix = closestAncestorMatrix
  where
    intAncestorsMatrix = imap
      (\(I2 i j) x -> A.ifThenElse x j (constant 0))
      ancestorsMatrix
    
    closestAncestorMatrix = A.maximum intAncestorsMatrix

buildClosestAncestorValue :: Acc (Vector Int) -> Acc (Matrix Int) -> Acc (Matrix Int)
buildClosestAncestorValue closestAncestorMatrix nodesChosen = closestAncestorValueMatrix
  where
    (I1 height) = shape closestAncestorMatrix
    (I2 _ width) = shape nodesChosen

    closestAncestorValueMatrix = generate
      (I2 height width)
      (\(I2 i j) -> nodesChosen A.!! ((closestAncestorMatrix A.!! i) * width + j))
