
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

@interface NSString (Ext)

#pragma mark - security spec
- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)urlEncode;

#pragma mark - utils
- (BOOL)contain:(NSString *)string;
- (NSString *)escape;
- (NSString *)unEscape;
- (NSString *)append:(NSString *)string;
- (NSString *)trim;
- (NSString *)trimNewLine;
- (CGSize)sizeOfFont:(UIFont *)font;
- (NSString *)removeSpace;
- (NSString *)filterNonNumericCharacter;
- (NSString *)removeString:(NSString *)string;
- (NSString *)escapeStringParameterUrl;
- (NSData *)dataFromHexString;
- (NSString *)stringbySha512;
- (NSString *)stringbySha256;
- (NSString *)uppercaseFirstLetter;
- (NSString *)extractNumber;
- (BOOL)containsString:(NSString *)string andOption:(NSStringCompareOptions)mask;
- (NSString *)removeEmoji;
+ (NSString *)wrap;
- (NSString *)insertAtIndex:(NSInteger)index;
- (BOOL)isNil;

#pragma mark - note - do not use
+ (NSString *)imprCStringWithEncoding:(NSStringEncoding)encoding format:(const char *)format,...;
+ (NSString *)imprCStringWithUTF8StringFormat:(const char *)format,...;
+ (NSString *)timeFormatConvertToSeconds:(NSNumber *)secs;
+ (NSString *)getTextBtw:(NSString *)text lBound:(NSString *)lBound rBound:(NSString *)rBound;

@end
