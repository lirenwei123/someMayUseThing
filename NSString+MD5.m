//
//  NSString+MD5.m
//  MD5加密
//
//  Created by 苹果电脑 on 16/9/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5{
    
    //加密
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    //将OC的串转为C的串
    const char *data = [self UTF8String];
    //<#const void *data#>:要加密的数据
    CC_MD5(data, (CC_LONG)strlen(data), md);
    
//    CC_MD5(<#const void *data#>, <#CC_LONG len#>, <#unsigned char *md#>)
    //转成OC的串
    NSMutableString *string = [NSMutableString string];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [string appendFormat:@"%02x", md[i]];
    }
    return string;
}

@end




