//
//  DashboardViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DashboardViewController.h"
#import "DasboardDataCollectionViewCell.h"
#import "DashboardDataModel.h"
#import "CurrencyDataModel.h"
#import "LoginModel.h"
#import "ProductDetailViewController.h"
#import "ProductListingViewController.h"
#import "UIView+Toast.h"
#import "EventDetailViewController.h"
#import "NewsCentreDetailViewController.h"
#import "HMSegmentedControl.h"
#import "OrderDetailViewController.h"
#import "ProfileViewController.h"

@interface DashboardViewController ()<UIGestureRecognizerDelegate> {
@private
    int selectedIndex;
    int buttonTag;
    NSMutableArray *bannerImageArray;
    NSMutableArray *footerImageArray;
    NSMutableArray *bestSellerDataArray;
    NSMutableArray *healthyLivingDataArray;
    NSMutableArray *promotionsDataArray;
    NSMutableArray *productsDataArray;
    NSMutableArray *samplersProductDataArray, *sectionTitleArray;
    DashboardDataModel * bannerImageData;
    CurrencyDataModel *exchangeCurrencyData;
    HMSegmentedControl *segmentView;
}
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonSeperator;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *footerImageCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *bestSellerButton;
@property (weak, nonatomic) IBOutlet UIButton *healthyLivingButton;
@property (weak, nonatomic) IBOutlet UIButton *samplers;
@property (weak, nonatomic) IBOutlet UIView *segmentedControlView;
@end

@implementation DashboardViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bannerImageArray=[[NSMutableArray alloc]init];
    bestSellerDataArray=[[NSMutableArray alloc]init];
    footerImageArray=[[NSMutableArray alloc]init];
    promotionsDataArray=[[NSMutableArray alloc]init];
    productsDataArray=[[NSMutableArray alloc]init];
    healthyLivingDataArray=[[NSMutableArray alloc]init];
    samplersProductDataArray=[[NSMutableArray alloc]init];
    [self viewCustomisation];
    _noRecordLabel.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:false];
    myDelegate.selectedCategoryIndex=-1;
    [self showSelectedTab:1];
    
    if ([myDelegate.isNotificationArrived isEqualToString:@"1"]) {
        int notificationTypeId=myDelegate.notificationType;
        switch(notificationTypeId) {
            case 1 : {
                // navigate to product listing
                ProductListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductListingViewController"];
                obj.selectedProductCategoryId=[myDelegate.screenTargetId intValue];
                myDelegate.isProductList=true;
                [self.navigationController pushViewController:obj animated:YES];
            }
                break;
            case 2 :{
                // navigate to product details
                ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
                obj.selectedProductId=[myDelegate.screenTargetId intValue];
                obj.isRedeemProduct=false;
                [self.navigationController pushViewController:obj animated:YES];
            }
                break;
            case 3 : {
                // navigate to event listing
                ProductListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductListingViewController"];
                obj.selectedProductCategoryId=[myDelegate.screenTargetId intValue];
                myDelegate.isProductList=false;
                [self.navigationController pushViewController:obj animated:YES];
            }
                break;
            case 4 :{
                // navigate to event details
                EventDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
                obj.selectedProductId=[myDelegate.screenTargetId intValue];
                [self.navigationController pushViewController:obj animated:YES];
            }
                break;
            case 5 :
            case 6 :
            case 7 :
            case 8 :
            case 9 :
            case 11 :{
                // navigate to order details
                [self navigateToOrderDetail];
            }
                break;
            case 10 :{
                // navigate to profile screen
                ProfileViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                [self.navigationController pushViewController:obj animated:YES];
            }
                break;
            default :
                DLog(@"Invalid notification type");
        }
       
    }
    else {
    if (myDelegate.firstTime) {
        if ([myDelegate.isShareUrlScreen isEqualToString:@"1"]) {
            if (nil==[UserDefaultManager getValue:@"quoteId"] || NULL==[UserDefaultManager getValue:@"quoteId"]) {
                [myDelegate showIndicator];
                [self performSelector:@selector(userLoginAsGuestDashboard) withObject:nil afterDelay:.1];
            }
        }
        else {
        [myDelegate showIndicator];
        [self performSelector:@selector(getCategoryListData) withObject:nil afterDelay:.1];
        }
    }
    else {
        [myDelegate showIndicator];
        [self performSelector:@selector(getDashboardData) withObject:nil afterDelay:.1];
    }
    }
}

- (void)navigateToOrderDetail {
    // navigate to order details
    OrderDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    obj.selectedOrderId=myDelegate.screenTargetId;
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    myDelegate.tabButtonTag=@"0";
}
#pragma mark - end

#pragma mark - View customisation
- (void)viewCustomisation {
    //set 3 cells per row in collection view
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_footerImageCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow-3);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow)-3;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    buttonTag=1;
    _bestSellerButton.hidden=YES;
    _samplers.hidden=YES;
    _healthyLivingButton.hidden=YES;
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    
    sectionTitleArray=[[NSMutableArray alloc] initWithObjects:NSLocalizedText(@"bestseller"), NSLocalizedText(@"Samplers"), NSLocalizedText(@"healthyliving"), NSLocalizedText(@"newProduct"), NSLocalizedText(@"newPromotions"), nil];
    segmentView = [[HMSegmentedControl alloc]initWithSectionTitles:sectionTitleArray];
    segmentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentView.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentView.frame=CGRectMake(0, 0, _segmentedControlView.frame.size.width, _segmentedControlView.frame.size.height-3);
    segmentView.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentView.selectionIndicatorColor = [UIColor colorWithRed:146.0/255.0 green:27.0/255.0 blue:55.0/255.0 alpha:1.0];
    segmentView.selectionIndicatorHeight = 2.0;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont montserratMediumWithSize:14], NSFontAttributeName,
                                [UIColor blackColor].CGColor, NSForegroundColorAttributeName, nil];
    [segmentView setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
        return attString;
    }];

    [_segmentedControlView addSubview:segmentView];
    [_segmentedControlView bringSubviewToFront:segmentView];
    [segmentView addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex==0) {
            _noRecordLabel.hidden=YES;
            buttonTag=1;
            [self reloadCollectionView];
    }
    else if (segmentedControl.selectedSegmentIndex==1) {
        _noRecordLabel.hidden=YES;
        buttonTag=2;
        [self reloadCollectionView];

    }
    else if (segmentedControl.selectedSegmentIndex==2) {
        _noRecordLabel.hidden=YES;
        buttonTag=3;
        [self reloadCollectionView];

    }
    else if (segmentedControl.selectedSegmentIndex==3) {
        _noRecordLabel.hidden=YES;
        buttonTag=4;
        [self reloadCollectionView];

    }
    else if (segmentedControl.selectedSegmentIndex==4) {
        _noRecordLabel.hidden=YES;
        buttonTag=5;
        [self reloadCollectionView];

    }

}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (view==_productCollectionView) {
        if (buttonTag==1) {
            return bestSellerDataArray.count;
        }
        else if (buttonTag==2) {
            return healthyLivingDataArray.count;
        }
        else if (buttonTag==3) {
            return samplersProductDataArray.count;
        }
        else if (buttonTag==4) {
            return productsDataArray.count;
        }
        else {
            return promotionsDataArray.count;
        }
    }
    else {
        return footerImageArray.count-1;
    }
}

- (DasboardDataCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_productCollectionView) {
        DasboardDataCollectionViewCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
        if (buttonTag==1) {
            [productCell displayProductListData:[bestSellerDataArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
        }
        else if (buttonTag==2) {
            [productCell displayProductListData:[healthyLivingDataArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
        }
        else if (buttonTag==3) {
            [productCell displayProductListData:[samplersProductDataArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
        }
        else if (buttonTag==4) {
            [productCell displayProductListData:[productsDataArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
        }
        else {
            [productCell displayProductListData:[promotionsDataArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
        }
        return productCell;
    }
    else {
        DasboardDataCollectionViewCell *footerImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footerImageCell" forIndexPath:indexPath];
        [footerImageCell displayFooterBannerData:[footerImageArray objectAtIndex:indexPath.item+1]];
        return footerImageCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==_productCollectionView) {
        if (buttonTag==1) {
            if ([[[bestSellerDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self screenNavigationToDetailScreen:[[[bestSellerDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"2"];
            }
            else {
                [self screenNavigationToDetailScreen:[[[bestSellerDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"1"];
            }
        }
        else if (buttonTag==2) {
            if ([[[healthyLivingDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self screenNavigationToDetailScreen:[[[healthyLivingDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"2"];
            }
            else {
                [self screenNavigationToDetailScreen:[[[healthyLivingDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"1"];
            }
            
        }
        else if (buttonTag==3) {
            if ([[[samplersProductDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self screenNavigationToDetailScreen:[[[samplersProductDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"2"];
            }
            else {
                [self screenNavigationToDetailScreen:[[[samplersProductDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"1"];
            }
            
        }
        else if (buttonTag==4) {
            if ([[[productsDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self screenNavigationToDetailScreen:[[[productsDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"2"];
            }
            else {
                [self screenNavigationToDetailScreen:[[[productsDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"1"];
            }
            
        }
        else {
            if ([[[promotionsDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self screenNavigationToDetailScreen:[[[promotionsDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"2"];
            }
            else {
                [self screenNavigationToDetailScreen:[[[promotionsDataArray objectAtIndex:indexPath.item] productId] intValue] screenType:@"1"];
            }
        }
    }
    else {
        [self handleBannerClickEvent:(int)indexPath.item+3];
    }
}

//screen navigation according to product type
- (void)screenNavigationToDetailScreen:(int)productId screenType:(NSString *)screenType {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([screenType isEqualToString:@"1"]) {
        ProductDetailViewController * detailScreen=[sb instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        detailScreen.selectedProductId=productId;
        [self.navigationController pushViewController:detailScreen animated:YES];
    }
    else {
        EventDetailViewController * detailScreen=[sb instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
        detailScreen.selectedProductId=productId;
        [self.navigationController pushViewController:detailScreen animated:YES];
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)bestSellerButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
    _noRecordLabel.hidden=YES;
    buttonTag=1;
    [self reloadCollectionView];
}

- (IBAction)healthyLivingButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
    _noRecordLabel.hidden=YES;
    buttonTag=2;
    [self reloadCollectionView];
}

- (IBAction)samplersButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
    _noRecordLabel.hidden=YES;
    buttonTag=3;
    [self reloadCollectionView];
}

- (void)reloadCollectionView {
    [_productCollectionView reloadData];
    [_productCollectionView setContentOffset:CGPointZero animated:YES];
}
#pragma mark - end

#pragma mark - Set animation for button bottom selection
- (void)reframeSeperatorLabel:(UIButton *)button {
    CGPoint endFrame = button.center;
    [UIView animateWithDuration:0.3 animations:^{
        _buttonSeperator.center = endFrame;
        _buttonSeperator.frame=CGRectMake(button.frame.origin.x+(button.frame.size.width/2)-(_buttonSeperator.frame.size.width/2), button.frame.size.height-2, _buttonSeperator.frame.size.width, _buttonSeperator.frame.size.height);
    }];
}
#pragma mark - end

#pragma mark - Webservice
//Get constants list
- (void) getConstantsListData {
    DashboardDataModel *constantList = [DashboardDataModel sharedUser];
    [constantList getConstantsListData:^(DashboardDataModel *userData)  {
        [self getDefaultCurrency];
    } onfailure:^(NSError *error) {
        
    }];
}

//Get default currency
- (void)getDefaultCurrency {
    CurrencyDataModel *currencyData = [CurrencyDataModel sharedUser];
    [currencyData getCurrencyData:^(CurrencyDataModel *userData)  {
        exchangeCurrencyData=userData;
        for (int i=0; i<exchangeCurrencyData.availableCurrencyRatesArray.count; i++) {
            if ([[UserDefaultManager getValue:@"DefaultCurrencyCode"] containsString:[[exchangeCurrencyData.availableCurrencyRatesArray objectAtIndex:i] currencyExchangeCode]]) {
                [UserDefaultManager setValue:[[exchangeCurrencyData.availableCurrencyRatesArray objectAtIndex:i] currencyExchangeRates] key:@"ExchangeRates"];
                if ([[[exchangeCurrencyData.availableCurrencyRatesArray objectAtIndex:i] currencysymbol] isEqualToString:@""] || [[exchangeCurrencyData.availableCurrencyRatesArray objectAtIndex:i] currencysymbol]==nil) {
                    [UserDefaultManager setValue:[UserDefaultManager getValue:@"DefaultCurrencyCode"] key:@"DefaultCurrencySymbol"];
                }
                else {
                    [UserDefaultManager setValue:[[exchangeCurrencyData.availableCurrencyRatesArray objectAtIndex:i] currencysymbol] key:@"DefaultCurrencySymbol"];
                }
            }
        }
        [self getDashboardData];
    } onfailure:^(NSError *error) {
        
    }];
}

//Get category list data
- (void)getCategoryListData {
    DashboardDataModel *categoryList = [DashboardDataModel sharedUser];
    categoryList.categoryId=@"2";
    [categoryList getCategoryListDataOnSuccess:^(DashboardDataModel *userData)  {
        myDelegate.firstTime=false;
        myDelegate.categoryNameArray=[userData.categoryNameArray mutableCopy];
        self.categorySliderObjc.categoryDataArray=[myDelegate.categoryNameArray mutableCopy];
        [self.categorySliderObjc.categorySliderCollectionView reloadData];
        [self getConstantsListData];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)getDashboardData {
    DashboardDataModel *dashboardData = [DashboardDataModel sharedUser];
    [dashboardData getDashboardData:^(DashboardDataModel *userData)  {
        bannerImageData=userData;
        //[UserDefaultManager setValue:deviceToken key:@"deviceToken"];
        if ((nil!=[UserDefaultManager getValue:@"deviceToken"])&&nil!=[UserDefaultManager getValue:@"allowNotification"]) {
            [self saveDeviceToken];
        }
        else{
            [myDelegate stopIndicator];
        }
        if ([myDelegate.isShareUrlScreen isEqualToString:@"1"]) {
            myDelegate.isShareUrlScreen=@"0";
            [myDelegate stopIndicator];
            [self navigateToDetailScreen];
        }
        [self displayData];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)navigateToDetailScreen {
    if ([[myDelegate.shareEventIdDataDict allKeys] containsObject:@"product_id"]) {
        ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        obj.selectedProductId=[[myDelegate.shareEventIdDataDict objectForKey:@"product_id"] intValue];
        [self.navigationController pushViewController:obj animated:YES];
        return;
    }
    else if ([[myDelegate.shareEventIdDataDict allKeys] containsObject:@"event_id"]) {
        //StoryBoard navigation
        EventDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
        obj.selectedProductId=[[myDelegate.shareEventIdDataDict objectForKey:@"event_id"] intValue];
        [self.navigationController pushViewController:obj animated:YES];
        return;
    }
    else if ([[myDelegate.shareEventIdDataDict allKeys] containsObject:@"post_id"]) {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsCentreDetailViewController * webView=[sb instantiateViewControllerWithIdentifier:@"NewsCentreDetailViewController"];
        webView.newsPostId=[myDelegate.shareEventIdDataDict objectForKey:@"post_id"];
        [self.navigationController pushViewController:webView animated:YES];
        return;
    }
}

- (void)userLoginAsGuestDashboard {
    LoginModel *userLogin = [LoginModel sharedUser];
    [userLogin loginGuestUserOnSuccess:^(LoginModel *userData) {
        [self getCategoryListData];
    } onfailure:^(NSError *error) {
        
    }];
}

//Save device token for push notifications
- (void)saveDeviceToken {
    LoginModel *saveDeviceToken = [LoginModel sharedUser];
    [saveDeviceToken saveDeviceToken:^(LoginModel *deviceToken) {
        [myDelegate stopIndicator];
        [UserDefaultManager removeValue:@"enableNotification"];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)displayData {
    bannerImageArray=[bannerImageData.bannerImageArray mutableCopy];
    footerImageArray=[bannerImageData.footerBannerImageArray mutableCopy];
    bestSellerDataArray=[bannerImageData.bestSellerArray mutableCopy];
    healthyLivingDataArray=[bannerImageData.healthyLivingArray mutableCopy];
    samplersProductDataArray=[bannerImageData.samplersDataArray mutableCopy];
    productsDataArray=[bannerImageData.productsDataArray mutableCopy];
    promotionsDataArray=[bannerImageData.promotionsDataArray mutableCopy];
    //footerImageView
    [ImageCaching downloadImages:_footerImageView imageUrl:[[footerImageArray objectAtIndex:0] banerImageUrl] placeholderImage:@"banner_placeholder" isDashboardCell:true];
    [_productCollectionView reloadData];
    [_footerImageCollectionView reloadData];
    [self swipeImages];
}
#pragma mark - end

#pragma mark - Swipe Images
- (void)swipeImages {
    selectedIndex=0;
    [ImageCaching downloadImages:_bannerImageView imageUrl:[[bannerImageArray objectAtIndex:selectedIndex] banerImageUrl] placeholderImage:@"banner_placeholder" isDashboardCell:true];
    self.bannerImageView.userInteractionEnabled = YES;
    _footerImageView.userInteractionEnabled=YES;
    //Swipe gesture to swipe images to left
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesLeft:)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImagesRight:)];
    swipeImageRight.delegate=self;
    
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    // Adding the swipe gesture on image view
    [[self bannerImageView] addGestureRecognizer:swipeImageLeft];
    [[self bannerImageView] addGestureRecognizer:swipeImageRight];
    
    //tap gesture
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSingleTap:)];
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    [_bannerImageView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSingleTap:)];
    tapGesture2.numberOfTapsRequired = 1;
    
    [tapGesture2 setDelegate:self];
    [_footerImageView addGestureRecognizer:tapGesture2];
    tapGesture1.view.tag=1;
    tapGesture2.view.tag=2;
}

//Adding left animation to banner images
- (void)addLeftAnimationPresentToView:(UIView *)viewTobeAnimatedLeft {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [viewTobeAnimatedLeft.layer addAnimation:transition forKey:nil];
}

//Adding right animation to banner images
- (void)addRightAnimationPresentToView:(UIView *)viewTobeAnimatedRight {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [viewTobeAnimatedRight.layer addAnimation:transition forKey:nil];
}

//Swipe images in left direction
- (void)swipeImagesLeft:(UISwipeGestureRecognizer *)sender {
    selectedIndex++;
    if (selectedIndex<bannerImageArray.count) {
        [ImageCaching downloadImages:_bannerImageView imageUrl:[[bannerImageArray objectAtIndex:selectedIndex] banerImageUrl] placeholderImage:@"banner_placeholder" isDashboardCell:true];
        UIImageView *moveImageView = _bannerImageView;
        [self addLeftAnimationPresentToView:moveImageView];
    }
    else {
        selectedIndex--;
    }
}

//Swipe images in right direction
- (void)swipeImagesRight:(UISwipeGestureRecognizer *)sender {
    selectedIndex--;
    if (selectedIndex<bannerImageArray.count) {
        //check if screen is navigated from image question or not
        //set image from afnetworking
        [ImageCaching downloadImages:_bannerImageView imageUrl:[[bannerImageArray objectAtIndex:selectedIndex] banerImageUrl] placeholderImage:@"banner_placeholder" isDashboardCell:true];
        UIImageView *moveImageView = _bannerImageView;
        [self addRightAnimationPresentToView:moveImageView];
    }
    else {
        selectedIndex++;
    }
}
#pragma mark - end

#pragma mark - Tap gesture handle
//Handle tap gesture action
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    //handle Tap...
    DLog(@"%d", (int)tap.view.tag);
    if (tap.view.tag==1) {
        if (bannerImageArray.count>0) {
            [self handleBannerClickEvent:1];
        }
    }
    else {
        if (footerImageArray.count>0) {
            [self handleBannerClickEvent:2];
        }
    }
}

- (void)handleBannerClickEvent:(int)tapIndex {
    DashboardDataModel *tempBannerImageData;
    if (tapIndex==1) {
        tempBannerImageData=[bannerImageArray objectAtIndex:selectedIndex];
    }
    else {
        tempBannerImageData=[footerImageArray objectAtIndex:tapIndex-2];
    }
    if (nil!=tempBannerImageData.banerImageId&&NULL!=tempBannerImageData.banerImageId&&![tempBannerImageData.banerImageId isEqualToString:@""]) {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if ([tempBannerImageData.bannerImageType isEqualToString:@"product_list"]) {
            //Navigate to product list
            DLog(@"%@",tempBannerImageData.banerImageId);
            myDelegate.isProductList=true;
            myDelegate.selectedCategoryIndex=[self selectedCategoryIndex:[tempBannerImageData.banerImageId intValue]];
            ProductListingViewController * detailScreen=[sb instantiateViewControllerWithIdentifier:@"ProductListingViewController"];
            detailScreen.selectedProductCategoryId=[tempBannerImageData.banerImageId intValue];
            [self.navigationController pushViewController:detailScreen animated:YES];
        }
        else if ([tempBannerImageData.bannerImageType isEqualToString:@"product_details"]) {
            //Navigate to product detail
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProductDetailViewController * detailScreen=[sb instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
            detailScreen.selectedProductId=[tempBannerImageData.banerImageId intValue];
            [self.navigationController pushViewController:detailScreen animated:YES];
        }
        else if ([tempBannerImageData.bannerImageType isEqualToString:@"event_list"]) {
            //Navigate to product list
            myDelegate.isProductList=false;
            ProductListingViewController * detailScreen=[sb instantiateViewControllerWithIdentifier:@"ProductListingViewController"];
            detailScreen.selectedProductCategoryId=[tempBannerImageData.banerImageId intValue];
            [self.navigationController pushViewController:detailScreen animated:YES];
        }
        else if ([tempBannerImageData.bannerImageType isEqualToString:@"event_details"]) {
            //Screen is not available
        }
    }
}

- (int)selectedCategoryIndex:(int)productId {
    int index=-1;
    for (int i=0; i<myDelegate.categoryNameArray.count; i++) {
        if ([[[myDelegate.categoryNameArray objectAtIndex:i] objectForKey:@"id"] intValue]==productId) {
            index=i;
            break;
        }
    }
    return index;
}
#pragma mark - end
@end
