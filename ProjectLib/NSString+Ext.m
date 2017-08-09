//
//  NSString+Custom.m
//  Zippie
//
//  Created by Manh Nguyen on 5/13/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import "NSString+Ext.h"

#define kMaxLengthVisible 20

@implementation NSString (Ext)

- (NSString*)md5 {
    // Create pointer to the string as UTF8
    const char *ptr = self.UTF8String;
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (uint32_t)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString *)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)urlEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)self.UTF8String;
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (BOOL)containsString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([self rangeOfString:string].location == NSNotFound) return NO;
    return YES;
}

- (BOOL)containsString:(NSString *)string andOption:(NSStringCompareOptions)mask {
    NSRange range = [self rangeOfString:string options:mask];
    if (range.location == NSNotFound) return NO;
    return YES;
}

- (NSString *)escapeString {
    NSString *retVal = self;
    if (retVal)
    {
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"\'" withString:@"&apos;"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    }
    
    return retVal;
}

- (NSString *)unEscapeString {
    NSString *retVal = self;
    if (retVal)
    {
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&apos;" withString:@"\'"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    }
    
    return retVal;
}

+ (NSString *)wrapString:(NSString *)string {
    if (string != nil && ![string isKindOfClass:[NSNull class]]) {
        return string;
    }
    return @"";
}

- (NSString *)add:(NSString *)string {
    return [self stringByAppendingString:[[self class] wrapString:string]];
}

- (NSString *)addToAbove:(NSString *)string {
    return [string stringByAppendingString:self];
}

- (NSString *)trimSpace {
    NSString *result = [[self class] wrapString:self];
    return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimPlus {
    NSString *result = [self trimSpace];
    if ([result rangeOfString:@"+"].location == 0) {
        result = [result substringFromIndex:1];
    }
    return result;
}

- (NSString *)trimZero {
    NSString *result = [self trimSpace];
    if ([result rangeOfString:@"0"].location == 0) {
        result = [result substringFromIndex:1];
    }
    return result;
}

- (NSString *)trimPlusOrZero {
    NSString *result = [self trimSpace];
    if ([result rangeOfString:@"+"].location == 0 || [result rangeOfString:@"0"].location == 0) {
        result = [result substringFromIndex:1];
    }
    return result;
}

- (NSString *)trimPlusOrZeroAndSpace {
    return [[self removeSpace] trimPlusOrZero];
}

- (NSString *)trimNewLine {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
}

- (NSString*)trimNewLineAndSpace {
    return [[self trimSpace] trimNewLine];
}

- (NSString *)trimDecimalDigit {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet] componentsJoinedByString:@""];
}

- (NSString *)addPlus {
    return [[self trimPlus] addToAbove:@"+"];
}

- (CGSize)sizeOfFont:(UIFont *)font {
    if (font) {
        return [self sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    return CGSizeZero;
}

- (NSString *)removeSpace {
    NSString *cleaned = [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    return cleaned;
}

- (NSString*)filterNonNumericCharacter {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"].invertedSet] componentsJoinedByString:@""];
}

- (NSString *)removeSpecialKeyChar {
    NSString *str = [self removeSpace];
    BOOL hasPlusPrefix = NO;
    if ([str hasPrefix:@"+"]) {
        hasPlusPrefix = YES;
    }
    NSString *result = [[self componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet] componentsJoinedByString:@""];
    if (hasPlusPrefix) {
        result = [result addPlus];
    }
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"*" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([result rangeOfString:@"00"].location == 0 ||
        [result rangeOfString:@"+00"].location == 0 ||
        [result rangeOfString:@"+0"].location == 0 ||
        [result rangeOfString:@"011"].location == 0 ) {
        
        BOOL hasPlus = ([result hasPrefix:@"+"]
                        || [result rangeOfString:@"00"].location == 0
                        || [result rangeOfString:@"011"].location == 0);
        BOOL hasZeroOneOne = [result hasPrefix:@"011"];
        if (hasPlus) {
            result = [result trimPlus];
        }
        NSRange range = [result rangeOfString:(hasZeroOneOne)?@"011":@"^0*" options:NSRegularExpressionSearch];
        result = [result stringByReplacingCharactersInRange:range withString:@""];
        if (hasPlus) {
            result = [result addPlus];
        }
    }
    return result;
}

- (NSString *)cleanPhone {
    NSString *result = [self removeSpecialKeyChar];
    return [result trimPlusOrZero];
}

- (NSString *)removeString:(NSString *)string {
    NSString *result;
    result = [self stringByReplacingOccurrencesOfString:string withString:@""];
    return result;
}

- (NSString *)escapeStringParameterUrl {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

+ (NSString *)timeFormatConvertToSeconds:(NSNumber *)secs{
    NSInteger totalSeconds = secs.integerValue;
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
    else{
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
}

- (NSData *)dataFromHexString {
    const char *chars = self.UTF8String;
    NSInteger i = 0, len = self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

- (NSString *)stringbySha512 {
    const char *cString = self.UTF8String;
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(cString, (CC_LONG)strlen(cString), result);
    NSString *hash = @"";
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        hash = [hash stringByAppendingFormat:@"%02X",result[i]];
    }
    return hash;
}

- (NSString *)stringbySha256
{
    const char *cString = self.UTF8String;
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cString, (CC_LONG)strlen(cString), result);
    NSString *hash = @"";
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        hash = [hash stringByAppendingFormat:@"%02X",result[i]];
    }
    return hash;
}

- (NSString *)uppercaseFirstLetter{
    NSString *capitalisedSentence = nil;
    if (self && self.length > 0) {
        capitalisedSentence = [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                            withString:[self substringToIndex:1].capitalizedString];
    }
    return capitalisedSentence;
}

- (NSString *)extractNumber {
    NSCharacterSet *nonDigitCharacterSet = [NSCharacterSet decimalDigitCharacterSet].invertedSet;
    return [[self componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

+ (NSString *)generateUUID{
    NSString *result = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid){
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return result;
}

- (NSString *)generateUUID{
    return [[self class] generateUUID];
}

+ (NSString *)getTextBtw:(NSString *)text lBound:(NSString *)lBound rBound:(NSString *)rBound {
    @try {
        NSArray *arr1 = [text componentsSeparatedByString:lBound];
        if (arr1.count > 1) {
            NSArray *arr2 = [arr1[1] componentsSeparatedByString:rBound];
            if (arr2 == nil || arr2.count <= 1)
                return arr1[1];
            return arr2[0];
        }
        else {
            return nil;
        }
    } @catch (NSException *e) {
        return nil;
    }
}

- (BOOL)isNumberEmoji:(NSString *)string {
    const unichar hs = [string characterAtIndex: 0];
    if ((hs <= 0x0039 && hs >= 0x0030)) {
        // is number
        if (string.length >= 3) {
            const unichar numberEmo1 = [string characterAtIndex: 1];
            const unichar numberEmo2 = [string characterAtIndex: 2];
            if (numberEmo1 == 0xfe0f || numberEmo2 == 0x20e3) {
                // is spec char
                return YES;
            }
        }
    }
    else if ((hs == 0x002a || hs == 0x0023) && string.length >= 3) {
        //character *
        const unichar numberEmo1 = [string characterAtIndex: 1];
        const unichar numberEmo2 = [string characterAtIndex: 2];
        if (numberEmo1 == 0xfe0f || numberEmo2 == 0x20e3) {
            // is spec char
            return YES;
        }
    }
    return NO;
}

- (BOOL)isContainEmoji {
    __block BOOL isEmoj = NO;
    
    [self enumerateSubstringsInRange: NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         
         const unichar hs = [substring characterAtIndex: 0];
         //apps.timwhitlock.info/emoji/tables/unicode - recommend
         //unicode.org/emoji/charts/full-emoji-list.html
         
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             const unichar ls = [substring characterAtIndex: 1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             if ((0x1d000 <= uc && uc <= 0x1F9FF)) {
                 isEmoj = YES;
                 *stop = YES;
             }
             // non surrogate
         } else {
             if ((0x2100 <= hs && hs <= 0x26ff)) {
                 isEmoj = YES;
                 *stop = YES;
             }
             else if ([self isNumberEmoji:substring]) {
                 isEmoj = YES;
                 *stop = YES;
             }
         }
     }];
    
    return isEmoj;
}

- (NSData *)Character:(NSString *)character {
    NSString *chax = [NSString stringWithFormat:@"\(%@)", character];
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    CGSize size = [chax sizeWithAttributes:attrsDictionary];
    
    UIGraphicsBeginImageContext(size);
    [chax drawAtPoint:CGPointMake(0, 0) withAttributes:attrsDictionary];
    NSData *charData = nil;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    charData = UIImagePNGRepresentation(image);
    UIGraphicsEndImageContext();
    return charData;
}

- (BOOL)validImoji:(NSString *)character {
    uint32_t refCode = 0x1f3f6;
    
    refCode = OSSwapHostToLittleInt32(refCode); // To make it byte-order safe
    NSString *refString = [[NSString alloc] initWithBytes:&refCode length:4 encoding:NSUTF32LittleEndianStringEncoding];
    
    NSData *refData = [self Character:refString];
    NSData *emojiData = [self Character:character];
    if (refData && emojiData && [refData isEqual:emojiData]) {
        return NO;
    }
    return YES;
}

- (BOOL)isContainValidEmoji {
    __block BOOL validEmoji = YES;
    [self enumerateSubstringsInRange: NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         
         const unichar hs = [substring characterAtIndex: 0];
         if (hs == 0xd83e) {
             validEmoji = NO;
             *stop = YES;
         }
     }];
    
    return validEmoji;
}

- (NSString*)removeEmoji {
    __block NSMutableString* temp = [NSMutableString string];
    
    [self enumerateSubstringsInRange: NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         
         const unichar hs = [substring characterAtIndex: 0];
         //apps.timwhitlock.info/emoji/tables/unicode - recommend
         //unicode.org/emoji/charts/full-emoji-list.html
         
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             const unichar ls = [substring characterAtIndex: 1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             if ((0x1d000 <= uc && uc <= 0x1F9FF)) {
                 [temp appendString:@""];
             }
             else if (hs != 0x200d) {
                 [temp appendString:substring];
             } // U+1D000-0x1F9FF
             
         // non surrogate
         } else {
             if ((0x2100 <= hs && hs <= 0x26ff)) {
                 [temp appendString:@""];
             }
             else if ([self isNumberEmoji:substring]) {
                 [temp appendString:@""];
             }
             else if (hs != 0x200d) {
                 [temp appendString:substring];
             }
         }
     }];
    
    return temp;
}

- (NSString *)convertContentWithValidEmoji {
    [self validImoji:self];
    __block NSString *copySelf = [self copy];
    [self enumerateSubstringsInRange: NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         if ([substring rangeOfCharacterFromSet:[NSCharacterSet illegalCharacterSet]].location != NSNotFound) {
             copySelf = [self stringByReplacingCharactersInRange:substringRange withString:@"?"];
         }
     }];
    return copySelf;
}

+ (NSString *)imprCStringWithUTF8StringFormat:(const char *)format,...{
    va_list vl;
    va_start(vl, format);
    NSString *str = [self imprCStringWithEncoding:NSUTF8StringEncoding format:format argList:vl];
    va_end(vl);
    
    return str;
}

+ (NSString *)imprCStringWithEncoding:(NSStringEncoding)encoding format:(const char *)format,...{
    va_list vl;
    va_start(vl, format);
    NSString *str = [self imprCStringWithEncoding:encoding format:format argList:vl];
    va_end(vl);
    return str;
}

+ (NSString *)imprCStringWithEncoding:(NSStringEncoding)encoding format:(const char *)format argList:(va_list)argList{
    char *buffer = NULL;
    int n;
    NSString *str;
    
    n = vasprintf(&buffer, format, argList);
    if (n != -1 && buffer != NULL) {
        str = [NSString stringWithCString:buffer encoding:encoding];
    }
    
    free(buffer);
    return str;
}

@end

