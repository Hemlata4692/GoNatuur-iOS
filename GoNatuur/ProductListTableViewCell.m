//
//  ProductListTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductListTableViewCell.h"

@implementation ProductListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayBannerImage:(NSString *)bannerImageUrl {
    [ImageCaching downloadImages:_bannerImage imageUrl:(![bannerImageUrl isEqualToString:@""]?[NSString stringWithFormat:@"%@/%@",productImageBaseUrl,bannerImageUrl]:@"") placeholderImage:@"banner_placeholder" isDashboardCell:true];
}
@end
