//
//  ProductDetailCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductDetailCollectionViewCell.h"

@implementation ProductDetailCollectionViewCell

- (void)displayProductMediaImage:(NSDictionary *)productImageDict qrCode:(UIImage *)qrCodeImage selectedIndex:(int)selectedIndex currentIndex:(int)currentIndex {
    _blackTransparentView.hidden=true;
    _blackTransparentView.layer.borderWidth=0.0;
    _blackTransparentView.clipsToBounds=true;
    _shadowView.clipsToBounds=true;
    _blackTransparentView.layer.borderColor=[UIColor whiteColor].CGColor;
    _productthumbnailImageView.layer.borderWidth=0.0;
    _productthumbnailImageView.clipsToBounds=true;
    _productthumbnailImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    if ([[productImageDict objectForKey:@"media_type"] isEqualToString:@"QRCode"]) {
        _productthumbnailImageView.image=qrCodeImage;
    }
    else {
        if([[productImageDict objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
            _blackTransparentView.hidden=false;
            _videoIconImageView.hidden=false;
            _icon360ImageView.hidden=true;
        }
        
        /*Code is commented for 360 video media type
         else if([[productImageDict objectForKey:@"media_type"] isEqualToString:@"image"]) {
         _blackTransparentView.hidden=false;
         _videoIconImageView.hidden=true;
         _icon360ImageView.hidden=false;
         }*/
        [ImageCaching downloadImages:_productthumbnailImageView imageUrl:[NSString stringWithFormat:@"%@%@",productDetailImageBaseUrl,[productImageDict objectForKey:@"file"]] placeholderImage:@"product_placeholder" isDashboardCell:true];
    }
    if (currentIndex==selectedIndex) {
        if ([[productImageDict objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
            _blackTransparentView.layer.borderWidth=2.0;
        }
        else {
            _productthumbnailImageView.layer.borderWidth=2.0;
        }
        [_shadowView addShadow:_shadowView color:[UIColor blackColor]];
    }
}
@end
