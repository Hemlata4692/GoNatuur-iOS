//
//  ProductDetailViewController.m
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDataModel.h"
#import "DynamicHeightWidth.h"
#import "ProductDetailCollectionViewCell.h"
#import "ProductDetailTableViewCell.h"
#import "UpdateCartItem.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "WebViewController.h"
#import "ReviewListingViewController.h"
#import "UIView+Toast.h"

@interface ProductDetailViewController ()<UIGestureRecognizerDelegate> {
@private
    ProductDataModel *productDetailModelData;
    float productDetailCellHeight;
    BOOL isServiceCalled;
    UIImageView *qrCodeImage;
    int selectedMediaIndex, currentQuantity;
    NSArray *cellIdentifierArray;
}
@property (strong, nonatomic) IBOutlet UITableView *productDetailTableView;
@end

@implementation ProductDetailViewController
@synthesize selectedProductId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInitialization];
    [myDelegate showIndicator];
    [self performSelector:@selector(getProductDetailData) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"Product");
    [self addLeftBarButtonWithImage:true];
    cellIdentifierArray = @[@"productDetailNameCell", @"productDetailDescriptionCell", @"productDetailRatingCell", @"productDetailImageCell", @"productDetailMediaCell",@"productDetailPriceCell", @"productDetailInfoCell",@"productDetailAddCartButtonCell",@"descriptionCell",@"benefitCell",@"brandCell",@"reviewCell",@"followCell",@"wishlistCell",@"shareCell",@"locationCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Initialized view
- (void)viewInitialization {
    isServiceCalled=false;
    productDetailCellHeight=0.0;
    selectedMediaIndex=0;
    currentQuantity=1;
}

//Create QRCode
- (void)makeQRCode {
    qrCodeImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80*4, 80*4)];
    NSString *qrString = [NSString stringWithFormat:@"%@%@%s",@"http://dev.gonatuur.com/",productDetailModelData.productUrlKey,".html"];
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = qrCodeImage.frame.size.width / qrImage.extent.size.width;
    float scaleY = qrCodeImage.frame.size.height / qrImage.extent.size.height;
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    qrCodeImage.image = [UIImage imageWithCIImage:qrImage
                                            scale:[UIScreen mainScreen].scale
                                      orientation:UIImageOrientationUp];
}
#pragma mark - end

#pragma mark - Table view datasource/delegates
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (isServiceCalled) {
        return 16;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return [DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.productName font:[UIFont montserratSemiBoldWithSize:20] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:52]+24;
    }
    else if (indexPath.row==1) {
        return [DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.productShortDescription font:[UIFont montserratSemiBoldWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:1000]+5;
    }
    else if (indexPath.row==2) {
        return 22;
    }
    else if (indexPath.row==3) {
        return 290;
    }
    else if (indexPath.row==4) {
        return 80;
    }
    else if (indexPath.row==5) {
        return 75;
    }
    else if (indexPath.row==6) {
        float tempHeight=[DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"Shipping is free if the total purchase is above USD$100.") font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
        tempHeight+=[DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"Products can be returned within 30 days of purchase, subject to the following conditions.") font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
        return tempHeight+2;
    }
    else if (indexPath.row==7) {
        return 45;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [cellIdentifierArray objectAtIndex:indexPath.row];
    ProductDetailTableViewCell* cell = [_productDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0) {
        [cell displayProductName:productDetailModelData.productName];
    }
    else if (indexPath.row==1) {
        [cell displayProductDescription:productDetailModelData.productShortDescription];
    }
    else if (indexPath.row==2) {
        [cell displayRating:productDetailModelData.productRating];
    }
    else if (indexPath.row==3) {
        [cell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] qrCode:qrCodeImage.image];
        cell.productImageView.userInteractionEnabled=YES;
        [self addSwipeGesture:cell.contentView];
    }
    else if (indexPath.row==4) {
        [cell.productMediaCollectionView reloadData];
    }
    else if (indexPath.row==5) {
        [cell displayProductPrice:productDetailModelData currentQuantity:currentQuantity];
        cell.incrementCartButton.tag=indexPath.row;
        cell.removeFromCartButton.tag=indexPath.row;
        [cell.incrementCartButton addTarget:self action:@selector(increaseQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.removeFromCartButton addTarget:self action:@selector(removeQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==6) {
        [cell displayProductInfo];
    }
    else if (indexPath.row==7) {
        [cell displayAddToCartButton];
        cell.addToCartButton.tag=indexPath.row;
        [cell.addToCartButton addTarget:self action:@selector(insertInCartItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==12) {
        UILabel *cellLabel=(UILabel *)[cell viewWithTag:10];
        if ([productDetailModelData.following isEqualToString:@"1"]) {
            cellLabel.text=NSLocalizedText(@"unfollow");
        }
        else{
            cellLabel.text=NSLocalizedText(@"follow");
        }
    }
    else if (indexPath.row==13) {
        UILabel *cellLabel=(UILabel *)[cell viewWithTag:11];
        if ([productDetailModelData.wishlist isEqualToString:@"1"]) {
            cellLabel.text=NSLocalizedText(@"wishlistAdded");
        }
        else{
            cellLabel.text=NSLocalizedText(@"wishlist");
        }
    }
    return cell;
}

- (void)addSwipeGesture:(UIView *)view {
    //Swipe gesture to swipe images to left
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageLeft)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageRight)];
    swipeImageRight.delegate=self;
    
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    // Adding the swipe gesture on image view
    [view addGestureRecognizer:swipeImageLeft];
    [view addGestureRecognizer:swipeImageRight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==3 && [[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
        NSURL *videoURL = [NSURL URLWithString:@""];
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
    else if (indexPath.row==8) {
        //Description action
        [self navigateToView:NSLocalizedText(@"Description") webViewData:productDetailModelData.productDescription viewIdentifier:@"webView" productId:0];
    }
    else if (indexPath.row==9) {
        //Benefit action
        [self navigateToView:NSLocalizedText(@"Benefits&Usage") webViewData:productDetailModelData.productBenefitsUsage viewIdentifier:@"webView" productId:0];
    }
    else if (indexPath.row==10) {
        //Brand action
        [self navigateToView:NSLocalizedText(@"BrandStory") webViewData:productDetailModelData.productBrandStory viewIdentifier:@"webView" productId:0];
    }
    else if (indexPath.row==11) {
        //Review action
        [self navigateToView:@"" webViewData:@"" viewIdentifier:@"reviewView" productId:[NSNumber numberWithInt:selectedProductId]];
    }
    else if (indexPath.row==12) {
        //Follow action
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
            [myDelegate checkGuestAccess];
        }
        else {
        if ([productDetailModelData.following isEqualToString:@"1"]) {
            [self unFollowProduct:(int)indexPath.row];
        }
        else {
            [self followProduct:(int)indexPath.row];
        }
        }
    }
    else if (indexPath.row==13) {
        //Wishlist action
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
            [myDelegate checkGuestAccess];
        }
        else {
        if ([productDetailModelData.following isEqualToString:@"1"]) {
            [self.view makeToast:NSLocalizedText(@"alreadyAddedWishlist")];
        }
        else {
            [self addToWishlist:(int)indexPath.row];
        }
        }
        
    }
    else if (indexPath.row==14) {
        //Share action
    }
    else if (indexPath.row==15) {
        //Location action
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WebViewController * webView=[sb instantiateViewControllerWithIdentifier:@"WebViewController"];
        webView.navigationTitle=NSLocalizedText(@"Where to buy");
        webView.productDetaiData=productDetailModelData.productWhereToBuy;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (void)navigateToView:(NSString *)navTitle webViewData:(NSString *)webViewData viewIdentifier:(NSString *)viewIdentifier productId:(NSNumber *)productId {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([viewIdentifier isEqualToString:@"webView"]) {
        WebViewController * webView=[sb instantiateViewControllerWithIdentifier:@"WebViewController"];
        webView.navigationTitle=navTitle;
        webView.productDetaiData=webViewData;
        [self.navigationController pushViewController:webView animated:YES];
    }
    else {
        ReviewListingViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewListingViewController"];
        reviewView.productID =productId;
        [self.navigationController pushViewController:reviewView animated:YES];
    }
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (isServiceCalled) {
        return productDetailModelData.productMediaArray.count;
    }
    return 0;
}

- (ProductDetailCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailCollectionViewCell *productMediaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productImageVideoCell" forIndexPath:indexPath];
    [productMediaCell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:indexPath.row] qrCode:qrCodeImage.image selectedIndex:selectedMediaIndex currentIndex:(int)indexPath.row];
    return productMediaCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedMediaIndex=(int)indexPath.row;
    ProductDetailTableViewCell *tempCell = [_productDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [tempCell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] qrCode:qrCodeImage.image];
    [collectionView reloadData];
}
#pragma mark - end

#pragma mark - Webservice
//Get product detail
- (void)getProductDetailData {
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData getProductDetailOnSuccess:^(ProductDataModel *productDetailData)  {
        productDetailModelData=productDetailData;
        [self makeQRCode];
        int tempIndex=-1;
        for (int i=0; i<productDetailModelData.productMediaArray.count; i++) {
            if ([[[productDetailModelData.productMediaArray objectAtIndex:i] objectForKey:@"media_type"] isEqualToString:@"image"]) {
                tempIndex=i+1;
            }
            else {
                tempIndex=i;
                break;
            }
        }
        [productDetailModelData.productMediaArray insertObject:@{@"media_type":@"QRCode"} atIndex:(tempIndex==-1?0:tempIndex)];
        [myDelegate stopIndicator];
        isServiceCalled=true;
        currentQuantity=[productDetailData.productMinQuantity intValue];
        [_productDetailTableView reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}

//Add product to wishlist
- (void)addToWishlist:(int)btnTag {
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    ProductDetailTableViewCell * cell = (ProductDetailTableViewCell *)[_productDetailTableView cellForRowAtIndexPath:index];
    UILabel *cellLabel=(UILabel *)[cell viewWithTag:11];
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData addProductWishlistOnSuccess:^(ProductDataModel *productDetailData)  {
        cellLabel.text=NSLocalizedText(@"wishlistAdded");
    } onfailure:^(NSError *error) {
        cellLabel.text=NSLocalizedText(@"wishlist");
    }];
    
}

//Add to cart
- (void)addToCartProductService {
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productQuantity=productDetailModelData.productQuantity;
    productData.productSku=productDetailModelData.productSku;
    [productData addToCartProductOnSuccess:^(ProductDataModel *productDetailData)  {
        [myDelegate stopIndicator];
        [UserDefaultManager setValue:[NSNumber numberWithInt:[[UserDefaultManager getValue:@"quoteCount"] intValue]+currentQuantity] key:@"quoteCount"];
        [self updateCartBadge];
        [self.view makeToast:NSLocalizedText(@"Added to cart")];
    } onfailure:^(NSError *error) {
        
    }];
}

//Follow product
- (void)followProduct:(int)btnTag {
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    ProductDetailTableViewCell * cell = (ProductDetailTableViewCell *)[_productDetailTableView cellForRowAtIndexPath:index];
    UILabel *cellLabel=(UILabel *)[cell viewWithTag:10];
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData followProductOnSuccess:^(ProductDataModel *productDetailData)  {
        cellLabel.text=NSLocalizedText(@"unfollow");
        productDetailModelData.following=@"1";
    } onfailure:^(NSError *error) {
        cellLabel.text=NSLocalizedText(@"follow");
    }];
}

//Unfollow product
- (void)unFollowProduct:(int)btnTag {
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    ProductDetailTableViewCell * cell = (ProductDetailTableViewCell *)[_productDetailTableView cellForRowAtIndexPath:index];
    UILabel *cellLabel=(UILabel *)[cell viewWithTag:10];
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData unFollowProductOnSuccess:^(ProductDataModel *productDetailData)  {
        cellLabel.text=NSLocalizedText(@"follow");
        productDetailModelData.following=@"0";
    } onfailure:^(NSError *error) {
        cellLabel.text=NSLocalizedText(@"unfollow");
    }];
    
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)increaseQuantityAction:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    ProductDetailTableViewCell *cell = [_productDetailTableView cellForRowAtIndexPath:indexPath];
    if([productDetailModelData.productMaxQuantity intValue]>currentQuantity){
        currentQuantity+=1;
        cell.cartNumberItemLabel.text=[NSString stringWithFormat:@"%d",currentQuantity];
    }
}

- (IBAction)removeQuantityAction:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    ProductDetailTableViewCell *cell = [_productDetailTableView cellForRowAtIndexPath:indexPath];
    if(currentQuantity>[productDetailModelData.productMinQuantity intValue]){
        currentQuantity-=1;
        cell.cartNumberItemLabel.text=[NSString stringWithFormat:@"%d",currentQuantity];
    }
}

- (IBAction)insertInCartItemAction:(UIButton *)sender {
    productDetailModelData.productQuantity=[NSNumber numberWithInt:currentQuantity];
    [myDelegate showIndicator];
    [self performSelector:@selector(addToCartProductService) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Swipe Images
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
- (void)swipeIntroImageLeft {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    ProductDetailTableViewCell *cell = [_productDetailTableView cellForRowAtIndexPath:indexPath];
    selectedMediaIndex++;
    if (selectedMediaIndex < productDetailModelData.productMediaArray.count) {
        [cell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] qrCode:qrCodeImage.image];
        UIView *moveIMageView = cell.contentView;
        [self addLeftAnimationPresentToView:moveIMageView];
        [self scrollMediaCollectionViewAtIndex];
    }
    else {
        selectedMediaIndex = (int)productDetailModelData.productMediaArray.count - 1;
    }
}

//Swipe images in right direction
- (void)swipeIntroImageRight {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    ProductDetailTableViewCell *cell = [_productDetailTableView cellForRowAtIndexPath:indexPath];
    selectedMediaIndex--;
    if (selectedMediaIndex>=0) {
        [cell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] qrCode:qrCodeImage.image];
        UIView *moveIMageView = cell.contentView;
        [self addRightAnimationPresentToView:moveIMageView];
        [self scrollMediaCollectionViewAtIndex];
    }
    else {
        selectedMediaIndex = 0;
    }
}

- (void)scrollMediaCollectionViewAtIndex {
    ProductDetailTableViewCell *tempCell = [_productDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [tempCell.productMediaCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedMediaIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    [tempCell.productMediaCollectionView reloadData];
}
#pragma mark - end
@end
