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
    if (![cartData.isRedeemProduct boolValue]) {
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

- (void)displayPriceCellData:(NSMutableDictionary *)priceDetail priceTitleArray:(NSString *)priceTitle islastIndex:(BOOL)islastIndex isApplyCoupon:(int)isApplyCoupon  {
    if (isApplyCoupon==0) {
        _priceTitleLabel.text=priceTitle;
    }
    else {
        _applyCouponButton.translatesAutoresizingMaskIntoConstraints=true;
        [_applyCouponButton setTitle:(isApplyCoupon==1?@"Apply coupon code":@"Remove coupon code") forState:UIControlStateNormal];
        [_applyCouponButton setTitleColor:[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_applyCouponButton sizeToFit];
        _applyCouponButton.frame=CGRectMake(10, 7, _applyCouponButton.frame.size.width, 20);
        DLog(@"%f",_applyCouponButton.frame.size.width);
        [_applyCouponButton setBottomBorder:_applyCouponButton color:[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0]];
    }
    _priceLabel.text=[priceDetail objectForKey:priceTitle];
    if (islastIndex) {
        _priceTitleLabel.font=[UIFont montserratRegularWithSize:15];
        _priceLabel.font=[UIFont montserratRegularWithSize:15];
    }
    else {
        _priceTitleLabel.font=[UIFont montserratRegularWithSize:13];
        _priceLabel.font=[UIFont montserratRegularWithSize:13];
    }
}
@end
