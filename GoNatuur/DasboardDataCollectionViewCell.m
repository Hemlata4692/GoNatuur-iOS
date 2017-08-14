//
//  DasboardDataCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 10/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DasboardDataCollectionViewCell.h"

@implementation DasboardDataCollectionViewCell
//Product cell
@synthesize productCellMainView;
@synthesize statusBannerImage;
@synthesize productName;
@synthesize productDescription;
@synthesize productPrice;
@synthesize productRating;
@synthesize ratingStarImage;
@synthesize productImageView;
@synthesize borderView;

//Footer image cell
@synthesize footerImageView;

//Product cell
- (void)displayProductListData :(DashboardDataModel *)productListData {
    [productCellMainView setBorder:productCellMainView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
    [productCellMainView setCornerRadius:5.0];
    [borderView addShadow:borderView color:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    productName.text=productListData.productName;
    productPrice.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrency"],productListData.productPrice];
    productDescription.text=productListData.productDescription;
    [ImageCaching downloadImages:productImageView imageUrl:productListData.productImageThumbnail placeholderImage:@"product_placeholder"];
    statusBannerImage.hidden=YES;
    if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil) {
        productRating.hidden=YES;
        ratingStarImage.hidden=YES;
    }
    else {
        productRating.hidden=NO;
        ratingStarImage.hidden=NO;
        productRating.text=productListData.productRating;
    }
}

//Footer image cell
- (void)displayFooterBannerData :(DashboardDataModel *)footerBannerImage {
    [ImageCaching downloadImages:footerImageView imageUrl:footerBannerImage.banerImageUrl placeholderImage:@"product_placeholder"];
}
@end
