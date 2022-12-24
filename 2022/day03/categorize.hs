import System.IO
import Data.Char
import qualified Data.Map as M
import qualified Data.Set as S

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business ls) ++ "\n" ++ unlines (business2 ls)
    where ls = lines input

business :: [String] -> [String]
business xs = [show (totalScore (linesToSharedChars xs))]

business2 :: [String] -> [String]
business2 xs = [show (totalScore (groupSharedChar (batch3 xs)))]

batch3 :: [String] -> [(String, String, String)]
batch3 [] = []
batch3 (x:y:z:xs) = (x,y,z) : (batch3 xs)
-- batch3 badXs = error ("list length not multiple of 3: " + (show badXs))

groupSharedChar :: [(String, String, String)] -> [Char]
groupSharedChar [] = []
groupSharedChar ((x,y,z):xs) = (head (S.toList (S.intersection (S.intersection (charSet x) (charSet y)) (charSet z)))):(groupSharedChar xs)


intsToLines :: [Int] -> [String]
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

totalScore :: [Char] -> Int
-- a-z are 1-26, A-Z are 27-52
totalScore chars = sum (map toNum chars)

toNum c | isUpper c = (ord c) - 64 + 26 -- A is codepoint 65 and should be 27
        | isLower c = (ord c) - 96      -- A is codepoint 97 and should be 1

charSet :: [Char] -> S.Set Char
-- tracks all c which exist, stores in a set
charSet str = S.fromList str

lineToSharedChars :: String -> String
lineToSharedChars str = S.toList (S.intersection (charSet (fst strings)) (charSet (snd strings)))
    where strings = (splitString str)

linesToSharedCharsHelper :: [String] -> [String]
linesToSharedCharsHelper ls = map lineToSharedChars ls

linesToSharedChars :: [String] -> [Char]
linesToSharedChars ls = map head (linesToSharedCharsHelper ls)
