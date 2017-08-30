//
//  ZopimViewController.m
//  GoNatuur
//
//  Created by Ranosys on 30/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ZopimViewController.h"
#import <ZDCChat/ZDCChat.h>

@interface ZopimViewController ()

@end
@implementation ZopimViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)zopimChatAction:(UIButton *)sender {
    [[ZDCChat instance].api trackEvent:@"Chat button pressed: (pre-set data)"];
    
    // before starting the chat set the visitor data
    [ZDCChat updateVisitor:^(ZDCVisitorInfo *visitor) {
        
        visitor.phone = [UserDefaultManager getValue:@"mobileNumber"];
        visitor.name = [UserDefaultManager getValue:@"firstname"];
        visitor.email = [UserDefaultManager getValue:@"emailId"];
    }];
    
    [ZDCChat startChatIn:[UIApplication sharedApplication].keyWindow.rootViewController.navigationController withConfig:^(ZDCConfig *config) {
        
        config.preChatDataRequirements.name = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.email = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.phone = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.department = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.message = ZDCPreChatDataRequired;
        config.tags = @[@"iPhoneChat"];
    }];
}

- (IBAction)ZopimTicketAction:(UIButton *)sender {
    
}
#pragma mark - end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
