//
//  CartListTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 04/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDataModel.h"

@interface CartListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *productQuantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPriceLabel;
- (void)displayCartListData:(CartDataModel *)cartData;
@end
