//
//  ProductGuideCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductGuideCollectionViewCell.h"

@implementation ProductGuideCollectionViewCell

- (void)displayCategoryData:(NSString *)productName selectedIndex:(int)selectedIndex currentIndex:(int)currentIndex {
    _categoryLabel.text=productName;
    if (currentIndex==selectedIndex) {
        _categoryLabel.textColor=[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0];
    }
    else {
       _categoryLabel.textColor=[UIColor blackColor];
    }
}

- (void)displaySubCategoryData:(NSString *)productName productImage:(NSString *)productImage selectedIndex:(int)selectedIndex currentIndex:(int)currentIndex {
    _subCategoryNameLabel.text=productName;
    [ImageCaching downloadImages:_subCategoryImageView imageUrl:productImage placeholderImage:@"product_placeholder" isDashboardCell:true];
    
    if (currentIndex==selectedIndex) {
        [_subCategoryImageView setBorder:_subCategoryImageView color:[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0] borderWidth:1.5];
    }
    else {
        [_subCategoryImageView setBorder:_subCategoryImageView color:[UIColor colorWithRed:123.0/255.0 green:123.0/255.0 blue:123.0/255.0 alpha:1.0] borderWidth:1.5];
    }
}
@end
