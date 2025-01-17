//
//  AppDelegate.m
//  Roman Numerals
//
//  Created by Robert Clarke on 25/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "AppDelegate.h"
#import "RomanIAPHelper.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [RomanIAPHelper sharedInstance];
    [self loadSettings];

    // Override point for customization after application launch.
    return YES;
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

#pragma mark - Settings

- (void)loadSettings {
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], kAutoCorrectKey,
                                 [NSNumber numberWithInt:0], kKeyboardPresentationKey,
                                 [NSNumber numberWithInt:2], kLargeNumberPresentationKey,
                                 [NSNumber numberWithBool:YES], kAutoSwitchKey,
                                 
                                 [NSNumber numberWithInt:0], kDateOrderKey,
                                 [NSNumber numberWithInt:0], kDateFormatKey,
                                 [NSNumber numberWithBool:YES], kYearFormatKey,
                                 
                                 [NSNumber numberWithBool:NO], kMigratedKey,
                                 
                                 [NSNumber numberWithBool:NO], kCalculatorPurchaseKey,
                                 [NSNumber numberWithBool:NO], kCalendarPurchaseKey,
                                 [NSNumber numberWithBool:NO], kCrosswordPurchaseKey,
                                 [NSNumber numberWithBool:NO], kProPurchaseKey,
                                 nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //[defaults setObject:[NSNumber numberWithBool:NO] forKey:kMigratedKey];
    //[defaults synchronize];

    if ([[defaults valueForKey:kMigratedKey] boolValue] == NO) {
        NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
        
        [groupDefaults setValue:[defaults valueForKey:kAutoCorrectKey] forKey:kAutoCorrectKey];
        [groupDefaults setValue:[defaults valueForKey:kKeyboardPresentationKey] forKey:kKeyboardPresentationKey];
        [groupDefaults setValue:[defaults valueForKey:kLargeNumberPresentationKey] forKey:kLargeNumberPresentationKey];
        [groupDefaults setValue:[defaults valueForKey:kAutoSwitchKey] forKey:kAutoSwitchKey];

        [groupDefaults setValue:[defaults valueForKey:kDateOrderKey] forKey:kDateOrderKey];
        [groupDefaults setValue:[defaults valueForKey:kDateFormatKey] forKey:kDateFormatKey];
        [groupDefaults setValue:[defaults valueForKey:kYearFormatKey] forKey:kYearFormatKey];

        [groupDefaults setValue:[defaults valueForKey:kCalculatorPurchaseKey] forKey:kCalculatorPurchaseKey];
        [groupDefaults setValue:[defaults valueForKey:kCalendarPurchaseKey] forKey:kCalendarPurchaseKey];
        [groupDefaults setValue:[defaults valueForKey:kCrosswordPurchaseKey] forKey:kCrosswordPurchaseKey];
        [groupDefaults setValue:[defaults valueForKey:kProPurchaseKey] forKey:kProPurchaseKey];

        [groupDefaults synchronize];

        // and finally migrate
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:kMigratedKey];
        [defaults synchronize];
    }
}

@end
