use std::fs::File;
use std::io::{BufRead, BufReader};
use std::sync::{Arc, Mutex};
use std::thread;

fn process_line(line: String) -> u64 {
    // Пример обработки: суммирование всех цифр в строке
    line.chars()
        .filter_map(|c| c.to_digit(10))
        .map(|d| d as u64)
        .sum()
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 2 {
        eprintln!("Использование: {} <файл>", args[0]);
        std::process::exit(1);
    }

    let filename = &args[1];
    let file = match File::open(filename) {
        Ok(f) => f,
        Err(e) => {
            eprintln!("Ошибка открытия файла {}: {}", filename, e);
            std::process::exit(1);
        }
    };

    let reader = BufReader::new(file);
    let lines: Vec<String> = reader
        .lines()
        .filter_map(|line| line.ok())
        .collect();

    let num_threads = thread::available_parallelism()
        .map(|n| n.get())
        .unwrap_or(4);
    let chunk_size = (lines.len() + num_threads - 1) / num_threads;

    let results = Arc::new(Mutex::new(Vec::<u64>::new()));
    let mut handles = vec![];

    for chunk in lines.chunks(chunk_size) {
        let chunk = chunk.to_vec();
        let results = Arc::clone(&results);

        let handle = thread::spawn(move || {
            let mut chunk_results = Vec::new();
            for line in chunk {
                let result = process_line(line);
                chunk_results.push(result);
            }
            let mut results = results.lock().unwrap();
            results.extend(chunk_results);
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    let results = results.lock().unwrap();
    let total: u64 = results.iter().sum();
    
    println!("Обработано строк: {}", results.len());
    println!("Общая сумма: {}", total);
}

