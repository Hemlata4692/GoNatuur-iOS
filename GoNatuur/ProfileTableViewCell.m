//
//  ProfileTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 29/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import "ProfileModel.h"
#import "DynamicHeightWidth.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayData:(CGSize)rectSize {
    [_redeemPointButton setCornerRadius:17.0];
    [_redeemPointButton addShadow:_redeemPointButton color:[UIColor blackColor]];
    [_userProfileImage setBorder:_userProfileImage color:[UIColor colorWithRed:138.0/255.0 green:28.0/255.0 blue:53.0/255.0 alpha:1.0] borderWidth:3.0];
    [_userProfileImage setCornerRadius:60.0];
    _totalTitle.text=NSLocalizedText(@"totalPoints");
    _recentTitle.text=NSLocalizedText(@"recentEarned");
    _personalDetailLabel.text=NSLocalizedText(@"personalDetails");
    _changePasswordLabel.text=NSLocalizedText(@"changePasswordProfile");
    _notificationLabel.text=NSLocalizedText(@"Notifications");
    _customerSupportLabel.text=NSLocalizedText(@"customerSupport");
    [_redeemPointButton setTitle:NSLocalizedText(@"sideBarRedeemPoints") forState:UIControlStateNormal];
    _notificationSwitch.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [_notificationSwitch setCornerRadius:16.0];
    if ( [myDelegate. notificationStatus isEqualToString:@"1"]) {
        [_notificationSwitch setOn:true animated:true];
    }
    else {
        [_notificationSwitch setOn:false animated:true];
    }
   _totalPointsLabel.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"TotalPoints"]]];
    _recentlyEarnedLabel.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"RecentEarned"]]];
    
    [ImageCaching downloadImages:_userProfileImage imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
    
    _userEmailLabel.text=[UserDefaultManager getValue:@"emailId"];
    _userEmailLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _userEmailLabel.numberOfLines=2;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userEmailLabel.text font:[UIFont montserratSemiBoldWithSize:15] widthValue:rectSize.width-50 heightValue:60];
    _userEmailLabel.frame=CGRectMake(25, _userEmailLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-50, newHeight);
 }

//set attributed string
- (NSAttributedString *)setAttributesText:(NSString *)labelText {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:labelText];
    NSRange registerTextRange = [labelText rangeOfString:@"ip"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont montserratRegularWithSize:14]} range:registerTextRange];
    return string;
}
@end
