//
//  QJBaseGroupCellModel.h
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//  一组的模型

#import <Foundation/Foundation.h>
#import "QJBaseCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QJBaseGroupCellModel : NSObject

@property (nonatomic , copy , nullable) NSString * sectionHeaderTitle ;
@property (nonatomic , copy , nullable) NSString * sectionFooterTitle ;

// 当前组的models
@property (nonatomic , strong) NSMutableArray<QJBaseCellModel *> * modelArr ;

@end

NS_ASSUME_NONNULL_END
