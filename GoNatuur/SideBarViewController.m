//
//  SideBarViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SideBarViewController.h"
#import "SWRevealViewController.h"
#import "DynamicHeightWidth.h"
#import "UIView+Toast.h"
#import "NotificationViewController.h"
#import "NewsLetterSubscriptionViewController.h"
#import "WebPageViewController.h"

@interface SideBarViewController () {
    NSArray *menuItemsArray, *sideBarLabelArray;
}
@property (weak, nonatomic) IBOutlet UITableView *sideBarTableView;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@end

@implementation SideBarViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    menuItemsArray = @[@"My Orders", @"Payment", @"Redeem Points", @"Events", @"News Centre",@"Notifications",@"AboutUs",@"ContactUs",@"NewsLetter",@"ProductGuide", @"Signout"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
     sideBarLabelArray=@[NSLocalizedText(@"sideBarOrder"), NSLocalizedText(@"sideBarPayment"), NSLocalizedText(@"sideBarRedeemPoints"),NSLocalizedText(@"sideBarEvents"), NSLocalizedText(@"sideBarNewsCentre"), NSLocalizedText(@"sideBarNotifications"), NSLocalizedText(@"sideBarAboutUs"), NSLocalizedText(@"sideBarContactUs"), NSLocalizedText(@"sideBarNewsLetter"),NSLocalizedText(@"sideBarProductGuide"),NSLocalizedText(@"sideBarSignOut")];
    [self viewCustomisationAndData];
    [_sideBarTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

- (void)viewCustomisationAndData {
    [_userProfileImageView setCornerRadius:_userProfileImageView.frame.size.width/2];
    [_userProfileImageView setBorder:_userProfileImageView color:[UIColor whiteColor] borderWidth:3.0];
    [ImageCaching downloadImages:_userProfileImageView imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
    
    _userEmailLabel.translatesAutoresizingMaskIntoConstraints=YES;
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        _userEmailLabel.text=NSLocalizedText(@"guestUser");
    }
    else {
        _userEmailLabel.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"firstname"],[UserDefaultManager getValue:@"lastname"]];
    }
    _userEmailLabel.numberOfLines=2;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userEmailLabel.text font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-120 heightValue:45];
    _userEmailLabel.frame=CGRectMake(30, _userEmailLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-120, newHeight+1);
    //remove extra lines from table view
    _sideBarTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItemsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row==5) {
        UILabel *notificationBadgeLabel=(UILabel *) [cell viewWithTag:10];
        notificationBadgeLabel.translatesAutoresizingMaskIntoConstraints=YES;
        if([[[UserDefaultManager getValue:@"notificationsCount"] stringValue] isEqualToString:@""] || [UserDefaultManager getValue:@"notificationsCount"]==nil || [[[UserDefaultManager getValue:@"notificationsCount"] stringValue] isEqualToString:@"0"]) {
            notificationBadgeLabel.hidden=YES;
        }
        else {
            notificationBadgeLabel.hidden=NO;
            notificationBadgeLabel.text=[[UserDefaultManager getValue:@"notificationsCount"] stringValue];
        }
        [notificationBadgeLabel sizeToFit];
        notificationBadgeLabel.frame=CGRectMake(185, notificationBadgeLabel.frame.origin.y,notificationBadgeLabel.frame.size.width+12, 15);
        [notificationBadgeLabel setCornerRadius:8.0];
    }
    
    UILabel *cellLabel=(UILabel *) [cell viewWithTag:1];
    UIImageView *cellImage=(UIImageView *) [cell viewWithTag:20];
    if (indexPath.row==10&&(nil==[UserDefaultManager getValue:@"userId"])) {
        cellLabel.text=NSLocalizedText(@"sideBarLogin");
        cellImage.image=[UIImage imageNamed:@"login"];
    }
    else {
        cellLabel.text=[[sideBarLabelArray objectAtIndex:indexPath.row] uppercaseString];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        if (![myDelegate checkGuestAccess]) {
             myDelegate.selectedCategoryIndex=-1;
           // [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
        }
    }
    else if (indexPath.row==1) {
        if (![myDelegate checkGuestAccess]) {
            myDelegate.selectedCategoryIndex=-1;
        }
    }
    else if (indexPath.row==2) {
        if (![myDelegate checkGuestAccess]) {
            myDelegate.selectedCategoryIndex=-1;
        }
    }
    else if (indexPath.row==3) {
        myDelegate.selectedCategoryIndex=-1;
        myDelegate.isProductList=false;
    }
    else if (indexPath.row==4) {
        myDelegate.selectedCategoryIndex=-1;
    }
    else if (indexPath.row==5) {
        if (![myDelegate checkGuestAccess]) {
            myDelegate.selectedCategoryIndex=-1;
        }
    }
    else if (indexPath.row==6) {
         myDelegate.selectedCategoryIndex=-1;
    }
    else if (indexPath.row==7) {
         myDelegate.selectedCategoryIndex=-1;
    }
    else if (indexPath.row==8) {
        myDelegate.selectedCategoryIndex=-1;
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsLetterSubscriptionViewController *popView =
        [storyboard instantiateViewControllerWithIdentifier:@"NewsLetterSubscriptionViewController"];
        popView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        [popView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:popView animated:YES completion:nil];
        });
    }
    else if (indexPath.row==9) {
        myDelegate.selectedCategoryIndex=-1;
    }
    else if (indexPath.row==10) {
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
            myDelegate.selectedCategoryIndex=-1;
            [myDelegate logoutUser];
        }
        else {
            myDelegate.selectedCategoryIndex=-1;
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
                //logout user
                [myDelegate logoutUser];
            }];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"logoutUser") closeButtonTitle:NSLocalizedText(@"alertCancel") duration:0.0f];
        }
    }
}

- (void)featureNotAvailable {
    if (![myDelegate checkGuestAccess]) {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
}
#pragma mark - end

#pragma mark - Navigation segue identifier
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        if([identifier isEqualToString:@"MyOrders"]) {
            return NO;
        }
        else if([identifier isEqualToString:@"Payment"]) {
            return NO;
        }
        else if([identifier isEqualToString:@"RedeemPoints"]) {
            return NO;
        }
        else if([identifier isEqualToString:@"Notifications"]) {
            return NO;
        }
        else if([identifier isEqualToString:@"AboutUs"]) {
            return YES;
        }
        else if([identifier isEqualToString:@"ContactUs"]) {
            return YES;
        }
        else {
            return YES;
        }
    }
    else {
        // by default perform the segue transition
//        if([identifier isEqualToString:@"MyOrders"]) {
//            return NO;
//        }
//        else {
        return YES;
//        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AboutUs"]) {
        UINavigationController *navController = [segue destinationViewController];
        WebPageViewController *destViewController = (WebPageViewController *)navController.topViewController;
        destViewController.pageIdentifier = @"AboutUs";
    }
    else if ([segue.identifier isEqualToString:@"ContactUs"]) {
        UINavigationController *navController = [segue destinationViewController];
        WebPageViewController *destViewController = (WebPageViewController *)navController.topViewController;
        destViewController.pageIdentifier = @"ContactUs";
    }
}
#pragma mark - end
@end
