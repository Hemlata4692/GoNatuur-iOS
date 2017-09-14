//
//  ShareViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UILabel *shareTextLabel;

@end

@implementation ShareViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_shareView setCornerRadius:2.0];
    _shareTextLabel.text=NSLocalizedText(@"shareText");
    self.view.backgroundColor=[UIColor clearColor];

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissNewsView:)];
    [_mainView addGestureRecognizer:singleFingerTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Dismiss view
//The event handling method
- (void)dismissNewsView:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - end

#pragma mark - IBActionss
- (IBAction)weiboButtonAction:(id)sender {
}

- (IBAction)wechatButtonAction:(id)sender {
}
- (IBAction)twitterButtonAction:(id)sender {
}

- (IBAction)pinterestButtonAction:(id)sender {
}
- (IBAction)instagramButtonAction:(id)sender {
}
- (IBAction)googlePlusButtonAction:(id)sender {
}
- (IBAction)facebookButtonAction:(id)sender {
}
#pragma mark - end
@end
