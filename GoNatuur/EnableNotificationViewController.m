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
}

- (IBAction)disableNotificationButtonAction:(id)sender {
    [myDelegate unregisterForRemoteNotifications];
}
#pragma mark - end
@end
