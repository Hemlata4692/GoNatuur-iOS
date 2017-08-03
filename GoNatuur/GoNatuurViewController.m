//
//  GoNatuurViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 03/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "GoNatuurViewController.h"
#import "SWRevealViewController.h"
#import "SearchViewController.h"

@interface GoNatuurViewController ()<SWRevealViewControllerDelegate>{
@private
    UIBarButtonItem *leftBarButton;
    UIBarButtonItem *searchButton;
}

@end

@implementation GoNatuurViewController

#pragma mark - Vie life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add side bar
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //add search button
    [self addSerachButtonWithImage:[UIImage imageNamed:@"search"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Back button and side bar button
- (void)addLeftBarButtonWithImage:(UIImage *)leftButtonImage isBackButton:(BOOL)isBackButton {
    //side bar menu/back button
    CGRect sideBarButtonFrame = CGRectMake(0, 0, leftButtonImage.size.width, leftButtonImage.size.height);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:sideBarButtonFrame];
    [leftButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:leftBarButton, nil];
    
    //add button action
    if (isBackButton) {
        [leftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        SWRevealViewController *revealViewController = self.revealViewController;
        if (revealViewController)
        {
            [leftButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
}

- (void)backButtonAction :(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

#pragma mark - Search button and action
- (void)addSerachButtonWithImage:(UIImage *)searchButtonImage {
    //side bar menu/back button
    CGRect searchButtonFrame = CGRectMake(0, 0, searchButtonImage.size.width, searchButtonImage.size.height);
    UIButton *serachBarButton = [[UIButton alloc] initWithFrame:searchButtonFrame];
    [serachBarButton setBackgroundImage:searchButtonImage forState:UIControlStateNormal];
    searchButton =[[UIBarButtonItem alloc] initWithCustomView:serachBarButton];
    self.navigationItem.rightBarButtonItem=searchButton;
    
    //add button action
    [serachBarButton addTarget:self action:@selector(serachButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)serachButtonAction:(id)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * searchView=[sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchView animated:YES];
}
#pragma mark - end

@end
