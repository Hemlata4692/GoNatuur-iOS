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

@interface DashboardViewController ()<UIGestureRecognizerDelegate> {
@private
    int selectedIndex;
    int buttonTag;
    BOOL firstTime;
    NSMutableArray *bannerImageArray;
    NSMutableArray *footerImageArray;
    NSMutableArray *bestSellerDataArray;
    NSMutableArray *healthyLivingDataArray;
    NSMutableArray *samplersProductDataArray;
    DashboardDataModel * bannerImageData;
    CurrencyDataModel *exchangeCurrencyData;
}
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonSeperator;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *footerImageCollectionView;

@end

@implementation DashboardViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    firstTime=true;
    bannerImageArray=[[NSMutableArray alloc]init];
    bestSellerDataArray=[[NSMutableArray alloc]init];
    footerImageArray=[[NSMutableArray alloc]init];
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
    NSLog(@"%@",NSLocalizedText(@"GoNatuur"));
    [self addLeftBarButtonWithImage:false];
    myDelegate.selectedCategoryIndex=-1;
    [self showSelectedTab:1];
    if (firstTime) {
        [myDelegate showIndicator];
        [self performSelector:@selector(getCategoryListData) withObject:nil afterDelay:.1];
    }
    else {
        [myDelegate showIndicator];
        [self performSelector:@selector(getDashboardData) withObject:nil afterDelay:.1];
    }
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
        else {
            return samplersProductDataArray.count;
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
        else {
            [productCell displayProductListData:[samplersProductDataArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
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
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductDetailViewController * detailScreen=[sb instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        if (buttonTag==1) {
            if ([[[bestSellerDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
                return;
            }
            detailScreen.selectedProductId=[[[bestSellerDataArray objectAtIndex:indexPath.item] productId] intValue];
        }
        else if (buttonTag==2) {
            if ([[[healthyLivingDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
                return;
            }
            detailScreen.selectedProductId=[[[healthyLivingDataArray objectAtIndex:indexPath.item] productId] intValue];
        }
        else {
            if ([[[samplersProductDataArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
                [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
                return;
            }
            detailScreen.selectedProductId=[[[samplersProductDataArray objectAtIndex:indexPath.item] productId] intValue];
        }
        [self.navigationController pushViewController:detailScreen animated:YES];
    }
    else {
        [self handleBannerClickEvent:(int)indexPath.item+3];
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
//Get default currency
- (void)getDefaultCurrency {
    CurrencyDataModel *currencyData = [CurrencyDataModel sharedUser];
    [currencyData getCurrencyData:^(CurrencyDataModel *userData)  {
        exchangeCurrencyData=userData;
        for (int i=0; i<exchangeCurrencyData.availableCurrencyRatesArray.count; i++) {
            if ([[UserDefaultManager getValue:@"DefaultCurrencyCode"] containsString:[[exchangeCurrencyData.availableCurrencyRatesArray objectAtIndex:i] currencyExchangeCode]]) {
                [UserDefaultManager setValue:[[exchangeCurrencyData.availableCurrencyRatesArray objectAtIndex:i] currencyExchangeRates] key:@"ExchangeRates"];
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
        myDelegate.categoryNameArray=[userData.categoryNameArray mutableCopy];
        self.categorySliderObjc.categoryDataArray=[myDelegate.categoryNameArray mutableCopy];
        [self.categorySliderObjc.categorySliderCollectionView reloadData];
        [self getDefaultCurrency];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)getDashboardData {
    DashboardDataModel *dashboardData = [DashboardDataModel sharedUser];
    [dashboardData getDashboardData:^(DashboardDataModel *userData)  {
        firstTime=false;
        bannerImageData=userData;
        [self displayData];
        if (nil!=[UserDefaultManager getValue:@"deviceToken"]&&NULL!=[UserDefaultManager getValue:@"deviceToken"]&&nil!=[UserDefaultManager getValue:@"enableNotification"]) {
            [self saveDeviceToken];
        }
        else{
            [myDelegate stopIndicator];
        }
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
