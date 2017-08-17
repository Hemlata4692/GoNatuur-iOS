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

//- (void)displaySearchListData :(DashboardDataModel *)productListData
- (void)displaySearchListData {
    [borderView setBorder:borderView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
    [borderView setCornerRadius:5.0];
    [productCellMainView addShadow:productCellMainView color:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
//    productName.text=productListData.productName;
//    productPrice.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrency"],productListData.productPrice];
//    productDescription.text=productListData.productDescription;
//    [ImageCaching downloadImages:productImageView imageUrl:productListData.productImageThumbnail placeholderImage:@"product_placeholder"];
//    statusBannerImage.hidden=YES;
//    if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil) {
//        productRating.hidden=YES;
//        ratingStarImage.hidden=YES;
//    }
//    else {
//        productRating.hidden=NO;
//        ratingStarImage.hidden=NO;
//        productRating.text=productListData.productRating;
//    }
}
@end
