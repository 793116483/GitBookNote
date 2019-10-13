//
//  QJBaseGroupCellModel.m
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJBaseGroupCellModel.h"

@implementation QJBaseGroupCellModel

-(NSMutableArray<QJBaseCellModel *> *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr ;
}

@end
