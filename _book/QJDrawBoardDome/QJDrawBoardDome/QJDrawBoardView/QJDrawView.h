//
//  QJDrawView.h
//  QJDrawBoardDome
//
//  Created by 瞿杰 on 2019/9/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJDrawView : UIView

@property (nonatomic , assign) CGFloat curLineWidth ;
@property (nonatomic , strong) UIColor * curLineColor ;

- (void)drawImage:(UIImage *)image ;

// 清屏
- (void)clearAll ;
// 撤销
- (void)repeal ;
// 橡皮擦
- (void)erase ;
// 把画板截个图保存到相册
- (void)save ;

@end

NS_ASSUME_NONNULL_END
