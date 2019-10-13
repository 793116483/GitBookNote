//
//  QJBadgeNumberView.m
//  QQ红点信息粘性
//
//  Created by 瞿杰 on 2019/9/18.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJBadgeNumberView.h"

@interface QJBadgeNumberView()

@property (nonatomic , strong) UILabel * badgeNumberLable ;
@property (nonatomic , strong) UILabel * smallCircle;
@property (nonatomic , strong) CAShapeLayer * shapeLayer ;

@end

@implementation QJBadgeNumberView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self ;
}
-(void)initView
{
    
    self.smallCircle = [[UILabel alloc] init];
    self.smallCircle.clipsToBounds = YES ;
    [self insertSubview:self.smallCircle atIndex:0];
    
    self.badgeNumberLable = [[UILabel alloc] init];
    self.badgeNumberLable.clipsToBounds = YES ;
    self.badgeNumberLable.text = @"99+";
    self.badgeNumberLable.textAlignment = NSTextAlignmentCenter;
    self.badgeNumberLable.font = [UIFont systemFontOfSize:14];
    self.badgeNumberLable.userInteractionEnabled = YES ;
    [self.badgeNumberLable addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] ];
    [self addSubview:self.badgeNumberLable];
    
    self.smallCircle.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    self.smallCircle.layer.cornerRadius = self.bounds.size.width * 0.5;
    
    self.badgeNumberLable.frame = self.smallCircle.frame;
    self.badgeNumberLable.layer.cornerRadius = self.smallCircle.layer.cornerRadius;
    
    // 设置属性的初始值
    self.messageColor = [UIColor whiteColor];
    self.fillColor = [UIColor redColor];
    self.movMaxDistance = 100.0 ;
}

-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGFloat badgeR = self.badgeNumberLable.frame.size.width * 0.5 ;

    // point 为在 x 和 y 轴上面分别移动了多少距离
    CGPoint point = [pan translationInView:pan.view.superview];
    point.x += badgeR ;
    point.y += badgeR ;
    self.badgeNumberLable.center = point ;
    
    CGFloat distance = [self distanceWithFromePoint:self.smallCircle.center toPoint:self.badgeNumberLable.center];
    // 最大拉长的距离比
    CGFloat k = distance / self.movMaxDistance ;
//    k = k >= 0.75 ? 0.75:k;
    
    // 变更小圆半径
    self.smallCircle.transform = CGAffineTransformMakeScale(1-k, 1-k);
    
    if (distance<=0) {
        return ;
    }
    
    if (!self.shapeLayer.hidden) {
        // 给形状图层给定一个图形路径 , 由于点的位置确定，所以形状图层位置也确定
        self.shapeLayer.path = [self shapeLayerBetweenCircleRectOne:self.smallCircle.frame circleViewTwo:self.badgeNumberLable.frame] ;
    }

    if (pan.state == UIGestureRecognizerStateEnded) {
        if (distance <= self.movMaxDistance) {
            // 移除形状图层，下次开始时再创建新的
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil ;

            // 用弹簧方式，快速弹簧可以把上面的操作在显示上没多大差别
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.badgeNumberLable.center = CGPointMake(badgeR, badgeR);
                self.smallCircle.transform = CGAffineTransformIdentity ;
            } completion:^(BOOL finished) {
                self.smallCircle.hidden = NO ;
            }];
        }
        else{ // 以某种动画方式删除当前 view
            [self.badgeNumberLable removeFromSuperview];
            CATransition * transition = [CATransition animation];
            transition.type = @"rippleEffect";
            transition.duration = 1;
            [self.badgeNumberLable.layer addAnimation:transition forKey:nil];
            [self removeFromSuperview];
        }
    }
    else{
        if (distance > self.movMaxDistance) {
            self.smallCircle.hidden = YES ;
            self.shapeLayer.hidden = YES ;
        }
    }
}

-(CGFloat) distanceWithFromePoint:(CGPoint)fromeP toPoint:(CGPoint)toP
{
    CGFloat tx = toP.x - fromeP.x ;
    CGFloat ty = toP.y - fromeP.y ;
    
    return sqrt(tx * tx + ty * ty);
}

-(CGPathRef)shapeLayerBetweenCircleRectOne:(CGRect)circleRectOne  circleViewTwo:(CGRect)circleRectTwo
{
    CGPoint smallCenter = CGPointMake(circleRectOne.origin.x + circleRectOne.size.width * 0.5, circleRectOne.origin.y + circleRectOne.size.height * 0.5);
    CGPoint badgeCenter = CGPointMake(circleRectTwo.origin.x + circleRectTwo.size.width * 0.5, circleRectTwo.origin.y + circleRectTwo.size.height * 0.5);
    
    // 两个圆的圆心距离
    CGFloat distance = [self distanceWithFromePoint:smallCenter toPoint:badgeCenter];
    // 最大拉长的距离比
    CGFloat k = distance / self.movMaxDistance ;
//    k = k >= 0.75 ? 0.75:k;
    
    // 两圆的半径
    CGFloat smallR = circleRectOne.size.width * (1-k) / 2;
    CGFloat badgeR = circleRectTwo.size.width * 0.5 ;

    // 两圆的位置坐标
    CGFloat smallX = smallCenter.x ;
    CGFloat smallY = smallCenter.y ;
    
    CGFloat badgeX = badgeCenter.x;
    CGFloat badgeY = badgeCenter.y ;
    // 三角形内一个角的正弘 和 余弘
    CGFloat cosAngle = (badgeY - smallY) / distance ;
    CGFloat sinAngle= (badgeX - smallX) / distance ;
    
    // 圆 circleViewOne 上的A、B点 ，圆 circleViewTwo 上的 C、D点
    CGPoint pointA = CGPointMake(smallX - smallR * cosAngle, smallY + smallR * sinAngle);
    CGPoint pointB = CGPointMake(smallX + smallR * cosAngle, smallY - smallR * sinAngle);
    CGPoint pointC = CGPointMake(badgeX + badgeR * cosAngle, badgeY - badgeR * sinAngle);
    CGPoint pointD = CGPointMake(badgeX - badgeR * cosAngle, badgeY + badgeR * sinAngle);
    
    // 曲线控制点斜边长度取一个固定值 = A点与D点的距离一半
    CGFloat dAD_half = [self distanceWithFromePoint:pointA toPoint:pointD] * 0.5;
    CGPoint pointO = CGPointMake(pointA.x + dAD_half * sinAngle , pointA.y + dAD_half * cosAngle);
    CGPoint pointP = CGPointMake(pointB.x + dAD_half * sinAngle , pointB.y + dAD_half * cosAngle);
    
    // 创建路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:pointA];
    [bezierPath addLineToPoint:pointB];
    [bezierPath addCurveToPoint:pointC controlPoint1:pointP controlPoint2:pointP];
    [bezierPath addLineToPoint:pointD];
    [bezierPath addCurveToPoint:pointA controlPoint1:pointO controlPoint2:pointO];
    
    return bezierPath.CGPath ;
}

#pragma make - getter & setter
-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    self.smallCircle.backgroundColor = fillColor;
    self.shapeLayer.fillColor = fillColor.CGColor ;
    self.badgeNumberLable.backgroundColor = fillColor ;
}
-(void)setMessageColor:(UIColor *)messageColor
{
    _messageColor = messageColor ;
    self.badgeNumberLable.textColor = messageColor ;
}
-(void)setMovMaxDistance:(CGFloat)movMaxDistance
{
    if (movMaxDistance <= 0) {
        movMaxDistance = 1.0 ;
    }
    _movMaxDistance = movMaxDistance ;
}

-(CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor redColor].CGColor ;
        [self.layer insertSublayer:_shapeLayer atIndex:0];
    }
    return _shapeLayer ;
}

@end
