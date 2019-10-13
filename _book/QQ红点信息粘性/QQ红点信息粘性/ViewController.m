//
//  ViewController.m
//  QQ红点信息粘性
//
//  Created by 瞿杰 on 2019/9/18.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "QJBadgeNumberView.h"
#import <objc/runtime.h>

@interface ViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    QJBadgeNumberView * badgeNumberView = [[QJBadgeNumberView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    [self.view addSubview:badgeNumberView];
    
    // 自定义删除控制器手势
//    UIScreenEdgePanGestureRecognizer * edgePan = self.interactivePopGestureRecognizer ;
//    NSLog(@"%ld====%@,",edgePan.edges,self.interactivePopGestureRecognizer);
//
//    // kvc 获取属性值
//    NSMutableArray * value = [edgePan valueForKey:@"_targets"];
//    // [0]    UIGestureRecognizerTarget *    0x600001a8aca0    0x0000600001a8aca0
//    id recognizerTarget = [value firstObject];
//    // <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7ff036c070c0>)>
//    id target = [recognizerTarget valueForKey:@"_target"];
//
//    // 自定义的删除手势 ,
//    [self.view removeGestureRecognizer:self.interactivePopGestureRecognizer];
//    UIPanGestureRecognizer * navPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    navPanGesture.delegate = self;
//    [self.view addGestureRecognizer:navPanGesture];
    
    
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch * touch = [touches anyObject];
//    if (touch.tapCount >= 2) {
//        UIViewController * vc = [[UIViewController alloc] init] ;
//        vc.view.backgroundColor = [UIColor redColor];
//        [self pushViewController:vc animated:YES];
//    }
//
//}
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//
//    return YES ;
//}
//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//
//    if (self.viewControllers.count > 1 ) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
//    }
//}
//-(void)back
//{
//    [self popViewControllerAnimated:YES];
//}

@end
