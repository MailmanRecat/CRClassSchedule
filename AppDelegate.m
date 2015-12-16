//
//  AppDelegate.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "AppDelegate.h"

#import "CRTestFunction.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)makeShortItems{
    UIApplicationShortcutItem *add = [[UIApplicationShortcutItem alloc] initWithType:@"shortcutItemAdd"
                                                                      localizedTitle:@"Add Class"
                                                                   localizedSubtitle:nil
                                                                                icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd]
                                                                            userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[ add ];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    NSLog(@"%@", shortcutItem.type);
    if( [shortcutItem.type isEqualToString:@"shortcutItemAdd"] ){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"FUCK" object:self];
    }
        
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [CRTestFunction runCRTestFunc];
    
    [self makeShortItems];
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
    
    NSLog(@"active");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
