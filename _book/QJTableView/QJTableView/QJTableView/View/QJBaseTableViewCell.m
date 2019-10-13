//
//  QJBaseTableViewCell.m
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJBaseTableViewCell.h"
#import "QJBaseCellModel.h"
#import "QJSwitchCellModel.h"

@interface QJBaseTableViewCell()

@property (nonatomic , strong) UISwitch * switchView ;

@end

@implementation QJBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)baseTableViewCellWithCellModel:(QJBaseCellModel *)cellModel
{
    QJBaseTableViewCell * cell = [[self alloc] initWithCellModel:cellModel];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellModel.cellClass) owner:nil options:nil] lastObject];
        cell = [cell initWithCellModel:cellModel];
    }
    return cell ;
}
-(instancetype)initWithCellModel:(QJBaseCellModel *)cellModel
{
    if (self = [self initWithStyle:cellModel.style reuseIdentifier:cellModel.reuseIdentifier]) {
        self.cellModel = cellModel ;
    }
    return self ;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor redColor ];
//        self.contentView.backgroundColor = [UIColor greenColor];
    }
    return self ;
}

-(void)setCellModel:(QJBaseCellModel *)cellModel
{
    _cellModel = cellModel ;
    self.textLabel.text = cellModel.text ;
    self.detailTextLabel.text = cellModel.detailText ;
    self.imageView.image = cellModel.image ;
    self.selectionStyle = cellModel.selectionStyle ;
    self.accessoryType = cellModel.accessoryType ;
    
    if ([cellModel isKindOfClass:[QJSwitchCellModel class]]) {
        self.switchView.on = ((QJSwitchCellModel *)cellModel).isOn ;
        self.accessoryView = self.switchView;
    }
    else{
        self.accessoryView = nil ;
    }
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

-(UISwitch *)switchView
{
    if (!_switchView) {
        self.switchView = [[UISwitch alloc] init];
        [self.switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchView ;
}
-(void)switchChanged:(UISwitch *)switchView
{
    if ([self.cellModel isKindOfClass:[QJSwitchCellModel class]]) {
        ((QJSwitchCellModel *)self.cellModel).on = switchView.on ;
    }
}

@end
