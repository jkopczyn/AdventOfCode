combine :: [Integer] -> [Integer] -> [Integer]
combine made [] = made
combine made (0:raw) = combine (0:made) raw
combine [] raw = combine [0] raw
combine (x:xs) (y:raw) = combine ((x+y):xs) raw

