//
//  QJDrawBoardView.m
//  QJDrawBoardDome
//
//  Created by 瞿杰 on 2019/9/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJDrawBoardView.h"
#import "QJDrawView.h"

@interface QJDrawBoardView ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet QJDrawView *drawView;

@end

@implementation QJDrawBoardView

+(instancetype)drawBoarView
{
    return [[NSBundle mainBundle] loadNibNamed:@"QJDrawBoardView" owner:nil options:nil].lastObject ;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.slider addTarget:self action:@selector(changeLineWidth:) forControlEvents:UIControlEventValueChanged];
}

#pragma make - 按钮点击事件
// 清屏
- (IBAction)clearAll:(id)sender {
    [self.drawView clearAll];
}
// 撤销
- (IBAction)repeal:(id)sender {
    [self.drawView repeal];
}
// 橡皮擦
- (IBAction)erase:(id)sender {
    [self.drawView erase];
}

// 照片
- (IBAction)photograph:(id)sender {
    UIImage * image = [UIImage imageNamed:@"cell自定义左滑按钮"];
    [self.drawView drawImage:image];

}
// 保存
- (IBAction)save:(id)sender {
    [self.drawView save];
}

- (void)changeLineWidth:(UISlider *)slider {
//    NSLog(@"%lf",slider.value);
    self.drawView.curLineWidth = slider.value;
}

- (IBAction)changeLineColor:(UIButton *)sender {
    self.drawView.curLineColor = sender.backgroundColor ;
}

@end
