//
//  UserDefaultManager.m
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager
//- (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
+ (void)setValue:(id)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (id)getValue:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

+ (void)removeValue:(NSString *)key {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}

+ (NSNumber *)getNumberValue:(NSString *)key dictData:(NSDictionary *)dictData {
    if ((nil==dictData[key])||[dictData[key] isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithInt:0];
    }
    return [NSNumber numberWithInt:[dictData[key] intValue]];
}

+ (NSString *)checkStringNull:(NSString *)key dictData:(NSDictionary *)dictData {
    if (nil==dictData[key]) {
        return @"";
    }
    return dictData[key];
}
@end
