//
//  ProductListCollectionViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardDataModel.h"

@interface ProductListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *productCellMainView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBannerImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productRating;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *borderView;

- (void)displayProductListData :(DashboardDataModel *)productListData exchangeRates:(NSString *)exchangeRates;
@end
