//
//  ZippiService.m
//  Zippie
//
//  Created by Manh Nguyen on 6/23/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "ZippiService.h"
#import "ZPUtil.h"

static inline NSString * ZippiContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
    return @"application/octet-stream";
#endif
}

@implementation ZippiService

+ (AFHTTPRequestOperationManager *)uploadOperationManager{
    static AFHTTPRequestOperationManager *_share = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _share = [AFHTTPRequestOperationManager manager];
        _share.requestSerializer.timeoutInterval = kDownloadRequestTimeout;
        _share.operationQueue.maxConcurrentOperationCount = 1;
    });
    return _share;
}

+ (AFHTTPRequestOperation *)uploadOperationContentInfoWithMessageId:(NSString *)messageId{
    NSArray *operations = [[self class] uploadOperationManager].operationQueue.operations;
    for (AFHTTPRequestOperation *op in operations) {
        if ([op isKindOfClass:[AFHTTPRequestOperation class]]) {
            if ([op.operationIdentifier isEqualToString:messageId]) {
                return op;
            }
        }
    }
    return nil;
}

+ (void)cancelAllOperationsWithUploadId:(NSString *)uploadId{
    NSArray *operations = [[self class] uploadOperationQueues];
    for (AFHTTPRequestOperation *op in operations) {
        if ([op isKindOfClass:[AFHTTPRequestOperation class]]) {
            if ([op.operationIdentifier isEqualToString:uploadId]) {
#ifdef DEBUG
                NSLog(@"cancel operation url %@-%@",uploadId, (op.request.URL).absoluteString);
#endif
                [op cancel];
            }
        }
    }
}

+ (NSArray *)uploadOperationQueues {
    NSArray *operations = [[self class] uploadOperationManager].operationQueue.operations;
    return operations;
}

+ (NSInteger)uploadOperationCount {
    return [[self class] uploadOperationManager].operationQueue.operations.count;
}

- (void)addAFHttpHeaders{
    AFHTTPRequestOperationManager *manager = [[self class] uploadOperationManager];
    // Header request
    NSMutableDictionary *httpHeaders = [self httpServiceHeaders];
    for (id httpHeader in httpHeaders.allKeys) {
        id httpValue = [httpHeaders valueForKey:httpHeader];
        [manager.requestSerializer setValue:httpValue forHTTPHeaderField:httpHeader];
    }
}

- (AFHTTPRequestOperation *)uploadFileData:(NSData *)fileData withName:(NSString *)fileName onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock{
    return [self uploadFileData:fileData withName:fileName handleBodyStreamExhausted:NO onProcess:processBlock onCompleted:completedBlock];
}

- (AFHTTPRequestOperation *)uploadFileData:(NSData *)fileData withName:(NSString *)fileName handleBodyStreamExhausted:(BOOL)bodyStreamExhausted onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock{
    AFHTTPRequestOperationManager *manager = [[self class] uploadOperationManager];
    
    [self addAFHttpHeaders];
    NSString *requestString = [self getServerUrlRequest];
    
#ifdef DEBUG
    NSLog(@"BaseService - sendRequestToServer: %@", requestString);
#endif
    void (^handleResponseUploadBlock)(id, NSHTTPURLResponse *, NSError *) = ^(id responseObject, NSHTTPURLResponse *response, NSError *error){
        if (completedBlock) {
            @autoreleasepool {
#ifdef DEBUG
                NSLog(@"##### ZippieService - StatusCode = %d", response.statusCode);
#endif
                ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:error statusCode:response.statusCode enabledLogs:self.enabledLogs];
                completedBlock(responseObj);
            }
        }
    };
    
    NSData *dataPost = fileData;
    AFHTTPRequestOperation *operation = [manager POST:requestString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:dataPost name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        if (bodyStreamExhausted) {
            // 8Kb
            [formData throttleBandwidthWithPacketSize:1024 * 8 delay:1.0];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handleResponseUploadBlock(responseObject, operation.response, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == NSURLErrorRequestBodyStreamExhausted && !bodyStreamExhausted) {
            [self uploadFileData:dataPost withName:fileName handleBodyStreamExhausted:YES onProcess:processBlock onCompleted:completedBlock];
        }
        else{
            handleResponseUploadBlock(nil, operation.response, error);
        }
    }];
    
    if (processBlock) {
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
#ifdef DEBUG
            NSLog(@"process upload:%f", progress * 100);
#endif
            processBlock(progress);
        }];
    }
    
    return operation;
}

- (AFHTTPRequestOperation *)uploadFileURL:(NSURL *)fileURL parameters:(NSDictionary *)parameters onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock{
    return [self uploadFileURL:fileURL parameters:parameters constructingBodyWithDictionary:nil onProcess:processBlock onCompleted:completedBlock];
}

- (AFHTTPRequestOperation *)uploadFileURL:(NSURL *)fileURL parameters:(NSDictionary *)parameters constructingBodyWithDictionary:(NSDictionary *)body onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock{
    return [self uploadFileURL:fileURL parameters:parameters constructingBodyWithDictionary:body handleBodyStreamExhausted:NO onProcess:processBlock onCompleted:completedBlock];
}

- (AFHTTPRequestOperation *)uploadFileURL:(NSURL *)fileURL parameters:(NSDictionary *)parameters constructingBodyWithDictionary:(NSDictionary *)body handleBodyStreamExhausted:(BOOL)bodyStreamExhausted onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock{
    return [self uploadFileURL:fileURL name:@"file" parameters:parameters constructingBodyWithDictionary:body handleBodyStreamExhausted:bodyStreamExhausted onProcess:processBlock onCompleted:completedBlock];
}

- (AFHTTPRequestOperation *)uploadFileURL:(NSURL *)fileURL name:(NSString *)name parameters:(NSDictionary *)parameters constructingBodyWithDictionary:(NSDictionary *)body handleBodyStreamExhausted:(BOOL)bodyStreamExhausted onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock{
    NSParameterAssert(fileURL);
    
    AFHTTPRequestOperationManager *manager = [[self class] uploadOperationManager];
    
    // Header request
    [self addAFHttpHeaders];
    NSString *requestString = [self getServerUrlRequest];
    
    void (^handleResponseUploadBlock)(id, AFHTTPRequestOperation *, NSError *) = ^(id responseObject, AFHTTPRequestOperation *operation, NSError *error){
        if (completedBlock) {
            @autoreleasepool {
#ifdef DEBUG
                NSLog(@"##### ZippieService - StatusCode = %d", operation.response.statusCode);
#endif
                ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:error statusCode:operation.response.statusCode enabledLogs:self.enabledLogs];
                responseObj.responseId = operation.operationIdentifier;
                completedBlock(responseObj);
            }
        }
    };
    
    NSURL *inputFileURL = fileURL;
    NSString *fileName = fileURL.lastPathComponent;
    NSString *mimeType = ZippiContentTypeForPathExtension(fileURL.pathExtension);
    NSDictionary *bodyWithDictionary = body;
    
    BlockWeakSelf weakSelf = self;
    AFHTTPRequestOperation *operation = [manager POST:requestString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        BlockStrongSelf strongSelf = weakSelf;
        [strongSelf handleMultipartFormData:formData withName:name
        onstructingBodyWithDictionary:bodyWithDictionary
                         inputFileURL:inputFileURL
                             fileName:fileName
                             mimeType:mimeType];
        if (bodyStreamExhausted) {
            // 8Kb
            [formData throttleBandwidthWithPacketSize:1024 * 8 delay:1.0];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handleResponseUploadBlock(responseObject, operation, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == NSURLErrorRequestBodyStreamExhausted && !bodyStreamExhausted) {
            [self uploadFileURL:inputFileURL parameters:parameters constructingBodyWithDictionary:bodyWithDictionary handleBodyStreamExhausted:YES onProcess:processBlock onCompleted:completedBlock];
        }
        else{
            handleResponseUploadBlock(nil, operation, error);
        }
    }];
    
    if (processBlock) {
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
            processBlock(progress);
        }];
    }
    
    return operation;
}

- (id<AFMultipartFormData>)handleMultipartFormData:(id<AFMultipartFormData>)formData
                                          withName:(NSString *)name
                     onstructingBodyWithDictionary:(NSDictionary *)bodyWithDictionary
                                      inputFileURL:(NSURL *)inputFileURL
                                          fileName:(NSString *)fileName
                                          mimeType:(NSString *)mimeType{
    
    [formData appendPartWithFileURL:inputFileURL
                               name:name
                           fileName:fileName
                           mimeType:mimeType
                              error:nil];
    
    // add other body if has
    if (bodyWithDictionary && bodyWithDictionary.count) {
        NSArray *allKeys = bodyWithDictionary.allKeys;
        for (NSString *key in allKeys) {
            NSString *otherFileURL = bodyWithDictionary[key];
            NSString *otherFileName = otherFileURL.lastPathComponent;
            NSString *otherMimeType = ZippiContentTypeForPathExtension(otherFileURL.pathExtension);
            
            if (otherFileName && otherFileURL && otherMimeType) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:otherFileURL]
                                           name:key
                                       fileName:otherFileName
                                       mimeType:otherMimeType
                                          error:nil];
            }
        }
    }
    return formData;
}

#pragma mark - Download

+ (AFHTTPRequestOperation *)downloadFileFromLink:(NSString *)linkURL onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:linkURL]];
    request.timeoutInterval = kDownloadRequestTimeout;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request] ;
    
    void (^handleResponseBlock)(id, NSHTTPURLResponse *, NSError *) = ^(id responseObject, NSHTTPURLResponse *response, NSError *error){
        if (completedBlock) {
            @autoreleasepool {
#ifdef DEBUG
                NSLog(@"##### ZippieService - StatusCode = %d", response.statusCode);
#endif
                ResponseObject *responseObj = [self responseObjectWithObject:responseObject error:error statusCode:response.statusCode];
                completedBlock(responseObj);
            }
        }
    };
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([linkURL isEqualToString:(operation.request).URL.absoluteString]) {
            handleResponseBlock(responseObject, operation.response, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([linkURL isEqualToString:(operation.request).URL.absoluteString]) {
            handleResponseBlock(nil, operation.response, error);
        }
    }];
    
    if (processBlock) {
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
            processBlock(progress);
        }];
    }
    
    return operation;
}

#pragma mark - Upload/Download supports nsurlsession

+ (AFHTTPSessionManager *)httpSessionManager{
    static AFHTTPSessionManager *_share = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        // Set up a configuration with a background session ID
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"io.miltec.vodi.download.background.session"];
        
        // Set the configuration to discretionary
        [configuration setDiscretionary:YES];
        
        // Set the configuration to run sometime in the next 18 hours
        [configuration setTimeoutIntervalForResource: 18 * 60 * 60];
        
        _share = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    return _share;
}

- (NSURLSessionUploadTask *)uploadTaskFromFile:(NSURL *)fileURL
                                      progress:(void(^)(NSProgress *uploadProgress))progressBlock
                             completionHandler:(void (^)(ResponseObject *responseObject))completionHandler{
    NSParameterAssert(fileURL);

    NSString *requestString = [self getServerUrlRequest];
    NSURL *inputFileURL = fileURL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    request.allHTTPHeaderFields = [self httpServiceHeaders];
    
    void (^handleResponseUploadBlock)(id, NSURLResponse *, NSError *) = ^(id responseObject, NSURLResponse *response, NSError *error){
        if (completionHandler) {
            @autoreleasepool {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
#ifdef DEBUG
                NSLog(@"##### ZippieService - StatusCode = %d", httpResponse.statusCode);
#endif
                ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:error statusCode:httpResponse.statusCode enabledLogs:self.enabledLogs];
                completionHandler(responseObj);
            }
        }
    };
    
    return [[[self class] httpSessionManager] uploadTaskWithRequest:request fromFile:inputFileURL progress:progressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handleResponseUploadBlock(responseObject, response, error);
    }];
}

- (NSURLSessionUploadTask *)uploadTaskFromData:(NSData *)bodyData
                                      progress:(void(^)(NSProgress *uploadProgress))progressBlock
                             completionHandler:(void (^)(ResponseObject *responseObject))completionHandler{
    NSString *requestString = [self getServerUrlRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    request.allHTTPHeaderFields = [self httpServiceHeaders];
    
    void (^handleResponseUploadBlock)(id, NSURLResponse *, NSError *) = ^(id responseObject, NSURLResponse *response, NSError *error){
        if (completionHandler) {
            @autoreleasepool {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
#ifdef DEBUG
                NSLog(@"##### ZippieService - StatusCode = %d", httpResponse.statusCode);
#endif
                
                ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:error statusCode:httpResponse.statusCode enabledLogs:self.enabledLogs];
                completionHandler(responseObj);
            }
        }
    };
    
    return [[[self class] httpSessionManager] uploadTaskWithRequest:request fromData:bodyData progress:progressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handleResponseUploadBlock(responseObject, response, error);
    }];
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedData:(NSData *)bodyData
                                              fileName:(NSString *)fileName
                                              progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                     completionHandler:(void (^)(ResponseObject *responseObject))completionHandler{
    NSString *requestString = [self getServerUrlRequest];

    void (^handleResponseUploadBlock)(id, NSURLResponse *, NSError *) = ^(id responseObject, NSURLResponse *response, NSError *error){
        if (completionHandler) {
            @autoreleasepool {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
#ifdef DEBUG
                NSLog(@"##### ZippieService - StatusCode = %d", httpResponse.statusCode);
#endif
                ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:error statusCode:httpResponse.statusCode enabledLogs:self.enabledLogs];
                completionHandler(responseObj);
            }
        }
    };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:bodyData name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
    } error:nil];
    
    request.allHTTPHeaderFields = [self httpServiceHeaders];
    return [[[self class] httpSessionManager] uploadTaskWithStreamedRequest:request progress:progressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handleResponseUploadBlock(responseObject, response, error);
    }];
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedFile:(NSURL *)fileURL
                        constructingBodyWithDictionary:(NSDictionary *)body
                                              progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                     completionHandler:(void (^)(ResponseObject *responseObject))completionHandler{
    NSParameterAssert(fileURL);
    NSString *requestString = [self getServerUrlRequest];
    
    void (^handleResponseUploadBlock)(id, NSURLResponse *, NSError *) = ^(id responseObject, NSURLResponse *response, NSError *error){
        if (completionHandler) {
            @autoreleasepool {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
#ifdef DEBUG
                NSLog(@"##### ZippieService - StatusCode = %d", httpResponse.statusCode);
#endif
                ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:error statusCode:httpResponse.statusCode enabledLogs:self.enabledLogs];
                completionHandler(responseObj);
            }
        }
    };
    
    NSURL *inputFileURL = fileURL;
    NSString *fileName = fileURL.lastPathComponent;
    NSString *mimeType = ZippiContentTypeForPathExtension(fileURL.pathExtension);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:inputFileURL
                                   name:@"file"
                               fileName:fileName
                               mimeType:mimeType
                                  error:nil];
        
        // add other body if has
        if (body) {
            NSArray *allKeys = body.allKeys;
            for (NSString *key in allKeys) {
                NSString *otherFileURL = body[key];
                NSString *otherFileName = otherFileURL.lastPathComponent;
                NSString *otherMimeType = ZippiContentTypeForPathExtension(otherFileURL.pathExtension);
                
                if (otherFileName && otherFileURL && otherMimeType) {
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:otherFileURL]
                                               name:key
                                           fileName:otherFileName
                                           mimeType:otherMimeType
                                              error:nil];
                }
            }
        }
    } error:nil];
    
    request.allHTTPHeaderFields = [self httpServiceHeaders];
    
    return [[[self class] httpSessionManager] uploadTaskWithStreamedRequest:request progress:progressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handleResponseUploadBlock(responseObject, response, error);
    }];
}

+ (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                         progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    return [[self httpSessionManager] uploadTaskWithRequest:request fromFile:fileURL progress:progressBlock completionHandler:completionHandler];
}

+ (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                         progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    return [[self httpSessionManager] uploadTaskWithRequest:request fromData:bodyData progress:progressBlock completionHandler:completionHandler];
}

+ (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    return [[self httpSessionManager] uploadTaskWithStreamedRequest:request progress:progressBlock completionHandler:completionHandler];
}

///-----------------------------
/// @name Running Download Tasks
///-----------------------------

+ (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void(^)(NSProgress *downloadProgress))progressBlock
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    return [self downloadTaskWithRequest:request progress:progressBlock processHandler:nil destination:destination completionHandler:completionHandler];
}

+ (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url
                                      destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = kDownloadRequestTimeout;
    return [self downloadTaskWithRequest:request progress:nil destination:destination completionHandler:completionHandler];
}

+ (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void(^)(NSProgress *downloadProgress))progressBlock
                                       processHandler:(void(^)(float process, NSURLSessionDownloadTask *task))processHandler
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    NSURLSessionDownloadTask *task = [[self httpSessionManager] downloadTaskWithRequest:request progress:progressBlock destination:destination completionHandler:completionHandler];
    if (processHandler) {
        [[self httpSessionManager] setDownloadTaskDidWriteDataBlock:^void(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            if (processHandler) {
                float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                processHandler(progress,downloadTask);
            }
        }];
    }
    
    [task resume];
    
    return task;
}

+ (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(void(^)(NSProgress *downloadProgress))progressBlock
                                             destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    NSURLSessionDownloadTask *task = [[self httpSessionManager] downloadTaskWithResumeData:resumeData progress:progressBlock destination:destination completionHandler:completionHandler];
    
    [task resume];
    
    return task;
}

@end
