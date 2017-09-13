//
//  FinalCheckoutTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FinalCheckoutTableViewCell.h"

@implementation FinalCheckoutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayCartListData:(CartDataModel *)cartData {
    _productNameLabel.text=cartData.itemName;
    _productPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([[cartData itemPrice] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])];
    _productQuantityLabel.text=[NSString stringWithFormat:@"x%@",cartData.itemQty];
    [ImageCaching downloadImages:_productImageView imageUrl:cartData.itemImageUrl placeholderImage:@"product_placeholder" isDashboardCell:false];
}
@end
