//
//  ConstantCode.h
//  CustomProductListBar
//
//  Created by Ranosys on 03/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ConstantType){
    FacebookLogin,
    WeChatLogin,
    WeiboLogin,
    GoogleLogin,
    
    Device5s,
    Device6,
    Device7Plus
};

@interface ConstantCode : NSObject

+ (ConstantType)checkDeviceType;
@end
