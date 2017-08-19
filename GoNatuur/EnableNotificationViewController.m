//
//  EnableNotificationViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "EnableNotificationViewController.h"

@interface EnableNotificationViewController () {
    @private
    BOOL isNotificationAllowed;
}
@property (weak, nonatomic) IBOutlet UIImageView *notificationBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@end

@implementation EnableNotificationViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
//UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Services to allow DigiBi to determine your location." message:@"" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
//
////                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"DigiBi\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
//alert.tag = 3;

#pragma mark - IBAction
- (IBAction)enableNotificationButtonAction:(id)sender {
    if ([[UserDefaultManager getValue:@"allowNotification"] isEqual:@1]) {
        [myDelegate registerForRemoteNotification];
        [self navigateToDashboard];
    }
    else {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
                                                          //User tapped "Allow"
                                                          [UserDefaultManager setValue:@1 key:@"allowNotification"];
                                                          [self navigateToDashboard];
                                                      }
                                                      else{
                                                          //User tapped "Don't Allow"
                                                          [self navigateToDashboard];
                                                      }
                                                  }];
    }
}

- (IBAction)disableNotificationButtonAction:(id)sender {
    [myDelegate unregisterForRemoteNotifications];
    [self navigateToDashboard];
}
#pragma mark - end

- (void)navigateToDashboard {
    [UserDefaultManager setValue:[NSNumber numberWithBool:true] key:@"enableNotification"];
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
}
@end
