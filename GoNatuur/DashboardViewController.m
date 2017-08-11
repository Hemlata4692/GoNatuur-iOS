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

@interface DashboardViewController ()<UIGestureRecognizerDelegate> {
@private
    int selectedIndex;
    int buttonTag;
    NSMutableArray *bannerImageArray;
    NSMutableArray *footerImageArray;
    NSMutableArray *bestSellerDataArray;
    NSMutableArray *healthyLivingDataArray;
    NSMutableArray *samplersProductDataArray;
    DashboardDataModel * bannerImageData;
}

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
    self.title=@"GoNatuur";
    [self addLeftBarButtonWithImage:false];
    // Do any additional setup after loading the view.
    bannerImageArray=[[NSMutableArray alloc]init];
    bestSellerDataArray=[[NSMutableArray alloc]init];
    footerImageArray=[[NSMutableArray alloc]init];
    healthyLivingDataArray=[[NSMutableArray alloc]init];
    samplersProductDataArray=[[NSMutableArray alloc]init];
    [self viewCustomisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [myDelegate showIndicator];
    [self performSelector:@selector(getCategoryListData) withObject:nil afterDelay:.1];
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
            [productCell displayProductListData:[bestSellerDataArray objectAtIndex:indexPath.item]];
        }
        else if (buttonTag==2) {
            [productCell displayProductListData:[healthyLivingDataArray objectAtIndex:indexPath.item]];
        }
        else {
            [productCell displayProductListData:[samplersProductDataArray objectAtIndex:indexPath.item]];
        }
        [productCell.contentView addShadow:productCell.contentView color:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
        return productCell;
    }
    else {
        DasboardDataCollectionViewCell *footerImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footerImageCell" forIndexPath:indexPath];
        [footerImageCell displayFooterBannerData:[footerImageArray objectAtIndex:indexPath.item]];
        return footerImageCell;
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)bestSellerButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
    buttonTag=1;
    [self reloadCollectionView];
}
- (IBAction)healthyLivingButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
    buttonTag=2;
    [self reloadCollectionView];
}
- (IBAction)samplersButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
    buttonTag=3;
    [self reloadCollectionView];
}

- (void)reloadCollectionView {
    [_productCollectionView reloadData];
//    [_productCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
//                                   atScrollPosition:UICollectionViewScrollPositionTop
//                                           animated:YES];
    [_productCollectionView setContentOffset:CGPointZero animated:YES];

}
#pragma mark - end

#pragma mark - Set animation for button bottom selection
- (void)reframeSeperatorLabel:(UIButton *)button {
    CGPoint endFrame = button.center;
    [UIView animateWithDuration:0.5 animations:^{
        _buttonSeperator.center = endFrame;
        _buttonSeperator.frame=CGRectMake(button.frame.origin.x+(button.frame.size.width/2)-(_buttonSeperator.frame.size.width/2), button.frame.size.height-2, _buttonSeperator.frame.size.width, _buttonSeperator.frame.size.height);
    }];
}
#pragma mark - end

#pragma mark - Webservice
//Get category list data
- (void)getCategoryListData {
    DashboardDataModel *categoryList = [DashboardDataModel sharedUser];
    categoryList.categoryId=@"2";
    [categoryList getCategoryListDataOnSuccess:^(DashboardDataModel *userData)  {
        self.categorySliderObjc.categoryDataArray=[userData.categoryNameArray mutableCopy];
        [self.categorySliderObjc.categorySliderCollectionView reloadData];
        [self getDashboardData];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)getDashboardData {
    DashboardDataModel *dashboardData = [DashboardDataModel sharedUser];
    [dashboardData getDashboardData:^(DashboardDataModel *userData)  {
        [myDelegate stopIndicator];
        bannerImageData=userData;
        [self displayData];
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
    bannerImageData=[footerImageArray objectAtIndex:0];
    [ImageCaching downloadImages:_footerImageView imageUrl:bannerImageData.banerImageUrl placeholderImage:@"banner_placeholder"];
    [_productCollectionView reloadData];
    [_footerImageCollectionView reloadData];
    [self swipeImages];
}
#pragma mark - end

#pragma mark - Swipe Images
- (void)swipeImages {
    selectedIndex=0;
    bannerImageData=[bannerImageArray objectAtIndex:selectedIndex];
    [ImageCaching downloadImages:_bannerImageView imageUrl:bannerImageData.banerImageUrl placeholderImage:@"banner_placeholder"];
    self.bannerImageView.userInteractionEnabled = YES;
    
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

//swipe images in left direction
- (void)swipeImagesLeft:(UISwipeGestureRecognizer *)sender {
    selectedIndex++;
    if (selectedIndex<bannerImageArray.count) {
        bannerImageData=[bannerImageArray objectAtIndex:selectedIndex];
        [ImageCaching downloadImages:_bannerImageView imageUrl:bannerImageData.banerImageUrl placeholderImage:@"banner_placeholder"];
        UIImageView *moveImageView = _bannerImageView;
        [self addLeftAnimationPresentToView:moveImageView];
    }
    else {
        selectedIndex--;
    }
}

//swipe images in right direction
- (void)swipeImagesRight:(UISwipeGestureRecognizer *)sender {
    selectedIndex--;
    if (selectedIndex<bannerImageArray.count) {
        //check if screen is navigated from image question or not
        bannerImageData=[bannerImageArray objectAtIndex:selectedIndex];
        //set image from afnetworking
        [ImageCaching downloadImages:_bannerImageView imageUrl:bannerImageData.banerImageUrl placeholderImage:@"banner_placeholder"];
        UIImageView *moveImageView = _bannerImageView;
        [self addRightAnimationPresentToView:moveImageView];
    }
    else {
        selectedIndex++;
    }
}
#pragma mark - end

@end
