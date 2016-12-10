//
//  SecurityUtility.h
//  PBEWithMD5andDES-Sample
//
//  Created by Ashish Singal on 03/11/14.
//  Copyright (c) 2014 Ashish Singal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtility : NSObject

+ (NSData*)     hexStrToBytes:      (NSString*)strHex;
+ (NSString*)   bytesToHexStr:      (NSData*)data;
+ (NSString*)   bytesToBase64Data:  (NSData*)data;
+ (NSData*)     Base64DatatoBytes:  (NSString*)base64String;

+ (NSString*)   DataToUTF8String:   (NSData*)data;
+ (NSData*)     UTF8StringToData:   (NSString*)str;


+ (NSString*)  encryptRSA:(NSString*)plainTextString key:(SecKeyRef)publicKey;

+ (NSString *) AESEncrypt:(NSString*)inputValue withKey:(NSString *)key;

@end

