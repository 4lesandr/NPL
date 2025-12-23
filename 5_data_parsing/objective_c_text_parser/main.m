#import <Foundation/Foundation.h>

@interface TextParser : NSObject
- (NSArray<NSString *> *)extractEmails:(NSString *)text;
- (NSArray<NSString *> *)extractPhones:(NSString *)text;
- (NSArray<NSString *> *)extractIPs:(NSString *)text;
- (void)parseText:(NSString *)inputFile outputFile:(NSString *)outputFile;
@end

@implementation TextParser

- (NSArray<NSString *> *)extractEmails:(NSString *)text {
    NSMutableArray<NSString *> *emails = [NSMutableArray array];
    
    // Регулярное выражение для email
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression 
        regularExpressionWithPattern:@"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"
        options:0
        error:&error];
    
    if (error) {
        NSLog(@"Ошибка создания регулярного выражения: %@", error);
        return emails;
    }
    
    NSArray *matches = [regex matchesInString:text 
                                     options:0 
                                       range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSString *email = [text substringWithRange:match.range];
        [emails addObject:email];
    }
    
    return emails;
}

- (NSArray<NSString *> *)extractPhones:(NSString *)text {
    NSMutableArray<NSString *> *phones = [NSMutableArray array];
    
    // Регулярные выражения для различных форматов телефонов
    NSArray<NSString *> *patterns = @[
        @"\\+7\\s*\\(\\d{3}\\)\\s*\\d{3}-\\d{2}-\\d{2}",  // +7 (XXX) XXX-XX-XX
        @"\\+7\\d{10}",                                    // +7XXXXXXXXXX
        @"8\\d{10}",                                      // 8XXXXXXXXXX
        @"\\(\\d{3}\\)\\s*\\d{3}-\\d{4}"                  // (XXX) XXX-XXXX
    ];
    
    for (NSString *pattern in patterns) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression 
            regularExpressionWithPattern:pattern
            options:0
            error:&error];
        
        if (error) {
            continue;
        }
        
        NSArray *matches = [regex matchesInString:text 
                                         options:0 
                                           range:NSMakeRange(0, text.length)];
        
        for (NSTextCheckingResult *match in matches) {
            NSString *phone = [text substringWithRange:match.range];
            [phones addObject:phone];
        }
    }
    
    return phones;
}

- (NSArray<NSString *> *)extractIPs:(NSString *)text {
    NSMutableArray<NSString *> *ips = [NSMutableArray array];
    
    // Регулярное выражение для IP-адресов (IPv4)
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression 
        regularExpressionWithPattern:@"\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b"
        options:0
        error:&error];
    
    if (error) {
        NSLog(@"Ошибка создания регулярного выражения: %@", error);
        return ips;
    }
    
    NSArray *matches = [regex matchesInString:text 
                                     options:0 
                                       range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSString *ipString = [text substringWithRange:match.range];
        
        // Проверяем, что каждая часть IP от 0 до 255
        NSArray<NSString *> *parts = [ipString componentsSeparatedByString:@"."];
        BOOL isValid = YES;
        for (NSString *part in parts) {
            int num = [part intValue];
            if (num < 0 || num > 255) {
                isValid = NO;
                break;
            }
        }
        
        if (isValid && parts.count == 4) {
            [ips addObject:ipString];
        }
    }
    
    return ips;
}

- (void)parseText:(NSString *)inputFile outputFile:(NSString *)outputFile {
    NSError *error = nil;
    NSString *text = [NSString stringWithContentsOfFile:inputFile 
                                                encoding:NSUTF8StringEncoding 
                                                   error:&error];
    
    if (error) {
        NSLog(@"Ошибка чтения файла: %@", error);
        return;
    }
    
    NSArray<NSString *> *emails = [self extractEmails:text];
    NSArray<NSString *> *phones = [self extractPhones:text];
    NSArray<NSString *> *ips = [self extractIPs:text];
    
    // Выводим результаты
    NSLog(@"=== Найденные email адреса ===");
    for (int i = 0; i < emails.count; i++) {
        NSLog(@"%d. %@", i + 1, emails[i]);
    }
    
    NSLog(@"\n=== Найденные телефоны ===");
    for (int i = 0; i < phones.count; i++) {
        NSLog(@"%d. %@", i + 1, phones[i]);
    }
    
    NSLog(@"\n=== Найденные IP-адреса ===");
    for (int i = 0; i < ips.count; i++) {
        NSLog(@"%d. %@", i + 1, ips[i]);
    }
    
    // Сохраняем результаты в JSON файл
    NSMutableString *json = [NSMutableString string];
    [json appendString:@"{\n"];
    [json appendString:@"  \"emails\": [\n"];
    for (int i = 0; i < emails.count; i++) {
        [json appendFormat:@"    \"%@\"", emails[i]];
        if (i < emails.count - 1) {
            [json appendString:@","];
        }
        [json appendString:@"\n"];
    }
    [json appendString:@"  ],\n"];
    [json appendString:@"  \"phones\": [\n"];
    for (int i = 0; i < phones.count; i++) {
        [json appendFormat:@"    \"%@\"", phones[i]];
        if (i < phones.count - 1) {
            [json appendString:@","];
        }
        [json appendString:@"\n"];
    }
    [json appendString:@"  ],\n"];
    [json appendString:@"  \"ips\": [\n"];
    for (int i = 0; i < ips.count; i++) {
        [json appendFormat:@"    \"%@\"", ips[i]];
        if (i < ips.count - 1) {
            [json appendString:@","];
        }
        [json appendString:@"\n"];
    }
    [json appendString:@"  ]\n"];
    [json appendString:@"}\n"];
    
    [json writeToFile:outputFile 
            atomically:YES 
              encoding:NSUTF8StringEncoding 
                 error:&error];
    
    if (error) {
        NSLog(@"Ошибка записи файла: %@", error);
    } else {
        NSLog(@"\nРезультаты сохранены в %@", outputFile);
    }
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 3) {
            NSLog(@"Использование: %s <входной_файл> <выходной_файл>", argv[0]);
            NSLog(@"Пример: %s input.txt output.json", argv[0]);
            return 1;
        }
        
        NSString *inputFile = [NSString stringWithUTF8String:argv[1]];
        NSString *outputFile = [NSString stringWithUTF8String:argv[2]];
        
        TextParser *parser = [[TextParser alloc] init];
        [parser parseText:inputFile outputFile:outputFile];
    }
    return 0;
}

