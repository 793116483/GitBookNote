//
//  QJBadgeNumberView.h
//  QQ红点信息粘性
//
//  Created by 瞿杰 on 2019/9/18.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJBadgeNumberView : UIView

// 需要显示的数据
@property (nonatomic , copy) NSString * message ;
/** message 文字颜色 ，默认为 白色 */
@property (nonatomic , strong) UIColor * messageColor ;

// 填充颜色 ， 默认为 红色
@property (nonatomic , strong) UIColor * fillColor ;

// 移动最大距离后 ，就不显示粘性样式 ， 默认为 100.0 ； 值 > 0
@property (nonatomic , assign) CGFloat movMaxDistance ;

@end

NS_ASSUME_NONNULL_END
