//
//  ProductListTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *bannerImage;
@property (strong, nonatomic) IBOutlet UICollectionView *productListCollectionView;
- (void)displayBannerImage:(NSString *)bannerImageUrl screenType:(NSString *)screenType;
@end
