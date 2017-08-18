//
//  BottomTabViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 03/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "BottomTabViewController.h"
#import "DashboardViewController.h"
#import "UIView+Toast.h"

@interface BottomTabViewController () {
@private
    int buttonCount;
}
@property (strong, nonatomic) IBOutlet UIView *bottomTabView;
@property (weak, nonatomic) IBOutlet UIButton *homeTab;
@property (weak, nonatomic) IBOutlet UIButton *myCartTab;
@property (weak, nonatomic) IBOutlet UIButton *wishlistTab;
@property (weak, nonatomic) IBOutlet UIButton *profileTab;
@property (weak, nonatomic) IBOutlet UIImageView *homeTabImageIcon;
@property (weak, nonatomic) IBOutlet UIImageView *myCartTabImageIcon;
@property (weak, nonatomic) IBOutlet UIImageView *wishlistTabImageIcon;
@property (weak, nonatomic) IBOutlet UIImageView *profileTabImageIcon;
@end

@implementation BottomTabViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_homeTab setSelected:YES];
    if (_homeTab.selected) {
        _homeTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTabImageIcon.alpha=0.6;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    buttonCount=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Tab bar IBAction
- (IBAction)homeTabAction:(id)sender {
    buttonCount=1;
    [_homeTab setSelected:YES];
    [_myCartTab setSelected:NO];
    [_wishlistTab setSelected:NO];
    [_profileTab setSelected:NO];
    if (_homeTab.selected) {
        _homeTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTabImageIcon.alpha=0.6;
        _myCartTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
        _myCartTabImageIcon.alpha=1.0;
        _wishlistTabImageIcon.alpha=1.0;
        _profileTabImageIcon.alpha=1.0;
    }
    else {
        _homeTabImageIcon.alpha=1.0;
        _homeTab.backgroundColor=[UIColor blackColor];
    }
    if (buttonCount==0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DashboardViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                             animated: NO];
    }
}

- (IBAction)myCartTabAction:(id)sender {
    [_homeTab setSelected:NO];
    [_myCartTab setSelected:YES];
    [_wishlistTab setSelected:NO];
    [_profileTab setSelected:NO];
    if (_myCartTab.selected) {
        _myCartTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _myCartTabImageIcon.alpha=0.6;
        _homeTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
        _homeTabImageIcon.alpha=1.0;
        _wishlistTabImageIcon.alpha=1.0;
        _profileTabImageIcon.alpha=1.0;
    }
    else {
        _myCartTabImageIcon.alpha=1.0;
        _myCartTab.backgroundColor=[UIColor blackColor];
    }
    [self.view makeToast:@"Feature is currently not available."];
}

- (IBAction)wishlistTabAction:(id)sender {
    [_homeTab setSelected:NO];
    [_myCartTab setSelected:NO];
    [_wishlistTab setSelected:YES];
    [_profileTab setSelected:NO];
    if (_wishlistTab.selected) {
        _wishlistTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTab.backgroundColor=[UIColor blackColor];
        _myCartTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
        _myCartTabImageIcon.alpha=1.0;
        _homeTabImageIcon.alpha=1.0;
        _wishlistTabImageIcon.alpha=0.6;
        _profileTabImageIcon.alpha=1.0;
    }
    else {
        _wishlistTabImageIcon.alpha=1.0;
        _wishlistTab.backgroundColor=[UIColor blackColor];
    }
    [self.view makeToast:@"Feature is currently not available."];
}

- (IBAction)profileTabAction:(id)sender {
    [_homeTab setSelected:NO];
    [_myCartTab setSelected:NO];
    [_wishlistTab setSelected:NO];
    [_profileTab setSelected:YES];
    if (_profileTab.selected) {
        _profileTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTab.backgroundColor=[UIColor blackColor];
        _myCartTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
        _myCartTabImageIcon.alpha=1.0;
        _homeTabImageIcon.alpha=1.0;
        _wishlistTabImageIcon.alpha=1.0;
        _profileTabImageIcon.alpha=0.6;
    }
    else {
        _profileTabImageIcon.alpha=1.0;
        _profileTab.backgroundColor=[UIColor blackColor];
    }
    [self.view makeToast:@"Feature is currently not available."];
}
#pragma mark - end

@end
