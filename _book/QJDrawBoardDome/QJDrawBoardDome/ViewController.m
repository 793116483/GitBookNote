//
//  ViewController.m
//  QJDrawBoardDome
//
//  Created by 瞿杰 on 2019/9/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "QJDrawBoardView/QJDrawBoardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    QJDrawBoardView * drawBoardView = [QJDrawBoardView drawBoarView];
    drawBoardView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:drawBoardView];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

@end
