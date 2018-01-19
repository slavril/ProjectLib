//
//  NSData+Split.h
//  Zippie
//
//  Created by Anh Quan on 12/2/15.
//  Copyright © 2015 Lunex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Split)

- (NSArray *)componentsSeparatedByByte:(Byte)sep;
- (NSArray *)componentsSeparatedByChunkSize:(NSUInteger)chunkSize;

@end
