//
//  ProductListCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductListCollectionViewCell.h"

@implementation ProductListCollectionViewCell

- (void)displayProductListData :(DashboardDataModel *)productListData exchangeRates:(NSString *)exchangeRates isRedeemPoints:(BOOL)isRedeemPoints {
    [_borderView setBorder:_borderView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
    [_borderView setCornerRadius:5.0];
    _productName.text=productListData.productName;
    if ((nil==productListData.productDescription)||[productListData.productDescription isEqualToString:@""]) {
        _productDescription.text=NSLocalizedText(@"dataNotAdded");
    }
    else {
        _productDescription.text=productListData.productDescription;
    }
    [ImageCaching downloadImages:_productImageView imageUrl:productListData.productImageThumbnail placeholderImage:@"product_placeholder" isDashboardCell:true];
    if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil || [productListData.productRating isEqualToString:@"0"]) {
        _productRating.hidden=YES;
        _ratingStarImage.hidden=YES;
    }
    else {
        _productRating.hidden=NO;
        _ratingStarImage.hidden=NO;
        float rating = (([productListData.productRating integerValue])*5.0)/100.0;
        _productRating.text=[NSString stringWithFormat:@"(%.1f)",rating];
    }
    double productCalculatedPrice;
    
    if (nil!=productListData.tierPriceArray || productListData.tierPriceArray.count!=0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customer_group_id == %@", [UserDefaultManager getValue:@"GroupId"]];
        NSArray *filteredArray = [productListData.tierPriceArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count!=0) {
            NSDictionary *tempDict=[[filteredArray objectAtIndex:0] mutableCopy];
            productCalculatedPrice=[[tempDict objectForKey:@"value"] doubleValue]*[exchangeRates doubleValue];
        }
        else {
            productCalculatedPrice=[self calculatePrice:productListData exchangeRates:[exchangeRates doubleValue]];
        }
    }
    else {
        productCalculatedPrice=[self calculatePrice:productListData exchangeRates:[exchangeRates doubleValue]];
    }
    
    if (isRedeemPoints) {
        NSString *ipString=@"ip";
        NSString *str=[NSString stringWithFormat:@"%.0f%@",[productListData.redeemPointsRequired floatValue],ipString];
       NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange decimalTextRange = [str rangeOfString:ipString];
        [string setAttributes:@{NSFontAttributeName: [UIFont montserratLightWithSize:14]} range:decimalTextRange];
        _productPrice.attributedText=string;
    }
    else {
    _productPrice.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:productCalculatedPrice]];
    }
    _statusBannerImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",productListData.ribbons,[UserDefaultManager getValue:@"Language"]]];
    [self customizedCellObject:productListData];
}

- (double)calculatePrice:(DashboardDataModel *)productListData exchangeRates:(double)exchangeRates {
    double price;
    if (nil!=productListData.specialPrice&&![productListData.specialPrice isEqualToString:@""]) {
        price =[productListData.specialPrice doubleValue]*exchangeRates;
    }
    else {
        price =[productListData.productPrice doubleValue]*exchangeRates;
    }
    return price;
}

- (void)customizedCellObject:(DashboardDataModel *)productListData {
    float picDimension = ([[UIScreen mainScreen] bounds].size.width-20) / 2.0;
    if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil || [productListData.productRating isEqualToString:@"0"]) {
        _productRating.hidden=YES;
        _ratingStarImage.hidden=YES;
        _productPrice.translatesAutoresizingMaskIntoConstraints=true;
        _productPrice.frame=CGRectMake(12, ((picDimension+105)-8)-26, ((picDimension-5)-8)-24, 20);//width:((picDimension-5)-8(upperMainViewSpace 7-bottommainViewSpace 1))-24(leading and trailing)
    }
    else {
        _productRating.hidden=NO;
        _ratingStarImage.hidden=NO;
        _productPrice.translatesAutoresizingMaskIntoConstraints=true;
        _productPrice.frame=CGRectMake(12, ((picDimension+105)-8)-26, ((picDimension-5)-8)-12-74, 20);;//width:((picDimension-5)-8(upperMainViewSpace 7-bottommainViewSpace 1))-12(leading)-74(70+4)
    }
}
@end
