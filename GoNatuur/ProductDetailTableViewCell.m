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
#import "UITextField+Padding.h"


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

- (void)displayProductMediaImage:(NSDictionary *)productImageDict defaultVideoThumbnail:(NSString *)defaultVideoThumbnail {
    _transparentView.hidden=true;
    _productImageView.translatesAutoresizingMaskIntoConstraints=true;
    _productImageView.frame=CGRectMake(40, 20, [[UIScreen mainScreen] bounds].size.width-80, 250);
    if([[productImageDict objectForKey:@"media_type"] isEqualToString:@"default-video"]) {
        _transparentView.hidden=false;
        _videoIcon.hidden=false;
        _video360Icon.hidden=true;
        [ImageCaching downloadImages:_productImageView imageUrl:[NSString stringWithFormat:@"%@%@%@",BaseUrl,productDetailImageBaseUrl,defaultVideoThumbnail] placeholderImage:@"product_placeholder" isDashboardCell:false];
    }
    else {
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

- (void)displayProductPrice:(ProductDataModel *)productData currentQuantity:(int)currentQuantity isRedeemPoints:(BOOL)isRedeemPoints {
    double productCalculatedPrice;
    
    if (nil!=productData.tierPricesArray || productData.tierPricesArray.count!=0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customer_group_id == %@", [UserDefaultManager getValue:@"GroupId"]];
        NSArray *filteredArray = [productData.tierPricesArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count!=0) {
            NSDictionary *tempDict=[[filteredArray objectAtIndex:0] mutableCopy];
            productCalculatedPrice=[[tempDict objectForKey:@"value"] doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
        }
        else {
            if (nil!=productData.specialPrice&&![productData.specialPrice isEqualToString:@""]) {
                productCalculatedPrice =[productData.specialPrice doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
            }
            else {
                productCalculatedPrice =[productData.productPrice doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
            }
        }
    }
    else {
        if (nil!=productData.specialPrice&&![productData.specialPrice isEqualToString:@""]) {
            productCalculatedPrice =[productData.specialPrice doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
        }
        else {
            productCalculatedPrice =[productData.productPrice doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
        }
    }
    NSMutableAttributedString *string;
    if (isRedeemPoints) {
        NSString *ipString=@"ip";
        NSString *str=[NSString stringWithFormat:@"%.0f%@",[productData.redeemPointsRequired floatValue],ipString];
         string = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange decimalTextRange = [str rangeOfString:ipString];
        [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:18]} range:decimalTextRange];
    }
    else {
        NSString *str=[NSString stringWithFormat:@"%@%@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:productCalculatedPrice]];
         string = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange currenyTextRange = [str rangeOfString:[UserDefaultManager getValue:@"DefaultCurrencySymbol"]];
        NSRange decimalTextRange = [str rangeOfString:[[str componentsSeparatedByString:@"."] objectAtIndex:1]];
        [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:18]} range:currenyTextRange];
        [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:18]} range:decimalTextRange];
    }
    _productPriceLabel.attributedText=string;
    _addCartView.layer.borderColor=[UIColor blackColor].CGColor;
    _addCartView.layer.borderWidth=1.0;
    _cartNumberItemLabel.text=[NSString stringWithFormat:@"%d",currentQuantity];
 
    //impact point rule
    double convertedBasePointRulePice=[[[UserDefaultManager getValue:@"impactPointRules"] objectForKey:@"rulePrice"] doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
    double earnedPoints=([[[UserDefaultManager getValue:@"impactPointRules"] objectForKey:@"earnedPoints"] doubleValue]/convertedBasePointRulePice)*productCalculatedPrice;
    
    NSString *ipString=@"ip";
    NSString *str=[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@ %.0f",NSLocalizedText(@"Points Earn"),earnedPoints],ipString];
    string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange decimalTextRange = [str rangeOfString:ipString];
    [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:17]} range:decimalTextRange];
    _productPointsEarnLabel.attributedText=string;
}

- (void)displayProductInfo:(NSString *)shippingTextData {
    _shippingFreeLabel.translatesAutoresizingMaskIntoConstraints=true;
    _shippingFreeLabel.frame=CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-80, [DynamicHeightWidth getDynamicLabelHeight:shippingTextData font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80]);
    _shippingFreeLabel.text=shippingTextData;
}

- (void)displayAddToCartButton:(NSString *)screenType {
    if ([screenType isEqualToString:@"EventDetail"]) {
      [_addToCartButton setTitle:NSLocalizedText(@"getTickets") forState:UIControlStateNormal];//Get tickets
    }
    else {
        [_addToCartButton setTitle:NSLocalizedText(@"addCart") forState:UIControlStateNormal];
    }
    [_addToCartButton setCornerRadius:20.0];
    [_addToCartButton addShadow:_addToCartButton color:[UIColor blackColor]];
}

- (void)displayTicketingData:(NSString *)ticket {
    _ticketSelectionTypeField.placeholder=NSLocalizedText(@"ticketType");
    [_ticketSelectionTypeField addTextFieldPaddingWithoutImages:_ticketSelectionTypeField];
    [_ticketSelectionTypeField setBorder:_ticketSelectionTypeField color:[UIColor blackColor] borderWidth:1.0];
}
@end
