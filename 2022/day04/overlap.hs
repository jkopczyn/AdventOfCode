import System.IO
import Data.List.Split

main = do  
    contents <- getContents  
    putStr (processLines contents)  

processLines :: String -> String
processLines input = unlines (business (lines input))

business :: [String] -> [String]
business xs = [show (realBusiness (linesToCoords xs)), show (realBusiness2 (linesToCoords xs))]

realBusiness xs = length (filter sharedMatchesEither xs)

realBusiness2 xs = length (filter nonemptyIntersection xs)

sharedMatchesEither :: ((Integer, Integer), (Integer, Integer)) -> Bool
sharedMatchesEither (x, y) = let shared = (intersect (x, y))
                             in ((x ==  shared) || (y == shared))

nonemptyIntersection :: ((Integer, Integer), (Integer, Integer)) -> Bool
nonemptyIntersection pair = let shared = intersect pair
                            in (fst shared) <= (snd shared)

linesToCoords :: [String] -> [((Integer, Integer), (Integer, Integer))]
linesToCoords [] = []
linesToCoords (s:ss) = (twoPairs (lineToPairs s)):(linesToCoords ss)

intersect :: ((Integer, Integer), (Integer, Integer)) -> (Integer, Integer)
intersect (x, y) = ((max (fst x) (fst y)), (min (snd x) (snd y)))

twoPairs :: [(Integer, Integer)] -> ((Integer, Integer), (Integer, Integer))
twoPairs [xs, ys] = (xs, ys)
twoPairs _ = error "arg not a two-element list"

lineToPairs :: String -> [(Integer, Integer)]
lineToPairs str = map coords (splitOneOf "," str)

coords :: String -> (Integer, Integer)
coords co = case (splitOneOf "-" co) of [x,y] -> (read x, read y)
                                        []    -> error "empty coordinates"
                                        _     -> error "coordinates wrong length"


intsToLines :: [Integer] -> [String]
intsToLines [] = []
intsToLines (x:xs) = (show x):(intsToLines xs)
