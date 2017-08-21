//
//  EnableNotificationViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "EnableNotificationViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface EnableNotificationViewController () {
    @private
    BOOL isNotificationAllowed;
    int isClickEnable;
}
@property (weak, nonatomic) IBOutlet UIImageView *notificationBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@end

@implementation EnableNotificationViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeInActiveState) name:UIApplicationWillEnterForegroundNotification object:nil];
    isClickEnable=0;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)didBecomeInActiveState {
    [self checkNotificationSetting];
}

- (void)checkNotificationSetting {
    if (isClickEnable!=0) {
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
}

- (void)showSettingAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\"GoNatuur\" Would Like to Send You Notifications" message:@"Notifications may include alerts, sounds, and icon badges. These can be configured in Settings." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *allow = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *donotAllow = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:donotAllow];
    [alertController addAction:allow];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)navigateToDashboard {
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
}
@end
