//
//  RedeemViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 13/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "RedeemViewController.h"
#import "RedeemTableViewCell.h"
#import "ProductListCollectionViewCell.h"
#import "DashboardDataModel.h"
#import "GoNatuurFilterView.h"
#import "GoNatuurPickerView.h"
#import "DynamicHeightWidth.h"
#import "UIImage+UIImage_fixOrientation.h"
#import "ProfileModel.h"
#import "ProductDetailViewController.h"
#import "UIView+Toast.h"

@interface RedeemViewController ()<UICollectionViewDelegateFlowLayout, GoNatuurFilterViewDelegate, GoNatuurPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSMutableArray *productListDataArray, *subCategoryDataList, *subCategoryPickerArray;
    int totalProductCount, currentpage;
    NSString *bannerImageUrl;
    float productListHeight;
    UIView *footerView;
    bool isPullToRefresh;
    GoNatuurFilterView *filterViewObj;
    int selectedFirstFilterIndex, selectedSubCategoryIndex, selectedSecondFilterIndex;
    GoNatuurPickerView *gNPickerViewObj;
    int currentCategoryId;
    int lastSelectedCategoryId;
    NSArray *menuArray;
    UIImage *userProfileImage;
    BOOL isImagePicker;
}
@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (strong, nonatomic) IBOutlet UITableView *redeemListTableView;
//Pull to refresh
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation RedeemViewController
@synthesize visitedFromScreen;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //When user go to search screen then store last product category id
    lastSelectedCategoryId=myDelegate.selectedCategoryIndex;
    isImagePicker=false;
    //Add custom picker view and initialized indexs
    [self addCustomPickerView];
    // Do any additional setup after loading the view.
    menuArray = @[@"profileImageCell", @"userEmailCell", @"impactPointCell", @"redeemPointCell", @"filterCell", @"productListCell", @"refreshCell"];
    myDelegate.isProductList=true;
    //Set default sort values
    _sortingType = NSLocalizedText(@"sortPrice");
    _sortFilterRequest = 0;
    _filterDictionary = @{@"maxPrice":@"0",@"minPrice":@"0", @"attributeId":@"9", @"attributedCode":@"country"};
    _sortBasis = DESC; //ASC/DESC

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"redeemCenter");
    if ([visitedFromScreen isEqualToString:@"profile"]) {
        [self addLeftBarButtonWithImage:true];
    }
    else {
        [self addLeftBarButtonWithImage:false];
    }
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    if (_isSortFilter) {
        NSLog(@"basis = %@, type = %@",_sortBasis,_sortingType);
        NSLog(@"filter dict %@",_filterDictionary);
        isPullToRefresh=true;
        [myDelegate showIndicator];
        [self performSelector:@selector(getRedeemListData) withObject:nil afterDelay:.1];
    } else {
        if (!isImagePicker) {
            [self viewInitialization];
            [myDelegate showIndicator];
            [self performSelector:@selector(getRedeemCategoryListData) withObject:nil afterDelay:.1];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View initialization
- (void)viewInitialization {
    myDelegate.selectedCategoryIndex=lastSelectedCategoryId;
    currentCategoryId=[[UserDefaultManager getValue:@"rewardCategoryId"] intValue];
    bannerImageUrl=@"";
    _noRecordLabel.hidden=true;
    isPullToRefresh=false;
    productListDataArray=[NSMutableArray new];
    subCategoryDataList=[NSMutableArray new];
    totalProductCount=0;
    currentpage=1;
    _redeemListTableView.tableFooterView=nil;
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
    //Allocate footer view
    [self initializeFooterView];
    // Pull to refresh
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-10, 0, 20, 20)];
    _refreshControl.tintColor=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    [_refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [_redeemListTableView addSubview:_refreshControl];
}

- (void)initializeFooterView {
    footerView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 40.0)];
    UIActivityIndicatorView *activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorObject.color=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    activityIndicatorObject.tag = 10;
    activityIndicatorObject.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-10, 0.0, 20.0, 20.0);
    activityIndicatorObject.hidesWhenStopped = YES;
    [footerView addSubview:activityIndicatorObject];
}

- (void)addCustomPickerView {
    //Add filter xib view
    filterViewObj=[[GoNatuurFilterView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 35) delegate:self];
    filterViewObj.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 35);
    [filterViewObj setButtonTitles:NSLocalizedText(@"Filter") subCategoryText:((subCategoryPickerArray.count>0)?[subCategoryPickerArray objectAtIndex:selectedSubCategoryIndex]:@"") secondFilterText:NSLocalizedText(@"Sortby")];
    //Customized filter view
    filterViewObj.firstFilterButtonOutlet.enabled=false;
    filterViewObj.secondFilterButtonOutlet.enabled=false;
    filterViewObj.firstFilterButtonOutlet.alpha=0.5;
    filterViewObj.secondFilterButtonOutlet.alpha=0.5;
    filterViewObj.firstFilterArrowImageView.alpha=0.4;
    filterViewObj.secondFilterArrowImageView.alpha=0.4;
//    if (!myDelegate.isProductList) {
        filterViewObj.subCategoryButtonOutlet.enabled=true;
//        filterViewObj.subCategoryButtonOutlet.alpha=0.5;
//        filterViewObj.subCategoryArrowImageView.alpha=0.4;
//    }
    //Set initial index of picker view and initialized picker view
    selectedFirstFilterIndex=0;
    selectedSubCategoryIndex=0;
    selectedSecondFilterIndex=0;
    subCategoryPickerArray=[NSMutableArray new];
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Table view datasource/delegates
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return 150;
    }
    else if (indexPath.row==1) {
        return [DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50 heightValue:60]+10;
    }
    else if (indexPath.row==2) {
        return 80;
    }
    else if (indexPath.row==3) {
        return 60;
    }
    else if (indexPath.row==4) {
        return 36.0;
    }
    else if (indexPath.row==5) {
        return productListHeight;
    }
    else {
        return 1; //Use for pagination in willDisplayCell
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuArray objectAtIndex:indexPath.row];
    RedeemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RedeemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0) {
        [cell displayData:_redeemListTableView.frame.size];
        [cell.editProfileButton addTarget:self action:@selector(editProfileImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==1) {
        [cell displayData:_redeemListTableView.frame.size];
    }
    else if (indexPath.row==2) {
       [cell displayData:_redeemListTableView.frame.size];
    }
    else if (indexPath.row==3) {
         [cell displayData:_redeemListTableView.frame.size];
         [cell.impactPointsOverview addTarget:self action:@selector(imapctPointsOverviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row==4) {
         [cell.contentView addSubview:filterViewObj.goNatuurFilterViewObj];
    }
    else if (indexPath.row==5) {
         [cell.productListCollectionView reloadData];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (productListDataArray.count == totalProductCount) {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
        _redeemListTableView.tableFooterView = nil;
    }
    else if(indexPath.row==6) {
        if(productListDataArray.count <= totalProductCount) {
            _redeemListTableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            currentpage+=1;
            isPullToRefresh=false;
            [self getRedeemListData];
        }
        else {
            _redeemListTableView.tableFooterView = nil;
        }
    }
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return productListDataArray.count;
}

- (ProductListCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductListCollectionViewCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
    [productCell displayProductListData:[productListDataArray objectAtIndex:indexPath.row] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
    return productCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = ([[UIScreen mainScreen] bounds].size.width-20) / 2.0;
    return CGSizeMake(picDimension-5, picDimension+105);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        //StoryBoard navigation
    ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    obj.selectedProductId=[[[productListDataArray objectAtIndex:indexPath.row] productId] intValue];
    [self.navigationController pushViewController:obj animated:YES];

}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)editProfileImageAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedText(@"TakePhoto")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedText(@"alertCancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedText(@"Camera"), NSLocalizedText(@"Gallery"), nil];
    [actionSheet showInView:self.view];
}

- (IBAction)imapctPointsOverviewButtonAction:(id)sender {
    [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
}
#pragma mark - end

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedText(@"error")
                                                                  message:NSLocalizedText(@"noCamera")
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedText(@"alertOk")
                                                        otherButtonTitles: nil];
            [myAlertView show];
        }
        else
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    if ([buttonTitle isEqualToString:NSLocalizedText(@"Gallery")]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.navigationBar.translucent = NO;
        picker.navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:233.0/255.0 blue:237.0/255.0 alpha:1];
        picker.navigationBar.tintColor = [UIColor blackColor];
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - end

#pragma mark - Image picker controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    RedeemTableViewCell * cell = (RedeemTableViewCell *)[_redeemListTableView cellForRowAtIndexPath:index];
    UIImage *correctOrientationImage = [image fixOrientation];
    cell.userImageView.image=correctOrientationImage;
    userProfileImage=cell.userImageView.image;
    isImagePicker=true;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [myDelegate showIndicator];
    [self performSelector:@selector(editUserProfileImage) withObject:nil afterDelay:.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end


#pragma mark - Webservice
//Get sub category list data
- (void)getRedeemCategoryListData {
    DashboardDataModel *subCategoryList = [DashboardDataModel sharedUser];
    subCategoryList.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
    [subCategoryList getCategoryListDataOnSuccess:^(DashboardDataModel *userData)  {
        subCategoryDataList=[NSMutableArray new];
        for (NSDictionary *tempDict in userData.categoryNameArray) {
            if ([[tempDict objectForKey:@"is_active"] isEqual:@1]) {
                [subCategoryDataList addObject:tempDict];
            }
        }
        //Set initial value come to default condition
        [subCategoryDataList insertObject:@{@"id":[NSNumber numberWithInt:currentCategoryId],
                                            @"name":NSLocalizedText(@"All")
                                            } atIndex:0];
        if (subCategoryDataList.count>0) {
            for (int i=0; i<subCategoryDataList.count; i++) {
                [subCategoryPickerArray addObject:[[subCategoryDataList objectAtIndex:i] objectForKey:@"name"]];
            }
            [filterViewObj.subCategoryButtonOutlet setTitle:[subCategoryPickerArray objectAtIndex:0] forState:UIControlStateNormal];
        }
        
        [self getUserImapctPointsData];
    } onfailure:^(NSError *error) {
    }];
}

//Get product list service
- (void)getRedeemListData {
    DashboardDataModel *productList = [DashboardDataModel sharedUser];
    productList.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
    productList.pageSize=[UserDefaultManager getValue:@"paginationSize"];
    productList.currentPage=[NSNumber numberWithInt:currentpage];
    productList.productSortingType = _sortingType;
    productList.productSortingValue = _sortBasis;
    productList.minPriceValue = _filterDictionary[@"minPrice"];
    productList.maxPriceValue = _filterDictionary[@"maxPrice"];
    productList.filterAttributeCode = _filterDictionary[@"attributedCode"];;
    productList.filterAttributeId = _filterDictionary[@"attributeId"];
    productList.sortFilterRequestParameter=_sortFilterRequest;
    
    [productList getProductListService:^(DashboardDataModel *productData)  {
        [myDelegate stopIndicator];
        [self serviceDataHandling:productData];
    } onfailure:^(NSError *error) {
        [_refreshControl endRefreshing];
    }];
}

//Get user impact points
- (void)getUserImapctPointsData {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.pageCount=@"1";
    userData.currentPage=@"1";
    [userData getImpactPoints:^(ProfileModel *userData) {
        [self getRedeemListData];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)editUserProfileImage {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.userImage=userProfileImage;
    [userData updateUserProfileImage:^(ProfileModel *userData) {
        isImagePicker=false;
        [myDelegate stopIndicator];
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}

#pragma mark - end

#pragma mark - Service handling
- (void)serviceDataHandling:(DashboardDataModel *)productData {
    if (isPullToRefresh) {
        isPullToRefresh=false;
        productListDataArray=[NSMutableArray new];
        totalProductCount=0;
        currentpage=1;
    }
    if (productListDataArray.count>0) {
        [productListDataArray addObjectsFromArray:productData.productDataArray];
    }
    else {
        productListDataArray=productData.productDataArray.mutableCopy;
    }
    
    if (productListDataArray.count>0) {
        _noRecordLabel.hidden=true;
    }
    else {
        _noRecordLabel.hidden=false;
    }
    totalProductCount=[productData.totalProductCount intValue];
    float picDimension = (self.view.frame.size.width-20) / 2.0;
    int rowCount=(int)productListDataArray.count/2;
    if (productListDataArray.count%2!=0) {
        rowCount+=1;
    }
    [_refreshControl endRefreshing];
    productListHeight=(rowCount*(picDimension+105))+35+((rowCount-1)*10);   //productListHeight: (rowCount*cellHeight)+35+((rowCount-1)*cellRowSpacing)
    [_redeemListTableView reloadData];
}
#pragma mark - end

#pragma mark - Pull to refresh
- (void)refreshControlAction {
    isPullToRefresh=true;
    currentpage=1;
    [self performSelector:@selector(getRedeemListData) withObject:nil afterDelay:.1];
    [_refreshControl endRefreshing];
}
#pragma mark - end

#pragma mark - Filter delegate
- (void)goNatuurFilterViewDelegateActionIndex:(int)option {
    DLog(@"%d",option);
    if (option==1) {
        if (subCategoryPickerArray.count>0) {
            [gNPickerViewObj showPickerView:subCategoryPickerArray selectedIndex:selectedSubCategoryIndex option:1 isCancelDelegate:false];
        }
    }
}
#pragma mark - end

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        if (selectedSubCategoryIndex!=tempSelectedIndex) {
            selectedSubCategoryIndex=tempSelectedIndex;
            [filterViewObj.subCategoryButtonOutlet setTitle:[subCategoryPickerArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            currentCategoryId=[[[subCategoryDataList objectAtIndex:selectedSubCategoryIndex] objectForKey:@"id"] intValue];
            bannerImageUrl=@"";
            productListDataArray=[NSMutableArray new];
            totalProductCount=0;
            currentpage=1;
        }
    }
}
#pragma mark - end
@end
