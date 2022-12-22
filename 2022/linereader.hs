import System.IO

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business (lines input))

business :: [String] -> [String]
business (x:xs) = ("foo"++x):(business xs)
business [] = []
