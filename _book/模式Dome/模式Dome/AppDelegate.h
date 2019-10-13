//
//  AppDelegate.h
//  模式Dome
//
//  Created by 瞿杰 on 2019/9/28.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

