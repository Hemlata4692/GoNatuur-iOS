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
#import "CategorySliderViewController.h"
#import "UIView+Toast.h"
#import "ProductListingViewController.h"

@interface GoNatuurViewController ()<SWRevealViewControllerDelegate,CategorySliderDelegate>{
@private
    UIBarButtonItem *leftBarButton;
    UIBarButtonItem *searchButton;
}
@end

@implementation GoNatuurViewController
@synthesize categorySliderObjc;
@synthesize bottomTabController;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //add side bar
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //add search button
    [self addSerachButtonWithImage:[UIImage imageNamed:@"search"]];
    
//    //add bottom tab
//    [self addBottomTab];
    
    //add category slider
    [self addCategorySlideView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //add bottom tab
    [self addBottomTab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [bottomTabController willMoveToParentViewController:nil];
    [bottomTabController.view removeFromSuperview];
    [bottomTabController removeFromParentViewController];
}
#pragma mark - end

#pragma mark - Add bottom tab
- (void)addBottomTab {
    //Load bottom tab bar xib
    bottomTabController = [[BottomTabViewController alloc] initWithNibName:@"BottomTabViewController" bundle:nil];
    [self addChildViewController:bottomTabController];
    [bottomTabController.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-60, [[UIScreen mainScreen] bounds].size.width, 60)];
    [self.view addSubview:bottomTabController.view];
    [bottomTabController didMoveToParentViewController:self];
}

- (void)showSelectedTab:(int)item {
    [bottomTabController showSelectedTab:item];
}

- (void)updateCartBadge {
    [bottomTabController updateCartBadge];
}
#pragma mark - end

#pragma mark - Add category slider
- (void)addCategorySlideView {
    //Load category slider xib
    categorySliderObjc = [[CategorySliderViewController alloc] initWithNibName:@"CategorySliderViewController" bundle:nil];
    categorySliderObjc.view.translatesAutoresizingMaskIntoConstraints=YES;
    //Under top and bottom bar is enable then 64+ is not needed else use 64+
    categorySliderObjc.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 64+40);//Height 64(fixed)+46(original height)
    [categorySliderObjc.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation.png"]]];
    categorySliderObjc.delegate=self;
    [categorySliderObjc.categorySliderCollectionView reloadData];
    [self addChildViewController:categorySliderObjc];
    [self.view addSubview:categorySliderObjc.view];
    [categorySliderObjc didMoveToParentViewController:self];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self setTransparentNavigtionBar];
}

//Make the navigation bar transparent and show only bar items.
- (void)setTransparentNavigtionBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)removeIfChildExist {
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UIView class]]) {
            //here do your work
        }
    }
}

- (void)selectedProduct:(int)option {
    NSLog(@"%d", option);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductListingViewController * productListView = [storyboard instantiateViewControllerWithIdentifier:@"ProductListingViewController"];
    productListView.selectedProductCategoryId=[[[self.categorySliderObjc.categoryDataArray objectAtIndex:option] objectForKey:@"id"] intValue];
    [self.navigationController setViewControllers: [NSArray arrayWithObject:productListView] animated:false];
}
#pragma mark - end

#pragma mark - Back button and side bar button
- (void)addLeftBarButtonWithImage:(BOOL)isBackButton {
    //side bar menu/back button
    CGRect sideBarButtonFrame = CGRectMake(0, 0, 26, 26);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:sideBarButtonFrame];
    leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:leftBarButton, nil];
    
    //add button action
    if (isBackButton) {
        [[leftButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [[leftButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"sidemenu"] forState:UIControlStateNormal];
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
    CGRect searchButtonFrame = CGRectMake(0, 0, 22, 22);
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
//    [self.view makeToast:@"Feature is currently not available."];
}
#pragma mark - end

@end
