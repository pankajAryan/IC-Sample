//
//  SecurityUtility.m
//  PBEWithMD5andDES-Sample
//
//  Created by Ashish Singal on 03/11/14.
//  Copyright (c) 2014 Ashish Singal. All rights reserved.
//

#import "SecurityUtility.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation SecurityUtility

+ (NSData*) UTF8StringToData:(NSString*)str{
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)bytesToHexStr:(NSData *)data
{
    NSMutableString *hexStr = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    
    char temp[3];
    int i = 0;
    
    for (i = 0; i < [data length]; i++) {
        temp[0] = temp[1] = temp[2] = 0;
        (void)sprintf(temp, "%02x", bytes[i]);
        [hexStr appendString:[NSString stringWithUTF8String:temp]];
    }
    return hexStr;
}
+ (NSData*) hexStrToBytes:(NSString*)strHex
{
    NSMutableData* data = [[NSMutableData alloc] init] ;
    int idx;
    for (idx = 0; idx+2 <= strHex.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [strHex substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
+ (NSString *)bytesToBase64Data:(NSData *)data
{
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}
+ (NSData*) Base64DatatoBytes:(NSString*)base64String
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return decodedData;
}

+ (NSString*) DataToUTF8String:(NSData*)data{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
}

/*
 Encryption logic with rsa
 */
+(NSString *)encryptRSA:(NSString *)plainTextString key:(SecKeyRef)publicKey
{
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    uint8_t *nonce = (uint8_t *)[plainTextString UTF8String];
    SecKeyEncrypt(publicKey,
                  kSecPaddingOAEP,
                  nonce,
                  strlen( (char*)nonce ),
                  &cipherBuffer[0],
                  &cipherBufferSize);
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    return [self bytesToBase64Data:encryptedData];
}

#pragma mark- AES/ECB/PKCS5Padding

#define FBENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES256

+ (NSString *)AESEncrypt:(NSString*)inputValue withKey:(NSString *)key {
    
    NSData *inputData = [inputValue dataUsingEncoding:NSUTF8StringEncoding];
    
    // setup key
    NSUInteger numberOfBytes = [key lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    NSUInteger usedLength = 0;
    NSRange range = NSMakeRange(0, [key length]);
   
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    
    [key getBytes:cKey maxLength:numberOfBytes usedLength:&usedLength encoding:NSUnicodeStringEncoding options:0 range:range remainingRange:NULL];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
//    if (iv) {
//        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
//    }
    
    // setup output buffer
    size_t bufferSize = [inputData length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [inputData bytes],
                                          [inputData length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        return [[NSData dataWithBytesNoCopy:buffer length:encryptedSize] base64EncodedStringWithOptions:0];
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
    
/*
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [inputData length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) ,
                                          [inputData bytes], dataLength, /* input
                                          buffer, bufferSize, /* output
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] base64EncodedStringWithOptions:0];
    }
    
    free(buffer); //free the buffer;
 
    */
    
    return nil;
}

@end
