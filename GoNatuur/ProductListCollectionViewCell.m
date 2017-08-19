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
    double productCalculatedPrice =[productListData.productPrice doubleValue]*[exchangeRates doubleValue];
    _productPrice.text=[NSString stringWithFormat:@"%@ %.2f",[UserDefaultManager getValue:@"DefaultCurrency"],productCalculatedPrice];
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
////    _productPrice.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrency"],productListData.productPrice];
//    _productDescription.text=productListData.productDescription;
//    [ImageCaching downloadImages:_productImageView imageUrl:productListData.productImageThumbnail placeholderImage:@"product_placeholder" isDashboardCell:true];
//        statusBannerImage.hidden=YES;
//        if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil) {
//            productRating.hidden=YES;
//            ratingStarImage.hidden=YES;
//        }
//        else {
//            productRating.hidden=NO;
//            ratingStarImage.hidden=NO;
//            productRating.text=productListData.productRating;
//        }
}
@end
