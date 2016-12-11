//
//  AppDelegate.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "AppDelegate.h"
//@import GoogleMaps;
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerForRemoteNotifications];

    NSString *userId = [UIViewController retrieveDataFromUserDefault:@"userId"];
    BOOL isLoggedIn = [[UIViewController retrieveDataFromUserDefault:@"isUserLoggedIn"] boolValue];

    if (!(isLoggedIn && (userId && userId.length))) {
        
        self.rootNavController = (UINavigationController*)self.window.rootViewController; // it'll return UINavigationController which is set as Initial view controller in storyboard.
        
        RootViewController *rootVC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
        
        self.rootNavController.viewControllers = @[rootVC];
        
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)logout {
//    [[GIDSignIn sharedInstance] signOut];
    [UIViewController saveDatatoUserDefault:@"" forKey:@"userId"];
    [UIViewController saveDatatoUserDefault:@"0" forKey:@"isUserLoggedIn"];

    UINavigationController *rootVC = [UINavigationController instantiateViewControllerWithIdentifier:@"rootNavController" fromStoryboard:@"Main"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.rootViewController = rootVC;
        [self.window makeKeyAndVisible];
    });
}
//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary *)options {
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//}


#pragma mark -

- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (token != nil) {
        [UIViewController saveDatatoUserDefault:token forKey:@"DEVICE_TOKEN"];
    }
}

#pragma mark -

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
}

@end
