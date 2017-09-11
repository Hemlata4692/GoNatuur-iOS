//
//  OrderListingCell.h
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyEarnedHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyEarnedLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackShippingButton;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingAddressHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)displayData:(CGSize)rectSize;
- (void)displayOrderData:(CGSize)rectSize orderData:(OrderModel *)orderData;

@end
