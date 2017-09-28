-- ==================================
fat :: Integer -> [Integer]
fat n = [product([1..x]) | x <- [1..n]]

-- ==================================
testaListaRecursao :: (a -> Bool) -> [a] -> Bool
testaListaRecursao _ [] = True
testaListaRecursao f (x:xs) = (f x) && (testaListaRecursao f xs)

testaListaMap :: (a -> Bool) -> [a] -> Bool
testaListaMap f l = and(map f l)

testaListaFold :: (a -> Bool) -> [a] -> Bool
testaListaFold f l = foldr (\a b -> f a && b) True l

-- ==================================
type Nome = String
type Conteudo = String

data Arquivo = ArqSimples | Diretorio
  deriving(Eq, Show)

