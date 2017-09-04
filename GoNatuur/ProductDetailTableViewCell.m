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
    _productShortDescriptionLabel.numberOfLines=0;
    _productShortDescriptionLabel.frame=CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:productDescription font:[UIFont montserratSemiBoldWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:1000]);
    _productShortDescriptionLabel.text=productDescription;
}

- (void)displayRating:(NSString *)productRating {
    _starBackView.starImage = [UIImage imageNamed:@"star-unselected"];
    _starBackView.starHighlightedImage = [UIImage imageNamed:@"star"];
    _starBackView.maxRating = 5.0;
    _starBackView.delegate = self;
    //        _starBackView.horizontalMargin = 10;
    _starBackView.editable=NO;
    _starBackView.displayMode=EDStarRatingDisplayHalf;
    if ([productRating isEqualToString:@""] || productRating==nil || [productRating isEqualToString:@"0"]) {
        _starBackView.rating= 0.0;;
    }
    else {
        float rating = (([productRating integerValue])*5.0)/100.0;
        _starBackView.rating=rating;
    }
}

- (void)displayProductMediaImage:(NSDictionary *)productImageDict qrCode:(UIImage *)qrCodeImage {
    _transparentView.hidden=true;
    _productImageView.translatesAutoresizingMaskIntoConstraints=true;
    if ([[productImageDict objectForKey:@"media_type"] isEqualToString:@"QRCode"]) {
        float width;
        if (([[UIScreen mainScreen] bounds].size.width-80)>240) {
            width=240;
        }
        else {
            width=([[UIScreen mainScreen] bounds].size.width-80);
        }
        _productImageView.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-(width/2), (290/2)-(width/2), width, width);
        _productImageView.image=qrCodeImage;
        DLog(@"%f,%f",qrCodeImage.size.width,qrCodeImage.size.height);
        _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        _productImageView.frame=CGRectMake(40, 20, [[UIScreen mainScreen] bounds].size.width-80, 250);
        if([[productImageDict objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
            _transparentView.hidden=false;
            _videoIcon.hidden=false;
            _video360Icon.hidden=true;
        }
        
        //Code is commented for 360 video media type
         else if([[productImageDict objectForKey:@"media_type"] isEqualToString:@"video_360"]) {
         _transparentView.hidden=false;
         _videoIcon.hidden=true;
         _video360Icon.hidden=false;
         }
        
        [ImageCaching downloadImages:_productImageView imageUrl:[NSString stringWithFormat:@"%@%@%@",BaseUrl,productDetailImageBaseUrl,[productImageDict objectForKey:@"file"]] placeholderImage:@"product_placeholder" isDashboardCell:false];
    }
}

- (void)displayProductPrice:(ProductDataModel *)productData currentQuantity:(int)currentQuantity {
    
    double productCalculatedPrice;
    if (nil!=productData.specialPrice&&![productData.specialPrice isEqualToString:@""]) {
        productCalculatedPrice =[productData.specialPrice doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
    }
    else {
        productCalculatedPrice =[productData.productPrice doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
    }
    NSString *str=[NSString stringWithFormat:@"%@%@",[UserDefaultManager getValue:@"DefaultCurrency"],[ConstantCode decimalFormatter:productCalculatedPrice]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange currenyTextRange = [str rangeOfString:[UserDefaultManager getValue:@"DefaultCurrency"]];
    NSRange decimalTextRange = [str rangeOfString:[[str componentsSeparatedByString:@"."] objectAtIndex:1]];
    [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:18]} range:currenyTextRange];
    [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:18]} range:decimalTextRange];
    _productPriceLabel.attributedText=string;
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
