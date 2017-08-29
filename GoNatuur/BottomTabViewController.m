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
#import "ProfileViewController.h"

@interface BottomTabViewController ()
@property (strong, nonatomic) IBOutlet UIView *bottomTabView;
@property (weak, nonatomic) IBOutlet UIButton *homeTab;
@property (weak, nonatomic) IBOutlet UIButton *myCartTab;
@property (strong, nonatomic) IBOutlet UILabel *cartBadgeLabel;
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
    [self viewInitialized];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewInitialized {
    //Deselect all tabs
    _cartBadgeLabel.layer.masksToBounds=true;
    _cartBadgeLabel.layer.cornerRadius=9;
    _cartBadgeLabel.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
    _cartBadgeLabel.textColor=[UIColor whiteColor];
    _cartBadgeLabel.hidden=true;
    [self updateCartBadge];
    [_homeTab setSelected:false];
    [_myCartTab setSelected:false];
    [_wishlistTab setSelected:false];
    [_profileTab setSelected:false];
    _homeTab.backgroundColor=[UIColor blackColor];
    _homeTabImageIcon.alpha=1.0;
    _myCartTab.backgroundColor=[UIColor blackColor];
    _wishlistTab.backgroundColor=[UIColor blackColor];
    _profileTab.backgroundColor=[UIColor blackColor];
    _myCartTabImageIcon.alpha=1.0;
    _wishlistTabImageIcon.alpha=1.0;
    _profileTabImageIcon.alpha=1.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Update home tab
- (void)showSelectedTab:(int)item {
    if (item==1) {
        _homeTab.selected=true;
        _homeTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTabImageIcon.alpha=0.6;
    }
    else if (item==2) {
        _myCartTab.selected=true;
        _myCartTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _myCartTabImageIcon.alpha=0.6;
        _cartBadgeLabel.backgroundColor=[UIColor whiteColor];
        _cartBadgeLabel.textColor=[UIColor blackColor];
    }
    else if (item==3) {
        _wishlistTab.selected=true;
        _wishlistTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _wishlistTabImageIcon.alpha=0.6;
    }
    else if (item==4) {
        _profileTab.selected=true;
        _profileTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _profileTabImageIcon.alpha=0.6;
    }
}

- (void)updateCartBadge {
    if ([[UserDefaultManager getValue:@"quoteCount"] intValue]>0) {
        _cartBadgeLabel.hidden=false;
        _cartBadgeLabel.text=[NSString stringWithFormat:@"%d",[[UserDefaultManager getValue:@"quoteCount"] intValue]];
    }
}
#pragma mark - end

#pragma mark - Tab bar IBAction
- (IBAction)homeTabAction:(id)sender {
    if (!_homeTab.selected) {
        myDelegate.selectedCategoryIndex=-1;
        _homeTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTabImageIcon.alpha=0.6;
        _myCartTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
        _myCartTabImageIcon.alpha=1.0;
        _wishlistTabImageIcon.alpha=1.0;
        _profileTabImageIcon.alpha=1.0;
        //Navigate to dashboard screen
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DashboardViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                             animated: NO];
    }
}

- (IBAction)myCartTabAction:(id)sender {
    /*Feature not available
    if (!_myCartTab.selected) {
        _myCartTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _myCartTabImageIcon.alpha=0.6;
        _homeTab.backgroundColor=[UIColor blackColor];
        _wishlistTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
        _homeTabImageIcon.alpha=1.0;
        _wishlistTabImageIcon.alpha=1.0;
        _profileTabImageIcon.alpha=1.0;
        myDelegate.tabButtonTag=@"0";
    }*/
    [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
}

- (IBAction)wishlistTabAction:(id)sender {
    /*Feature not available
    if (!_wishlistTab.selected) {
        _wishlistTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
        _homeTab.backgroundColor=[UIColor blackColor];
        _myCartTab.backgroundColor=[UIColor blackColor];
        _profileTab.backgroundColor=[UIColor blackColor];
        _myCartTabImageIcon.alpha=1.0;
        _homeTabImageIcon.alpha=1.0;
        _wishlistTabImageIcon.alpha=0.6;
        _profileTabImageIcon.alpha=1.0;
        myDelegate.tabButtonTag=@"0";
    }*/
    [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
}

- (IBAction)profileTabAction:(id)sender {
    if (![myDelegate checkGuestAccess]) {
        if (!_profileTab.selected) {
            _profileTab.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0];
            _homeTab.backgroundColor=[UIColor blackColor];
            _myCartTab.backgroundColor=[UIColor blackColor];
            _wishlistTab.backgroundColor=[UIColor blackColor];
            _myCartTabImageIcon.alpha=1.0;
            _homeTabImageIcon.alpha=1.0;
            _wishlistTabImageIcon.alpha=1.0;
            _profileTabImageIcon.alpha=0.6;
            myDelegate.tabButtonTag=@"0";
            //Navigate to dashboard screen
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProfileViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                                 animated: NO];
        }
    }
}
#pragma mark - end

@end
