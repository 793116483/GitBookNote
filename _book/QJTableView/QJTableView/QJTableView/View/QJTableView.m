//
//  QJTableView.m
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJTableView.h"
#import "QJBaseTableViewCell.h"

@interface QJTableView(TableViewPackage)

@end


@implementation QJTableView

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.dataSource = self ;
}
-(instancetype)initWithGroupArray:(NSMutableArray *)groupArr
{
    if (self = [super init]) {
        self.groupArr = groupArr ;
    }
    return self ;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        self.dataSource = self ;
        
    }
    return self ;
}

-(NSMutableArray<QJBaseGroupCellModel *> *)groupArr
{
    if (!_groupArr) {
        _groupArr = [NSMutableArray array];
    }
    return _groupArr ;
}

#pragma makr - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArr.count ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QJBaseGroupCellModel * groupCellModel = [self.groupArr objectAtIndex:section];
    return groupCellModel.modelArr.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    QJBaseGroupCellModel * groupCellModel = [self.groupArr objectAtIndex:indexPath.section];
    QJBaseCellModel * cellModel = [groupCellModel.modelArr objectAtIndex:indexPath.row] ;
    
    QJBaseTableViewCell * cell = [[tableView dequeueReusableCellWithIdentifier:cellModel.reuseIdentifier] initWithCellModel:cellModel];
    if (!cell) {
        cell = [cellModel.cellClass baseTableViewCellWithCellModel:cellModel];
    }
    
    if (cellModel.updateCellSubviewWhenSetCellModelBlock) {
        cellModel.updateCellSubviewWhenSetCellModelBlock(cell, cellModel);
    }
    
    return cell ;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QJBaseGroupCellModel * groupCellModel = [self.groupArr objectAtIndex:section];
    return groupCellModel.sectionHeaderTitle ;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    QJBaseGroupCellModel * groupCellModel = [self.groupArr objectAtIndex:section] ;
    return groupCellModel.sectionFooterTitle ;
}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%s",__func__);
//}
@end
