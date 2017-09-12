//
//  AttendeesViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AttendeesViewController.h"
#import "AttendeesTableViewCell.h"

@interface AttendeesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *attendeesTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation AttendeesViewController
@synthesize attendeesArray;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"Attending");
    [self addLeftBarButtonWithImage:true];
    if (attendeesArray.count==0) {
        _noRecordLabel.hidden=NO;
        _noRecordLabel.text=NSLocalizedText(@"norecord");
    }
    else {
        _noRecordLabel.hidden=YES;
    }
    //remove extra lines from table view
    _attendeesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return attendeesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"attendeeCell";
    AttendeesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *tempDict=[attendeesArray objectAtIndex:indexPath.row];
    [cell displayData:tempDict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - end
@end
