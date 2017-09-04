//
//  LocalizedString.m
//  GoNatuur
//
//  Created by Ranosys on 10/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "LocalizedString.h"

@implementation LocalizedString

+ (NSString*)changeLocalizedString:(NSString*)string {
      return [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] ofType:@"strings"]] objectForKey:string];
}
@end
