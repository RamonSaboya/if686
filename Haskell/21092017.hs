-- ==================================
mdc :: Int -> Int -> Int
mdc x y | (mod x y) == 0 = y
        | otherwise = mdc y (mod x y)

-- ==================================
divisible :: Int -> Int -> Bool
divisible x y = mod x y /= 0

primo :: Int -> Bool
primo n = elem n [x | x <- [2..n], all (divisible x)[2..(floor(sqrt(fromIntegral x)))]]

-- ==================================
type Ponto = (Double, Double, Double)

distancia :: Ponto -> Ponto -> Double
distancia (x1, y1, z1) (x2, y2, z2) = sqrt(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2) + ((z1 - z2) ^ 2))

-- ==================================
sum100pow :: Integer
sum100pow = foldl1 (+) [x^2 | x <- [1..100]]

-- ==================================
grid :: Int -> Int -> [(Int, Int)]
grid m n = [(x, y) | x <- [0..m], y <- [0..n]]

-- ==================================
square :: Int -> [(Int, Int)]
square n = [(x, y) | (x, y) <- (grid n n), x /= y]

-- ==================================
merge :: Ord t => [t] -> [t] -> [t]
merge [] l = l
merge l [] = l
merge (x:xs) (y:ys) | x < y = x : (merge xs (y : ys))
                    | otherwise = y : (merge (x : xs) ys)

-- ==================================
split :: Int -> [t] -> ([t],[t])
split _ [] = ([], [])
split 0 l = ([], l)
split n (x:xs) = (x:a, b)
  where (a, b) = split (n - 1) xs

halve :: [t] -> ([t],[t])
halve l = split (div (length l) 2) l

msort :: Ord t => [t] -> [t]
msort [] = []
msort [x] = [x]
msort l = merge (msort a) (msort b)
  where (a, b) = halve l

-- ==================================
aplicaFuncoes :: [Int->Int] -> [Int] -> [[Int]]
aplicaFuncoes _ [] = []
aplicaFuncoes [] _ = []
aplicaFuncoes (x:xs) l = [x k | k <- l] : aplicaFuncoes xs l

-- ==================================
data DiaSemana = Domingo | Segunda | Terca | Quarta | Quinta | Sexta | Sabado
  deriving (Eq, Ord, Show, Enum)

util :: DiaSemana -> Bool
util dia = dia > Domingo && dia < Sabado

ordena :: [DiaSemana] -> [DiaSemana]
ordena l = msort l

ordenaUteis :: [DiaSemana] -> [DiaSemana]
ordenaUteis l = msort (filter util l)

datasIguais :: [(DiaSemana, Int)] -> DiaSemana -> [Int]
datasIguais [] _ = []
datasIguais (x:xs) dia | a == dia = b : datasIguais xs dia
                       | otherwise = datasIguais xs dia
  where (a, b) = x

imprimeMes :: DiaSemana -> [(Int, DiaSemana)]
imprimeMes dia = zip [1..30] ([dia .. Sabado] ++ (cycle [Domingo .. Sabado]))
