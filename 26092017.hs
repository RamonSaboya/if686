fat n | n == 1 = [1]
      | otherwise = (fat (n - 1)) ++ [n * (last (fat (n - 1)))]