//
//  JSONTOModel.m
//  Model
//
//  Created by Four on 2018/1/20.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "JSONTOModel.h"

#import "JSONModel.h"

@implementation JSONTOModel

+ (void) creatModelWithsonPath:(NSString *)jsonPath {
    
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    JSONModel *model = [[JSONModel alloc] initWithDictionary:dictionary];
    
    [model creatContentFile];
}
@end
