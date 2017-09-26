mdc x y | (mod x y) == 0 = y
        | otherwise = mdc y (mod x y)

divisible x y = mod x y /= 0

crivo :: Integer -> [Integer]
crivo n = [x | x <- [2..n], all (divisible x)[2..(floor(sqrt(fromIntegral x)))]]
