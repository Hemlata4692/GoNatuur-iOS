//
//  SearchCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell
@synthesize productCellMainView;
@synthesize statusBannerImage;
@synthesize productName;
@synthesize productDescription;
@synthesize productPrice;
@synthesize productRating;
@synthesize ratingStarImage;
@synthesize productImageView;
@synthesize borderView;

//Search cell
- (void)displayProductListData :(SearchDataModel *)productListData exchangeRates:(NSString *)exchangeRates {
    [borderView setBorder:borderView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
    [borderView setCornerRadius:5.0];
    [productCellMainView addShadow:productCellMainView color:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    productName.text=productListData.productName;
    double productCalculatedPrice =[productListData.productPrice doubleValue]*[exchangeRates doubleValue];
    productPrice.text=[NSString stringWithFormat:@"%@ %.2f",[UserDefaultManager getValue:@"DefaultCurrency"],productCalculatedPrice];
    if ((nil==productListData.productDescription)||[productListData.productDescription isEqualToString:@""]) {
        productDescription.text=NSLocalizedText(@"dataNotAdded");
    }
    else {
        productDescription.text=productListData.productDescription;
    }
    [ImageCaching downloadImages:productImageView imageUrl:productListData.productImageThumbnail placeholderImage:@"product_placeholder" isDashboardCell:true];
    statusBannerImage.hidden=YES;
    if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil || [productListData.productRating isEqualToString:@"0"]) {
        productRating.hidden=YES;
        ratingStarImage.hidden=YES;
    }
    else {
        productRating.hidden=NO;
        ratingStarImage.hidden=NO;
        float rating = (([productListData.productRating integerValue])*5.0)/100.0;
        productRating.text=[NSString stringWithFormat:@"%.1f",rating];
    }
}
//end
@end
