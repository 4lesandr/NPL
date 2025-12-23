(* Извлечение email, телефонов и IP-адресов из текста на Standard ML *)

structure TextParser = struct

    (* Вспомогательная функция для проверки, является ли символ цифрой *)
    fun isDigit c = #"0" <= c andalso c <= #"9"
    
    (* Вспомогательная функция для проверки, является ли символ буквой *)
    fun isAlpha c = (#"a" <= c andalso c <= #"z") orelse (#"A" <= c andalso c <= #"Z")
    
    (* Вспомогательная функция для проверки, является ли символ допустимым для email *)
    fun isEmailChar c = isAlpha c orelse isDigit c orelse c = #"." orelse c = #"-" orelse c = #"_"
    
    (* Извлечение email адресов *)
    fun extractEmails text =
        let
            fun findEmail (chars, acc, current, inEmail) =
                case chars of
                    [] => if inEmail andalso List.exists (fn c => c = #"@") current then
                              String.implode (rev current) :: acc
                          else
                              acc
                  | #"@" :: rest =>
                      if inEmail then
                          findEmail(rest, acc, #"@" :: current, true)
                      else
                          findEmail(rest, acc, [#"@"], true)
                  | c :: rest =>
                      if inEmail then
                          if isEmailChar c orelse c = #"@" then
                              findEmail(rest, acc, c :: current, true)
                          else
                              if List.exists (fn x => x = #"@") current then
                                  findEmail(rest, String.implode (rev current) :: acc, [], false)
                              else
                                  findEmail(rest, acc, [], false)
                      else
                          if isEmailChar c then
                              findEmail(rest, acc, [c], false)
                          else
                              findEmail(rest, acc, [], false)
        in
            findEmail(explode text, [], [], false)
        end
    
    (* Извлечение телефонов (упрощенная версия) *)
    fun extractPhones text =
        let
            fun isPhoneDigit c = isDigit c orelse c = #"+" orelse c = #"(" orelse c = #")" 
                                  orelse c = #"-" orelse c = #" "
            fun findPhone (chars, acc, current, inPhone, digitCount) =
                case chars of
                    [] => if inPhone andalso digitCount >= 10 then
                              String.implode (rev current) :: acc
                          else
                              acc
                  | c :: rest =>
                      if isPhoneDigit c then
                          let val newCount = if isDigit c then digitCount + 1 else digitCount
                          in
                              findPhone(rest, acc, c :: current, true, newCount)
                          end
                      else
                          if inPhone andalso digitCount >= 10 then
                              findPhone(rest, String.implode (rev current) :: acc, [], false, 0)
                          else
                              findPhone(rest, acc, [], false, 0)
        in
            findPhone(explode text, [], [], false, 0)
        end
    
    (* Извлечение IP-адресов *)
    fun extractIPs text =
        let
            fun isValidIP ipStr =
                let
                    val parts = String.tokens (fn c => c = #".") ipStr
                    fun allValid [] = true
                      | allValid (p::ps) =
                          case Int.fromString p of
                              SOME n => n >= 0 andalso n <= 255 andalso allValid ps
                            | NONE => false
                in
                    length parts = 4 andalso allValid parts
                end
            
            fun findIP (chars, acc, current, inIP) =
                case chars of
                    [] => if inIP andalso isValidIP (String.implode (rev current)) then
                              String.implode (rev current) :: acc
                          else
                              acc
                  | c :: rest =>
                      if isDigit c orelse c = #"." then
                          findIP(rest, acc, c :: current, true)
                      else
                          if inIP andalso isValidIP (String.implode (rev current)) then
                              findIP(rest, String.implode (rev current) :: acc, [], false)
                          else
                              findIP(rest, acc, [], false)
        in
            findIP(explode text, [], [], false)
        end
    
    (* Главная функция парсинга *)
    fun parseText filename =
        let
            val file = TextIO.openIn filename
            val text = TextIO.inputAll file
            val _ = TextIO.closeIn file
            
            val emails = extractEmails text
            val phones = extractPhones text
            val ips = extractIPs text
        in
            (emails, phones, ips)
        end
    
    (* Вывод результатов *)
    fun printResults (emails, phones, ips) =
        let
            fun printList title items =
                (print (title ^ "\n");
                 List.app (fn item => print ("  " ^ item ^ "\n")) items;
                 print "\n")
        in
            printList "=== Найденные email адреса ===" emails;
            printList "=== Найденные телефоны ===" phones;
            printList "=== Найденные IP-адреса ===" ips
        end

end

(* Главная функция *)
val _ = 
    case CommandLine.arguments() of
        [inputFile, outputFile] =>
            let
                val (emails, phones, ips) = TextParser.parseText inputFile
                val _ = TextParser.printResults (emails, phones, ips)
                val file = TextIO.openOut outputFile
                val _ = TextIO.output(file, "{\n  \"emails\": [\n")
                val _ = TextIO.output(file, String.concatWith ",\n" 
                    (map (fn e => "    \"" ^ e ^ "\"") emails))
                val _ = TextIO.output(file, "\n  ],\n  \"phones\": [\n")
                val _ = TextIO.output(file, String.concatWith ",\n" 
                    (map (fn p => "    \"" ^ p ^ "\"") phones))
                val _ = TextIO.output(file, "\n  ],\n  \"ips\": [\n")
                val _ = TextIO.output(file, String.concatWith ",\n" 
                    (map (fn ip => "    \"" ^ ip ^ "\"") ips))
                val _ = TextIO.output(file, "\n  ]\n}\n")
                val _ = TextIO.closeOut file
            in
                print ("Результаты сохранены в " ^ outputFile ^ "\n")
            end
      | _ =>
            (print "Использование: text_parser <входной_файл> <выходной_файл>\n";
             print "Пример: text_parser input.txt output.json\n";
             OS.Process.exit OS.Process.failure)

