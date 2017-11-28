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

@property (weak, nonatomic) IBOutlet UILabel *cartSubtotalHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *cartSubtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditPointsHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsSubtotalHeadinglabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsSubtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionDiscountHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *rewardInfoLabel;

- (void)displayData:(CGSize)rectSize orderId:(NSString *)orderId;
- (void)displayPurchaseData:(CGSize)rectSize ;
- (void)displayOrderTotalData:(CGSize)rectSize finalCheckoutPriceDict:(NSDictionary *)finalCheckoutPriceDict;
- (void)displayCartListData:(CartDataModel *)cartData rectSize:(CGSize)rectSize;

@end
