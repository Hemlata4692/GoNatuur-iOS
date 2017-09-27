//
//  FinalCheckoutTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDataModel.h"

@interface FinalCheckoutTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productQuantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *guestInformationLabel;
@property (strong, nonatomic) IBOutlet UIButton *applyCouponButton;
@property (strong, nonatomic) IBOutlet UILabel *separatorLabel;
- (void)displayCartListData:(CartDataModel *)cartData isSeparatorHide:(BOOL)isSeparatorHide;
- (void)displayPriceCellData:(NSMutableDictionary *)priceDetail priceTitleArray:(NSString *)priceTitle islastIndex:(BOOL)islastIndex isApplyCoupon:(BOOL)isApplyCoupon;
@end
