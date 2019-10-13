//
//  QJBaseCellModel.h
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//   当前模型是根模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QJBaseTableViewCell ;

@interface QJBaseCellModel : NSObject

// 这是每个模型对应的 cell class (必须是 QJBaseTableViewCell 类 或者 其子类) , 必须设置
@property (nonatomic , assign) Class cellClass ;
/** 重用标识，默认 = cellClass 类的类名  */
@property (nonatomic , copy ) NSString * reuseIdentifier ;

/* 可选属性 */ 
@property (nonatomic , strong , nullable) UIImage * image ;
@property (nonatomic , copy , nullable) NSString * text ;
@property (nonatomic , copy , nullable) NSString * detailText ;

// 默认值 UITableViewCellStyleValue1
@property (nonatomic , assign) UITableViewCellStyle style ;
@property (nonatomic) UITableViewCellSelectionStyle   selectionStyle;  
@property (nonatomic , assign) UITableViewCellAccessoryType    accessoryType;

// block
// 外界设置cell数据
@property (nonatomic , copy , nullable) void (^updateCellSubviewWhenSetCellModelBlock)(QJBaseTableViewCell * cell , QJBaseCellModel * cellModel);

// 被选中的 cell 外界需要做的事
//@property (nonatomic , copy , nullable) void (^selectedCellBlock)(QJBaseTableViewCell * cell);


/**
 初始化

 @param cellClass cell 的类
 @param reuseIdentifier 重用机制的标识 ， 如果为 nil ，则与 cellClass 类的类名
 */
+ (instancetype) baseCellModelWithCellClass:(Class)cellClass reuseIdentifier:(nullable NSString *)reuseIdentifier ;
- (instancetype) initWithCellClass:(Class)cellClass reuseIdentifier:(nullable NSString *)reuseIdentifier ;

@end

NS_ASSUME_NONNULL_END
