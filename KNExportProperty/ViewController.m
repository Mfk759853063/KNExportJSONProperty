//
//  ViewController.m
//  KNExportProperty
//
//  Created by kwep_vbn on 16/2/2.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+ExportJSONModelProperty.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self printJSONPropertyCode:((NSArray *)[json valueForKeyPath:@"data"]).firstObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
