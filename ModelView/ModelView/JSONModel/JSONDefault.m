//
//  JSONDefault.m
//  TestView
//
//  Created by Four on 2018/1/20.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "JSONDefault.h"

static NSString *json = @"";

static NSString *folder = @"";

@implementation JSONDefault

+ (NSString *) folderPath {
    
    return folder;
}

+ (NSString *) jsonPath {

    return json;
}

+(void)setJsonPath:(NSString *)jsonPath {
    
    json = jsonPath;
}

+(void)setFolderPath:(NSString *)folderPath {
    
    folder = folderPath;
}

@end
