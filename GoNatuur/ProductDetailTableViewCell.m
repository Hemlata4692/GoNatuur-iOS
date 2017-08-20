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
    _productNameLabel.frame=CGRectMake(40, 24, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:productName font:[UIFont montserratMediumWithSize:20] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:52]);
    _productNameLabel.text=productName;
//    _productNameLabel.backgroundColor=[UIColor grayColor];
}

- (void)displayProductDescription:(NSString *)productDescription {
    _productShortDescriptionLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productShortDescriptionLabel.frame=CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:productDescription font:[UIFont montserratMediumWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:30]);
    _productShortDescriptionLabel.text=productDescription;
//    _productShortDescriptionLabel.backgroundColor=[UIColor greenColor];
}

- (void)displayRating:(NSString *)productRating {
    if ([productRating isEqualToString:@""] || productRating==nil || [productRating isEqualToString:@"0"]) {
        //Show all blank star
    }
    else {
        float rating = (([productRating integerValue])*5.0)/100.0;
        //Show star according to rating
    }
}

- (void)displayProductMediaImage:(NSDictionary *)productImageDict qrCode:(UIImage *)qrCodeImage {
    _transparentView.hidden=true;
    if ([[productImageDict objectForKey:@"media_type"] isEqualToString:@"QRCode"]) {
        _productImageView.image=qrCodeImage;
    }
    else {
        if([[productImageDict objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
            _transparentView.hidden=false;
            _videoIcon.hidden=false;
            _video360Icon.hidden=true;
        }
        
        /*Code is commented for 360 video media type
         else if([[productImageDict objectForKey:@"media_type"] isEqualToString:@"image"]) {
         _transparentView.hidden=false;
         _videoIcon.hidden=true;
         _video360Icon.hidden=false;
         }*/
        [ImageCaching downloadImages:_productImageView imageUrl:[productImageDict objectForKey:@"path"] placeholderImage:@"product_placeholder" isDashboardCell:true];
    }
}

- (void)displayProductPrice:(ProductDataModel *)productData currentQuantity:(int)currentQuantity {
    NSString *str=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrency"],[productData.productPrice floatValue]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange currenyTextRange = [str rangeOfString:[UserDefaultManager getValue:@"DefaultCurrency"]];
    NSRange decimalTextRange = [str rangeOfString:[[str componentsSeparatedByString:@"."] objectAtIndex:1]];
    [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:18]} range:currenyTextRange];
    [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:18]} range:decimalTextRange];
    _productPriceLabel.attributedText=string;
    _productPointsEarnLabel.text=[NSString stringWithFormat:@"Points Earn: %@ip",(nil==productData.productPointsEarn?@"0":productData.productPointsEarn)];
    _addCartView.layer.borderColor=[UIColor blackColor].CGColor;
    _addCartView.layer.borderWidth=1.0;
    _cartNumberItemLabel.text=[NSString stringWithFormat:@"%d",currentQuantity];
}

- (void)displayProductInfo {
    _shippingFreeLabel.translatesAutoresizingMaskIntoConstraints=true;
    _shippingFreeLabel.frame=CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"Shipping is free if the total purchase is above USD$100.") font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80]);
    _productReturnLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productReturnLabel.frame=CGRectMake(40, _shippingFreeLabel.frame.origin.y+_shippingFreeLabel.frame.size.height, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"Products can be returned within 30 days of purchase, subject to the following conditions.") font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80]);
}

- (void)displayAddToCartButton {
    _addToCartButton.layer.cornerRadius=17.5;
    _addToCartButton.layer.masksToBounds=true;
}
@end
