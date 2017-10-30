//
//  NotificationViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NotificationViewController.h"
#import "DynamicHeightWidth.h"
#import "NotificationDataModel.h"
#import "ProductListingViewController.h"
#import "EventDetailViewController.h"
#import "ProductDetailViewController.h"
#import "OrderDetailViewController.h"
#import "ProfileViewController.h"

@interface NotificationViewController () {
@private
    NSMutableArray *notificationArray;
    int totalCount;
    UIView *footerView;
    int pageCount;
}
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation NotificationViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _notificationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//remove extra cell from table view
    _notificationTableView.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0];
    _noRecordLabel.hidden=YES;
    pageCount=1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"Notifications");
    [self addLeftBarButtonWithImage:false];
    [self initFooterView];
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    //call notification list webservice
    notificationArray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getNotificationListing) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getNotificationListing {
    NotificationDataModel *notificationList = [NotificationDataModel sharedUser];
    notificationList.pageCount=[NSNumber numberWithInt:pageCount];
    [notificationList getUserNotification:^(NotificationDataModel *userData) {
        [myDelegate stopIndicator];
        [notificationArray addObjectsFromArray:userData.notificationListArray];
        if (notificationArray.count==0) {
            _noRecordLabel.hidden=NO;
        }
        else {
            _noRecordLabel.hidden=YES;
            totalCount =[userData.totalCount intValue];
            [_notificationTableView reloadData];
        }
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
    }];
}

- (void)markNotificationAsRead:(NSString *)notificationId currentIndex:(int)currentIndex {
    NotificationDataModel *notificationList = [NotificationDataModel sharedUser];
    notificationList.notificationId=notificationId;
    [notificationList markNotificationRead:^(NotificationDataModel *userData) {
        NotificationDataModel *notiData=[notificationArray objectAtIndex:currentIndex];
        notiData.notificationStatus=@"1";
        [_notificationTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notificationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier=@"notificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *notificationBadgeLabel=(UILabel *) [cell viewWithTag:1];
    UIImageView *notiIcon=(UIImageView *) [cell viewWithTag:2];
    UIImageView *arrowIcon=(UIImageView *) [cell viewWithTag:3];
    UIImageView *sepImage=(UIImageView *) [cell viewWithTag:4];
    notificationBadgeLabel.translatesAutoresizingMaskIntoConstraints=YES;
    NotificationDataModel *notiData=[notificationArray objectAtIndex:indexPath.row];
    if ([notiData.notificationStatus isEqualToString:@"1"]) {
        notificationBadgeLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0];
        notiIcon.alpha=1.0;
        arrowIcon.alpha=1.0;
        sepImage.image=[UIImage imageNamed:@"navigationSep2"];
    }
    else {
        notificationBadgeLabel.textColor=[UIColor colorWithRed:247.0/255.0 green:216.0/255.0 blue:223.0/255.0 alpha:1.0];
        cell.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:59.0/255.0 blue:95.0/255.0 alpha:1.0];
        notiIcon.alpha=0.95;
        arrowIcon.alpha=0.6;
        sepImage.image=[UIImage imageNamed:@"notificationSep"];
    }
    notificationBadgeLabel.text=notiData.notificationMessage;
    DLog(@"%@",notificationBadgeLabel.text);
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:notificationBadgeLabel.text font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-77]+30;
    notificationBadgeLabel.frame=CGRectMake(48, 0,[[UIScreen mainScreen] bounds].size.width-77, newHeight);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:[[notificationArray objectAtIndex:indexPath.row] notificationMessage] font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-77]+30;
    return newHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationDataModel *notiData=[notificationArray objectAtIndex:indexPath.row];
    [self markNotificationAsRead:notiData.notificationId currentIndex:(int)indexPath.row];
    int notificationTypeId= [notiData.notificationType intValue];
    switch(notificationTypeId) {
        case 1 : {
            // navigate to product listing
            ProductListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductListingViewController"];
            obj.selectedProductCategoryId=[notiData.targetId intValue];
            myDelegate.isProductList=true;
            [self.navigationController pushViewController:obj animated:YES];
        }
        break;
        case 2 :{
            // navigate to product details
            ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
            obj.selectedProductId=[notiData.targetId intValue];
            obj.isRedeemProduct=false;
            [self.navigationController pushViewController:obj animated:YES];
        }
        break;
        case 3 : {
            // navigate to event listing
            ProductListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductListingViewController"];
            obj.selectedProductCategoryId=[notiData.targetId intValue];
            myDelegate.isProductList=false;
            [self.navigationController pushViewController:obj animated:YES];
        }
        break;
        case 4 :{
            // navigate to event details
            EventDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
            obj.selectedProductId=[notiData.targetId intValue];
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
            OrderDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
            obj.selectedOrderId=notiData.targetId;
            [self.navigationController pushViewController:obj animated:YES];
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
#pragma mark - end

#pragma mark - Pagignation for table view
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (notificationArray.count ==totalCount) {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
    }
    else if(indexPath.row==[notificationArray count]-1) {
        if(notificationArray.count < totalCount) {
            tableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            pageCount++;
            [self getNotificationListing];
        }
        else {
            _notificationTableView.tableFooterView = nil;
        }
    }
}

//Load footer view in table
- (void)initFooterView {
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    actInd.color=[UIColor whiteColor];
    actInd.tag = 10;
    actInd.frame = CGRectMake(self.view.frame.size.width/2-10, 10.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerView addSubview:actInd];
    actInd = nil;
}
#pragma mark - end

@end
