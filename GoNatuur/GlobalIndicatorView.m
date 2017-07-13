//
//  GlobalIndicatorView.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 13/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "GlobalIndicatorView.h"


@implementation GlobalIndicatorView 
@synthesize spinnerView;
@synthesize spinnerBackground;
@synthesize loaderView;

#pragma mark - Singleton instance
+ (id)sharedManager {
    static GlobalIndicatorView *sharedMyManager = nil;
        sharedMyManager = [[self alloc] initSingelton];
    return sharedMyManager;
}

- (id)initSingelton{
    if (self = [super init]) {
        //do stuff here
        return self;
    }
    return nil;
}

#pragma mark - end

#pragma mark - Global indicator view
//show indicator
- (void)showIndicator:(UIView *)view
{
    spinnerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 50, 50)];
    spinnerBackground.backgroundColor=[UIColor whiteColor];
    spinnerBackground.layer.cornerRadius=25.0f;
    spinnerBackground.clipsToBounds=YES;
    spinnerBackground.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    loaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    loaderView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:0.3];
    [loaderView addSubview:spinnerBackground];
    spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    spinnerView.tintColor = [UIColor colorWithRed:144.0/255.0 green:187.0/255.0 blue:62.0/255.0 alpha:1.0];
    spinnerView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    spinnerView.lineWidth=3.0f;
    [view addSubview:loaderView];
    [view addSubview:self.spinnerView];
    [spinnerView startAnimating];
}

//stop indicator
- (void)stopIndicator {
    [loaderView removeFromSuperview];
    [spinnerView removeFromSuperview];
    [spinnerView stopAnimating];
}
#pragma mark - end

@end
