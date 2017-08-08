//
//  DynamicHeightWidth.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DynamicHeightWidth.h"

@implementation DynamicHeightWidth

+ (float)getDynamicLabelWidth:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue {
    CGSize size = CGSizeMake(widthValue,1000);
    CGRect textRect=[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:font}
                     context:nil];
    return textRect.size.width;
}
@end
