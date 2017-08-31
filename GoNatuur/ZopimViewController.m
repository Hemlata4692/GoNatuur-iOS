//
//  ZopimViewController.m
//  GoNatuur
//
//  Created by Ranosys on 30/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ZopimViewController.h"
#import <ZDCChat/ZDCChat.h>
#import <ZendeskSDK/ZendeskSDK.h>

@interface ZopimViewController ()

@end
@implementation ZopimViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:253.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0]];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:true];
//     [self setupSupportInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

- (BOOL) setupIdentity {
    
        if ([UserDefaultManager getValue:@"firstname"]) {
    
    NSString *email = [UserDefaultManager getValue:@"emailId"];
    
    if ( email.length > 0) {
        
        [ZDKConfig instance].userIdentity = [[ZDKJwtIdentity alloc] initWithJwtUserIdentifier:email];
        return YES;
    }
        }
    
    return NO;
}

-(void) setupSupportInformation {
    
    [ZDKRequests configure:^(ZDKAccount *account, ZDKRequestCreationConfig *requestCreationConfig) {
        // configgure additional info
        NSString *appVersionString = [NSString stringWithFormat:@"version_%@",
                                      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        
        
        // Setting the custom form id to use the IOS Support form
        [ZDKConfig instance].ticketFormId = @62609;
        
        // adding Application Version information
        ZDKCustomField *customeFieldApplicationVersion = [[ZDKCustomField alloc] initWithFieldId:@24328555 andValue:appVersionString];
        //OS version
        ZDKCustomField *customFieldOSVersion = [[ZDKCustomField alloc] initWithFieldId:@24273979
                                                                              andValue:[UIDevice currentDevice].systemVersion];
        //Device model
        ZDKCustomField *customFieldDeviceModel = [[ZDKCustomField alloc] initWithFieldId:@24273989
                                                                                andValue:[ZDKDeviceInfo deviceType]];
        //Device memory
        NSString *deviceMemory = [NSString stringWithFormat:@"%f MB", [ZDKDeviceInfo totalDeviceMemory]];
        ZDKCustomField *customFieldDeviceMemory = [[ZDKCustomField alloc] initWithFieldId:@24273999
                                                                                 andValue:deviceMemory];
        //Device free space
        NSString *deviceFreeSpace = [NSString stringWithFormat:@"%f GB", [ZDKDeviceInfo freeDiskspace]];
        ZDKCustomField *customFieldDeviceFreeSpace = [[ZDKCustomField alloc] initWithFieldId:@24274009 andValue:deviceFreeSpace];
        //Device battery level
        NSString *deviceBatteryLevel = [NSString stringWithFormat:@"%f", [ZDKDeviceInfo batteryLevel]];
        ZDKCustomField *customFieldDeviceBatteryLevel = [[ZDKCustomField alloc] initWithFieldId:@24274019 andValue:deviceBatteryLevel];
        
        
        [ZDKConfig instance].customTicketFields = @[customeFieldApplicationVersion,
                                                    customFieldOSVersion,
                                                    customFieldDeviceModel,
                                                    customFieldDeviceMemory,
                                                    customFieldDeviceFreeSpace,
                                                    customFieldDeviceBatteryLevel];
        
        
        requestCreationConfig.tags = @[@"ratemyapp_ios", @"paying_customer"];
        
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        
        if(appName) {
            requestCreationConfig.additionalRequestInfo =
            [NSString stringWithFormat:@"%@-------------\nSent from %@.", requestCreationConfig.contentSeperator, appName];
        }
        
        
    }];
}

#pragma mark - IBActions
- (IBAction)zopimChatAction:(UIButton *)sender {
    [[ZDCChat instance].api trackEvent:@"Chat button pressed: (pre-set data)"];
    
    // before starting the chat set the visitor data
    [ZDCChat updateVisitor:^(ZDCVisitorInfo *visitor) {
        
        visitor.phone = [UserDefaultManager getValue:@"mobileNumber"];
        visitor.name = [UserDefaultManager getValue:@"firstname"];
        visitor.email = [UserDefaultManager getValue:@"emailId"];
    }];
    
    [ZDCChat startChatIn:[UIApplication sharedApplication].keyWindow.rootViewController.navigationController withConfig:^(ZDCConfig *config) {
        
        config.preChatDataRequirements.name = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.email = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.phone = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.department = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.message = ZDCPreChatDataRequired;
        config.tags = @[@"iPhoneChat"];
    }];
}

- (IBAction)ZopimTicketAction:(UIButton *)sender {
    if ([self setupIdentity]) {
        
              if([ZDKUIUtil isPad]) {
            
            self.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            [ZDKRequests presentRequestListWithViewController:self];
            
        } else {
            [ZDKRequests presentRequestListWithViewController:self];
//            [ZDKRequests pushRequestListWithNavigationController:self.navigationController layoutGuide:ZDKLayoutRespectTop];
        }
        
        
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Wait a second..." message:@"You need to go in the profile screen and setup your email ..." delegate:self cancelButtonTitle:@"OK, doing it now :)" otherButtonTitles:nil];
        [alert show];
    }
    
//    ZDKRequestProvider *provider = [ZDKRequestProvider new];
//    ZDKCreateRequest *request = [ZDKCreateRequest new];
//    
//    request.subject = @"My printer is on fire!";
//    request.requestDescription = @"The smoke is very colorful.";
//    request.tags = @[@"printer", @"fire"];
//    
//    [provider createRequest:request withCallback:^(id result, NSError *error) {
//        
//        if (error) {
//            // Handle the error
//            
//            // Log the error
//            [ZDKLogger e:@"Something went wrong"];
//            
//        } else {
//            // Handle the success
//        }
//    }];
}
#pragma mark - end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
