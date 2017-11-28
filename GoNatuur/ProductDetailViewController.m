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
#import <MediaPlayer/MediaPlayer.h>
#import "HCYoutubeParser.h"
#import "ShareViewController.h"
#import "SubscriptionViewController.h"

@interface ProductDetailViewController ()<UIGestureRecognizerDelegate> {
@private
    ProductDataModel *productDetailModelData;
    float productDetailCellHeight;
    BOOL isServiceCalled, isSubscribed;
    int selectedMediaIndex, currentQuantity;
    NSArray *cellIdentifierArray;
    bool isServiceCalledMPMoviePlayerDone;
    
}
@property (strong, nonatomic) IBOutlet UITableView *productDetailTableView;
@end

@implementation ProductDetailViewController
@synthesize selectedProductId;
@synthesize reviewAdded;
@synthesize isRedeemProduct;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInitialization];
    // Do any additional setup after loading the view.
    if (isServiceCalledMPMoviePlayerDone) {
        [myDelegate showIndicator];
        [self performSelector:@selector(getProductDetailData) withObject:nil afterDelay:.1];
    }
    else {
        isServiceCalledMPMoviePlayerDone=true;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"Product");
    [self addLeftBarButtonWithImage:true];
    cellIdentifierArray = @[@"productDetailNameCell", @"productDetailDescriptionCell", @"productDetailRatingCell", @"productDetailImageCell", @"productDetailMediaCell",@"productDetailPriceCell", @"productDetailInfoCell",@"subscriptionCell",@"productDetailAddCartButtonCell",@"descriptionCell",@"benefitCell",@"brandCell",@"reviewCell",@"followCell",@"wishlistCell",@"shareCell",@"locationCell"];
    [myDelegate.recentlyViewedItemsArrayGuest addObject:[NSNumber numberWithInt:selectedProductId]];
    [UserDefaultManager setValue:myDelegate.recentlyViewedItemsArrayGuest key:@"recentlyViewedGuest"];
    NSLog(@"%@",_subscriptionDetailDict);
    if (_subscriptionDetailDict != nil) {
        isSubscribed = true;
        [_productDetailTableView reloadData];
    } else {
        isSubscribed = false;
    }
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
    productDetailModelData=[[ProductDataModel alloc]init];
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
        if ([productDetailModelData.shippingText isEqualToString:@""] && nil!=productDetailModelData.shippingText) {
            return 1;
        }
        else {
            float tempHeight=[DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.shippingText font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
            return tempHeight+5;
        }
    }
    else if (indexPath.row==7) {
        if (productDetailModelData.enableSubscription == 0) {
            return 0;
        } else {
            return 40;
        }
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
        [cell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] defaultVideoThumbnail:productDetailModelData.productVideoDefaultThumbnail];
        cell.productImageView.userInteractionEnabled=YES;
        [self addSwipeGesture:cell.contentView];
    }
    else if (indexPath.row==4) {
        [cell.productMediaCollectionView reloadData];
    }
    else if (indexPath.row==5) {
        [cell displayProductPrice:productDetailModelData currentQuantity:currentQuantity isRedeemPoints:isRedeemProduct];
        cell.incrementCartButton.tag=indexPath.row;
        cell.removeFromCartButton.tag=indexPath.row;
        [cell.incrementCartButton addTarget:self action:@selector(increaseQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.removeFromCartButton addTarget:self action:@selector(removeQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==6) {
        [cell displayProductInfo:productDetailModelData.shippingText];
    } else if (indexPath.row==7) {
        [cell displaySubscriptionData:isSubscribed];
    }
    else if (indexPath.row==8) {
        [cell displayAddToCartButton:@"ProductDetail"];
        cell.addToCartButton.tag=indexPath.row;
        [cell.addToCartButton addTarget:self action:@selector(insertInCartItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==9) {
        cellLabel.text=NSLocalizedText(@"Description");
    }
    else if (indexPath.row==10) {
        cellLabel.text=NSLocalizedText(@"Benefits&Usage");
    }
    else if (indexPath.row==11) {
        cellLabel.text=NSLocalizedText(@"BrandStory");
    }
    else if (indexPath.row==12) {
        cellLabel.text=NSLocalizedText(@"Review");
    }
    else if (indexPath.row==13) {
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
    else if (indexPath.row==14) {
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
    else if (indexPath.row==15) {
        cellLabel.text=NSLocalizedText(@"socialMedia");
    }
    else if (indexPath.row==16) {
        cellLabel.text=NSLocalizedText(@"Where to buy");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==3) {
        if (![[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"media_type"] isEqualToString:@"image"]) {
            if ([[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"media_type"] isEqualToString:@"default-video"]) {
                NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseUrl,productDetailImageBaseUrl,productDetailModelData.productVideoDefault]];
                NSArray * arrayOfThingsIWantToPassAlong =
                [NSArray arrayWithObjects: videoURL, @"false", nil];
                [myDelegate showIndicator];
                [self performSelector:@selector(showYouTubeVideo:) withObject:arrayOfThingsIWantToPassAlong afterDelay:.1];
            }
            else {
                NSURL *videoURL = [NSURL URLWithString:[[[[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] objectForKey:@"extension_attributes"] objectForKey:@"video_content"] objectForKey:@"video_url"]];
                [myDelegate showIndicator];
                NSArray * arrayOfThingsIWantToPassAlong =
                [NSArray arrayWithObjects: videoURL, @"true", nil];
                [myDelegate showIndicator];
                [self performSelector:@selector(showYouTubeVideo:) withObject:arrayOfThingsIWantToPassAlong afterDelay:.1];
            }
        }
    }  else if (indexPath.row==7) {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SubscriptionViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"SubscriptionViewController"];
        nextView.productId = selectedProductId;
        nextView.isEventScreen = false;
        nextView.productDetailControllerObj = self;
        [self.navigationController pushViewController:nextView animated:YES];
    }
    else if (indexPath.row==8) {
        //Description action
        [self navigateToView:NSLocalizedText(@"Description") webViewData:productDetailModelData.productDescription viewIdentifier:@"webView" productId:0 reviewId:@""];
    }
    else if (indexPath.row==9) {
        //Benefit action
        [self navigateToView:NSLocalizedText(@"Benefits&Usage") webViewData:productDetailModelData.productBenefitsUsage viewIdentifier:@"webView" productId:0 reviewId:@""];
    }
    else if (indexPath.row==10) {
        //Brand action
        [self navigateToView:NSLocalizedText(@"BrandStory") webViewData:productDetailModelData.productBrandStory viewIdentifier:@"webView" productId:0 reviewId:@""];
    }
    else if (indexPath.row==11) {
        //Review action
        [self navigateToView:NSLocalizedText(@"Review") webViewData:@"" viewIdentifier:@"reviewView" productId:[NSNumber numberWithInt:selectedProductId] reviewId:productDetailModelData.reviewId];
    }
    else if (indexPath.row==12) {
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
    else if (indexPath.row==13) {
        //Wishlist action
        if (![myDelegate checkGuestAccess]) {
            if ([productDetailModelData.wishlist isEqualToString:@"1"]) {
                [self.view makeToast:NSLocalizedText(@"alreadyAddedWishlist")];
            }
            else {
                [self addToWishlist:(int)indexPath.row];
            }
        }
    }
    else if (indexPath.row==14) {
        //Share action
        //[self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
        NSString *shareText=[NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedText(@"checkThisOut"),productDetailModelData.productName,[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@.html?product_id=%d",BaseUrl,[UserDefaultManager getValue:@"Language"],productDetailModelData.productUrlKey,selectedProductId]],NSLocalizedText(@"onGonatuur")];
        NSArray *items = @[shareText];
        
        // build an activity view controller
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
        
        // exclude several items (for example, facebook and twitter)
        NSArray *excluded = @[UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList,UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypeOpenInIBooks,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypeCopyToPasteboard,UIActivityTypePostToVimeo,UIActivityTypePostToFlickr];
        controller.excludedActivityTypes = excluded;
        
        // and present it
        [self presentActivityController:controller];
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

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
            [self shareProductData:@"facebook"];
        } else if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {
            [self shareProductData:@"wechat"];
        } else if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
            [self shareProductData:@"weibo"];
        } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
             [self shareProductData:@"twitter"];
        }
        else if ([activityType isEqualToString:@"com.google.GooglePlus.ShareExtension"]) {
            [self shareProductData:@"google"];
        } else if ([activityType isEqualToString:@"pinterest.ShareExtension"]) {
            [self shareProductData:@"pintrest"];
        }
        // react to the completion
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
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

- (void)navigateToView:(NSString *)navTitle webViewData:(NSString *)webViewData viewIdentifier:(NSString *)viewIdentifier productId:(NSNumber *)productId reviewId:(NSString *)reviewId {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([viewIdentifier isEqualToString:@"webView"]) {
        WebViewController * webView=[sb instantiateViewControllerWithIdentifier:@"WebViewController"];
        webView.navigationTitle=navTitle;
        webView.productDetaiData=webViewData;
        webView.isLocation=@"No";
        [self.navigationController pushViewController:webView animated:YES];
    }
    else {
        ReviewListingViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewListingViewController"];
        reviewView.productID =productId;
        reviewView.reviewId=reviewId;
        reviewView.navigationHeading=navTitle;
        reviewView.reviewAdded=reviewAdded;
        reviewView.productDetailObj=self;
        [self.navigationController pushViewController:reviewView animated:YES];
    }
}
#pragma mark - end

#pragma mark - HCYoutubeParser method
- (void)showYouTubeVideo:(NSArray *)dataArray {
    NSString *isYouTube = [dataArray objectAtIndex:1];
    NSURL *url=[dataArray objectAtIndex:0];
    if ([isYouTube isEqualToString:@"true"]) {
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
                    //                MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:URLString]];
                    //                isServiceCalledMPMoviePlayerDone=false;
                    //                [self presentViewController:mp animated:YES completion:NULL];
                    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:URLString]];
                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                    playerViewController.player = player;
                    [playerViewController.player play];//used to play on start
                    isServiceCalledMPMoviePlayerDone=false;
                    [self presentViewController:playerViewController animated:YES completion:nil];
                }];
            }
            else {
                [myDelegate stopIndicator];
            }
        }];
    }
    else {
        [myDelegate stopIndicator];
        AVPlayer *player = [AVPlayer playerWithURL:url];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [playerViewController.player play];//used to play on start
        [self presentViewController:playerViewController animated:YES completion:nil];
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
    [productMediaCell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:indexPath.row] selectedIndex:selectedMediaIndex currentIndex:(int)indexPath.row defaultVideoThumbnail:productDetailModelData.productVideoDefaultThumbnail];
    return productMediaCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedMediaIndex=(int)indexPath.row;
    ProductDetailTableViewCell *tempCell = [_productDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [tempCell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] defaultVideoThumbnail:productDetailModelData.productVideoDefaultThumbnail];
    [collectionView reloadData];
}
#pragma mark - end

#pragma mark - Webservice
//Get product detail
- (void)getProductDetailData {
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData getProductDetailOnSuccess:^(ProductDataModel *productDetailData)  {
        if ([productDetailData.redeemPointsRequired isEqualToString:@""] || productDetailData.redeemPointsRequired==nil) {
            isRedeemProduct=false;
        }
        else {
            isRedeemProduct=true;
        }
        productDetailModelData=nil;
        productDetailModelData=productDetailData;
        reviewAdded=productDetailModelData.reviewAdded;
        if (nil!=productDetailModelData.productVideoDefault && ![productDetailModelData.productVideoDefault isEqualToString:@""]) {
            [productDetailModelData.productMediaArray addObject:@{@"media_type":@"default-video"}];
        }
        [myDelegate stopIndicator];
        isServiceCalled=true;
        currentQuantity=[productDetailData.productMinQuantity intValue];
        [_productDetailTableView reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}

//Share product
- (void)shareProductData:(NSString*) mediaType {
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    productData.socialMediaType=mediaType;
    productData.sharingType=@"product";
    productData.productName=productDetailModelData.productName;
    [productData shareProductDataService:^(ProductDataModel *productDetailData)  {
        [myDelegate stopIndicator];
        isServiceCalled=true;
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
- (void)addToCartProductService {
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productQuantity=productDetailModelData.productQuantity;
    productData.productSku=productDetailModelData.productSku;
    productData.isSubscribed = isSubscribed;
    productData.subscribeDataDict = _subscriptionDetailDict;
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
    currentQuantity+=1;
    cell.cartNumberItemLabel.text=[NSString stringWithFormat:@"%d",currentQuantity];
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
        [cell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] defaultVideoThumbnail:productDetailModelData.productVideoDefaultThumbnail];
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
        [cell displayProductMediaImage:[productDetailModelData.productMediaArray objectAtIndex:selectedMediaIndex] defaultVideoThumbnail:productDetailModelData.productVideoDefaultThumbnail];
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
