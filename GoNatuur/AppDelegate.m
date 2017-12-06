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
#import "UncaughtExceptionHandler.h"
#import "ChatStyling.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import <ZDCChat/ZDCChat.h>
#import "ProductDetailViewController.h"
#import "EventDetailViewController.h"
#import "NewsCentreDetailViewController.h"
#import "ProductDetailViewController.h"
#import "ProfileViewController.h"
#import "ProductListingViewController.h"
#import "OrderDetailViewController.h"
#import "NotificationDataModel.h"

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
@synthesize isProductList;
@synthesize exchangeRates;
@synthesize tabButtonTag;
@synthesize productCartItemsDetail;
@synthesize productCartItemKeys;
@synthesize firstTime;
@synthesize notificationStatus;
@synthesize shareEventIdDataDict;
@synthesize isShareUrlScreen;
@synthesize recentlyViewedItemsArrayGuest;
@synthesize screenTargetId;
@synthesize isNotificationArrived;
@synthesize notificationType;

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

//crashlytics
- (void)installUncaughtExceptionHandler {
    InstallUncaughtExceptionHandler();
}

#pragma mark - Application life cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
 
   // Call crashlytics method
    [self performSelector:@selector(installUncaughtExceptionHandler) withObject:nil afterDelay:0];
    
    firstTime=true;
    isShareUrlScreen=@"0";
    shareEventIdDataDict=[[NSMutableDictionary alloc]init];
    recentlyViewedItemsArrayGuest=[[NSMutableArray alloc]init];
    recentlyViewedItemsArrayGuest=[[UserDefaultManager getValue:@"recentlyViewedGuest"] mutableCopy];
    
    //set default language to english
    if (nil==[UserDefaultManager getValue:@"Language"]) {
        [UserDefaultManager setValue:@"en" key:@"Language"];
    }
    
    [NSThread sleepForTimeInterval:1.0];
        //Set navigation bar color
   [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont montserratMediumWithSize:20], NSFontAttributeName, nil]];
    //Values initialized
    [self initializedValues];
    //Connect appdelegate to facebook delegate
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    navigationController = (UINavigationController *)[self.window rootViewController];
    if (nil!=[UserDefaultManager getValue:@"quoteId"]) {
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:objReveal];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        [self.window makeKeyAndVisible];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //[self registerForRemoteNotification];
    return YES;
}

//deeplinking open url handler
-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString: NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        NSLog(@"----------------------%@---------------",url);
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *urlComponents = [url.absoluteString componentsSeparatedByString:@"?"];
        NSArray *urlComponents2 = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents2) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            [queryStringDictionary setObject:value forKey:key];
        }
        if ([[queryStringDictionary allKeys] containsObject:@"product_id"]) {
            isShareUrlScreen=@"1";
            shareEventIdDataDict=[queryStringDictionary mutableCopy];
        }
        else if ([[queryStringDictionary allKeys] containsObject:@"event_id"]) {
            isShareUrlScreen=@"1";
            shareEventIdDataDict=[queryStringDictionary mutableCopy];
        }
        else if ([[queryStringDictionary allKeys] containsObject:@"post_id"]) {
            isShareUrlScreen=@"1";
            shareEventIdDataDict=[queryStringDictionary mutableCopy];
        }
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationController = (UINavigationController *)[self.window rootViewController];
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:objReveal];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        [self.window makeKeyAndVisible];
    }
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
    notificationStatus=@"1";
}

- (void)unregisterForRemoteNotifications {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    notificationStatus=@"0";
}
#pragma mark - end

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    [self notifcationResponseDict:response.notification.request.content.userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"%@", notification.request.content.userInfo);
    completionHandler(UNNotificationPresentationOptionAlert);
}
#pragma mark - end

#pragma mark - PushNotification delegate
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)token {
    NSString *tokenString = [[token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = tokenString;
    [UserDefaultManager setValue:deviceToken key:@"deviceToken"];
    NSLog(@"My device token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Received notification: %@", userInfo);
    //    [self notifcationResponseDict:userInfo];
}

- (void)notifcationResponseDict:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSDictionary *dict = [userInfo objectForKey:@"aps"] ;
    NSLog(@"notification response === %@",dict);
    [self markNotificationAsRead:dict[@"notification_id"]];
    self.screenTargetId=dict[@"targat_id"];
    self.notificationType=[dict[@"type"] intValue];
    isNotificationArrived=@"1";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:objReveal];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
}

- (void)markNotificationAsRead:(NSString *)notificationId {
    NotificationDataModel *notificationList = [NotificationDataModel sharedUser];
    notificationList.notificationId=notificationId;
    [notificationList markNotificationRead:^(NotificationDataModel *userData) {
        userData.notificationStatus=@"1";
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)showNotificationAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedText(@"alertTitle") message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedText(@"alertOk"), nil];
    [alert show];
}
#pragma mark - end

#pragma mark - Value initialized of didFinishLaunch
- (void)initializedValues {
    tabButtonTag=0;
    selectedLoginType=FacebookLogin;
    if (myDelegate.productCartItemKeys==nil) {
        myDelegate.productCartItemKeys=[NSMutableArray new];
        myDelegate.productCartItemsDetail=[NSMutableDictionary new];
    }
    selectedCategoryIndex=-1;
    
    //ZopimTicket setup
    [[ZDKConfig instance] initializeWithAppId:zopimTicketAppId
                                   zendeskUrl:zopimURL
                                     clientId:zopimClientId];
    [[ZDCChatOverlay appearance] setInsets:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(75.0f, 15.0f, 70.0f, 15.0f)]];
    // ZopimChat setup
    [ChatStyling applyStyling];
    // Configure account key and pre-chat form
    [ZDCChat initializeWithAccountKey:zopimAppId];
    [ZDCChat startChat:^(ZDCConfig *config){
        config.preChatDataRequirements.name = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.email = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.phone = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.department = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.message = ZDCPreChatDataRequired;
        //config.emailTranscriptAction = ZDCEmailTranscriptActionNeverSend;
    }];
    // To override the default avatar uncomment and complete the image name
    //[[ZDCChatAvatar appearance] setDefaultAvatar:@"your_avatar_name_here"];
    // Uncomment to disable visitor data persistence between application runs
    //    [[ZDCChat instance].session visitorInfo].shouldPersist = YES;
    
    // Uncomment if you don't want open chat sessions to be automatically resumed on application launch
    [ZDCChat instance].shouldResumeOnLaunch = YES;
    
    // Remember to switch off debug logging before app store submission!
    [ZDCLog enable:YES];
    [ZDCLog setLogLevel:ZDCLogLevelWarn];
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

#pragma mark - Guest access
- (BOOL)checkGuestAccess {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
            //logout user
            [self logoutUser];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"guestUserAccess") closeButtonTitle:NSLocalizedText(@"alertCancel") duration:0.0f];
        return true;
    }
    else {
        return false;
    }
}
#pragma mark - end

#pragma mark - Logout user
- (void)logoutUser {
    [myDelegate unregisterForRemoteNotifications];
    //Logout user
    [UserDefaultManager removeValue:@"quoteCount"];
    [UserDefaultManager removeValue:@"userId"];
    [UserDefaultManager removeValue:@"emailId"];
    [UserDefaultManager removeValue:@"Authorization"];
    [UserDefaultManager removeValue:@"profilePicture"];
    [UserDefaultManager removeValue:@"enableNotification"];
    [UserDefaultManager removeValue:@"quoteId"];
    [UserDefaultManager removeValue:@"firstname"];
    [UserDefaultManager removeValue:@"lastname"];
    [UserDefaultManager setValue:@"" key:@"TotalPoints"];
    [UserDefaultManager setValue:@"" key:@"RecentEarned"];
    firstTime=true;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    myDelegate.window.rootViewController = myDelegate.navigationController;
}
#pragma mark - end
@end
