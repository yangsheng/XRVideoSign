//
//  DES3Util.h
//  JuziAnalyticsDemo
//
//  Created by wanyakun on 13-6-6.
//  Copyright (c) 2013年 The9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

+ (NSString*) AES128Encrypt:(NSString *)plainText;

+ (NSString*) AES128Decrypt:(NSString *)encryptText;

@end
