//
//  AppDelegate.h
//  QQ红点信息粘性
//
//  Created by 瞿杰 on 2019/9/18.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

