//
//  NSString+HexToBytes.m
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/17.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "NSString+HexToBytes.h"

@implementation NSString (HexToBytes)


/**
 将当前字符串等值转换为二进制值 如：str = "ff11"; 二进制值：data = <ff11>

 @return 二进制值
 */
- (NSData *)hexToBytes
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

/**
 将二进制值等比转换为字符串， 如二进制data = <ff11>, 则str = "ff11";

 @param data 给定的二进制
 @return 返回相应字符串
 */
+ (NSString *)hexStrByData:(NSData *)data
{
    return [self filterInvalidChar:[data description]];
}

/**
 过滤二进制字符串的无效字符
 
 @param NSString 二进制字符
 @return 已过滤无效字符的字符串
 */
+ (NSString *)filterInvalidChar:(NSString *)str
{
    //    text = [NSMutableString stringWithFormat:@"%@", [text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    str = [NSMutableString stringWithFormat:@"%@", [str stringByReplacingOccurrencesOfString:@"<" withString:@""]];
    str = [NSMutableString stringWithFormat:@"%@", [str stringByReplacingOccurrencesOfString:@">" withString:@""]];
    str = [NSMutableString stringWithFormat:@"%@", [str stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    return str.uppercaseString;
}

@end
