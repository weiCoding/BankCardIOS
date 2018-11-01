//
//  AppDelegate.h
//  BankCardTest
//
//  Created by weicz on 2018/10/26.
//  Copyright © 2018年 SAIC FINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

