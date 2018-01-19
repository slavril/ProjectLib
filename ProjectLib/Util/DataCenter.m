//
//  DataCenter.m
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import "DataCenter.h"
#define MEM_CACHE 8 //Megabytes

@implementation DataCenter

+ (DataCenter *)shared{
    static dispatch_once_t onceToken;
    static DataCenter *_shared = nil;
    dispatch_once(&onceToken, ^{
        _shared = [[DataCenter alloc] init];
    });
    
    return _shared;
}

+ (NSCache *)memoryCache{
    static dispatch_once_t once;
    static NSCache *_cache;
    dispatch_once(&once, ^{
        _cache = [[NSCache alloc] init];
        _cache.name = @"com.sl.data.center.memory.cache";
        _cache.totalCostLimit = MEM_CACHE * 1024 * 1024;
    });
    
    return _cache;
}

+ (void)storeObject:(id<NSCoding>)object forKey:(NSString *)key {
    if (object && key) {
        [[self memoryCache] setObject:object forKey:key];
    }
}

+ (id)objectFromMemoryCacheForKey:(NSString *)key {
    if (key) {
        return [[self memoryCache] objectForKey:key];
    }
    
    return nil;
}

+ (void)removeCacheForKey:(NSString *)key {
    [[self memoryCache] removeObjectForKey:key];
}

+ (void)clearMemoryObjects {
    [[self memoryCache] removeAllObjects];
}

@end
