//
//  TicketingViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "TicketingViewController.h"
#import "TicketTableViewCell.h"
#import "DynamicHeightWidth.h"

@interface TicketingViewController () {
    @private
    NSMutableArray *ticketArray;
}
@property (weak, nonatomic) IBOutlet UITableView *ticketTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation TicketingViewController
@synthesize ticketingArray;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (ticketingArray.count==0) {
        _noRecordLabel.hidden=NO;
        _noRecordLabel.text=NSLocalizedText(@"norecord");
    }
    else {
        _noRecordLabel.hidden=YES;
        ticketArray=[[NSMutableArray alloc]init];
        NSMutableDictionary *tempDict=[ticketingArray objectAtIndex:0];
        ticketArray=[[[tempDict objectForKey:@"event_option_type"]objectForKey:@"event_option_options"] mutableCopy];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"ticketing");
    [self addLeftBarButtonWithImage:true];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

      NSDictionary *ticketDict=[ticketArray objectAtIndex:indexPath.row];
    float nameHeight=[DynamicHeightWidth getDynamicLabelHeight:[ticketDict objectForKey:@"title"] font:[UIFont montserratLightWithSize:13] widthValue:(_ticketTableView.frame.size.width-20)/2-16];
    float priceHeight=[DynamicHeightWidth getDynamicLabelHeight:[ticketDict objectForKey:@"price"] font:[UIFont montserratLightWithSize:13] widthValue:(_ticketTableView.frame.size.width-20)/2-16];
    if (nameHeight<=25 && priceHeight<=25) {
        return 71;
    }
    else {
    return 50+nameHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ticketArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ticketCell";
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *ticketDict=[ticketArray objectAtIndex:indexPath.row];
    [cell displayData:ticketDict rectSize:cell.contentView.frame.size];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - end

@end
