//
//  NewsCentreViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 31/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NewsCentreViewController.h"
#import "GoNatuurFilterView.h"
#import "GoNatuurPickerView.h"
#import "ProductListTableViewCell.h"
#import "ProductListCollectionViewCell.h"
#import "LoginModel.h"
#import "SearchViewController.h"
#import "NewsCentreDetailViewController.h"
#import "ShareViewController.h"
#import "UIView+Toast.h"
#import "ProductDataModel.h"

@interface NewsCentreViewController () <UICollectionViewDelegateFlowLayout, GoNatuurFilterViewDelegate, GoNatuurPickerViewDelegate> {
    @private
    NSMutableArray *productListDataArray, *subCategoryDataList, *subCategoryPickerArray;
    int totalProductCount, currentpage;
    NSString *bannerImageUrl;
    float productListHeight;
    UIView *footerView;
    bool isPullToRefresh, isFilter, isSorting;
    GoNatuurFilterView *filterViewObj;
    int selectedFirstFilterIndex, selectedSubCategoryIndex, selectedSecondFilterIndex;
    GoNatuurPickerView *gNPickerViewObj;
    int currentCategoryId;
    int lastSelectedCategoryId;
    NSMutableArray *archiveOptionsArray, *sortingDataArray;
    NSString *sortingType, *filterValue1, *filterValue2, *shareProductNameText;
}

@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (strong, nonatomic) IBOutlet UITableView *newsListingTableView;
//Pull to refresh
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation NewsCentreViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sortingType=DESC;
    filterValue2=@"";
    filterValue1=@"";
    archiveOptionsArray=[[NSMutableArray alloc]init];
    sortingDataArray=[[NSMutableArray alloc]initWithObjects:NSLocalizedText(@"mostRecent"),NSLocalizedText(@"oldest"), nil];
    //Add custom picker view and initialized indexs
    [self addCustomPickerView];
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
    [self viewInitialization];
    productListDataArray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getNewsCategoryListData) withObject:nil afterDelay:.1];
}

- (void)serachButtonAction:(id)sender {
    myDelegate.selectedCategoryIndex=-1;
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * searchView=[sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchView.screenType=@"News";
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
}

#pragma mark - end

#pragma mark - View initialization
- (void)viewInitialization {
    _noRecordLabel.hidden=true;
    isPullToRefresh=false;
    totalProductCount=0;
    currentpage=1;
    _newsListingTableView.tableFooterView=nil;
    //Allocate footer view
    [self initializeFooterView];
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
    // Pull to refresh
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-10, 0, 20, 20)];
    _refreshControl.tintColor=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    [_refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [_newsListingTableView addSubview:_refreshControl];
    
    //Add filter xib view
    filterViewObj=[[GoNatuurFilterView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 35) delegate:self];
    filterViewObj.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 35);
    [filterViewObj setButtonTitles:((archiveOptionsArray.count>0)?[archiveOptionsArray objectAtIndex:selectedFirstFilterIndex]:@"") subCategoryText:((subCategoryPickerArray.count>0)?[subCategoryPickerArray objectAtIndex:selectedSubCategoryIndex]:@"") secondFilterText:((sortingDataArray.count>0)?[sortingDataArray objectAtIndex:selectedFirstFilterIndex]:@"")];
    //Customized filter view
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return 180.0;
    }
    else if (indexPath.row==1) {
        return 35.0;
    }
    else if (indexPath.row==2) {
        return productListHeight;
    }
    else {
        return 1; //Use for pagination in willDisplayCell
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListTableViewCell *cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BannerImageCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BannerImageCell"];
        }
        [cell displayBannerImage:bannerImageUrl screenType:@"News"];
    }
    else if (indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterCell"];
        }
        [cell.contentView addSubview:filterViewObj.goNatuurFilterViewObj];
    }
    else if (indexPath.row==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productListCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productListCell"];
        }
        [cell.productListCollectionView reloadData];
    }
    else {
        //No any use this cell to display data. This cell will be used for pagination in willDisplayCell
        cell = [tableView dequeueReusableCellWithIdentifier:@"refreshCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"refreshCell"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (productListDataArray.count == totalProductCount) {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
        _newsListingTableView.tableFooterView = nil;
    }
    else if(indexPath.row==3) {//self.array is the array of items you are displaying
        if(productListDataArray.count <= totalProductCount) {
            _newsListingTableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            currentpage+=1;
            isPullToRefresh=false;
            [self getNewsListData];
        }
        else {
            _newsListingTableView.tableFooterView = nil;
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
    [productCell displayProductListData:[productListDataArray objectAtIndex:indexPath.row] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"] isRedeemPoints:false];
    productCell.shareNewButton.tag=indexPath.item;
    [productCell.shareNewButton addTarget:self action:@selector(shareNewsAction:) forControlEvents:UIControlEventTouchUpInside];
    return productCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = (self.view.frame.size.width-20) / 2.0;
    return CGSizeMake(picDimension-5, picDimension+80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsCentreDetailViewController * webView=[sb instantiateViewControllerWithIdentifier:@"NewsCentreDetailViewController"];
    webView.newsPostId=[[productListDataArray objectAtIndex:indexPath.item]productId];
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)shareNewsAction:(id)sender {
   //  [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    DashboardDataModel * newsDataModel=[productListDataArray objectAtIndex:[sender tag]];
    shareProductNameText=newsDataModel.productName;
    NSString *shareText=[NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedText(@"checkThisOut"),newsDataModel.productName,[NSURL URLWithString:[NSString stringWithFormat:@"%@?post_id=%@",newsDataModel.newsURL,newsDataModel.productId]],NSLocalizedText(@"onGonatuur")];
    NSArray *items = @[shareText];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // exclude several items (for example, facebook and twitter)
    NSArray *excluded = @[UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList,UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypeOpenInIBooks,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypeCopyToPasteboard,UIActivityTypePostToVimeo,UIActivityTypePostToFlickr];
    controller.excludedActivityTypes = excluded;
    
    // and present it
    [self presentActivityController:controller];
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
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
#pragma mark - end

#pragma mark - Webservice

//Share product
- (void)shareProductData:(NSString*) mediaType {
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:currentCategoryId];
    productData.socialMediaType=mediaType;
    productData.sharingType=@"news";
    productData.productName=shareProductNameText;
    [productData shareProductDataService:^(ProductDataModel *productDetailData)  {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

//Get sub category list data
- (void)getNewsCategoryListData {
    DashboardDataModel *subCategoryList = [DashboardDataModel sharedUser];
    [subCategoryList getNewsCategoryListDataOnSuccess:^(DashboardDataModel *userData)  {
        [self NewsCenterBanner:[UserDefaultManager getValue:@"newsCentre"]];
        subCategoryDataList=[NSMutableArray new];
        //Set initial value come to default condition
        for (NSDictionary *tempDict in userData.categoryNameArray) {
            [subCategoryDataList addObject:tempDict];
        }
        //Set initial value come to default condition
        [subCategoryDataList insertObject:@{@"category_id":[NSNumber numberWithInt:currentCategoryId],
                                            @"category_name":NSLocalizedText(@"All")
                                            } atIndex:0];
        if (subCategoryDataList.count>0) {
            for (int i=0; i<subCategoryDataList.count; i++) {
                [subCategoryPickerArray addObject:[[subCategoryDataList objectAtIndex:i] objectForKey:@"category_name"]];
            }
            [filterViewObj.subCategoryButtonOutlet setTitle:[subCategoryPickerArray objectAtIndex:0] forState:UIControlStateNormal];
        }
        
    } onfailure:^(NSError *error) {
    }];
}

//fetch news center banner
- (void)NewsCenterBanner:(NSString *)identifier {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.cmsPageType=identifier;
    [userLogin CMSPageService:^(LoginModel *userData) {
        self.navigationItem.title=userData.cmsTitle;
        [self parseImageFromTag:userData.cmsContent];
        [self getNewsArchiveFilters];
    } onfailure:^(NSError *error) {
    }];
}

//parse image from html tag
- (void)parseImageFromTag:(NSString *)htmlString {
    NSString *yourHTMLSourceCodeString = htmlString;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    [regex enumerateMatchesInString:yourHTMLSourceCodeString
                            options:0
                              range:NSMakeRange(0, [yourHTMLSourceCodeString length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSString *img = [yourHTMLSourceCodeString substringWithRange:[result rangeAtIndex:2]];
                             
                             NSURL *candidateURL = [NSURL URLWithString:img];
                             
                             if (candidateURL && candidateURL.scheme && candidateURL.host) {
                                 bannerImageUrl=img;
                             }
                         }];
}

//Get product list service
- (void)getNewsListData {
    DashboardDataModel *productList = [DashboardDataModel sharedUser];
    if (currentCategoryId==0&&!isFilter&&!isSorting) {
        productList.newsType=@"All";
    }
    else if (isFilter && isSorting) {
        productList.newsType=@"filter";
        productList.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
        productList.filterValue=filterValue1;
        productList.filterValue2=filterValue2;
        productList.sortingValue=sortingType;
    }
    else if (!isFilter && isSorting) {
        productList.newsType=@"sort";
        productList.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
        productList.sortingValue=sortingType;
    }
    else {
        productList.newsType=@"";
        productList.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
    }
    productList.pageSize=[UserDefaultManager getValue:@"paginationSize"];
    productList.currentPage=[NSNumber numberWithInt:currentpage];
    [productList getNewsListDataService:^(DashboardDataModel *productData)  {
        [myDelegate stopIndicator];
        [self serviceDataHandling:productData];
    } onfailure:^(NSError *error) {
        [_refreshControl endRefreshing];
    }];
}

//Get news filters list service
- (void)getNewsArchiveFilters {
    DashboardDataModel *productList = [DashboardDataModel sharedUser];
    [productList getNewsListFiltersDataService:^(DashboardDataModel *productData)  {
        [self getNewsListData];
        for (int i=0; i<productData.archiveOptionsForNews.count; i++) {
        NSString *dateString = [productData.archiveOptionsForNews objectAtIndex:i];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatterService];
        NSDate *date = [[NSDate alloc] init];
        date = [dateFormatter dateFromString:dateString];
        // converting into our required date format
        [dateFormatter setDateFormat:dateFormatterService];
        NSString *reqDateString = [dateFormatter stringFromDate:date];
        [archiveOptionsArray insertObject:reqDateString atIndex:i];
        }
        [archiveOptionsArray insertObject:NSLocalizedText(@"All") atIndex:0];
        [filterViewObj.firstFilterButtonOutlet setTitle:[archiveOptionsArray objectAtIndex:0] forState:UIControlStateNormal];
    } onfailure:^(NSError *error) {
        [_refreshControl endRefreshing];
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
    [_newsListingTableView reloadData];
}
#pragma mark - end

#pragma mark - Pull to refresh
- (void)refreshControlAction {
    isPullToRefresh=true;
    currentpage=1;
    sortingType=DESC;
    filterValue2=@"";
    filterValue1=@"";
    currentCategoryId=0;
    isFilter=false;
    isSorting=false;
    subCategoryPickerArray=[NSMutableArray new];
    archiveOptionsArray=[NSMutableArray new];
    [filterViewObj.secondFilterButtonOutlet setTitle:[sortingDataArray objectAtIndex:0] forState:UIControlStateNormal];
    [self performSelector:@selector(getNewsCategoryListData) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Filter delegate
- (void)goNatuurFilterViewDelegateActionIndex:(int)option {
    DLog(@"%d",option);
    if (option==1) {
        if (subCategoryPickerArray.count>0) {
            [gNPickerViewObj showPickerView:subCategoryPickerArray selectedIndex:selectedSubCategoryIndex option:1 isCancelDelegate:false isFilterScreen:false];
        }
    }
    else if (option==2) {
        if (archiveOptionsArray.count>0) {
            [gNPickerViewObj showPickerView:archiveOptionsArray selectedIndex:selectedFirstFilterIndex option:2 isCancelDelegate:false isFilterScreen:false];
        }
    }
    else{
        if (sortingDataArray.count>0) {
            [gNPickerViewObj showPickerView:sortingDataArray selectedIndex:selectedSecondFilterIndex option:3 isCancelDelegate:false isFilterScreen:false];
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
            currentCategoryId=[[[subCategoryDataList objectAtIndex:tempSelectedIndex] objectForKey:@"category_id"] intValue];
            productListDataArray=[NSMutableArray new];
            totalProductCount=0;
            currentpage=1;
        }
    }
    else  if (option==2) {
        if (selectedFirstFilterIndex!=tempSelectedIndex) {
            selectedFirstFilterIndex=tempSelectedIndex;
            [filterViewObj.firstFilterButtonOutlet setTitle:[archiveOptionsArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            if (tempSelectedIndex!=0) {
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:dateFormatterService];
                NSDate *dateValue = [dateFormatter dateFromString:[archiveOptionsArray objectAtIndex:tempSelectedIndex]];
                [self returnDate:dateValue];
                isFilter=true;
                isSorting=true;
            }
            else {
                isFilter=false;
            }
            productListDataArray=[NSMutableArray new];
            totalProductCount=0;
            currentpage=1;
        }
    }
    else {
        if (selectedSecondFilterIndex!=tempSelectedIndex) {
            selectedSecondFilterIndex=tempSelectedIndex;
            [filterViewObj.secondFilterButtonOutlet setTitle:[sortingDataArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            if (tempSelectedIndex==0) {
                sortingType=DESC;
            }
            else {
                 sortingType=ASC;
            }
            productListDataArray=[NSMutableArray new];
            totalProductCount=0;
            currentpage=1;
            isSorting=true;
        }
    }
    [myDelegate showIndicator];
    [self performSelector:@selector(getNewsListData) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Date formatter
- (void)returnDate:(NSDate *)date {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSDate * firstDateOfMonth = [self returnDateForMonth:comps.month year:comps.year day:1];
    NSDate * lastDateOfMonth = [self returnDateForMonth:comps.month+1 year:comps.year day:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatterDate];
    filterValue1=[dateFormatter stringFromDate:firstDateOfMonth];
    filterValue2=[dateFormatter stringFromDate:lastDateOfMonth];
}

- (NSDate *)returnDateForMonth:(NSInteger)month year:(NSInteger)year day:(NSInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian dateFromComponents:components];
}
#pragma mark - end
@end
