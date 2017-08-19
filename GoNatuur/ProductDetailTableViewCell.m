//
//  ProductDetailTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductDetailTableViewCell.h"
#import "DynamicHeightWidth.h"
#import "ProductDataModel.h"

@implementation ProductDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayProductName:(NSString *)productName {

    _productNameLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productNameLabel.frame=CGRectMake(40, 24, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:productName font:[UIFont montserratMediumWithSize:20] widthValue:[[UIScreen mainScreen] bounds].size.width-80]);
    _productNameLabel.text=productName;
}

- (void)displayProductDescription:(NSString *)productDescription {
    
    _productShortDescriptionLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productShortDescriptionLabel.frame=CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:productDescription font:[UIFont montserratMediumWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-80]);
    _productShortDescriptionLabel.text=productDescription;
}

- (void)displayRating:(NSNumber *)productRating {
    
    
}

- (void)displayProductImage:(NSString *)productImageUrl {
    
    
}

- (void)displayProductPrice:(ProductDataModel *)productData {
    
    
}

- (void)displayProductInfo {
    
    _shippingFreeLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productReturnLabel.translatesAutoresizingMaskIntoConstraints=true;
    _shippingFreeLabel.frame=CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:@"Shipping is free if the total purchase is above USD$100." font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80]);
    _productReturnLabel.frame=CGRectMake(40, _shippingFreeLabel.frame.origin.y+_shippingFreeLabel.frame.size.height, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:@"Products can be returned within 30 days of purchase, subject to the following conditions." font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80]);
}
@end
