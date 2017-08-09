//
//  ResponseObject.h
//  Zippie
//
//  Created by Manh Nguyen on 10/14/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResponseObject : NSObject<NSCoding>

@property (nonatomic, assign, readonly) NSInteger errorCode;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign, readonly) BOOL hasError;
@property (nonatomic, copy) NSString *responseId;

+ (instancetype)response;

// support write to file and load from file
+ (ResponseObject *)responseObjectWithFileName:(NSString *)fileName;
- (BOOL)writeToFileWithName:(NSString *)fileName;

@end
