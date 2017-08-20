//
//  ProductDetailCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductDetailCollectionViewCell.h"

@implementation ProductDetailCollectionViewCell

- (void)displayProductMediaImage:(NSDictionary *)productImageDict qrCode:(UIImage *)qrCodeImage {
    _blackTransparentView.hidden=true;
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
        [ImageCaching downloadImages:_productthumbnailImageView imageUrl:[productImageDict objectForKey:@"path"] placeholderImage:@"product_placeholder" isDashboardCell:true];
    }
}
@end
