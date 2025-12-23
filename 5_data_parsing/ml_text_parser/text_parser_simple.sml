(* Упрощенная версия парсера на Standard ML для SML/NJ *)

fun extractEmails text =
    let
        fun isEmailChar c = 
            Char.isAlphaNum c orelse c = #"." orelse c = #"-" orelse c = #"_"
        fun findEmail (chars, acc, current, foundAt) =
            case chars of
                [] => if foundAt then String.implode (rev current) :: acc else acc
              | #"@" :: rest =>
                  if foundAt then
                      findEmail(rest, acc, #"@" :: current, true)
                  else
                      findEmail(rest, acc, [#"@"], true)
              | c :: rest =>
                  if foundAt then
                      if isEmailChar c then
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
                  if Char.isDigit c orelse c = #"." then
                      findIP(rest, acc, c :: current, true)
                  else
                      if inIP andalso isValidIP (String.implode (rev current)) then
                          findIP(rest, String.implode (rev current) :: acc, [], false)
                      else
                          findIP(rest, acc, [], false)
    in
        findIP(explode text, [], [], false)
    end

fun main() =
    let
        val args = CommandLine.arguments()
        val filename = case args of
            [f] => f
          | _ => (print "Использование: sml text_parser_simple.sml input.txt\n"; OS.Process.exit OS.Process.failure; "")
        val file = TextIO.openIn filename
        val text = TextIO.inputAll file
        val _ = TextIO.closeIn file
        val emails = extractEmails text
        val ips = extractIPs text
    in
        (print "=== Найденные email адреса ===\n";
         List.app (fn e => print ("  " ^ e ^ "\n")) emails;
         print "\n=== Найденные IP-адреса ===\n";
         List.app (fn ip => print ("  " ^ ip ^ "\n")) ips)
    end

val _ = main()

