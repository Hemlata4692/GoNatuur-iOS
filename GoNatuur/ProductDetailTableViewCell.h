//
//  ProductDetailTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDataModel.h"

@interface ProductDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productShortDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *starBackView;
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIImageView *videoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *video360Icon;
@property (strong, nonatomic) IBOutlet UICollectionView *productMediaCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPointsEarnLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingFreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *productReturnLabel;
@property (strong, nonatomic) IBOutlet UIView *addCartView;
@property (strong, nonatomic) IBOutlet UIButton *removeFromCartButton;
@property (strong, nonatomic) IBOutlet UIButton *incrementCartButton;
@property (strong, nonatomic) IBOutlet UILabel *cartNumberItemLabel;
@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;

- (void)displayProductName:(NSString *)productName;
- (void)displayProductDescription:(NSString *)productDescription;
- (void)displayRating:(NSString *)productRating;
- (void)displayProductMediaImage:(NSDictionary *)productImageDict qrCode:(UIImage *)qrCodeImage;
- (void)displayProductPrice:(ProductDataModel *)productData currentQuantity:(int)currentQuantity;
- (void)displayProductInfo;
- (void)displayAddToCartButton;
@end
