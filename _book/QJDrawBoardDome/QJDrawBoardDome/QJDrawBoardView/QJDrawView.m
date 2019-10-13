//
//  QJDrawView.m
//  QJDrawBoardDome
//
//  Created by 瞿杰 on 2019/9/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJDrawView.h"
#import "QJBezierPath.h"

@interface QJDrawView ()

@property (nonatomic , strong) NSMutableArray * bezierPaths ;
// 橡皮檫状态
@property (nonatomic , assign) BOOL isEraseState ;

@end

@implementation QJDrawView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
-(void)setUp
{
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    self.curLineColor = [UIColor blackColor];
    self.curLineWidth = 1.0 ;
    
    // 颜色渐变层
//    CAGradientLayer * layer = [CAGradientLayer layer];
//    layer.colors = @[(id)[UIColor redColor].CGColor ,(id)[UIColor blueColor].CGColor, (id)[UIColor blackColor].CGColor , (id)[UIColor yellowColor].CGColor];
//    layer.locations = @[@0.2 , @0.4 ,@0.8];
//    layer.type = kCAGradientLayerConic ;
//    layer.frame = self.layer.bounds;
//    [self.layer addSublayer:layer];
    
    // 复制图层
//    CAReplicatorLayer * repLayer = [CAReplicatorLayer layer];
//    repLayer.frame = self.layer.bounds;
//    repLayer.backgroundColor = [UIColor blueColor].CGColor;
//    repLayer.opacity = 0.6;
//    repLayer.instanceCount = 2 ;
//    repLayer.instanceColor = [UIColor redColor].CGColor;
//    repLayer.anchorPoint = CGPointMake(0.5, 1);
//    repLayer.position = CGPointMake(repLayer.bounds.size.width / 2.0, repLayer.bounds.size.height);
//    repLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
//    repLayer.instanceRedOffset -= 0.2;
//    repLayer.instanceGreenOffset -= 0.2;
//    repLayer.instanceBlueOffset -= 0.2;
//    repLayer.instanceAlphaOffset -= 0.1;
//    [self.layer addSublayer:repLayer];
    
    // 需要复制的子图层
//    CALayer * subLayer = [CALayer layer];
//    subLayer.frame = CGRectMake(50, 100, 40, 100);
//    subLayer.backgroundColor = [UIColor grayColor].CGColor;
//    subLayer.anchorPoint = CGPointMake(0.5, 1);
//    subLayer.position = CGPointMake(50, 100);
//    subLayer.repeatCount = 3;
//    [repLayer addSublayer:subLayer];
    
}
-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self];
//    NSLog(@"{%lf,%lf}",point.x , point.y);

    if (pan.state == UIGestureRecognizerStateBegan) {
        QJBezierPath * path = [QJBezierPath bezierPath];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path setLineCapStyle:kCGLineCapRound];
        if (self.isEraseState) {
            [path setLineWidth:10];
            path.color = self.backgroundColor ;
        }
        else{
            [path setLineWidth:self.curLineWidth];
            path.color = self.curLineColor ;
        }
        [path moveToPoint:point];
        [self.bezierPaths addObject:path];
    }
    else if (pan.state == UIGestureRecognizerStateChanged){
        QJBezierPath * path = [self.bezierPaths lastObject];
        [path addLineToPoint:point];
    }
    [self setNeedsDisplay];
}

-(void)drawImage:(UIImage *)image
{
    if (image.size.width) {
        [self.bezierPaths addObject:image];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (id path in self.bezierPaths) {
        if ([path isKindOfClass:[QJBezierPath class]]) {
            QJBezierPath * curPath = (QJBezierPath *)path;
            [curPath.color set];
            [curPath stroke];
        }
        else if ([path isKindOfClass:[UIImage class]]){
            UIImage * image = (UIImage *)path ;
            [image drawInRect:self.bounds];
        }
    }
}

#pragma make - 操作
// 清屏
- (void)clearAll{
    self.isEraseState = NO ;
    self.bezierPaths = nil ;
    [self setNeedsDisplay];
}
// 撤销
- (void)repeal {
    self.isEraseState = NO ;
    [self.bezierPaths removeLastObject];
    [self setNeedsDisplay];
}
// 橡皮擦
- (void)erase {
    self.isEraseState = YES ;
}
// 把画板截个图保存到相册
- (void)save {
    self.isEraseState = NO ;
    
    // opaque : 不透明
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext() ;
    [self.layer renderInContext:contextRef];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 转成PNG格式
    newImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
    
    UIGraphicsEndImageContext();
    
    // 把画板截个图保存到相册
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"已经保存到相册中了");
    }
    else{
        NSLog(@"保存到相册失败");
    }
   
}

#pragma make - getter
-(NSMutableArray *)bezierPaths
{
    if (!_bezierPaths) {
        _bezierPaths = [NSMutableArray array];
    }
    return _bezierPaths ;
}
-(void)setCurLineWidth:(CGFloat)curLineWidth
{
    _curLineWidth = curLineWidth ;
    self.isEraseState = NO ;
}
-(void)setCurLineColor:(UIColor *)curLineColor
{
    _curLineColor = curLineColor ;
    self.isEraseState = NO ;
}

@end
