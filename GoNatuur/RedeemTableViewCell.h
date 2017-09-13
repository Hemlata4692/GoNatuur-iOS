//
//  RedeemTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 13/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *productListCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsHeading;
@property (weak, nonatomic) IBOutlet UILabel *totalPoints;
@property (weak, nonatomic) IBOutlet UILabel *redeemPointsHeading;
@property (weak, nonatomic) IBOutlet UILabel *redeemPoints;
@property (weak, nonatomic) IBOutlet UIButton *impactPointsOverview;
- (void)displayData:(CGSize)rectSize;
@end
