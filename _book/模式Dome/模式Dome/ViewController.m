//
//  ViewController.m
//  模式Dome
//
//  Created by 瞿杰 on 2019/9/28.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "QJSubOneModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    QJSubOneModel * instance1 = [QJSubOneModel shareSubOne];
    QJSubOneModel * instance2 = [[QJSubOneModel alloc] init];
    NSLog(@"%@ === %@",instance1,instance2);
}


@end
