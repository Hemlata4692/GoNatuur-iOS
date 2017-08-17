//
//  SearchCollectionViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *productCellMainView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBannerImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productRating;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *borderView;

- (void)displaySearchListData;
@end
