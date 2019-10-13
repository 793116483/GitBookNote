//
//  QJSwitchCellModel.h
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.

// accessoryView 是 UISwitch 开关

#import "QJBaseCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QJSwitchCellModel : QJBaseCellModel

@property (nonatomic , getter=isOn) BOOL on ;

@end

NS_ASSUME_NONNULL_END
