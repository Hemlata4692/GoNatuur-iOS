//
//  CategorySliderCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CategorySliderCell.h"

@implementation CategorySliderCell

#pragma mark - Load cell data
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displaySliderItems:(NSString *)name isSelected:(BOOL)isSelected {
    [self.contentView setCornerRadius:15];
    _categoryName.text=name;
    if (isSelected) {
        [self.contentView setBorder:self.contentView color:[UIColor clearColor] borderWidth:0.0];
        self.contentView.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _categoryName.textColor=[UIColor whiteColor];
    }
    else {
         [self.contentView setBorder:self.contentView color:[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0] borderWidth:2.0];
        self.contentView.backgroundColor=[UIColor clearColor];
        _categoryName.textColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
    }
}
#pragma mark - end
@end
