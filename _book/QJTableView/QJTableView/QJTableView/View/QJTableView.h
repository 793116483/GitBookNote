//
//  QJTableView.h
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QJBaseGroupCellModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 当前 tableView 只实现了 UITableViewDataSource 协议中前5个方法
 
 如果继成了当前的类，那么可以调用 [super tableView:...] UITableViewDataSource 协议的前5个方法
 */
@interface QJTableView : UITableView <UITableViewDataSource>

-(instancetype)initWithGroupArray:(NSMutableArray *)groupArr ;

@property (nonatomic , strong)NSMutableArray<QJBaseGroupCellModel *> * groupArr ;

@end

NS_ASSUME_NONNULL_END
