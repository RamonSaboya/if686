-- Ramon de Saboya Gomes
-- RSG3


-- ==========================================
sublistas :: Eq a => [a] -> [[a]]
sublistas [] = []
sublistas (x:[]) = [[x],[]]
sublistas l@(x:xs) = [l] ++ [x:k:[] | k <- xs, x:k:[] /= l] ++ [[x]] ++ (sublistas xs)

-- ==========================================
filtrar :: [[Int]] -> [[Int]]
filtrar [] = []
filtrar l = [x | x <- l, (foldl (+) 0 (filter odd x)) > (foldl (+) 0 (filter even x))]

filtrarEInserir :: [[Int]] -> Int -> ([[Int]],Int)
filtrarEInserir [] _ = ([],0)
filtrarEInserir l n = ((filtrar l), (n * maximum([foldl (+) 0 x | x <- (filtrar l)])))

-- ==========================================
altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap _ _ [] = []
altMap f1 f2 (x:[]) = [f1 x]
altMap f1 f2 (x:y:xs) = (f1 x) : (f2 y) : (altMap f1 f2 xs)

-- ==========================================
poli :: Integer -> Integer -> Integer -> Integer -> Integer
poli a b c = (\x -> a*(x^2) + b*x + c)

listaPoli :: [(Integer, Integer, Integer)] -> [Integer -> Integer]
listaPoli [] = []
listaPoli (x:xs) = (poli a b c) : (listaPoli xs)
  where (a,b,c) = x

appListaPoli :: [Integer -> Integer] -> [Integer] -> [Integer]
appListaPoli [] l = l
appListaPoli _ [] = []
appListaPoli fl el = [f e | (f, e) <- (zip fl el)]

-- ==========================================
data Mobile = Pendente Int | Barra Mobile Mobile

peso :: Mobile -> Int
peso (Pendente v) = v
peso (Barra m1 m2) = (peso m1) + (peso m2)

balanceado :: Mobile -> Bool
balanceado (Pendente _) = True
balanceado (Barra m1 m2) = ((peso m1) == (peso m2)) && (balanceado m1) && (balanceado m2)
