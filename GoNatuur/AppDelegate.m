//
//  AppDelegate.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 10/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AppDelegate.h"
#import "MMMaterialDesignSpinner.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate () <UNUserNotificationCenterDelegate>{
    UIView *loaderView;
    UIImageView *spinnerBackground;
}
@property (strong, nonatomic) MMMaterialDesignSpinner *spinnerView;
@end

@implementation AppDelegate
@synthesize selectedLoginType;
@synthesize deviceToken;
@synthesize selectedCategoryIndex;
@synthesize navigationController;
@synthesize spinnerView;
@synthesize categoryNameArray;

#pragma mark - Global indicator
//Show indicator
- (void)showIndicator {
    spinnerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 50, 50)];
    spinnerBackground.backgroundColor=[UIColor whiteColor];
    spinnerBackground.layer.cornerRadius=25.0f;
    spinnerBackground.clipsToBounds=true;
    spinnerBackground.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    loaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    loaderView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:0.3];
    [loaderView addSubview:spinnerBackground];
    spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    spinnerView.tintColor = [UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    spinnerView.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    spinnerView.lineWidth=3.0f;
    [self.window addSubview:loaderView];
    [self.window addSubview:spinnerView];
    [spinnerView startAnimating];
}

//Stop indicator
- (void)stopIndicator {
    [loaderView removeFromSuperview];
    [spinnerView removeFromSuperview];
    [spinnerView stopAnimating];
}
#pragma mark - end

#pragma mark - Application life cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Set navigation bar color
   [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont montserratMediumWithSize:20], NSFontAttributeName, nil]];
    
    selectedLoginType=FacebookLogin;
    //Connect appdelegate to facebook delegate
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    navigationController = (UINavigationController *)[self.window rootViewController];
    if (nil!=[UserDefaultManager getValue:@"userId"]) {
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:objReveal];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        [self.window makeKeyAndVisible];
    }
    
    //[self registerForRemoteNotification];
    selectedCategoryIndex=-1;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - end

#pragma mark - Notification Registration
- (void)registerForRemoteNotification {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(iOS_Version)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)unregisterForRemoteNotifications {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}
#pragma mark - end

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    //    [self notifcationResponseDict:response.notification.request.content.userInfo];
}
#pragma mark - end

#pragma mark - PushNotification delegate
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)token {
    NSString *tokenString = [[token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = tokenString;
    NSLog(@"My device token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Received notification: %@", userInfo);
    //    [self notifcationResponseDict:userInfo];
}

- (void)notifcationResponseDict:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSDictionary *dict = [userInfo objectForKey:@"aps"] ;
    NSLog(@"notification response === %@",dict);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //if app is in active state
    } else {
        //if app is not active
    }
}
- (void)showNotificationAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedText(@"alertTitle") message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedText(@"alertOk"), nil];
    [alert show];
}
#pragma mark - end

#pragma mark - Facebook open url connection
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}
#pragma mark - end

#pragma mark - Google Sign-in open url connection
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    if (selectedLoginType==FacebookLogin) {
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
}
#pragma mark - end
@end
