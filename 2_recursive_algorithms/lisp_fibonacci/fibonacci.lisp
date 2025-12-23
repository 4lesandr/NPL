;; Вычисление чисел Фибоначчи с мемоизацией в Common Lisp

(defvar *fib-memo* (make-hash-table :test 'eql))

;; Инициализация базовых случаев
(setf (gethash 0 *fib-memo*) 0)
(setf (gethash 1 *fib-memo*) 1)

;; Рекурсивная функция с мемоизацией
(defun fibonacci (n)
  "Вычисляет n-е число Фибоначчи с использованием мемоизации"
  (cond
    ((< n 0) (error "Число должно быть неотрицательным"))
    ((gethash n *fib-memo*))  ; Возвращаем значение из кэша, если оно есть
    (t
     (let ((result (+ (fibonacci (- n 1))
                      (fibonacci (- n 2)))))
       (setf (gethash n *fib-memo*) result)  ; Сохраняем в кэш
       result))))

;; Функция для сброса кэша
(defun reset-fib-memo ()
  "Сбрасывает кэш чисел Фибоначчи"
  (clrhash *fib-memo*)
  (setf (gethash 0 *fib-memo*) 0)
  (setf (gethash 1 *fib-memo*) 1))

;; Главная функция для демонстрации
(defun main ()
  (format t "Вычисление чисел Фибоначчи с мемоизацией~%")
  (format t "========================================~%")
  (loop for i from 0 to 30 do
    (format t "fib(~A) = ~A~%" i (fibonacci i)))
  (format t "~%Вычисление больших чисел:~%")
  (format t "fib(100) = ~A~%" (fibonacci 100))
  (format t "fib(200) = ~A~%" (fibonacci 200))
  (format t "~%Размер кэша: ~A записей~%" (hash-table-count *fib-memo*)))

;; Запуск программы
(main)

