//
//  ImapctPointHistoryTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"

@interface ImapctPointHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *editUserProfileImageButton;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyEarnedHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyEarnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionIdHeading;
@property (weak, nonatomic) IBOutlet UILabel *pointsHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnedHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

- (void)displayData:(CGSize)rectSize;
- (void)displayImpactsPointData:(CGSize)rectSize impactsPointData:(NSMutableDictionary *)impactsPointData;
@end
