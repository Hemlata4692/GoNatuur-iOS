//
//  OrderListingViewController.m
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderListingViewController.h"
#import "OrderModel.h"
#import "OrderListingCell.h"
#import "DynamicHeightWidth.h"
#import "UIImage+UIImage_fixOrientation.h"
#import "ProfileModel.h"
#import "OrderDetailViewController.h"
#import "UIView+Toast.h"

@interface OrderListingViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
@private
    NSMutableArray *orderListArray, *selectedSecArray;
    OrderModel *orderDataModel;
    UIImage *userProfileImage;
    BOOL isImagePicker;
    UIView *sectionView;
    UIImageView* arrowView;
    int totalProductCount, currentpage;
    UIView *footerView;
}
@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation OrderListingViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    orderListArray = [NSMutableArray new];
    selectedSecArray = [NSMutableArray new];
    isImagePicker = false;
    [myDelegate showIndicator];
    [self performSelector:@selector(getUserImapctPoints) withObject:nil afterDelay:.1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"orderTitle");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:false];
    totalProductCount=0;
    currentpage=1;
    _orderListTableView.tableFooterView=nil;
    //Allocate footer view
    [self initializeFooterView];
    if (!isImagePicker) {
        [_orderListTableView reloadData];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (orderListArray.count > 0) {
        return [orderListArray count]+1;
    } else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    else {
        if ([[selectedSecArray objectAtIndex:section-1] boolValue]) {
            return 1;
        }
        else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    else
        return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return 150;
        } else if (indexPath.row==1) {
            return [DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50 heightValue:60]+10;
        } else if (indexPath.row==2) {
            return 80;
        } else if (indexPath.row==3) {
            return 55;
        } else if (indexPath.row==4) {
            return 12;
        }
    }
    else  {
        float height =[DynamicHeightWidth getDynamicLabelHeight:orderDataModel.shippingAddress font:[UIFont montserratLightWithSize:14] widthValue:_orderListTableView.frame.size.width-132 heightValue:50];
        float billHeight =[DynamicHeightWidth getDynamicLabelHeight:orderDataModel.BillingAddress font:[UIFont montserratLightWithSize:14] widthValue:_orderListTableView.frame.size.width-132 heightValue:50];
        return 105 + height + billHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            simpleTableIdentifier=@"profileImageCell";
        } else if (indexPath.row == 1) {
            simpleTableIdentifier=@"userEmailCell";
        } else if (indexPath.row == 2) {
            simpleTableIdentifier=@"impactPointCell";
        } else if (indexPath.row == 3) {
            simpleTableIdentifier=@"TrackShippingCell";
        } else if (indexPath.row == 4) {
            simpleTableIdentifier=@"bottomArrowCell";
        }
    }
    else {
        simpleTableIdentifier=@"orderListCell";
    }
    OrderListingCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[OrderListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
        } else {
            [cell displayData:_orderListTableView.frame.size];
            [cell.editProfileImage addTarget:self action:@selector(editUserImageAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        orderDataModel = [orderListArray objectAtIndex:indexPath.section - 1];
        [cell displayOrderData:_orderListTableView.frame.size orderData:orderDataModel];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260,0)];
        return sectionView;
    }
    else {
        orderDataModel = [orderListArray objectAtIndex:section-1];
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,70)];
        sectionView.tag=section;
        sectionView.backgroundColor = [UIColor whiteColor];
        //Add order Id label
        UILabel *orderIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 3, _orderListTableView.frame.size.width-20, 30)];
        orderIdLabel.font = [UIFont montserratRegularWithSize:16];
        orderIdLabel.textAlignment=NSTextAlignmentLeft;
        NSString *str=[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"PurchaseOrderHeading"), orderDataModel.purchaseOrderId];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange registerTextRange = [str rangeOfString:NSLocalizedText(@"PurchaseOrderHeading")];
        [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratSemiBoldWithSize:16]} range:registerTextRange];
        orderIdLabel.attributedText=string;
        [sectionView addSubview:orderIdLabel];
        //Add order date label
        UILabel *orderDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, _orderListTableView.frame.size.width-10, 30)];
        orderDateLabel.font = [UIFont montserratRegularWithSize:13];
        orderDateLabel.textAlignment=NSTextAlignmentLeft;
        str=[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"orderDateHeading"), orderDataModel.orderDate];
        string = [[NSMutableAttributedString alloc]initWithString:str];
        registerTextRange = [str rangeOfString:NSLocalizedText(@"orderDateHeading")];
        [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratSemiBoldWithSize:13]} range:registerTextRange];
        orderDateLabel.attributedText=string;
        [sectionView addSubview:orderDateLabel];
        //Add a custom Separator with Section view
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 69, _orderListTableView.frame.size.width - 20, 1)];
        separatorLineView.backgroundColor = [UIColor lightGrayColor];
        [sectionView addSubview:separatorLineView];
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(_orderListTableView.frame.size.width - 25, (sectionView.frame.size.height/2) - 6, 12, 12)];
        arrowView.image = [UIImage imageNamed:@"arrowGrey"];
        if ([[selectedSecArray objectAtIndex:section-1] boolValue]) {
            arrowView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        else {
            arrowView.transform = CGAffineTransformMakeRotation(M_PI*2);
        }
        [sectionView addSubview:arrowView];
        //Add UITapGestureRecognizer to SectionView
        UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
        [sectionView addGestureRecognizer:headerTapped];
        return  sectionView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    } else {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OrderDetailViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
        nextView.selectedIndex = indexPath.section - 1;
        [self.navigationController pushViewController:nextView animated:YES];
    }
}
#pragma mark - end

#pragma mark - Pagination
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height)
    {
        if (orderListArray.count == totalProductCount)
        {
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
            [(UILabel *)[footerView viewWithTag:11] setHidden:true];
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
            _orderListTableView.tableFooterView = nil;
        }
        else {
            if(orderListArray.count <= totalProductCount)
            {
                _orderListTableView.tableFooterView = footerView;
                [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
                currentpage+=1;
                [self getOrderListing];
            }
            else
            {
                _orderListTableView.tableFooterView = nil;
            }
        }
    }
}
#pragma mark - end

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.section == 0) {
        
    } else {
        if (indexPath.row < orderListArray.count) {
            BOOL collapsed  = [[selectedSecArray objectAtIndex:indexPath.section-1] boolValue];
            for (int i=0; i<[orderListArray count]; i++) {
                if (indexPath.section - 1 == i) {
                    [selectedSecArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                } else {
                }
            }
            [_orderListTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)trackShippingButtonAction:(id)sender {
    [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
}

- (IBAction)editUserImageAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedText(@"TakePhoto")delegate:self cancelButtonTitle: NSLocalizedText(@"alertCancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedText(@"Camera"), NSLocalizedText(@"Gallery"), nil];
    [actionSheet showInView:self.view];
}
#pragma mark - end

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedText(@"error")message:NSLocalizedText(@"noCamera")delegate:nil cancelButtonTitle:NSLocalizedText(@"alertOk")otherButtonTitles: nil];
            [myAlertView show];
        }
        else {
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
    OrderListingCell * cell = (OrderListingCell *)[_orderListTableView cellForRowAtIndexPath:index];
    UIImage *correctOrientationImage = [image fixOrientation];
    cell.userProfileImage.image=correctOrientationImage;
    isImagePicker=true;
    userProfileImage=cell.userProfileImage.image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [myDelegate showIndicator];
    [self performSelector:@selector(editUserProfileImage) withObject:nil afterDelay:.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Web services
- (void)getUserImapctPoints {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.pageCount=@"1";
    userData.currentPage=@"1";
    [userData getImpactPoints:^(ProfileModel *userData) {
        [self performSelector:@selector(getOrderListing) withObject:nil afterDelay:.1];
        [_orderListTableView reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)getOrderListing {
    orderDataModel = [OrderModel sharedUser];
    orderDataModel.pageSize=[NSNumber numberWithInt:12];
    orderDataModel.currentPage=[NSNumber numberWithInt:currentpage];
    [orderDataModel getOrderListing:^(OrderModel *userData) {
        [orderListArray addObjectsFromArray:userData.orderListingArray];
        if (orderListArray.count > 0) {
            for (int i=0; i<[orderListArray count]; i++) {
                [selectedSecArray addObject:[NSNumber numberWithBool:NO]];
            }
            _noRecordLabel.hidden = YES;
        } else {
            _noRecordLabel.hidden = NO;
        }
        totalProductCount=[userData.totalProductCount intValue];
        if (orderListArray.count == totalProductCount) {
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
            [(UILabel *)[footerView viewWithTag:11] setHidden:true];
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
            _orderListTableView.tableFooterView = nil;
        }
        [_orderListTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
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
@end
