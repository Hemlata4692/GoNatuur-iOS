//
//  EnableNotificationViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "EnableNotificationViewController.h"
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface EnableNotificationViewController () {
    @private
    BOOL isNotificationAllowed;
    int isClickEnable;
}
@property (weak, nonatomic) IBOutlet UIImageView *notificationBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *notiTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *okayButton;
@property (weak, nonatomic) IBOutlet UIButton *notNowButton;
@end

@implementation EnableNotificationViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeInActiveState) name:UIApplicationWillEnterForegroundNotification object:nil];
    isClickEnable=0;
    // Do any additional setup after loading the view.
    [self localizedText];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) localizedText {
    _notiTitleLabel.text=NSLocalizedText(@"enableNotification");
    _descLabel.text=NSLocalizedText(@"descText");
    _infoTextLabel.text=NSLocalizedText(@"infoText");
    [_okayButton setTitle:NSLocalizedText(@"okay") forState:UIControlStateNormal];
    [_notNowButton setTitle:NSLocalizedText(@"notnow") forState:UIControlStateNormal];
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)enableNotificationButtonAction:(id)sender {
    if ([[UserDefaultManager getValue:@"allowNotification"] isEqual:@1]) {
        isClickEnable=1;
        [self checkNotificationSetting];
    }
    else {
    [myDelegate registerForRemoteNotification];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
                                                          //User tapped "Allow"
                                                            [UserDefaultManager setValue:[NSNumber numberWithBool:true] key:@"enableNotification"];
                                                          }
                                                        [UserDefaultManager setValue:@1 key:@"allowNotification"];
                                                        [self navigateToDashboard];
                                                  }];
    }
}

- (IBAction)disableNotificationButtonAction:(id)sender {
    [myDelegate unregisterForRemoteNotifications];
    [self navigateToDashboard];
}
#pragma mark - end

#pragma mark - UIApplicationWillEnterForegroundNotification handler
- (void)didBecomeInActiveState {
    [self checkNotificationSetting];
}
#pragma mark - end

#pragma mark - Check push notification setting
- (void)checkNotificationSetting {
    if (isClickEnable!=0) {
        if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(iOS_Version)) {
            //Use for iOS 9 or later device
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings){
                //Query the authorization status of the UNNotificationSettings object
                switch (settings.authorizationStatus) {
                    case UNAuthorizationStatusAuthorized:
                        if (isClickEnable==2) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showSettingAlert];
                            });
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [myDelegate registerForRemoteNotification];
                                [UserDefaultManager setValue:[NSNumber numberWithBool:true] key:@"enableNotification"];
                                [self navigateToDashboard];
                            });
                        }
                        break;
                    case UNAuthorizationStatusDenied:
                    {
                        if (isClickEnable==1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showSettingAlert];
                            });
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [myDelegate unregisterForRemoteNotifications];
                                [self navigateToDashboard];
                            });
                        }
                    }
                        break;
                    case UNAuthorizationStatusNotDetermined:
                        break;
                    default:
                        break;
                }
            }];
        }
        else {
            //Use for iOS 8 device
            if ([[[UIApplication sharedApplication] currentUserNotificationSettings] types]!=UIUserNotificationTypeNone) {
                if (isClickEnable==2) {
                    [self showSettingAlert];
                }
                else {
                    [myDelegate registerForRemoteNotification];
                    [UserDefaultManager setValue:[NSNumber numberWithBool:true] key:@"enableNotification"];
                    [self navigateToDashboard];
                }
            }
            else {
                if (isClickEnable==1) {
                    [self showSettingAlert];
                }
                else {
                    [myDelegate unregisterForRemoteNotifications];
                    [self navigateToDashboard];
                }
            }
        }
    }
}
#pragma mark - end

#pragma mark - Show alert
- (void)showSettingAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedText(@"PushNotificationAlertTitle") message:NSLocalizedText(@"PushNotificationAlertMessage") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *allow = [UIAlertAction actionWithTitle:NSLocalizedText(@"alertSettings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *donotAllow = [UIAlertAction actionWithTitle:NSLocalizedText(@"alertCancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:donotAllow];
    [alertController addAction:allow];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - end

#pragma mark - Navigate to dashboard
- (void)navigateToDashboard {
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
}
#pragma mark - end
@end
