mdc x y | (mod x y) == 0 = y
        | otherwise = mdc y (mod x y)

valid :: Integer -> Integer -> Bool
valid x n | x < n = False
          | n == 2 = (mod x 2 == 0)
          | otherwise = (valid x (n - 1)) || (mod x n == 0)

test x n = valid x (floor(sqrt(n)))

crivo :: Integer -> [Integer]
crivo n = [x | x <- [2..n], (test x n)]