isMatrix :: [[Int]] -> Bool
isMatrix [] = True
isMatrix [x] = True
isMatrix (x:y:xs) = ((length x) == (length y)) && (isMatrix (y:xs))
