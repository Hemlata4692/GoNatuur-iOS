//
//  EventDetailViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 10/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "EventDetailViewController.h"
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
#import <MediaPlayer/MediaPlayer.h>
#import "HCYoutubeParser.h"
#import "AttendeesViewController.h"
#import "TicketingViewController.h"
#import "GoNatuurPickerView.h"
#import "ShareViewController.h"

@interface EventDetailViewController ()<UIGestureRecognizerDelegate,GoNatuurPickerViewDelegate> {
@private
    ProductDataModel *productDetailModelData;
    float productDetailCellHeight;
    BOOL isServiceCalled;
    UIImageView *qrCodeImage;
    int selectedMediaIndex, currentQuantity;
    NSArray *cellIdentifierArray;
    bool isServiceCalledMPMoviePlayerDone;
    GoNatuurPickerView *customerTicketPicker;
    int selectedPickerIndex, ticketBtnTag;
    NSMutableArray *ticketArray;
}
@property (strong, nonatomic) IBOutlet UITableView *productDetailTableView;
@end

@implementation EventDetailViewController
@synthesize selectedProductId;
@synthesize reviewAdded;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInitialization];
    // Do any additional setup after loading the view.
    if (isServiceCalledMPMoviePlayerDone) {
        [myDelegate showIndicator];
        [self performSelector:@selector(getEventDetailData) withObject:nil afterDelay:.1];
    }
    else {
        isServiceCalledMPMoviePlayerDone=true;
    }
    [self addCustomPickerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"EventDetails");
    [self addLeftBarButtonWithImage:true];
    cellIdentifierArray = @[@"productDetailNameCell", @"productDetailDescriptionCell", @"productDetailRatingCell", @"productDetailImageCell", @"productDetailMediaCell",@"ticketingPriceCell",@"productDetailPriceCell", @"productDetailInfoCell",@"productDetailAddCartButtonCell",@"descriptionCell",@"mapCell",@"attendingCell",@"ticketCell",@"reviewCell",@"followCell",@"wishlistCell",@"shareCell",@"locationCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //Bring front view picker view
    [self.view bringSubviewToFront:customerTicketPicker.goNatuurPickerViewObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end

#pragma mark - Initialized view
- (void)viewInitialization {
    reviewAdded=@"0";
    isServiceCalledMPMoviePlayerDone=true;
    isServiceCalled=false;
    productDetailCellHeight=0.0;
    selectedMediaIndex=0;
    currentQuantity=1;
}

//Create QRCode
- (void)makeQRCode {
    qrCodeImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80*4, 80*4)];
    NSString *qrString = [NSString stringWithFormat:@"%@%@%s",BaseUrl,productDetailModelData.productUrlKey,".html"];
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
        return 18;
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
    else if (indexPath.row==6) {
        return 75;
    }
    else if (indexPath.row==7) {
        float tempHeight=[DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"Shipping is free if the total purchase is above USD$100.") font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
        tempHeight+=[DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"Products can be returned within 30 days of purchase, subject to the following conditions.") font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
        return tempHeight+5;
    }
    else if (indexPath.row==8) {
        return 50;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [cellIdentifierArray objectAtIndex:indexPath.row];
    ProductDetailTableViewCell* cell = [_productDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *cellLabel=(UILabel *)[cell viewWithTag:1];
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
        [cell displayTicketingData:@""];
         [cell.selectTicketingButton addTarget:self action:@selector(selectTicketType:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectTicketingButton.tag=indexPath.row;
    }
    else if (indexPath.row==6) {
        [cell displayProductPrice:productDetailModelData currentQuantity:currentQuantity];
        cell.incrementCartButton.tag=indexPath.row;
        cell.removeFromCartButton.tag=indexPath.row;
        [cell.incrementCartButton addTarget:self action:@selector(increaseQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.removeFromCartButton addTarget:self action:@selector(removeQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==7) {
        [cell displayProductInfo];
    }
    else if (indexPath.row==8) {
        [cell displayAddToCartButton:@"EventDetail"];
        cell.addToCartButton.tag=indexPath.row;
        [cell.addToCartButton addTarget:self action:@selector(insertInCartItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==9) {
        cellLabel.text=NSLocalizedText(@"Description");
    }
    else if (indexPath.row==10) {
        cellLabel.text=NSLocalizedText(@"mapLocation");
    }
    else if (indexPath.row==11) {
        cellLabel.text=NSLocalizedText(@"attending");
    }
    else if (indexPath.row==12) {
        cellLabel.text=NSLocalizedText(@"ticketing");
    }

    else if (indexPath.row==13) {
        cellLabel.text=NSLocalizedText(@"Comments");//Comments
    }
    else if (indexPath.row==14) {
        UILabel *cellLabel=(UILabel *)[cell viewWithTag:10];
        if ([productDetailModelData.following isEqualToString:@"1"]) {
            cellLabel.text=NSLocalizedText(@"unfollow");
            cellLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        }
        else{
            cellLabel.text=NSLocalizedText(@"follow");
            cellLabel.textColor=[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        }
    }
    else if (indexPath.row==15) {
        UILabel *cellLabel=(UILabel *)[cell viewWithTag:11];
        if ([productDetailModelData.wishlist isEqualToString:@"1"]) {
            cellLabel.text=NSLocalizedText(@"wishlistAdded");
            cellLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        }
        else{
            cellLabel.text=NSLocalizedText(@"wishlist");
            cellLabel.textColor=[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        }
    }
    else if (indexPath.row==16) {
        cellLabel.text=NSLocalizedText(@"socialMedia");
    }
    else if (indexPath.row==17) {
        cellLabel.text=NSLocalizedText(@"Where to buy");
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
    if (indexPath.row==3 && ![[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"media_type"] isEqualToString:@"image"]) {
        NSURL *videoURL = [NSURL URLWithString:[[[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"extension_attributes"] objectForKey:@"video_content"] objectForKey:@"video_url"]];
        [myDelegate showIndicator];
        [self performSelector:@selector(showYouTubeVideo:) withObject:videoURL afterDelay:.1];
    }
    else if (indexPath.row==9) {
        //Description action
        [self navigateToView:NSLocalizedText(@"Description") webViewData:productDetailModelData.productDescription viewIdentifier:@"webView" productId:0 reviewId:@"" isLocation:@"No"];
    }
    else if (indexPath.row==10) {
        //map action
        [self navigateToView:NSLocalizedText(@"mapLocation") webViewData:productDetailModelData.productBenefitsUsage viewIdentifier:@"webView" productId:0 reviewId:@"" isLocation:@"Yes"];
    }
    else if (indexPath.row==11) {
        //attending action
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AttendeesViewController * attendeeView=[sb instantiateViewControllerWithIdentifier:@"AttendeesViewController"];
        attendeeView.attendeesArray=[productDetailModelData.attendiesArray mutableCopy];
        [self.navigationController pushViewController:attendeeView animated:YES];
    }
    else if (indexPath.row==12) {
        //ticket action
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TicketingViewController * ticketView=[sb instantiateViewControllerWithIdentifier:@"TicketingViewController"];
        ticketView.ticketingArray=[productDetailModelData.ticketingArray mutableCopy];
        [self.navigationController pushViewController:ticketView animated:YES];
    }
    else if (indexPath.row==13) {
        //Review action
        [self navigateToView:NSLocalizedText(@"Comments") webViewData:@"" viewIdentifier:@"reviewView" productId:[NSNumber numberWithInt:selectedProductId] reviewId:productDetailModelData.reviewId isLocation:@"No"];
    }
    else if (indexPath.row==14) {
        //Follow action
        if (![myDelegate checkGuestAccess]) {
            if ([productDetailModelData.following isEqualToString:@"1"]) {
                [self unFollowProduct:(int)indexPath.row];
            }
            else {
                [self followProduct:(int)indexPath.row];
            }
        }
    }
    else if (indexPath.row==15) {
        //Wishlist action
        if (![myDelegate checkGuestAccess]) {
            if ([productDetailModelData.wishlist isEqualToString:@"1"]) {
                [self.view makeToast:NSLocalizedText(@"eventAddedWishlist")];
            }
            else {
                [self addToWishlist:(int)indexPath.row];
            }
        }
    }
    else if (indexPath.row==16) {
        //Share action
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShareViewController *popView =
        [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
        popView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        [popView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:popView animated:YES completion:nil];
        });

    }
    else if (indexPath.row==17) {
        //Location action
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WebViewController * webView=[sb instantiateViewControllerWithIdentifier:@"WebViewController"];
        webView.navigationTitle=NSLocalizedText(@"Where to buy");
        webView.productDetaiData=productDetailModelData.productWhereToBuy;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (void)navigateToView:(NSString *)navTitle webViewData:(NSString *)webViewData viewIdentifier:(NSString *)viewIdentifier productId:(NSNumber *)productId reviewId:(NSString *)reviewId isLocation:(NSString *)isLocation{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([viewIdentifier isEqualToString:@"webView"]) {
        WebViewController * webView=[sb instantiateViewControllerWithIdentifier:@"WebViewController"];
        webView.navigationTitle=navTitle;
        webView.productDetaiData=webViewData;
        webView.isLocation=isLocation;
        webView.locationArray=[productDetailModelData.locationDataArray mutableCopy];
        [self.navigationController pushViewController:webView animated:YES];
    }
    else {
        ReviewListingViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewListingViewController"];
        reviewView.productID =productId;
        reviewView.reviewId=reviewId;
        reviewView.navigationHeading=navTitle;
        reviewView.reviewAdded=reviewAdded;
        reviewView.eventDetailObj=self;
        [self.navigationController pushViewController:reviewView animated:YES];
    }
}
#pragma mark - end

#pragma mark - HCYoutubeParser method
- (void)showYouTubeVideo:(NSURL *)url {
    [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                
                [myDelegate stopIndicator];
                NSDictionary *qualities = videoDictionary;
                NSString *URLString = nil;
                if ([qualities objectForKey:@"small"] != nil) {
                    URLString = [qualities objectForKey:@"small"];
                }
                else if ([qualities objectForKey:@"live"] != nil) {
                    URLString = [qualities objectForKey:@"live"];
                }
                else {
                    return;
                }
                MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:URLString]];
                isServiceCalledMPMoviePlayerDone=false;
                [self presentViewController:mp animated:YES completion:NULL];
            }];
        }
        else {
            [myDelegate stopIndicator];
        }
    }];
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
- (void)getEventDetailData {
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
        reviewAdded=productDetailModelData.reviewAdded;
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
    cellLabel.text=NSLocalizedText(@"wishlistAdded");
    cellLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
    productDetailModelData.wishlist=@"1";
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData addProductWishlistOnSuccess:^(ProductDataModel *productDetailData)  {
        
    } onfailure:^(NSError *error) {
        cellLabel.text=NSLocalizedText(@"wishlist");
        productDetailModelData.wishlist=@"0";
        cellLabel.textColor=[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    }];
    
}

//Add to cart
- (void)addTicketsToCartProductService {
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
    cellLabel.text=NSLocalizedText(@"unfollow");
    cellLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
    productDetailModelData.following=@"1";
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData followProductOnSuccess:^(ProductDataModel *productDetailData)  {
        
    } onfailure:^(NSError *error) {
        cellLabel.text=NSLocalizedText(@"follow");
        cellLabel.textColor=[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        productDetailModelData.following=@"0";
    }];
}

//Unfollow product
- (void)unFollowProduct:(int)btnTag {
    NSIndexPath *index=[NSIndexPath indexPathForRow:btnTag inSection:0];
    ProductDetailTableViewCell * cell = (ProductDetailTableViewCell *)[_productDetailTableView cellForRowAtIndexPath:index];
    UILabel *cellLabel=(UILabel *)[cell viewWithTag:10];
    cellLabel.text=NSLocalizedText(@"follow");
    cellLabel.textColor=[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    productDetailModelData.following=@"0";
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData unFollowProductOnSuccess:^(ProductDataModel *productDetailData)  {
        
    } onfailure:^(NSError *error) {
        cellLabel.text=NSLocalizedText(@"unfollow");
        cellLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        productDetailModelData.following=@"1";
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
    else {
        [self.view makeToast:[NSString stringWithFormat:@"%@ %@ %@",NSLocalizedText(@"maximuQtyAdded"),productDetailModelData.productMaxQuantity,NSLocalizedText(@"cart")]];//cart
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
    [self performSelector:@selector(addTicketsToCartProductService) withObject:nil afterDelay:.1];
}

- (IBAction)selectTicketType:(UIButton *)sender {
    ticketBtnTag=(int)[sender tag];
    ticketArray=[NSMutableArray new];
    NSMutableDictionary *tempDict=[productDetailModelData.ticketingArray objectAtIndex:0];
    NSArray *dataArray=[[[tempDict objectForKey:@"event_option_type"]objectForKey:@"event_option_options"] mutableCopy];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *ticketDict=[dataArray objectAtIndex:i];
        double productCalculatedPrice =[[ticketDict objectForKey:@"price"] doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
        NSString *price=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:productCalculatedPrice]];
        [ticketArray addObject:[NSString stringWithFormat:@"%@ + %@",[ticketDict objectForKey:@"title"],price]];
    }
    [customerTicketPicker showPickerView:ticketArray selectedIndex:selectedPickerIndex option:1 isCancelDelegate:false];
}
#pragma mark - end

#pragma mark - Custom picker delegate method
//add picker view
- (void)addCustomPickerView {
    selectedPickerIndex=-1;
    //Set initial index of picker view and initialized picker view
    customerTicketPicker=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:customerTicketPicker.goNatuurPickerViewObj];
}

- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ticketBtnTag inSection:0];
        ProductDetailTableViewCell *cell = [_productDetailTableView cellForRowAtIndexPath:indexPath];
        cell.ticketSelectionTypeField.text=[ticketArray objectAtIndex:tempSelectedIndex];
        
        NSMutableDictionary *tempDict=[productDetailModelData.ticketingArray objectAtIndex:0];
        NSArray *dataArray=[[[tempDict objectForKey:@"event_option_type"]objectForKey:@"event_option_options"] mutableCopy];
        NSDictionary *ticketDict=[dataArray objectAtIndex:tempSelectedIndex];
       
        double productCalculatedPrice =[[ticketDict objectForKey:@"price"] doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
        if (nil!=productDetailModelData.specialPrice&&![productDetailModelData.specialPrice isEqualToString:@""]) {
            double price1 = [productDetailModelData.eventPrice doubleValue];
             productDetailModelData.specialPrice = [NSString stringWithFormat:@"%f",productCalculatedPrice+price1];
        }
        else {
            double price1 = [productDetailModelData.eventPrice doubleValue];
             productDetailModelData.productPrice = [NSNumber numberWithDouble:productCalculatedPrice+price1];
        }

        [cell displayProductPrice:productDetailModelData currentQuantity:currentQuantity];
        selectedPickerIndex=tempSelectedIndex;
        [_productDetailTableView reloadData];
    }
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
