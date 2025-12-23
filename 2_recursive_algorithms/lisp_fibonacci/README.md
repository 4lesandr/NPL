# Lisp - Вычисление чисел Фибоначчи с мемоизацией

## Описание
Программа вычисляет числа Фибоначчи рекурсивно с использованием мемоизации (hash table) для оптимизации.

## Запуск
```bash
cd lisp_fibonacci
sbcl --script fibonacci.lisp
```

## Альтернативные способы запуска
```bash
# SBCL
sbcl --load fibonacci.lisp

# CLISP
clisp fibonacci.lisp

# В интерактивном режиме
sbcl
> (load "fibonacci.lisp")
```

## Требования
Требуется Common Lisp интерпретатор (SBCL, CLISP, или другой).

