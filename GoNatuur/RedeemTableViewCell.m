//
//  RedeemTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 13/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "RedeemTableViewCell.h"
#import "DynamicHeightWidth.h"

@implementation RedeemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayData:(CGSize)rectSize {
    [_impactPointsOverview setCornerRadius:20.0];
    [_impactPointsOverview addShadow:_impactPointsOverview color:[UIColor blackColor]];
    [_userImageView setBorder:_userImageView color:[UIColor colorWithRed:138.0/255.0 green:28.0/255.0 blue:53.0/255.0 alpha:1.0] borderWidth:3.0];
    [_userImageView setCornerRadius:60.0];
     [ImageCaching downloadImages:_userImageView imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
    _totalPointsHeading.text=NSLocalizedText(@"totalPoints");
    _redeemPointsHeading.text=NSLocalizedText(@"recentEarned");
    [_impactPointsOverview setTitle:NSLocalizedText(@"impactPointsOverview") forState:UIControlStateNormal];
    _totalPoints.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"TotalPoints"]]];
    _redeemPoints.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"RecentEarned"]]];
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
