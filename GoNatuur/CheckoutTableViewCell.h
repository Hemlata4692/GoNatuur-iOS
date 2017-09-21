//
//  CheckoutTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *radioLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingMethodLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingMethodPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceTitle;
- (void)displayCellData:(NSDictionary *)shippingMethodData isSelected:(BOOL)isSelected totalPrice:(float)totalPrice;
- (void)displayPriceCellData:(NSMutableDictionary *)priceDetail priceTitleArray:(NSString *)priceTitle islastIndex:(BOOL)islastIndex;
@end
