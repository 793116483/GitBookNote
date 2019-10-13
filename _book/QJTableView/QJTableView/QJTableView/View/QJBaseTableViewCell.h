//
//  QJBaseTableViewCell.h
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QJBaseCellModel ;
@interface QJBaseTableViewCell : UITableViewCell

@property (nonatomic , strong) QJBaseCellModel * cellModel ;

+(instancetype)baseTableViewCellWithCellModel:(QJBaseCellModel *)cellModel ;

-(instancetype)initWithCellModel:(QJBaseCellModel *)cellModel ;

@end

NS_ASSUME_NONNULL_END
