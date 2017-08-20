//
//  DynamicHeightWidth.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicHeightWidth : NSObject

+ (float)getDynamicLabelWidth:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue;
+ (float)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue;
+ (float)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue  heightValue:(float)heightValue;
@end
