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

@interface ProductDetailViewController ()<UIGestureRecognizerDelegate> {
@private
    ProductDataModel *productDetailModelData;
    float productDetailCellHeight;
    BOOL isServiceCalled;
    UIImageView *qrCodeImage;
    int selectedMediaIndex, currentQuantity;
}
@property (strong, nonatomic) IBOutlet UITableView *productDetailTableView;
@end

@implementation ProductDetailViewController
@synthesize selectedProductId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"Product");
    [self addLeftBarButtonWithImage:true];
    [self viewInitialization];
    [myDelegate showIndicator];
    [self performSelector:@selector(getProductDetailData) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
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
    qrCodeImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80*2, 80*2)];
    NSString *qrString = [NSString stringWithFormat:@"RohitModiQRCode"];
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
        return [DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.productName font:[UIFont montserratMediumWithSize:20] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:52]+24;
    }
    else if (indexPath.row==1) {
        return [DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.productShortDescription font:[UIFont montserratMediumWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:30]+3;
    }
    else if (indexPath.row==2) {
        return 15;
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
    ProductDetailTableViewCell *cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailNameCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailNameCell"];
        }
        [cell displayProductName:productDetailModelData.productName];
    }
    else if (indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailDescriptionCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailDescriptionCell"];
        }
        [cell displayProductDescription:productDetailModelData.productShortDescription];
    }
    else if (indexPath.row==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailRatingCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailRatingCell"];
        }
        [cell displayRating:productDetailModelData.productRating];
    }
    else if (indexPath.row==3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailImageCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailImageCell"];
        }
        [cell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] qrCode:qrCodeImage.image];
        cell.productImageView.userInteractionEnabled=YES;
        //Swipe gesture to swipe images to left
        UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageLeft)];
        swipeImageLeft.delegate=self;
        UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageRight)];
        swipeImageRight.delegate=self;
        
        // Setting the swipe direction.
        [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
        // Adding the swipe gesture on image view
        [cell.contentView addGestureRecognizer:swipeImageLeft];
        [cell.contentView addGestureRecognizer:swipeImageRight];
    }
    else if (indexPath.row==4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailMediaCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailMediaCell"];
        }
        [cell.productMediaCollectionView reloadData];
    }
    else if (indexPath.row==5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailPriceCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailPriceCell"];
        }
        [cell displayProductPrice:productDetailModelData currentQuantity:currentQuantity];
        cell.incrementCartButton.tag=indexPath.row;
        cell.removeFromCartButton.tag=indexPath.row;
        [cell.incrementCartButton addTarget:self action:@selector(increaseQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.removeFromCartButton addTarget:self action:@selector(removeQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailInfoCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailInfoCell"];
        }
        [cell displayProductInfo];
    }
    else if (indexPath.row==7) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailAddCartButtonCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailAddCartButtonCell"];
        }
        [cell displayAddToCartButton];
        cell.addToCartButton.tag=indexPath.row;
        [cell.addToCartButton addTarget:self action:@selector(insertInCartItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==8) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descriptionCell"];
        }
    }
    else if (indexPath.row==9) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"benefitCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"benefitCell"];
        }
    }
    else if (indexPath.row==10) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"brandCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brandCell"];
        }
    }
    else if (indexPath.row==11) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reviewCell"];
        }
    }
    else if (indexPath.row==12) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"followCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"followCell"];
        }
    }
    else if (indexPath.row==13) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"wishlistCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wishlistCell"];
        }
    }
    else if (indexPath.row==14) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareCell"];
        }
    }
    else if (indexPath.row==15) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationCell"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==3 && [[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
        NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
    /*Code is commented for 360 video media type
     else if(indexPath.row==3 && [[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
     }*/
    else if (indexPath.row==8) {
        //Description action
    }
    else if (indexPath.row==9) {
        //Benifit action
    }
    else if (indexPath.row==10) {
        //Brand action
    }
    else if (indexPath.row==11) {
        //Review action
    }
    else if (indexPath.row==12) {
        //Follow action
    }
    else if (indexPath.row==13) {
        //Wishlist action
    }
    else if (indexPath.row==14) {
        //Share action
    }
    else if (indexPath.row==15) {
        //Location action
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
    [productMediaCell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:indexPath.row] qrCode:qrCodeImage.image];
    return productMediaCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedMediaIndex=(int)indexPath.row;
    ProductDetailTableViewCell *tempCell = [_productDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [tempCell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] qrCode:qrCodeImage.image];
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
        [_productDetailTableView reloadData];
    } onfailure:^(NSError *error) {
        
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
    if(currentQuantity>1){
        currentQuantity-=1;
        cell.cartNumberItemLabel.text=[NSString stringWithFormat:@"%d",currentQuantity];
    }
}

- (IBAction)insertInCartItemAction:(UIButton *)sender {
    productDetailModelData.productQuantity=[NSNumber numberWithInt:currentQuantity];
    [UpdateCartItem addProductCartItem:[productDetailModelData copy]];
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
    }
    else {
        selectedMediaIndex = 0;
    }
}
#pragma mark - end
@end
