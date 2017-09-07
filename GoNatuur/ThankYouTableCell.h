//
//  ThankYouTableCell.h
//  GoNatuur
//
//  Created by Monika on 9/5/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDataModel.h"

@interface ThankYouTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *thankYouDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rewardInfoLabel;

- (void)displayData:(CGSize)rectSize ;
- (void)displayPurchaseData:(CGSize)rectSize ;
- (void)displayOrderTotalData:(CGSize)rectSize;
- (void)displayCartListData:(CartDataModel *)cartData rectSize:(CGSize)rectSize;

@end
