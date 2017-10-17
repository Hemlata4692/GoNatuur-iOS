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
- (void)displayProductListData :(DashboardDataModel *)productListData exchangeRates:(NSString *)exchangeRates {
    [productCellMainView setBorder:productCellMainView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
    [productCellMainView setCornerRadius:5.0];
    [borderView addShadow:borderView color:[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]];
    productName.text=productListData.productName;
    
    if ((nil==productListData.productDescription)||[productListData.productDescription isEqualToString:@""]) {
        productDescription.text=NSLocalizedText(@"dataNotAdded");
    }
    else {
        productDescription.text=productListData.productDescription;
    }
    [ImageCaching downloadImages:productImageView imageUrl:productListData.productImageThumbnail placeholderImage:@"product_placeholder" isDashboardCell:true];
    if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil || [productListData.productRating isEqualToString:@"0"]) {
        productRating.hidden=YES;
        ratingStarImage.hidden=YES;
    }
    else {
        productRating.hidden=NO;
        ratingStarImage.hidden=NO;
        float rating = (([productListData.productRating integerValue])*5.0)/100.0;
        productRating.text=[NSString stringWithFormat:@"(%.1f)",rating];
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
    productPrice.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:productCalculatedPrice]];
    statusBannerImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",productListData.ribbons,[UserDefaultManager getValue:@"Language"]]];
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

//Footer image cell
- (void)displayFooterBannerData :(DashboardDataModel *)footerBannerImage {
    [ImageCaching downloadImages:footerImageView imageUrl:footerBannerImage.banerImageUrl placeholderImage:@"product_placeholder" isDashboardCell:true];
}

- (void)customizedCellObject:(DashboardDataModel *)productListData {
    float picDimension = 186.0;
    if ([productListData.productRating isEqualToString:@""] || productListData.productRating==nil || [productListData.productRating isEqualToString:@"0"]) {
        productRating.hidden=YES;
        ratingStarImage.hidden=YES;
        productPrice.translatesAutoresizingMaskIntoConstraints=true;
        productPrice.frame=CGRectMake(12, ((picDimension+105)-8)-26, ((picDimension-5)-8)-24, 20);//width:((picDimension-5)-8(upperMainViewSpace 7-bottommainViewSpace 1))-24(leading and trailing)
    }
    else {
        productRating.hidden=NO;
        ratingStarImage.hidden=NO;
        productPrice.translatesAutoresizingMaskIntoConstraints=true;
        productPrice.frame=CGRectMake(12, ((picDimension+105)-8)-26, ((picDimension-5)-8)-12-74, 20);;//width:((picDimension-5)-8(upperMainViewSpace 7-bottommainViewSpace 1))-12(leading)-74(70+4)
    }
}
@end
