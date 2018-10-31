//
//  ViewController.m
//  WXWLuckView
//
//  Created by administrator on 2018/8/29.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (IBAction)testAction:(id)sender {
    [self.navigationController pushViewController:[TestViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
