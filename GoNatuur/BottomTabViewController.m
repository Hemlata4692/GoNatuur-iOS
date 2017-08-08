//
//  BottomTabViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 03/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "BottomTabViewController.h"

@interface BottomTabViewController ()
@property (strong, nonatomic) IBOutlet UIView *bottomTabView;
@property (weak, nonatomic) IBOutlet UIButton *homeTab;
@property (weak, nonatomic) IBOutlet UIButton *myCartTab;
@property (weak, nonatomic) IBOutlet UIButton *wishlistTab;
@property (weak, nonatomic) IBOutlet UIButton *profileTab;
@end

@implementation BottomTabViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_homeTab setSelected:YES];
    if (_homeTab.selected) {
        _homeTab.backgroundColor=[UIColor colorWithRed:182.0/255/0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Tab bar IBAction
- (IBAction)homeTabAction:(id)sender {
    [_homeTab setSelected:YES];
    [_myCartTab setSelected:NO];
    [_wishlistTab setSelected:NO];
    [_profileTab setSelected:NO];
    if (_homeTab.selected) {
        _homeTab.backgroundColor=[UIColor colorWithRed:182.0/255/0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _myCartTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
    }
    else {
        _homeTab.backgroundColor=[UIColor blackColor];
        
    }
}
- (IBAction)myCartTabAction:(id)sender {
    [_homeTab setSelected:NO];
    [_myCartTab setSelected:YES];
    [_wishlistTab setSelected:NO];
    [_profileTab setSelected:NO];
    if (_myCartTab.selected) {
        _myCartTab.backgroundColor=[UIColor colorWithRed:182.0/255/0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
    }
    else {
        _myCartTab.backgroundColor=[UIColor blackColor];
    }
}
- (IBAction)wishlistTabAction:(id)sender {
    [_homeTab setSelected:NO];
    [_myCartTab setSelected:NO];
    [_wishlistTab setSelected:YES];
    [_profileTab setSelected:NO];
    if (_wishlistTab.selected) {
        _wishlistTab.backgroundColor=[UIColor colorWithRed:182.0/255/0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTab.backgroundColor=[UIColor blackColor];
        _myCartTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
    }
    else {
        _wishlistTab.backgroundColor=[UIColor blackColor];
    }
}
- (IBAction)profileTabAction:(id)sender {
    [_homeTab setSelected:NO];
    [_myCartTab setSelected:NO];
    [_wishlistTab setSelected:NO];
    [_profileTab setSelected:YES];
    if (_profileTab.selected) {
        _profileTab.backgroundColor=[UIColor colorWithRed:182.0/255/0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTab.backgroundColor=[UIColor blackColor];
        _myCartTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
    }
    else {
        _profileTab.backgroundColor=[UIColor blackColor];
    }
}
#pragma mark - end

@end
