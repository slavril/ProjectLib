//
//  AFHTTPRequestOperation+Ext.m
//  Zippie
//
//  Created by Minh Tran on 6/26/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "AFHTTPRequestOperation+Ext.h"
#import <objc/runtime.h>

@implementation AFHTTPRequestOperation (Ext)

- (void)setOperationIdentifier:(NSString *)operationIdentifier {
    objc_setAssociatedObject(self, @selector(operationIdentifier), operationIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)operationIdentifier {
    return objc_getAssociatedObject(self, @selector(operationIdentifier));
}

@end
