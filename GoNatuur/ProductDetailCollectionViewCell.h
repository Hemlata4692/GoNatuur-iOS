//
//  ProductDetailCollectionViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIImageView *productthumbnailImageView;
@property (weak, nonatomic) IBOutlet UIView *blackTransparentView;
@property (strong, nonatomic) IBOutlet UIImageView *icon360ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *videoIconImageView;
- (void)displayProductMediaImage:(NSDictionary *)productImageDict qrCode:(UIImage *)qrCodeImage selectedIndex:(int)selectedIndex currentIndex:(int)currentIndex;
@end
