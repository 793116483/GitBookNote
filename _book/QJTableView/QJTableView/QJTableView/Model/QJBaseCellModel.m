//
//  QJBaseCellModel.m
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJBaseCellModel.h"

@implementation QJBaseCellModel

+(instancetype)baseCellModelWithCellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier
{
    QJBaseCellModel * cellModel = [[self alloc] initWithCellClass:cellClass reuseIdentifier:reuseIdentifier];
    return cellModel ;
}
-(instancetype)initWithCellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [self init]) {
        self.reuseIdentifier = [reuseIdentifier copy];
        self.cellClass = cellClass ;
    }
    return self ;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.style = UITableViewCellStyleValue1 ;
    }
    return self ;
}

- (void)setCellClass:(Class)cellClass
{
    if (!self.reuseIdentifier || [_cellClass isKindOfClass:NSClassFromString(self.reuseIdentifier)]) {
        self.reuseIdentifier = NSStringFromClass(cellClass);
    }
    _cellClass = cellClass ;
}

@end
