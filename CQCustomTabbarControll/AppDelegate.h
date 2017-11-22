//
//  AppDelegate.h
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/17.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

