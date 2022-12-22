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
splitString str = splitAndHalfReflect [] str

splitAndHalfReflect :: (String, String) -> (String, String)
splitAndHalfReflect ([], []) = ([], [])
splitAndHalfReflect (ys, (x:xs)) = if (length ys) >= (length (x:xs))
                                   then (ys, (x:xs))
                                   else (splitAndHalfReflect (x:ys) xs)



priority :: Char -> Integer
-- a-z are 1-26, A-Z are 27-52
priority char = 0 -- not sure how to do this

charMap :: [Char] -> M.Map Char Integer
-- counts how many of c exist, stores in a dict
charMap str = M.fromList str

charSet :: [Char] -> S.Set Char
-- tracks all c which exist, stores in a set
charSet str = S.fromList str


