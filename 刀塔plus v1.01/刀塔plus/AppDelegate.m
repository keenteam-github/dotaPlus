//
//  AppDelegate.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "AppDelegate.h"

#import <Bugly/CrashReporter.h>
#import "MyTabBarController.h"
#import "FirstLaunchViewController.h"


@interface AppDelegate ()
{
    MyTabBarController *_tbBar;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //崩溃收集id
    [[CrashReporter sharedInstance] enableLog:YES];
[[CrashReporter sharedInstance] installWithAppId:kCrashCollectID];
    
    _tbBar=[[MyTabBarController alloc]init];
    
    BOOL isNotFirstLaunch=[[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstLaunch"];
    
    if(isNotFirstLaunch)
    {
        self.window.rootViewController=_tbBar;
    }
    else
    {
        isNotFirstLaunch=!isNotFirstLaunch;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirstLaunch"];
        FirstLaunchViewController *first=[[FirstLaunchViewController alloc]init];
        self.window.rootViewController=first;
    }
    
    [_window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
