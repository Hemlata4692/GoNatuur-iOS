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
- (void)displayCellData:(NSDictionary *)shippingMethodData isSelected:(BOOL)isSelected totalPrice:(float)totalPrice;
@end
