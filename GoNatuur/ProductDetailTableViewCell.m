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
    _productNameLabel.frame=CGRectMake(40, 24, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:productName font:[UIFont montserratSemiBoldWithSize:20] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:52]);
    _productNameLabel.text=productName;
}

- (void)displayProductDescription:(NSString *)productDescription {
    _productShortDescriptionLabel.translatesAutoresizingMaskIntoConstraints=true;
    _productShortDescriptionLabel.frame=CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:productDescription font:[UIFont montserratSemiBoldWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:30]);
    _productShortDescriptionLabel.text=productDescription;
}

- (void)displayRating:(NSString *)productRating {
    
    _starBackView.starImage = [UIImage imageNamed:@"star-unselected"];
    _starBackView.starHighlightedImage = [UIImage imageNamed:@"star"];
    _starBackView.maxRating = 5.0;
    _starBackView.delegate = self;
    //        _starBackView.horizontalMargin = 10;
    _starBackView.editable=NO;
    _starBackView.rating= 4.5;
    _starBackView.displayMode=EDStarRatingDisplayHalf;
}

- (void)displayProductMediaImage:(NSDictionary *)productImageDict qrCode:(UIImage *)qrCodeImage {
    _transparentView.hidden=true;
    if ([[productImageDict objectForKey:@"media_type"] isEqualToString:@"QRCode"]) {
        _productImageView.image=qrCodeImage;
        _productImageView.contentMode = UIViewContentModeScaleAspectFit;
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
    _productPointsEarnLabel.text=[NSString stringWithFormat:@"%@: %@ip",NSLocalizedText(@"Points Earn"),(nil==productData.productPointsEarn?@"0":productData.productPointsEarn)];
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
    [_addToCartButton setCornerRadius:17.0];
    [_addToCartButton addShadow:_addToCartButton color:[UIColor blackColor]];
}
@end
