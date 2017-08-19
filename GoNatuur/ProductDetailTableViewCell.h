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
@property (strong, nonatomic) IBOutlet UICollectionView *productMediaCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPointsEarnLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingFreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *productReturnLabel;
@property (strong, nonatomic) IBOutlet UIView *addCartView;
@property (strong, nonatomic) IBOutlet UIButton *removeFromCartButton;
@property (strong, nonatomic) IBOutlet UIButton *addInCartButton;
@property (strong, nonatomic) IBOutlet UILabel *cartNumberItemLabel;
@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;

- (void)displayProductName:(NSString *)productName;
- (void)displayProductDescription:(NSString *)productDescription;
- (void)displayRating:(NSNumber *)productRating;
- (void)displayProductImage:(NSString *)productImageUrl;
- (void)displayProductPrice:(ProductDataModel *)productData;
- (void)displayProductInfo;
@end
