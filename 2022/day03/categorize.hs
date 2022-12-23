import System.IO
import qualified Data.Map as M
import qualified Data.Set as S

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business (lines input))

business :: [String] -> [String]
business xs = intsToLines (realBusiness (linesToInts xs))

realBusiness :: [Integer] -> [Integer]
realBusiness xs = [0]

linesToInts :: [String] -> [Integer]
linesToInts [] = []
linesToInts ("":ss) = 0:(linesToInts ss)
linesToInts (s:ss) = (read s):(linesToInts ss)

intsToLines :: [Integer] -> [String]
intsToLines [] = []
intsToLines (x:xs) = (show x):(intsToLines xs)

splitString :: String -> (String, String)
-- split into first half and second half
splitString [] = ([], [])
splitString str = splitStringHelper ([], str)

splitStringHelper :: (String, String) -> (String, String)
splitStringHelper ([], []) = ([], [])
splitStringHelper (xs, (x:y:ys)) =
    if (length xs) <= (length ys)
    then splitStringHelper ((x:xs), (y:ys))
    else (reverse xs, x:y:ys)

priority :: Char -> Integer
-- a-z are 1-26, A-Z are 27-52
priority char = 0 -- not sure how to do this

charSet :: [Char] -> S.Set Char
-- tracks all c which exist, stores in a set
charSet str = S.fromList str


