import System.IO
import Data.List

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business (lines input))

business :: [String] -> [String]
business xs =
  let theList = (realBusiness (linesToInts xs))
  in map show ((maximum theList):[sum (take 3 (reverse (Data.List.sort theList)))])

realBusiness :: [Integer] -> [Integer]
realBusiness xs = combine [0] xs

linesToInts :: [String] -> [Integer]
linesToInts [] = []
linesToInts ("":ss) = 0:(linesToInts ss)
linesToInts (s:ss) = (read s):(linesToInts ss)

intsToLines :: [Integer] -> [String]
intsToLines [] = []
intsToLines (x:xs) = (show x):(intsToLines xs)

combine :: [Integer] -> [Integer] -> [Integer]
combine made [] = made
combine made (0:raw) = combine (0:made) raw
combine [] raw = combine [0] raw
combine (x:xs) (y:raw) = combine ((x+y):xs) raw
