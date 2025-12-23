-module(parallel_processing).
-export([main/1, process_line/1, process_chunk/2]).

% Обработка одной строки: суммирование всех цифр
process_line(Line) ->
    Digits = [Char - $0 || Char <- Line, Char >= $0, Char =< $9],
    lists:sum(Digits).

% Обработка чанка строк в отдельном процессе
process_chunk(Parent, Chunk) ->
    Results = [process_line(Line) || Line <- Chunk],
    Parent ! {self(), Results}.

% Главная функция
main([Filename]) ->
    case file:open(Filename, [read]) of
        {ok, File} ->
            Lines = read_all_lines(File),
            file:close(File),
            
            NumProcesses = erlang:system_info(schedulers),
            ChunkSize = (length(Lines) + NumProcesses - 1) div NumProcesses,
            Chunks = split_into_chunks(Lines, ChunkSize),
            
            % Создаем процессы для обработки каждого чанка
            Pids = [spawn(?MODULE, process_chunk, [self(), Chunk]) || Chunk <- Chunks],
            
            % Собираем результаты от всех процессов
            AllResults = collect_results(Pids, []),
            
            Total = lists:sum(AllResults),
            io:format("Обработано строк: ~p~n", [length(AllResults)]),
            io:format("Общая сумма: ~p~n", [Total]),
            ok;
        {error, Reason} ->
            io:format("Ошибка открытия файла: ~p~n", [Reason]),
            halt(1)
    end;
main(_) ->
    io:format("Использование: erl -noshell -s parallel_processing main [\"data.txt\"] -s init stop~n"),
    halt(1).

% Чтение всех строк из файла
read_all_lines(File) ->
    read_all_lines(File, []).
read_all_lines(File, Acc) ->
    case file:read_line(File) of
        {ok, Line} ->
            % Убираем символ новой строки
            CleanLine = string:trim(Line, trailing, "\n\r"),
            read_all_lines(File, [CleanLine | Acc]);
        eof ->
            lists:reverse(Acc)
    end.

% Разделение списка на чанки
split_into_chunks(List, ChunkSize) ->
    split_into_chunks(List, ChunkSize, []).
split_into_chunks([], _, Acc) ->
    lists:reverse(Acc);
split_into_chunks(List, ChunkSize, Acc) ->
    {Chunk, Rest} = lists:split(min(ChunkSize, length(List)), List),
    split_into_chunks(Rest, ChunkSize, [Chunk | Acc]).

% Сбор результатов от всех процессов
collect_results([], Acc) ->
    Acc;
collect_results(Pids, Acc) ->
    receive
        {Pid, Results} ->
            case lists:member(Pid, Pids) of
                true ->
                    RemainingPids = lists:delete(Pid, Pids),
                    collect_results(RemainingPids, Acc ++ Results);
                false ->
                    collect_results(Pids, Acc)
            end
    end.

