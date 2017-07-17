//
//  FacebookConnect.h
//  
//  Created by Ranosys on 12/07/16.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@protocol FacebookDelegate <NSObject>
@optional
- (void) facebookLoginWithReadPermissionResponse:(id)fbResult status:(int)status;
@end

@interface FacebookConnect : NSObject{
    id <FacebookDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

- (void)facebookLoginWithReadPermission:(UIViewController *)selfVC;
@end
