//
//  ProductListCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductListCollectionViewCell.h"

@implementation ProductListCollectionViewCell

- (void)displayProductListData :(DashboardDataModel *)productListData exchangeRates:(NSString *)exchangeRates  {
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
    _statusBannerImage.hidden=YES;
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
    if (nil!=productListData.specialPrice&&![productListData.specialPrice isEqualToString:@""]) {
        _statusBannerImage.hidden=false;
        _statusBannerImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",@"clear_",[UserDefaultManager getValue:@"Language"]]];
        productCalculatedPrice =[productListData.specialPrice doubleValue]*[exchangeRates doubleValue];
    }
    else {
        if ((!myDelegate.isProductList || [productListData.productType isEqualToString:eventIdentifier])&&(nil==productListData.productQty||NULL==productListData.productQty||[productListData.productQty intValue]<1)) {
             _statusBannerImage.hidden=false;
             _statusBannerImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",@"sold_",[UserDefaultManager getValue:@"Language"]]];
            }
        productCalculatedPrice =[productListData.productPrice doubleValue]*[exchangeRates doubleValue];
    }
    _productPrice.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:productCalculatedPrice]];
    [self customizedCellObject:productListData];
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
