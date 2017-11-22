//
//  ProfileTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 29/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileModel;

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyEarnedLabel;
@property (weak, nonatomic) IBOutlet UIButton *redeemPointButton;
@property (weak, nonatomic) IBOutlet UILabel *recentTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalTitle;
@property (weak, nonatomic) IBOutlet UILabel *personalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerSupportLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *recentViewLabel;

- (void)displayData:(CGSize)rectSize ;
@end
