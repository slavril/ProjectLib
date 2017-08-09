//
//  ZippiService.h
//  Zippie
//
//  Created by Manh Nguyen on 6/23/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "BaseService.h"
#import "AFHTTPRequestOperation+Ext.h"
#import "AFHTTPSessionManager.h"

@class MessageModel;

@interface ZippiService : BaseService

+ (AFHTTPRequestOperationManager *)uploadOperationManager;

+ (NSArray *)uploadOperationQueues;
+ (NSInteger)uploadOperationCount;
+ (void)cancelAllOperationsWithUploadId:(NSString *)uploadId;
+ (AFHTTPRequestOperation *)uploadOperationContentInfoWithMessageId:(NSString *)messageId;
+ (AFHTTPRequestOperation *)uploadOperationContentInfoWithMessageModel:(MessageModel *)message;

#pragma mark - Upload

- (AFHTTPRequestOperation *)uploadFileData:(NSData *)fileData withName:(NSString *)fileName onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock;

- (AFHTTPRequestOperation *)uploadFileURL:(NSURL *)fileURL parameters:(NSDictionary *)parameters onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock;

- (AFHTTPRequestOperation *)uploadFileURL:(NSURL *)fileURL parameters:(NSDictionary *)parameters constructingBodyWithDictionary:(NSDictionary *)body onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock;

#pragma mark - Download

+ (AFHTTPRequestOperation *)downloadFileFromLink:(NSString *)linkURL onProcess:(void (^)(CGFloat progress))processBlock onCompleted:(void (^)(ResponseObject *responseObject))completedBlock;

#pragma mark - Upload/Download supports nsurlsession

- (NSURLSessionUploadTask *)uploadTaskFromFile:(NSURL *)fileURL
                                      progress:(void(^)(NSProgress *uploadProgress))progressBlock
                             completionHandler:(void (^)(ResponseObject *responseObject))completionHandler;

- (NSURLSessionUploadTask *)uploadTaskFromData:(NSData *)bodyData
                                      progress:(void(^)(NSProgress *uploadProgress))progressBlock
                             completionHandler:(void (^)(ResponseObject *responseObject))completionHandler;

- (NSURLSessionUploadTask *)uploadTaskWithStreamedFile:(NSURL *)fileURL
                        constructingBodyWithDictionary:(NSDictionary *)body
                                              progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                     completionHandler:(void (^)(ResponseObject *responseObject))completionHandler;

- (NSURLSessionUploadTask *)uploadTaskWithStreamedData:(NSData *)bodyData
                                              fileName:(NSString *)fileName
                                              progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                     completionHandler:(void (^)(ResponseObject *responseObject))completionHandler;

+ (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                         progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

+ (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                         progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

+ (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void(^)(NSProgress *uploadProgress))progressBlock
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

///-----------------------------
/// @name Running Download Tasks
///-----------------------------

+ (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void(^)(NSProgress *downloadProgress))progressBlock
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

+ (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

+ (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void(^)(NSProgress *downloadProgress))progressBlock
                                       processHandler:(void(^)(float process, NSURLSessionDownloadTask *task))processHandler
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

+ (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(void(^)(NSProgress *downloadProgress))progressBlock
                                             destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
