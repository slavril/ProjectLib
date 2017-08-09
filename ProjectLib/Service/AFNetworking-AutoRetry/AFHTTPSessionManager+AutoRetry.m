//
// Created by Shai Ohev Zion on 1/23/14.
// Copyright (c) 2014 shaioz. All rights reserved.

#import "AFHTTPRequestOperationManager+AutoRetry.h"
#import "AFHTTPSessionManager+AutoRetry.h"
#import "ObjcAssociatedObjectHelpers.h"
#import "Util.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

@implementation AFHTTPSessionManager (AutoRetry)

SYNTHESIZE_ASC_OBJ(__tasksDict, setTasksDict);
SYNTHESIZE_ASC_OBJ(__retryDelayCalcBlock, setRetryDelayCalcBlock);

- (void)resetAllTasks{
    [self createTasksDict];
}

- (void)createTasksDict {
    self.tasksDict = [[NSDictionary alloc] init];
}

- (void)createDelayRetryCalcBlock {
    RetryDelayCalcBlock block = ^int(int totalRetries, int currentRetry, int delayInSecondsSpecified) {
        return delayInSecondsSpecified;
    };
    self.retryDelayCalcBlock = block;
}

- (id)retryDelayCalcBlock {
    if (!self.__retryDelayCalcBlock) {
        [self createDelayRetryCalcBlock];
    }
    return self.__retryDelayCalcBlock;
}

- (id)tasksDict {
    if (!self.__tasksDict) {
        [self createTasksDict];
    }
    return self.__tasksDict;
}

// subclass and overide this method if necessary
- (BOOL)isErrorFatal:(NSError *)error {
    switch (error.code) {
        case kCFHostErrorHostNotFound:
        case kCFHostErrorUnknown: // Query the kCFGetAddrInfoFailureKey to get the value returned from getaddrinfo; lookup in netdb.h
            // HTTP errors
        case kCFErrorHTTPAuthenticationTypeUnsupported:
        case kCFErrorHTTPBadCredentials:
        case kCFErrorHTTPParseFailure:
        case kCFErrorHTTPRedirectionLoopDetected:
        case kCFErrorHTTPBadURL:
        case kCFErrorHTTPBadProxyCredentials:
        case kCFErrorPACFileError:
        case kCFErrorPACFileAuth:
        case kCFStreamErrorHTTPSProxyFailureUnexpectedResponseToCONNECTMethod:
            // Error codes for CFURLConnection and CFURLProtocol
        case kCFURLErrorUnknown:
        case kCFURLErrorCancelled:
        case kCFURLErrorBadURL:
        case kCFURLErrorUnsupportedURL:
        case kCFURLErrorHTTPTooManyRedirects:
        case kCFURLErrorBadServerResponse:
        case kCFURLErrorUserCancelledAuthentication:
        case kCFURLErrorUserAuthenticationRequired:
        case kCFURLErrorZeroByteResource:
        case kCFURLErrorCannotDecodeRawData:
        case kCFURLErrorCannotDecodeContentData:
        case kCFURLErrorCannotParseResponse:
        case kCFURLErrorInternationalRoamingOff:
        case kCFURLErrorCallIsActive:
        case kCFURLErrorDataNotAllowed:
        case kCFURLErrorRequestBodyStreamExhausted:
        case kCFURLErrorFileDoesNotExist:
        case kCFURLErrorFileIsDirectory:
        case kCFURLErrorNoPermissionsToReadFile:
        case kCFURLErrorDataLengthExceedsMaximum:
            // SSL errors
        case kCFURLErrorServerCertificateHasBadDate:
        case kCFURLErrorServerCertificateUntrusted:
        case kCFURLErrorServerCertificateHasUnknownRoot:
        case kCFURLErrorServerCertificateNotYetValid:
        case kCFURLErrorClientCertificateRejected:
        case kCFURLErrorClientCertificateRequired:
        case kCFURLErrorCannotLoadFromNetwork:
            // Cookie errors
        case kCFHTTPCookieCannotParseCookieFile:
            // Errors originating from CFNetServices
        case kCFNetServiceErrorUnknown:
        case kCFNetServiceErrorCollision:
        case kCFNetServiceErrorNotFound:
        case kCFNetServiceErrorInProgress:
        case kCFNetServiceErrorBadArgument:
        case kCFNetServiceErrorCancel:
        case kCFNetServiceErrorInvalid:
            // Special case
        case 101: // null address
        case 102: // Ignore "Frame Load Interrupted" errors. Seen after app store links.
            return YES;
        default:
            break;
    }
    return NO;
}

- (void)removeTaskDictByTask:(NSURLSessionDataTask *)task{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self.tasksDict];
    [newDict removeObjectForKey:task];
    self.tasksDict = newDict;
#ifdef DEBUG
    NSLog(@"removeTaskDictByTask:%@ - count:%d", self.tasksDict, [self.tasksDict count]);
#endif
}

- (NSURLSessionDataTask *)requestUrlWithAutoRetry:(int)retriesRemaining
                                    retryInterval:(int)intervalInSeconds
                           originalRequestCreator:(NSURLSessionDataTask *(^)(void (^)(NSURLSessionDataTask *, NSError *)))taskCreator
                                  originalFailure:(void(^)(NSURLSessionDataTask *, NSError *))failure {
    
    id taskcreatorCopy = [taskCreator copy];
    BlockWeakSelf weakSelf = self;
    
    void(^retryBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        // error is fatal, do not retry
        if ([weakSelf isErrorFatal:error]) {
#ifdef DEBUG
            NSLog(@"AutoRetry: Request failed with error: %@", error.localizedDescription);
#endif
            [weakSelf removeTaskDictByTask:task];
            failure(task, error);
            return;
        }
        
        NSMutableDictionary *retryOperationDict = weakSelf.tasksDict[taskcreatorCopy];
        int originalRetryCount = [retryOperationDict[@"originalRetryCount"] intValue];
        int retriesRemainingCount = [retryOperationDict[@"retriesRemainingCount"] intValue];
        
        if (retriesRemainingCount > 0) {
#ifdef DEBUG
            NSLog(@"AutoRetry: Request failed: %@, retry %d out of %d begining...",
                error.localizedDescription, originalRetryCount - retriesRemainingCount + 1, originalRetryCount);
#endif
            void (^addRetryOperation)() = ^{
                [weakSelf requestUrlWithAutoRetry:retriesRemaining - 1 retryInterval:intervalInSeconds originalRequestCreator:taskCreator originalFailure:^(NSURLSessionDataTask *task, NSError *error) {
                    BlockStrongSelf strongSelf = weakSelf;
                    // retry request with request timeout and lost connection
                    if (error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorTimedOut) {
                        [strongSelf requestUrlWithAutoRetry:retriesRemaining - 1 retryInterval:0 originalRequestCreator:taskCreator originalFailure:failure];
                    }
                    else{
                        [strongSelf removeTaskDictByTask:task];
                        failure(task, error);
                    }
                }];
            };
            
            RetryDelayCalcBlock delayCalc = weakSelf.retryDelayCalcBlock;
            int intervalToWait = delayCalc(originalRetryCount, retriesRemainingCount, intervalInSeconds);
            
            if (intervalToWait > 0) {
#ifdef DEBUG
                NSLog(@"AutoRetry: Delaying retry for %d seconds...", intervalToWait);
#endif
                dispatch_time_t delay = dispatch_time(0, (int64_t)(intervalToWait * NSEC_PER_SEC));
                dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                    addRetryOperation();
                });
            }
            else {
                addRetryOperation();
            }
        }
        else {
#ifdef DEBUG
            NSLog(@"AutoRetry: Request failed %d times: %@ -> url:%@", originalRetryCount, error.localizedDescription, (task.currentRequest).URL.absoluteString);
            NSLog(@"AutoRetry: No more retries allowed! executing supplied failure block...");
#endif
            [weakSelf removeTaskDictByTask:task];
            
            if (error.code == NSURLErrorNetworkConnectionLost) {
                [weakSelf requestUrlWithAutoRetry:999 retryInterval:0 originalRequestCreator:taskCreator originalFailure:failure];
            }
            else{
                failure(task, error);
            }
        }
    };
    
    NSURLSessionDataTask *task = taskCreator(retryBlock);
    NSMutableDictionary *taskDict = self.tasksDict[taskcreatorCopy];
    
    if (!taskDict) {
        taskDict = [[NSMutableDictionary alloc] init];
        taskDict[@"originalRetryCount"] = @(retriesRemaining);
    }
    
    taskDict[@"retriesRemainingCount"] = @(retriesRemaining);
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self.tasksDict];
    newDict[task] = taskDict;
    self.tasksDict = newDict;
#ifdef DEBUG
    NSLog(@"tasks dict:%@ - count:%d", self.tasksDict, [self.tasksDict count]);
#endif
    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id respo))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry
                retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        BlockWeakSelf weakSelf = self;
        return [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf removeTaskDictByTask:task];
            success(task, responseObject);
        } failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        BlockWeakSelf weakSelf = self;
        return [self HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask *task) {
            [weakSelf removeTaskDictByTask:task];
            success(task);
        }failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        BlockWeakSelf weakSelf = self;
        return [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf removeTaskDictByTask:task];
            success(task, responseObject);
        } failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        BlockWeakSelf weakSelf = self;
        return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf removeTaskDictByTask:task];
            success(task, responseObject);
        }failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry
                retryInterval:(int)intervalInSeconds
{

    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        BlockWeakSelf weakSelf = self;
        return [self PUT:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf removeTaskDictByTask:task];
            success(task, responseObject);
        } failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                      autoRetry:(int)timesToRetry
                  retryInterval:(int)intervalInSeconds
{

    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        BlockWeakSelf weakSelf = self;
        return [self PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [weakSelf removeTaskDictByTask:task];
            success(task, responseObject);
        } failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        BlockWeakSelf weakSelf = self;
        return [self DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [weakSelf removeTaskDictByTask:task];
            success(task, responseObject);
        } failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id respo))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry {
    return [self GET:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry {
    return [self HEAD:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry {
    return [self POST:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry {
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry {
    return [self PUT:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                       autoRetry:(int)timesToRetry {
    return [self DELETE:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

@end

#pragma clang diagnostic pop
