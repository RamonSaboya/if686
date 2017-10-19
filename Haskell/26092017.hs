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

data Arquivo = ArqSimples Nome Conteudo | Diretorio Nome [Arquivo]

instance Eq Arquivo where
  (ArqSimples nome1 conteudo1) == (ArqSimples nome2 conteudo2) = nome1 == nome2 && conteudo1 == conteudo2
  (Diretorio nome1 conteudo1) == (Diretorio nome2 conteudo2) = nome1 == nome2 && conteudo1 == conteudo2
  _ == _ = False

instance Show Arquivo where
  show (ArqSimples nome _) = nome
  show (Diretorio nome _) = nome

nomeArq :: Arquivo -> Nome
nomeArq (ArqSimples nome _) = nome
nomeArq (Diretorio nome _) = nome

isDiretorio :: Arquivo -> Bool
isDiretorio (ArqSimples _ _) = False;
isDiretorio _ = True;

isArqSimples :: Arquivo -> Bool
isArqSimples arq = not(isDiretorio arq)

mudarDir :: Arquivo -> Nome -> String
mudarDir (ArqSimples _ _) _ = "nao existe"
mudarDir (Diretorio nomeDir arquivos) nomeMudar | nomeMudar == nomeDir = nomeMudar
                                                | elem nomeMudar [nomeArq arquivo | arquivo <- arquivos, isDiretorio arquivo] = nomeMudar
                                                | otherwise = "nao existe"

listArqSimples :: Arquivo -> [Nome]
listArqSimples (Diretorio nome arquivos) = foldl (++) (map nomeArq (filter isArqSimples arquivos)) [listArqSimples dir | dir <- arquivos, isDiretorio dir]

mkdir :: [Arquivo] -> Nome -> [Arquivo]
mkdir [] nome = [(Diretorio nome [])]
mkdir (x:xs) nome | (isDiretorio x) && ((nomeArq x) == nome) = x:xs
                  | otherwise = x : (mkdir xs nome)
