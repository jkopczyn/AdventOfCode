import System.IO

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business (lines input))

business :: [String] -> [String]
business xs = [""]

-- lines -> (initial, orders, width)
parse :: [String] -> ([String], [String], Int)
parse xs = (first, second, maximum (map (\xs -> length (words xs)) first)) where (first, second) = parseHelper xs

parseHelper :: [String] -> ([String], [String])
parseHelper xs = (init first, tail second) where (first, second) = span (\x -> (length x) > 0) xs

data Stacks = Setup Int [[Char]] deriving (Show)

stackCount :: Stacks -> Int
stackCount  (Setup len _) = len

stackStacks :: Stacks -> [[Char]]
stackStacks (Setup _ stacks) = stacks

getStack :: Stacks -> Int -> [Char]
getStack (Setup len stacks) idx = if (idx <= len && idx > 0)
                                   then stacks!!(idx-1)
                                   else error "index out of range"

stackFrom :: Stacks -> Int -> Char
stackFrom stacks idx = head (getStack stacks idx)

stacksBefore :: Stacks -> Int -> [[Char]]
stacksBefore (Setup len stacks) idx = if (idx <= len && idx > 0)
                                      then take (idx-1) stacks
                                      else error "index out of range"
stacksAfter :: Stacks -> Int -> [[Char]]
stacksAfter (Setup len stacks) idx = if (idx <= len && idx > 0)
                                     then drop idx stacks
                                     else error "index out of range"

stacksPartition :: Stacks -> Int -> ([[Char]], [Char], [[Char]])
stacksPartition (Setup len stacks) idx = if (idx <= len && idx > 0)
                                         then let (b, a) = splitAt (idx-1) stacks
                                            in (b, (head a), (tail a))
                                         else error "index out of range"

stackPop :: Stacks -> Int -> (Stacks, Char)
stackPop stacks idx = let (b, t, a) = stacksPartition stacks idx
                      in (Setup (stackCount stacks)  (b ++ [tail t] ++ a), head t)

stackPush :: Stacks -> Int -> Char -> Stacks
stackPush stacks idx ch = let (b, t, a) = stacksPartition stacks idx
                          in Setup (stackCount stacks)  (b ++ [(ch:t)] ++ a)
