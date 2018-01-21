//
//  ViewController.m
//  ModelView
//
//  Created by Four on 2018/1/20.
//  Copyright © 2018年 Four. All rights reserved.
//

#import "ViewController.h"

#import "JSONTOModel.h"

@interface ViewController ()

@property (weak) IBOutlet NSTextFieldCell *jsonPath;

@property (weak) IBOutlet NSTextFieldCell *folderPath;

@property (weak) IBOutlet NSTextFieldCell *state;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)done:(NSButton *)sender {
    

    if (self.jsonPath.title.length > 0 && self.folderPath.title.length > 0) {
        
        [JSONDefault setJsonPath:self.jsonPath.title];

        [JSONDefault setFolderPath:self.folderPath.title];
        
        [JSONTOModel creatModelWithsonPath:[JSONDefault jsonPath]];
        
        self.state.title = @"susscess";
    }
}

- (IBAction)clear:(NSButton *)sender {
    
    self.state.title = @"prepare";

    self.jsonPath.title = @"";
    
    self.folderPath.title = @"";
}

@end
