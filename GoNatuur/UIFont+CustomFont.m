//
//  UIFont+CustomFont.m
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

+ (UIFont*)helveticaNeueBoldWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
    return font;
}

+ (UIFont*)helveticaNeueRegularWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Regular" size:size];
    return font;
}

+ (UIFont*)helveticaNeueWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue" size:size];
    return font;
}

+ (UIFont*)helveticaNeueThinWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
    return font;
}

+ (UIFont*)helveticaNeueMediumWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
    return font;
}

+ (UIFont*)montserratMediumWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"Montserrat-Medium" size:size];
    return font;
}

+ (UIFont*)montserratRegularWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"Montserrat-Regular" size:size];
    return font;
}

+ (UIFont*)montserratBoldWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"Montserrat-Bold" size:size];
    return font;
}

+ (UIFont*)montserratLightWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"Montserrat-Light" size:size];
    return font;
}

+ (UIFont*)montserratSemiBoldWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"Montserrat-SemiBold" size:size];
    return font;
}

+ (UIFont*)sfuiDisplayRegularWithSize:(int)size {
    UIFont *font=[UIFont fontWithName:@"SFUIDisplay-Regular" size:size];
    return font;
}
@end
