//
//  SocialLoginViewController.h
//  GoNatuur
//
//  Created by Ranosys on 04/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SocialLoginDelegate <NSObject>
@optional
- (void)socialLoginResponse:(ConstantType)option result:(NSDictionary *)result;
@end
@interface SocialLoginViewController : UIViewController {
    
    id <SocialLoginDelegate> _delegate;
}
@property (nonatomic,strong) id <SocialLoginDelegate>delegate;

@property (strong, nonatomic) NSString *fbText;
@property (strong, nonatomic) NSString *weChatText;
@property (strong, nonatomic) NSString *wieboText;
@property (strong, nonatomic) NSString *googlPlusText;
@end
