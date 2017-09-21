//
//  CartListTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 04/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CartListTableViewCell.h"
#import "DynamicHeightWidth.h"

@implementation CartListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayCartListData:(CartDataModel *)cartData {
    [self changeObjectFraming:cartData];
}

- (void)changeObjectFraming:(CartDataModel *)cartData {
    [self removeAutolayout];
    //Reframe product name label
    float height=[DynamicHeightWidth getDynamicLabelHeight:cartData.itemName font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
    _productNameLabel.frame=CGRectMake(88, 10, [[UIScreen mainScreen] bounds].size.width-228, height);
    _productNameLabel.text=cartData.itemName;
    //Reframe product description label
    height=[DynamicHeightWidth getDynamicLabelHeight:cartData.itemDescription font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
    _productDescriptionLabel.frame=CGRectMake(88,_productNameLabel.frame.origin.y+_productNameLabel.frame.size.height+15, [[UIScreen mainScreen] bounds].size.width-228, height);
    _productDescriptionLabel.text=cartData.itemDescription;
    //Reframe product price label
    
    if ([cartData.isRedeemProduct boolValue]) {
        height=[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%dip",(int)([[cartData productImpactPoint] floatValue]*[cartData.itemQty floatValue])] font:[UIFont montserratRegularWithSize:11] widthValue:54];
        _productPriceLabel.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width-62, 10, 54, height);
        _productPriceLabel.text=[NSString stringWithFormat:@"%dip",(int)([[cartData productImpactPoint] floatValue]*[cartData.itemQty floatValue])];
    }
    else {
        height=[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([[cartData itemPrice] floatValue]*[cartData.itemQty floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] font:[UIFont montserratRegularWithSize:11] widthValue:54];
        _productPriceLabel.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width-62, 10, 54, height);
        _productPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([[cartData itemPrice] floatValue]*[cartData.itemQty floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])];
    }
    
    //Reframe product quantity label
    height=[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@",cartData.itemQty] font:[UIFont montserratRegularWithSize:11] widthValue:64];
    _productQuantityLabel.frame=CGRectMake(_productPriceLabel.frame.origin.x-71, 10, 64, height);
    _productQuantityLabel.text=[NSString stringWithFormat:@"%@",cartData.itemQty];
     [ImageCaching downloadImages:_productImageView imageUrl:cartData.itemImageUrl placeholderImage:@"product_placeholder" isDashboardCell:false];
    [_removeItem setBottomBorder:_removeItem color:[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]];
}

- (void)removeAutolayout {
    _productNameLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productDescriptionLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productQuantityLabel.translatesAutoresizingMaskIntoConstraints=true;
   _productPriceLabel.translatesAutoresizingMaskIntoConstraints=true;
}
@end
