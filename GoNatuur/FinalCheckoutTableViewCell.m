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

- (void)displayCartListData:(CartDataModel *)cartData isSeparatorHide:(BOOL)isSeparatorHide {
    _productNameLabel.text=cartData.itemName;
    if ([cartData.isRedeemProduct boolValue]) {
        _productPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([[cartData itemPrice] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])];
    }
    else {
        _productPriceLabel.text=[NSString stringWithFormat:@"%dip",(int)[[cartData productImpactPoint] floatValue]];
    }
    _productQuantityLabel.text=[NSString stringWithFormat:@"x%@",cartData.itemQty];
    [ImageCaching downloadImages:_productImageView imageUrl:cartData.itemImageUrl placeholderImage:@"product_placeholder" isDashboardCell:false];
    if (isSeparatorHide) {
        _separatorLabel.hidden=false;
    }
    else {
        _separatorLabel.hidden=true;
    }
}

- (void)displayPriceData:(NSString *)titleString priceString:(NSString *)priceString {
    
}
@end
