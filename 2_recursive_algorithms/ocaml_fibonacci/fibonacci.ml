(* Вычисление чисел Фибоначчи с мемоизацией в OCaml *)

open Hashtbl

(* Создаем хеш-таблицу для мемоизации *)
let fib_memo : (int, int) Hashtbl.t = Hashtbl.create 1000

(* Инициализация базовых случаев *)
let _ =
  Hashtbl.add fib_memo 0 0;
  Hashtbl.add fib_memo 1 1

(* Рекурсивная функция с мемоизацией *)
let rec fibonacci n =
  if n < 0 then
    invalid_arg "Число должно быть неотрицательным"
  else
    try
      Hashtbl.find fib_memo n  (* Возвращаем значение из кэша, если оно есть *)
    with Not_found ->
      let result = fibonacci (n - 1) + fibonacci (n - 2) in
      Hashtbl.add fib_memo n result;  (* Сохраняем в кэш *)
      result

(* Функция для сброса кэша *)
let reset_fib_memo () =
  Hashtbl.clear fib_memo;
  Hashtbl.add fib_memo 0 0;
  Hashtbl.add fib_memo 1 1

(* Главная функция для демонстрации *)
let main () =
  print_endline "Вычисление чисел Фибоначчи с мемоизацией";
  print_endline "========================================";
  for i = 0 to 30 do
    Printf.printf "fib(%d) = %d\n" i (fibonacci i)
  done;
  print_newline ();
  print_endline "Вычисление больших чисел:";
  Printf.printf "fib(100) = %d\n" (fibonacci 100);
  Printf.printf "fib(200) = %d\n" (fibonacci 200);
  Printf.printf "\nРазмер кэша: %d записей\n" (Hashtbl.length fib_memo)

(* Запуск программы *)
let () = main ()

