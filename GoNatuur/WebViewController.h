//
//  WebViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : GoNatuurViewController
@property (nonatomic, strong) NSString *productDetaiData;
@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, strong) NSString *isLocation;
@end
