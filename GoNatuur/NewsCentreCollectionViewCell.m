//
//  NewsCentreCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 20/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NewsCentreCollectionViewCell.h"

@implementation NewsCentreCollectionViewCell
@synthesize productCellMainView;
@synthesize productName;
@synthesize productDescription;
@synthesize productImageView;
@synthesize borderView;

//News search cell
- (void)displayProductListData :(DashboardDataModel *)productListData exchangeRates:(NSString *)exchangeRates {
    [borderView setBorder:borderView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
    [borderView setCornerRadius:5.0];
    [borderView addShadow:borderView color:[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]];
    productName.text=productListData.productName;
    if ((nil==productListData.productDescription)||[productListData.productDescription isEqualToString:@""]) {
        productDescription.text=NSLocalizedText(@"dataNotAdded");
    }
    else {
        productDescription.text=productListData.productDescription;
    }
    [ImageCaching downloadImages:productImageView imageUrl:productListData.productImageThumbnail placeholderImage:@"product_placeholder" isDashboardCell:true];
}
//end
@end
