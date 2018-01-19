//
//  DataCenter.h
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

+ (DataCenter *)shared;
+ (void)storeObject:(id<NSCoding>)object forKey:(NSString *)key;
+ (id)objectFromMemoryCacheForKey:(NSString *)key;
+ (void)removeCacheForKey:(NSString *)key;
+ (void)clearMemoryObjects;

@end
