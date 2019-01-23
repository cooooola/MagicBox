//
//  CCJsonTool.m
//  SmallGames
//
//  Created by hello on 2018/11/1.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCJsonTool.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>

@implementation CCJsonTool
+(id)JsonToolWithDataConvertedJsonWhitData:(id)data{
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return jsonObject;
}


+(NSString *)JsonToolGetTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *tempDate = [dateFormatter dateFromString:str];
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];
    return timeStr;
}

+(NSString *)JsonToolDataTimeStrWithString:(NSString *)str{
    NSTimeInterval interval    = [str doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}


+(NSString *)JsonGetNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+(NSString *)JsonHmacSha{
    const char *cKey  = [@"205ddc6f72d30f461e020bf15eb92d19" cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [[self JsonGetNowTimeTimestamp] cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSString *hash;
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;
}

+ (NSString *)JsonToolEncodedStringWithString:(NSString *)string{
    NSString *unencodedString = string;
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (BOOL)checkPhotoLibraryAuthorizationStatus{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window  andText:@"请在iPhone的“设置->大黄鸭->照片”中打开本应用的访问权限"];
        return NO;
    }
    return YES;
}

+(NSString*)JsonToolUniqueAppInstanceIdentifier{
    static NSString* UUID_KEY = @"MPUUID";
    static NSString *Service_KEY = @"com.gameCasualSoccer";
    NSString* app_uuid = [self passwordForService:Service_KEY account:UUID_KEY];
    if (app_uuid == nil) {
        app_uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        app_uuid = [self md5:app_uuid];
        [self addItemWithService:Service_KEY account:UUID_KEY password:app_uuid];
    }
    return app_uuid;
}

+ (NSString *) md5:(NSString *) str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



+(BOOL)addItemWithService:(NSString *)service account:(NSString *)account password:(NSString *)password{
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    [queryDic setObject:service forKey:(__bridge id)kSecAttrService];
    [queryDic setObject:account forKey:(__bridge id)kSecAttrAccount];
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    OSStatus status = -1;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &result);
    if (status == errSecItemNotFound) {
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
        [queryDic setObject:passwordData forKey:(__bridge id)kSecValueData];
        status = SecItemAdd((__bridge CFDictionaryRef)queryDic, NULL);
    }else if (status == errSecSuccess){
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:queryDic];
        [dict setObject:passwordData forKey:(__bridge id)kSecValueData];
        status = SecItemUpdate((__bridge CFDictionaryRef)queryDic, (__bridge CFDictionaryRef)dict);
    }
    return (status == errSecSuccess);
}

+(NSString *)passwordForService:(nonnull NSString *)service account:(nonnull NSString *)account{
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [queryDic setObject:(__bridge id)kCFBooleanTrue  forKey:(__bridge id)kSecReturnData];
    [queryDic setObject:service forKey:(__bridge id)kSecAttrService];
    [queryDic setObject:account forKey:(__bridge id)kSecAttrAccount];
    OSStatus status = -1;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic,&result);
    if (status != errSecSuccess) {
        return nil;
    }
    [queryDic removeObjectForKey:(__bridge id)kSecReturnData];
    NSString *password = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)result bytes] length:[(__bridge NSData *)result length] encoding:NSUTF8StringEncoding];
    [queryDic setObject:password forKey:(__bridge id)kSecValueData];
    return password;
}


@end
