//
//  AppDelegate.m
//  Tachist33
//
//  Created by Jon Howell on 12/09/2013.
//  Copyright (c) 2013 Manchester Metropolitan University - ESS - psyc. All rights reserved.
//  this version 7/9/16
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize     keyboardIsShowing;//for determining if keyboard on screen

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString       * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString       * settingsBundlePath    = [pathStr stringByAppendingPathComponent:           @"Settings.bundle"];
    NSString       * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary   * defaultPrefs          = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults * defaults              = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [defaults synchronize];//make sure all are updated
    
    //for determining if keyboard on screen
    // Monitor keyboard status application wide
    self.keyboardIsShowing = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    self.keyboardIsShowing = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.keyboardIsShowing = NO;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
