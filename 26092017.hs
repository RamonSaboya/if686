-- ==================================
fat :: Int -> [Int]
fat 1 = [1]
fat n = (fat (n - 1)) ++ [n * (last (fat (n - 1)))]

-- ==================================
testaListaRecursao :: (a -> Bool) -> [a] -> Bool
testaListaRecursao _ [] = True
testaListaRecursao f (x:xs) = (f x) && (testaListaRecursao f xs)

testaListaMap :: (a -> Bool) -> [a] -> Bool
testaListaMap f l = and(map f l)

testaListaFold :: (a -> Bool) -> [a] -> Bool
testaListaFold f l = foldr (\a b -> f a && b) True l 