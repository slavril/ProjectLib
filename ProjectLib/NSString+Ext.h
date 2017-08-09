//
//  NSString+Custom.h
//  Zippie
//
//  Created by Manh Nguyen on 5/13/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

@interface NSString (Ext)

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)urlEncode;
- (BOOL)containsString:(NSString *)string;
- (NSString *)escapeString;
- (NSString *)unEscapeString;
- (NSString *)add:(NSString *)string;
- (NSString *)addToAbove:(NSString *)string;
- (NSString *)trimSpace;
- (NSString *)trimPlus;
- (NSString *)trimZero;
- (NSString *)trimPlusOrZero;
- (NSString *)trimPlusOrZeroAndSpace;
- (NSString *)trimNewLine;
- (NSString*)trimNewLineAndSpace;
- (NSString *)trimDecimalDigit;
- (NSString *)addPlus;
- (CGSize)sizeOfFont:(UIFont *)font;
- (NSString *)removeSpace;
- (NSString*)filterNonNumericCharacter;
- (NSString *)removeSpecialKeyChar;
- (NSString *)cleanPhone;
- (NSString *)removeString:(NSString *)string;
- (NSString *)escapeStringParameterUrl;
- (NSData *)dataFromHexString;
- (NSString *)stringbySha512;
- (NSString *)stringbySha256;
- (NSString *)uppercaseFirstLetter;
- (NSString *)extractNumber;
- (BOOL)containsString:(NSString *)string andOption:(NSStringCompareOptions)mask;

+ (NSString *)generateUUID;
- (NSString *)generateUUID;
+ (NSString *)timeFormatConvertToSeconds:(NSNumber *)secs;

+ (NSString *)getTextBtw:(NSString *)text lBound:(NSString *)lBound rBound:(NSString *)rBound;
- (NSString *)removeEmoji;

#pragma mark - func in C for improve performance

/**
 NSString creation is not particularly expensive, but when used in a tight loop (as dictionary keys, for example), +[NSString stringWithFormat:] performance can be improved dramatically by being replaced with asprintf or similar functions in C.
 */
+ (NSString *)imprCStringWithEncoding:(NSStringEncoding)encoding format:(const char *)format,...;
+ (NSString *)imprCStringWithUTF8StringFormat:(const char *)format,...;

@end
