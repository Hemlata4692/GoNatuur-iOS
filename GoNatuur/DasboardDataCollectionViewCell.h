//
//  DasboardDataCollectionViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 10/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DasboardDataCollectionViewCell : UICollectionViewCell
//Product cell
@property (weak, nonatomic) IBOutlet UIView *productCellMainView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBannerImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productRating;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

//Footer image cell
@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;

@end
