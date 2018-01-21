//
//  JSONDefault.h
//  TestView
//
//  Created by Four on 2018/1/20.
//  Copyright © 2018年 Four. All rights reserved.
//

#import <Foundation/Foundation.h>

// 默认配置
@interface JSONDefault : NSObject

// 生成文件的路径
+ (NSString *) folderPath;

// json 文件路径
+ (NSString *) jsonPath;

+(void)setJsonPath:(NSString *)jsonPath;

+(void)setFolderPath:(NSString *)folderPath;

@end
