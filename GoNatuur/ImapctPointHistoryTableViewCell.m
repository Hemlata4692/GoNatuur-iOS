//
//  ImapctPointHistoryTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ImapctPointHistoryTableViewCell.h"
#import "DynamicHeightWidth.h"


@implementation ImapctPointHistoryTableViewCell

#pragma mark - Cell life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)displayData:(CGSize)rectSize {
    [_userProfileImage setBorder:_userProfileImage color:[UIColor colorWithRed:138.0/255.0 green:28.0/255.0 blue:53.0/255.0 alpha:1.0] borderWidth:3.0];
    _totalPointsHeadingLabel.text=NSLocalizedText(@"totalPoints");
    _recentlyEarnedHeadingLabel.text=NSLocalizedText(@"recentEarned");
    _totalPointsLabel.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"TotalPoints"]]];
    _recentlyEarnedLabel.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"RecentEarned"]]];
    [_userProfileImage setCornerRadius:60.0];
    [ImageCaching downloadImages:_userProfileImage imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
    _userEmail.text=[UserDefaultManager getValue:@"emailId"];
    _userEmail.translatesAutoresizingMaskIntoConstraints=YES;
    _userEmail.numberOfLines=2;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userEmail.text font:[UIFont montserratSemiBoldWithSize:15] widthValue:rectSize.width-24 heightValue:60];
    _userEmail.frame=CGRectMake(0, _userEmail.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-24, newHeight);
}

- (void)displayImpactsPointData:(CGSize)rectSize impactsPointData:(NSMutableDictionary *)impactsPointData {
    _transactionIdHeading.text=NSLocalizedText(@"transactionId");
    _pointsHeadingLabel.text=NSLocalizedText(@"pointsLabel");
    _earnedHeadingLabel.text=NSLocalizedText(@"earnedDate");
    _expiryDateHeadingLabel.text=NSLocalizedText(@"expiryDate");
    _transactionIdLabel.text=[impactsPointData objectForKey:@"id"];
    _earnedDateLabel.text=[impactsPointData objectForKey:@"created_at"];
    _expiryDateLabel.text=[impactsPointData objectForKey:@"expired_at"];
    
    if ([[impactsPointData objectForKey:@"amount"] containsString:@"-"]) {
        _pointsLabel.textColor=[UIColor redColor];
        _pointsLabel.text=[impactsPointData objectForKey:@"amount"];
    }
    else {
        _pointsLabel.textColor=[UIColor colorWithRed:0.0/255.0 green:153/255.0 blue:51/255.0 alpha:1.0];
        _pointsLabel.text=[NSString stringWithFormat:@"+%@",[impactsPointData objectForKey:@"amount"]];
    }
    
    _commentsLabel.text=[impactsPointData objectForKey:@"comments"];
    _commentsLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _commentsLabel.numberOfLines=0;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_commentsLabel.text font:[UIFont montserratLightWithSize:14] widthValue:rectSize.width-20 heightValue:200];
    _commentsLabel.frame=CGRectMake(10, _commentsLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-20, newHeight);
}

//set attributed string
- (NSAttributedString *)setAttributesText:(NSString *)labelText {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:labelText];
    NSRange registerTextRange = [labelText rangeOfString:@"ip"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont montserratRegularWithSize:14]} range:registerTextRange];
    return string;
}
@end
