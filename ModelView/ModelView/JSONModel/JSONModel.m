//
//  JSONModel.m
//  Model
//
//  Created by Four on 2018/1/20.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "JSONModel.h"

#import "JSONDefault.h"

@interface JSONModel ()

@property (strong, nonatomic) NSDictionary *dictionary; // 写属性用到

@property (strong, nonatomic) NSMutableArray *models;

@end

@implementation JSONModel

- (NSMutableArray *)models {
    
    if (!_models) {
        
        _models = [[NSMutableArray alloc] init];
    }
    
    return _models;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if([key isEqualToString:@"class"]) {
        
        self.className = value;
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.dictionary = dictionary;
        
        [self setValuesForKeysWithDictionary:dictionary];
        
        [self checkDictionary:dictionary];
    }
    return self;
}

- (void) checkDictionary:(NSDictionary *)dictionary {
    
    // 遍历所有key
    for (NSString *key in dictionary.allKeys) {
        
        id value = dictionary[key];
        
        if ([value isKindOfClass:[NSDictionary class]]) { // 字典 就建模
            
            JSONModel *model = [self modelWidthDictionary:value key:key];
            
            // 添加到模型数组中
            [self.models addObject:model];
            
        }else if ([value isKindOfClass:[NSArray class]]) {
            
            NSArray *array = (NSArray *)value;
            
            for (id sub in array) {
                
                if([sub isKindOfClass:[NSDictionary class]]) { // 数组中可能包含不同的字典
                    
                    [self modelWidthDictionary:sub key:key];
                }
            }
        }
    }
}

// 获取模型
- (JSONModel *) modelWidthDictionary:(NSDictionary *)dictionary key:(NSString *)key{
    
    JSONModel *model = [[JSONModel alloc] initWithDictionary:dictionary];
    
    model.classKey = key;
    
    [model creatContentFile];
    
    return model;
}

// 创建 .h .m
- (void) creatFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath_h = [self hPre];
    
    NSString *filePath_m = [self mPre];
    
    [fileManager createFileAtPath:filePath_h contents:nil attributes:nil];
    
    [fileManager createFileAtPath:filePath_m contents:nil attributes:nil];
}

- (NSString *) hPre {
    
    NSString *h = [[NSString alloc] initWithFormat:@"%@.h",self.className];
    
    return [[JSONDefault folderPath] stringByAppendingPathComponent:h];
}

- (NSString *) mPre {
    
    NSString *m = [[NSString alloc] initWithFormat:@"%@.m",self.className];
    
    return [[JSONDefault folderPath] stringByAppendingPathComponent:m];
}

- (NSString *) logString {
    
    return @"// 喝一杯Java☕️ 继续Python💻\n// blog : http://blog.csdn.net/nameisyou\n// https://github.com/wmc657585618\n\n";
}

// 将属性写到 .h
- (void) writePropertyToH:(NSString *)property fileHandle:(NSFileHandle *)fileHandle{
    
    [fileHandle seekToEndOfFile];  // 将节点跳到文件的末尾
    
    NSData* stringData  = [property dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; // 追加写入数据
}

// 添加文件内容到 .m
- (void) writeContentToM{
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[self mPre]];

    NSString *content = [[NSString alloc] initWithFormat:@"%@#import \"%@.h\"\n\n@implementation %@\n\n@end",[self logString], self.className, self.className];
    
    [fileHandle seekToEndOfFile];  // 将节点跳到文件的末尾
    
    NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; // 追加写入数据
    
    [fileHandle closeFile];
}

// 写属性
- (NSArray *) writeContentWihtDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    [mArray addObject:[self logString]];
    
    [mArray addObject:@"#import <Foundation/Foundation.h>\n\n"];

    // import
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    for (JSONModel *model in self.models) {
        
        if(model.className) {
            
            [set addObject:model.className];
        }
    }
    
    for (NSString *className in set.allObjects) {
        
        NSString *importContent = [[NSString alloc] initWithFormat:@"#import \"%@.h\"\n\n",className];
        
        [mArray addObject:importContent];
    }
    
    NSString *interface = [[NSString alloc] initWithFormat:@"@interface %@ : NSObject\n",self.className];
    
    [mArray addObject:interface];
    
    for (NSString *key in dictionary.allKeys) {
        
        NSString *property = @"assign";
        
        NSString *propertyType = @"NSString *";
        
        NSString *propertyName = key;
        
        id value = dictionary[key];
        
        if([key isEqualToString:@"class"]) {
            
            continue;
        }
        
        if([value isKindOfClass:[NSString class]]) {
            
            property = @"copy";
            
            propertyType = @"NSString *";
            
        } else if ([value isKindOfClass:[NSArray class]]) {
            
            property = @"strong";
            
            propertyType = @"NSArray *";
            
        } else if ([value isKindOfClass:[NSData class]]) {
            
            property = @"strong";
            
            propertyType = @"NSData *";
            
        } else if ([value isEqual:@0] || [value isEqual:@1]){
            
            property = @"assign";
            
            propertyType = @"BOOL ";
            
        } else {
            
            propertyType = @"NSNumber *";
            
            property = @"strong";
        }
        NSString *_property = [[NSString alloc] initWithFormat:@"\n@property (%@, nonatomic) %@%@;\n",property,propertyType,propertyName];
        ;
        
        [mArray addObject:_property];
    }
    
    // 添加自定义类型
    for (JSONModel *sub in self.models) {
        
        NSString *_property = [[NSString alloc] initWithFormat:@"\n@property (strong, nonatomic) %@ *%@;\n",sub.className,sub.classKey];
        
        [mArray addObject:_property];
    }
    
    [mArray addObject:@"\n@end"];
    
    return [NSArray arrayWithArray:mArray];
}

// 检查类型
- (void) checkValue:(id)value property:(NSString *)property propertyType:(NSString *)propertyType {
    
    if([value isKindOfClass:[NSString class]]) {
        
        property = @"copy";
        
        propertyType = @"NSString *";
        
    } else if ([value isKindOfClass:[NSArray class]]) {
        
        property = @"strong";
        
        propertyType = @"NSArray *";
        
    } else if ([value isKindOfClass:[NSData class]]) {
        
        property = @"strong";
        
        propertyType = @"NSData *";
        
    } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
        
        property = @"assign";
        
        propertyType = @"BOOL ";
        
    } else {
        
        propertyType = @"NSNumber *";
        
        property = @"strong";
    }
}

#pragma mark - public
- (void) creatContentFile {
    
    // 创建文件 并 写属性
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:self.dictionary];
    
    for (NSString *key in mDic.allKeys) {
        
        id value = mDic[key];
        
        if([value isKindOfClass:[NSDictionary class]]) { // 在 models 中有记录
            
            [mDic removeObjectForKey:key];
        }
    }
    
    if(self.className.length > 0){
        
        [self creatFile];
        
        // 写属性
        NSArray *contentArray = [self writeContentWihtDictionary:mDic];
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[self hPre]];
        
        // .h
        for (NSString *content in contentArray) {
            
            [self writePropertyToH:content fileHandle:fileHandle];
        }
        
        [fileHandle closeFile];
        
        // .m
        [self writeContentToM];
    }
}

@end
