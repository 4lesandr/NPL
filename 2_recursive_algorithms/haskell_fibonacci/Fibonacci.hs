module Main where

import Data.Map (Map)
import qualified Data.Map as Map

-- Мемоизация с использованием Map
type Memo = Map Integer Integer

-- Вычисление числа Фибоначчи с мемоизацией
fibonacci :: Integer -> Integer
fibonacci n = fst $ fibonacciMemo n Map.empty

-- Вспомогательная функция с мемоизацией
fibonacciMemo :: Integer -> Memo -> (Integer, Memo)
fibonacciMemo 0 memo = (0, memo)
fibonacciMemo 1 memo = (1, memo)
fibonacciMemo n memo =
    case Map.lookup n memo of
        Just value -> (value, memo)
        Nothing ->
            let (fib1, memo1) = fibonacciMemo (n - 1) memo
                (fib2, memo2) = fibonacciMemo (n - 2) memo1
                result = fib1 + fib2
                newMemo = Map.insert n result memo2
            in (result, newMemo)

-- Главная функция для демонстрации
main :: IO ()
main = do
    putStrLn "Вычисление чисел Фибоначчи с мемоизацией"
    putStrLn "=========================================="
    mapM_ (\n -> do
        let result = fibonacci n
        putStrLn $ "fib(" ++ show n ++ ") = " ++ show result
        ) [0..30]
    putStrLn "\nВычисление больших чисел:"
    putStrLn $ "fib(100) = " ++ show (fibonacci 100)
    putStrLn $ "fib(200) = " ++ show (fibonacci 200)

