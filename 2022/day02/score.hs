import System.IO

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business (lines input))

business :: [String] -> [String]
business xs = [show (sum (scoreLines xs)), show (sum (scoreLines2 xs))]

scoreLines :: [String] -> [Integer]
scoreLines [] = []
scoreLines (x:xs) = (scorePair (castToPair x)):(scoreLines xs)

scoreLines2 :: [String] -> [Integer]
scoreLines2 [] = []
scoreLines2 (x:xs) = (scorePair (castToPairAlt x)):(scoreLines2 xs)

data RPS = Rock | Paper | Scissors deriving (Show)

scorePair :: (RPS, RPS) -> Integer
-- scoring rule: second move gets 0,3,6 for loss,draw,win
-- scoring rule: second move gets 1,2,3 for Rock,Paper,Scissors
scorePair (Paper,    Rock)      = 1
scorePair (Scissors, Paper)     = 2
scorePair (Rock,     Scissors)  = 3
scorePair (Rock,     Rock)      = 4
scorePair (Paper,    Paper)     = 5
scorePair (Scissors, Scissors)  = 6
scorePair (Scissors, Rock)      = 7
scorePair (Rock,     Paper)     = 8
scorePair (Paper,    Scissors)  = 9

lineToTwoWords :: String -> (String, String)
lineToTwoWords str = case (words str) of (_:_:_:_)  -> error "line with 3+ symbols"
                                         (_:[])     -> error "line with only one symbol"
                                         []         -> error "empty line"
                                         [x, y] -> (x, y)

castToPair :: String -> (RPS, RPS)
castToPair str = let (x, y) = lineToTwoWords str
                 in (wordToRPS x, wordToRPS y)
--     case expression of pattern -> result  
--                        pattern -> result  
--                        pattern -> result  
--                        ...  
wordToRPS :: String -> RPS
wordToRPS "X" = Rock
wordToRPS "Y" = Paper
wordToRPS "Z" = Scissors
wordToRPS "A" = Rock
wordToRPS "B" = Paper
wordToRPS "C" = Scissors
wordToRPS x = error ("no encoding to RPS move for symbol " ++ show x)

castToPairAlt :: String -> (RPS, RPS)
castToPairAlt str = let (x, y) = lineToTwoWords str
                    in (wordToRPS x, wordPairToMove (wordToRPS x) y)

-- lose
wordPairToMove move "X" = case move of Rock -> Scissors
                                       Paper -> Rock
                                       Scissors -> Paper
-- draw
wordPairToMove move "Y" = move
-- win
wordPairToMove move "Z" = case move of Rock -> Paper
                                       Paper -> Scissors
                                       Scissors -> Rock

combine :: [Integer] -> [Integer] -> [Integer]
combine made [] = made
combine made (0:raw) = combine (0:made) raw
combine [] raw = combine [0] raw
combine (x:xs) (y:raw) = combine ((x+y):xs) raw
