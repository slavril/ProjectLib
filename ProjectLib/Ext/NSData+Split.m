//
//  NSData+Split.m
//  Zippie
//
//  Created by Anh Quan on 12/2/15.
//  Copyright © 2015 Lunex. All rights reserved.
//

#import "NSData+Split.h"

@implementation NSData (Split)

- (NSArray *)componentsSeparatedByByte:(Byte)sep{
    unsigned long len, index, last_sep_index;
    NSData *line;
    NSMutableArray *lines = nil;
    
    len = self.length;
    Byte cData[len];
    [self getBytes:cData length:len];
    
    index = last_sep_index = 0;
    lines = [[NSMutableArray alloc] init];
    
    do{
        if (sep == cData[index]){
            NSRange startEndRange = NSMakeRange(last_sep_index, index - last_sep_index);
            line = [self subdataWithRange:startEndRange];
            
            [lines addObject:line];
            last_sep_index = index + 1;
            
            continue;
        }
    } while (index++ < len);
    
    return lines;
}

- (NSArray *)componentsSeparatedByChunkSize:(NSUInteger)chunkSize{
    NSUInteger length = self.length;
    NSUInteger offset = 0;
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData *chunkData = [NSData dataWithBytesNoCopy:(char *)self.bytes + offset length:thisChunkSize freeWhenDone:NO];
        
        [parts addObject:chunkData];
        offset += thisChunkSize;
        
    } while (offset < length);
    
    return parts;
}

@end
