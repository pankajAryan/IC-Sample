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

    BOOL isLoggedIn = [[UIViewController retrieveDataFromUserDefault:@"isUserLoggedIn"] boolValue];

    if (isLoggedIn) {
        
        self.rootNavController = (UINavigationController*)self.window.rootViewController; // it'll return UINavigationController which is set as Initial view controller in storyboard.
        
        RootViewController *rootVC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
        
        self.rootNavController.viewControllers = @[rootVC];
        
        [self.window makeKeyAndVisible];
    }

    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[NSURL URLWithString:GET_JAVA_BASE_URL]
     withParameter:nil
     onCompletion:^(eResponseType responseType, id response)
     {
         if (responseType == eResponseTypeSuccessJSON)
         {
             [FFWebServiceHelper sharedManager].dynamicBaseUrl = [response objectForKey:@"server_url"];
         }
     }];

    return YES;
}

- (void)logout {

    [UIViewController saveDatatoUserDefault:@"0" forKey:@"isUserLoggedIn"];

    UINavigationController *rootVC = [UINavigationController instantiateViewControllerWithIdentifier:@"rootNavController" fromStoryboard:@"Main"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.rootViewController = rootVC;
        [self.window makeKeyAndVisible];
    });
}

#pragma mark -

- (void)registerForRemoteNotifications{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
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
