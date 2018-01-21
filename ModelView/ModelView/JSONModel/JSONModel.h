//
//  JSONModel.h
//  Model
//
//  Created by Four on 2018/1/20.
//  Copyright © 2018年 Four. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModel : NSObject

// 生成类的名称
@property (copy, nonatomic) NSString *className;

// 对应的名称
@property (copy, nonatomic) NSString *classKey;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// 生成文件
- (void) creatContentFile;

@end
