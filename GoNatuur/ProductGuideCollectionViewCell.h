//
//  ProductGuideCollectionViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDataModel.h"
#import "ProductGuideDataModel.h"

@interface ProductGuideCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *subCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *subCategoryNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

- (void)displaySubCategoryData:(NSString *)productName productImage:(NSString *)productImage selectedIndex:(int)selectedIndex currentIndex:(int)currentIndex;

- (void)displayCategoryData:(NSString *)productName selectedIndex:(int)selectedIndex currentIndex:(int)currentIndex;
- (void)displayProductListData:(SearchDataModel *)productListData;
- (void)displayProductListSearchData:(ProductGuideDataModel *)productListSearchData;
@end
