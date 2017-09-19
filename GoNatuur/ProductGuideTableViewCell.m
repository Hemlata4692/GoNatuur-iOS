//
//  ProductGuideTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductGuideTableViewCell.h"
#import "DynamicHeightWidth.h"

@implementation ProductGuideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayProductBottomHeadingData:(NSString *)data {
    _productHeading.translatesAutoresizingMaskIntoConstraints=YES;
    float tempHeight= [DynamicHeightWidth getDynamicLabelHeight:data font:[UIFont montserratMediumWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50];
    _productHeading.frame=CGRectMake(25, 10, [[UIScreen mainScreen] bounds].size.width-50, tempHeight);
    _productHeading.text=data;
}

- (void)displayProductName:(NSString *)data {
    _nameLabel.text=data;
}

- (void)displayProductTagline:(NSString *)data {
   _taglineLabel.text=data;
}

- (void)displayProductShortDescription:(NSString *)data {
   _shortDescriptionLabel.text=data;
}
@end
