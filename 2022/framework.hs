import System.IO

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business (lines input))

business :: [String] -> [String]
business xs = [intsToLines (realBusiness (linesToInts xs))]

realBusiness :: [Integer] -> [Integer]
realBusiness xs = [0]

linesToInts :: [String] -> [Integer]
linesToInts [] = []
linesToInts ("":ss) = 0:(linesToInts ss)
linesToInts (s:ss) = (read s):(linesToInts ss)

intsToLines :: [Integer] -> [String]
intsToLines [] = []
intsToLines (x:xs) = (show x):(intsToLines xs)
