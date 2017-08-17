//
//  EnableNotificationViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "EnableNotificationViewController.h"

@interface EnableNotificationViewController ()
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

#pragma mark - IBAction
- (IBAction)enableNotificationButtonAction:(id)sender {
    [myDelegate registerForRemoteNotification];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
                                                          //User tapped "Allow"
                                                          [self navigateToDashboard];
                                                      }
                                                      else{
                                                          //User tapped "Don't Allow"
                                                          [self navigateToDashboard];
                                                      }
                                                  }];
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
