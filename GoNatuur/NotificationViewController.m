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

@interface NotificationViewController () {
@private
    NSMutableArray *notificationArray;
    int totalCount;
}
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;

@end

@implementation NotificationViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _notificationTableView.estimatedRowHeight = 400.0;//set maximum row height
    _notificationTableView.rowHeight = UITableViewAutomaticDimension;//set dynamic height of row according to text
    _notificationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//remove extra cell from table view
    
    notificationArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=@"Notifications";
    [self addLeftBarButtonWithImage:false];
    
    //call notification list webservice
    [myDelegate showIndicator];
    [self performSelector:@selector(getNotificationListing) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getNotificationListing {
    NotificationDataModel *notificationList = [NotificationDataModel sharedUser];
    [notificationList getUserNotification:^(NotificationDataModel *userData)  {
        [myDelegate stopIndicator];
        notificationArray=[userData.notificationListArray mutableCopy];
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
    UITableViewCell *complainCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (complainCell == nil) {
        complainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *notificationBadgeLabel=(UILabel *) [complainCell viewWithTag:1];
    notificationBadgeLabel.translatesAutoresizingMaskIntoConstraints=YES;
    notificationBadgeLabel.text=[[notificationArray objectAtIndex:indexPath.row] notificationMessage];
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:notificationBadgeLabel.text font:[UIFont fontWithName:@"Montserrat-Regular" size:15.0] widthValue:_notificationTableView.frame.size.width-77];
    notificationBadgeLabel.frame=CGRectMake(48, 7,_notificationTableView.frame.size.width-77, newHeight+1);
    return complainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
#pragma mark - end
@end
