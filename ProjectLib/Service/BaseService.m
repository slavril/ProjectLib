
#import "BaseService.h"
#import "NSString+Ext.h"
#import "Util.h"

#define kEnableServiceLogs 1
#define kBaseServiceHeaderPageEnable 1
#define kDefaultMaximumRetryCount 2
#define kDefaultUrlRequestTimeoutInterval 90

static const NSInteger kDefaultCacheMaxCacheAge = 60; // 60s

#pragma mark - AutoPurgeCache

@interface AutoPurgeCache : NSCache

@end

@implementation AutoPurgeCache

+ (AutoPurgeCache *)shared{
    static AutoPurgeCache *cache = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        cache = [[AutoPurgeCache alloc] init];
        cache.name = @"com.vodi.base.service.memory.cache";
        cache.totalCostLimit = 6 * 1024 * 1024; // 6MB
    });
    
    return cache;
}

@end

#pragma mark - ExpiringCacheItem

@interface ExpiringCacheItem : NSObject

@property (nonatomic, strong) NSDate *expiringCacheItemDate;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) id object;

@end

@implementation ExpiringCacheItem

@end

#pragma mark - ExpiringCache

@interface ExpiringCache : NSObject

@property (nonatomic, assign) NSTimeInterval expiryTimeInterval;

- (id)cacheObjectForKey:(id)key;
- (void)setCacheObject:(ExpiringCacheItem *)obj forKey:(id)key;

@end

@implementation ExpiringCache

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.expiryTimeInterval = kDefaultCacheMaxCacheAge;
    }
    
    return self;
}

- (id)cacheObjectForKey:(id)key {
    @try {
        ExpiringCacheItem *object = [[AutoPurgeCache shared] objectForKey:key];
        if (object) {
            NSTimeInterval timeSinceCache = fabs((object.expiringCacheItemDate).timeIntervalSinceNow);
            if (timeSinceCache > self.expiryTimeInterval) {
                [[AutoPurgeCache shared] removeObjectForKey:key];
                return nil;
            }
        }
        
        return object;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (void)setCacheObject:(ExpiringCacheItem *)obj forKey:(id)key {
    if (obj && key) {
        obj.expiringCacheItemDate = [NSDate date];
        [[AutoPurgeCache shared] setObject:obj forKey:key];
    }
}

@end

#pragma mark - BaseService

@interface BaseService ()

@property (nonatomic, strong) ExpiringCache *expiringCache;

@end

@implementation BaseService

+ (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.discretionary = YES;
        configuration.allowsCellularAccess = YES;
        
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)) {
            if ([configuration respondsToSelector:@selector(setShouldUseExtendedBackgroundIdleMode:)]) {
                configuration.shouldUseExtendedBackgroundIdleMode = YES;
            }
        }

        configuration.HTTPAdditionalHeaders = [self HTTPAdditionalHeaders];
        
        // create instance
        instance = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        instance.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
        
        //config json encode and decode
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        instance.responseSerializer = responseSerializer;
    });
    
    return instance;
}

+ (NSOperationQueue *)requestOperationQueue{
    static NSOperationQueue *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[NSOperationQueue alloc] init];
        instance.maxConcurrentOperationCount = 1;
    });
    
    return instance;
}

- (NSMutableDictionary *)tagParams{
    if (!_tagParams) {
        _tagParams = [[NSMutableDictionary alloc] init];
    }
    return _tagParams;
}

- (NSMutableDictionary *)getParams{
    if (!_getParams) {
        _getParams = [[NSMutableDictionary alloc] init];
    }
    return _getParams;
}

- (NSMutableDictionary *)postParams{
    if (!_postParams) {
        _postParams = [[NSMutableDictionary alloc] init];
    }
    return _postParams;
}

- (NSMutableDictionary *)httpHeaders{
    if (!_httpHeaders) {
        _httpHeaders = [[NSMutableDictionary alloc] initWithDictionary:[[self class] BasicHTTPHeaders]];
    }
    return _httpHeaders;
}

static NSMutableDictionary *_BasicHTTPHeaders = nil;
+ (NSMutableDictionary *)BasicHTTPHeaders{
    if (!_BasicHTTPHeaders) {
        _BasicHTTPHeaders = [[NSMutableDictionary alloc] init];
        // Using gzip
        _BasicHTTPHeaders[@"Accept-Encoding"] = @"gzip;q=1.0,compress;q=0.5";
        // Using others
        _BasicHTTPHeaders[@"Os"] = @"IOS";
        NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
        if (localTimeZone.name) {
            _BasicHTTPHeaders[@"Timezone"] = localTimeZone.name;
        }
        if (localTimeZone.abbreviation) {
            _BasicHTTPHeaders[@"Timezone_Abbreviation"] = localTimeZone.abbreviation;
        }
        localTimeZone = nil;
        
        // no cache
        _BasicHTTPHeaders[@"Cache-Control"] = @"no-cache, no-store, must-revalidate";
        _BasicHTTPHeaders[@"Pragma"] = @"no-cache";
        _BasicHTTPHeaders[@"Expires"] = @"0";
        
        [_BasicHTTPHeaders addEntriesFromDictionary:[BaseService HTTPAdditionalHeaders]];
    }
    return _BasicHTTPHeaders;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        self.enabledLogs = YES; // by default
#else
        self.enabledLogs = NO; // by default
#endif
        self.contentType = @"application/json";
        self.methodType = kGet;
        self.responseType = kRawData;
        self.timeoutInterval = kDefaultUrlRequestTimeoutInterval;
        self.autoRetryTimes = kDefaultMaximumRetryCount;
        self.shouldCacheResponse = NO;
        self.maxResponseCacheAge = 0;
        self.needSecurityPassword = YES;
    }
    
    return self;
}

- (instancetype)initWithUrlRequest:(NSString *)urlString method:(MethodType)method response:(ResponseType)response {
    self = [self init];
    if (self) {
        self.urlRequest = urlString;
        self.methodType = method;
        self.responseType = response;
        
        // only supports cache response for get method if needs
        if (method != kGet) {
            self.shouldCacheResponse = NO;
        }
    }
    return self;
}

#pragma mark - Cache Response

- (ExpiringCache *)expiringCache{
    if (_expiringCache == nil) {
        _expiringCache = [[ExpiringCache alloc] init];
    }
    return _expiringCache;
}

- (void)setMaxResponseCacheAge:(NSInteger)maxResponseCacheAge{
    if (maxResponseCacheAge < 0) {
        _maxResponseCacheAge = 0; // no cache
    }
    else{
        _maxResponseCacheAge = maxResponseCacheAge;
    }
    
    if (_maxResponseCacheAge > 0) {
        self.expiringCache.expiryTimeInterval = maxResponseCacheAge;
    }
}

+ (ResponseObject *)responseObjectCacheForKey:(NSString *)key expireTimeInterval:(NSTimeInterval)expireTimeInterval {
    ExpiringCacheItem *cacheObject = [[AutoPurgeCache shared] objectForKey:key];
    if (cacheObject) {
        NSTimeInterval timeSinceCache = fabs((cacheObject.expiringCacheItemDate).timeIntervalSinceNow);
        if (timeSinceCache > expireTimeInterval) {
            [[AutoPurgeCache shared] removeObjectForKey:key];
            return nil;
        }
        
        ResponseObject *responseObject = [ResponseObject response];
        responseObject.error = cacheObject.error;
        responseObject.object = cacheObject.object;
        responseObject.statusCode = cacheObject.statusCode;
        return responseObject;
    }
    return nil;
}

+ (void)cacheResponseObject:(ResponseObject *)responseObject forKey:(NSString *)key{
    ExpiringCacheItem *item = [[ExpiringCacheItem alloc] init];
    item.error = responseObject.error;
    item.object = responseObject.object;
    item.statusCode = responseObject.statusCode;
    item.expiringCacheItemDate = [NSDate date];
    [[AutoPurgeCache shared] setObject:item forKey:key];
}

+ (void)clearAllCacheResponses{
    [[AutoPurgeCache shared] removeAllObjects];
}

#pragma mark -

static NSMutableDictionary *_HTTPAdditionalHeaders = nil;
+ (NSMutableDictionary *)HTTPAdditionalHeaders{
    if (!_HTTPAdditionalHeaders) {
        _HTTPAdditionalHeaders = [[NSMutableDictionary alloc] initWithDictionary:@{@"Connection":@"keep-alive",@"Keep-Alive":@"timeout=15,max=500",@"Proxy-Connection":@"keep-alive"}];
    }
    return _HTTPAdditionalHeaders;
}

- (NSString *)jsonStringWithPrettyPrint:(BOOL)prettyPrint object:(NSMutableDictionary *)object {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        return @"{}";
    }
    else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSString *)getPostBody {
    if (self.postParams.count) {
        return [self jsonStringWithPrettyPrint:NO object:self.postParams];
    }
    return nil;
}

- (NSMutableDictionary *)httpServiceHeaders {
    // Add Page to header
    if (!(self.httpHeaders)[kBaseServiceHeaderPageKey]) {
        if (kBaseServiceHeaderPageEnable) {
            NSString *callerControllerName = [self getCallerControllerName];
            if (callerControllerName) {
                (self.httpHeaders)[kBaseServiceHeaderPageKey] = callerControllerName;
            }
        }
    }
   
    // Using content type
    if ((self.contentType).length > 0) {
        (self.httpHeaders)[@"Content-Type"] = self.contentType;
    }
    
    // App language
    (self.httpHeaders)[@"Lang"] = @"en";
    
    // Log headers
#ifdef DEBUG
    if (kEnableServiceLogs) {
        NSLog(@"#### Headers = %@", self.httpHeaders);
    }
#endif
    
    return self.httpHeaders;
}

- (NSString *)getServerUrlRequest {
    NSString *urlParams = [self getUrlParams];
    NSString *url;
    
    if (urlParams.length > 0) {
        url = [NSString stringWithFormat:@"%@/?%@", self.urlRequest, urlParams];
    }
    else{
        url = [self.urlRequest copy];
    }

#ifdef DEBUG
    if (kEnableServiceLogs) {
        NSLog(@"urlRequest = %@", url);
        NSLog(@"Request body ++ %@", [self getPostBody]);
    }
#endif
    
    return url;
}

- (NSString *)getHttpMethod {
    NSString *httpMethod = @"GET";
    switch (self.methodType) {
        case kPost:
            httpMethod = @"POST";
            break;
        case kPut:
            httpMethod = @"PUT";
            break;
        case kDelete:
            httpMethod = @"DELETE";
            break;
        default:
            break;
    }
    return httpMethod;
}

- (NSURLRequest *)buildRequestForRequestString:(NSString *)requestString{
    
    NSURL *URL = [NSURL URLWithString:requestString];
    NSMutableDictionary *httpHeaders = [self httpServiceHeaders];
    NSString *postBody = nil;
    NSString *httpMethod = [self getHttpMethod];
    
    if ([httpMethod isEqualToString:@"POST"] || [httpMethod isEqualToString:@"PUT"]) {
        postBody = [self getPostBody];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
    request.HTTPMethod = httpMethod;
    
    [httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];

    if (postBody != nil) {
        NSData *bodyData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = bodyData;
    }
    
    return request;
}

- (id)handleResponseDataCacheForRequestString:(NSString *)requestString{
    return [self.expiringCache cacheObjectForKey:requestString];
}

- (void)cacheResponseObject:(ExpiringCacheItem *)item forRequestString:(NSString *)requestString{
    [self.expiringCache setCacheObject:item forKey:requestString];
}

+ (void)clearCacheResponsesForKey:(NSString *)requestKey {
    if ([[AutoPurgeCache shared] objectForKey:requestKey]) {
        [[AutoPurgeCache shared] removeObjectForKey:requestKey];
    }
}

#pragma mark -

- (void)sendRequestToServerWithCompleteBlock:(void (^)(ResponseObject *response))completeBlock{
    @autoreleasepool {
        NSString *requestString = [[self getServerUrlRequest] copy];
        NSString *cacheRequestKey = nil;
        if (self.shouldCacheResponse && self.methodType == kGet) {
            NSString *tsStr = [NSString getTextBtw:requestString lBound:@"&ts=" rBound:@"&"];
            NSString *checkSumStr = [NSString getTextBtw:requestString lBound:@"&check_sum=" rBound:@"&"];
            cacheRequestKey = [requestString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&ts=%@&", tsStr] withString:@""];
            cacheRequestKey = [cacheRequestKey stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"check_sum=%@&", checkSumStr] withString:@""];
        }
        
        NSURLRequest *request = [self buildRequestForRequestString:requestString];
        BOOL shouldReloadNewData = NO;
        void (^handleResponseBlock)(id, NSHTTPURLResponse *, NSError *) = ^(id responseObject, NSHTTPURLResponse *response, NSError *error){
            NSInteger statusCode = response.statusCode;
            if (statusCode == HTTP_STATUS_CODE_AUTH_FAILED) {
                // todo - post authen failed
            }
            else {
                if (statusCode == HTTP_STATUS_CODE_SERVER_ERROR) {
                }
                if (completeBlock) {
                    @autoreleasepool {
                        ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:error statusCode:statusCode];
                        if (self.shouldCacheResponse && self.methodType == kGet && response.statusCode == 200 && !responseObj.hasError) {
                            ExpiringCacheItem *item = [[ExpiringCacheItem alloc] init];
                            item.error = responseObj.error;
                            item.object = responseObj.object;
                            item.statusCode = responseObj.statusCode;
                            [self cacheResponseObject:item forRequestString:cacheRequestKey];
                        }
                        completeBlock(responseObj);
                    }
                }
            }
        };
        
        if (self.shouldCacheResponse && self.methodType == kGet) {
            ExpiringCacheItem *item = [self handleResponseDataCacheForRequestString:cacheRequestKey];
            if (item) {
                ResponseObject *obj = [ResponseObject response];
                obj.error = item.error;
                obj.object = item.object;
                obj.statusCode = item.statusCode;
                
                if (completeBlock) {
                    da_mainSafeWithBlock(^{
                        completeBlock(obj);
                    });
                }
            }
            else{
                shouldReloadNewData = YES;
            }
        }
        else{
            shouldReloadNewData = YES;
        }
        
        if (shouldReloadNewData) {
            // add to queue
            NSArray *operations = [[self class] requestOperationQueue].operations;
            BOOL existed = NO;
            
            for (AFHTTPRequestOperation *o in operations) {
                if ([(o.request.URL).absoluteString isEqualToString:(request.URL).absoluteString]) {
                    existed = YES;
                    break;
                }
            }
            
            if (!existed) {
                __block AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
                responseSerializer.removesKeysWithNullValues = YES;
                op.responseSerializer = responseSerializer;
                
                [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    handleResponseBlock(responseObject, operation.response, nil);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    handleResponseBlock(nil, operation.response, error);
                }];
                
                [[[self class] requestOperationQueue] addOperation:op];
            }
        }
    }
}

- (void)cancelSessionTasks:(NSArray<NSURLSessionTask *> *)tasks{
    AFHTTPSessionManager *manager = [[self class] sessionManager];
    NSArray *allTasks = [manager tasks];
    
    for (NSURLSessionTask *task in allTasks) {
        for (NSURLSessionTask *t in tasks) {
            if (task.taskIdentifier == t.taskIdentifier && task.state == NSURLSessionTaskStateRunning) {
#ifdef DEBUG
                NSLog(@"-----------------------Task[%d] %@ cancelled request %@----------------------",task.taskIdentifier, task.taskDescription, task.originalRequest);
#endif
                [task cancel];
                break;
            }
        }
        
    }
}

- (void)sendRequestToServerOnCompleted:(void (^)(ResponseObject *responseObject))completedBlock {
    @autoreleasepool {
        [self sessionDataTaskWithCompleteBlock:completedBlock];
    }
}

- (NSURLSessionDataTask *)sessionDataTaskWithCompleteBlock:(void (^)(ResponseObject *responseObject))completedBlock{
    @autoreleasepool {
        return [self sessionDataTaskWithProcessBlock:nil completeBlock:completedBlock];
    }
}

- (NSURLSessionDataTask *)sessionDataTaskWithProcessBlock:(void (^)(CGFloat progress))processBlock completeBlock:(void (^)(ResponseObject *responseObject))completedBlock{
    AFHTTPSessionManager *manager = [[self class] sessionManager];
    NSURLSessionConfiguration *config = manager.session.configuration;
    
    // config more timeout for every request sending
    if (config.timeoutIntervalForRequest != self.timeoutInterval){
        manager.session.configuration.timeoutIntervalForRequest = self.timeoutInterval;
    }
    if (manager.requestSerializer.timeoutInterval != self.timeoutInterval){
        manager.requestSerializer.timeoutInterval = self.timeoutInterval;
    }
    
    // Header request
    NSMutableDictionary *httpServiceHeaders = [self httpServiceHeaders];
    [httpServiceHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    // Send request
    NSString *requestString = [self getServerUrlRequest];
    NSString *cacheRequestKey = nil;

    if (self.shouldCacheResponse && self.methodType == kGet) {
        NSString *tsStr = [NSString getTextBtw:requestString lBound:@"&ts=" rBound:@"&"];
        NSString *checkSumStr = [NSString getTextBtw:requestString lBound:@"&check_sum=" rBound:@"&"];
        cacheRequestKey = [requestString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&ts=%@&", tsStr] withString:@""];
        cacheRequestKey = [cacheRequestKey stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"check_sum=%@&", checkSumStr] withString:@""];
    }

    __block NSURLSessionDataTask *task = nil;
    BlockWeakSelf weakSelf = self;
    
    void (^handleResponseService)(id, NSURLSessionDataTask *, NSError *) = ^(id responseObject, NSURLSessionDataTask *task, NSError *err){
        BlockStrongSelf strongSelf = weakSelf;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        NSInteger statusCode = httpResponse.statusCode;
        
        // If status code is auth failed (401), just post notification and logout instead of execute completedBlock
        if (statusCode == HTTP_STATUS_CODE_AUTH_FAILED) {
        }
        else {
            if (statusCode == HTTP_STATUS_CODE_SERVER_ERROR) {
            }
            
            if (completedBlock) {
                @autoreleasepool {
                    ResponseObject *responseObj = [[self class] responseObjectWithObject:responseObject error:err statusCode:statusCode];
                    if (self.shouldCacheResponse && strongSelf.methodType == kGet && httpResponse.statusCode == 200) {
                        if (responseObj.object && !responseObj.hasError) {
                            ExpiringCacheItem *item = [[ExpiringCacheItem alloc] init];
                            item.error = responseObj.error;
                            item.object = responseObj.object;
                            item.statusCode = responseObj.statusCode;
                            
                            [strongSelf cacheResponseObject:item forRequestString:cacheRequestKey];
                        }
                    }
                    
                    completedBlock(responseObj);
                }
            }
        }
    };
    
    void (^responseSuccessBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject){
        handleResponseService(responseObject, task, nil);
    };
    
    void (^responseFailureBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error){
        handleResponseService(nil, task, error);
    };
    
    switch (self.methodType) {
        case kPost: {
            // MARK: should read AFURLRequestSerialization.h, to reach the way we encode request post.
            task = [manager POST:requestString parameters:self.postParams success:responseSuccessBlock failure:responseFailureBlock autoRetry:self.autoRetryTimes];
        }
            break;
        case kPut: {
            task = [manager PUT:requestString parameters:self.postParams success:responseSuccessBlock failure:responseFailureBlock autoRetry:self.autoRetryTimes];
        }
            break;
        case kDelete: {
            task = [manager DELETE:requestString parameters:self.postParams success:responseSuccessBlock failure:responseFailureBlock autoRetry:self.autoRetryTimes];
        }
            break;
        default: {
            BOOL shouldReloadNewData = NO;
            if (self.shouldCacheResponse && self.methodType == kGet) {
                ExpiringCacheItem *item = [self handleResponseDataCacheForRequestString:cacheRequestKey];
                if (item) {
                    ResponseObject *responseObj = [ResponseObject response];
                    responseObj.object = item.object;
                    responseObj.error = item.error;
                    responseObj.statusCode = item.statusCode;
                    
                    if (completedBlock) {
                        da_mainSafeWithBlock(^{
                            completedBlock(responseObj);
                        });
                    }
                }
                else{
                    shouldReloadNewData = YES;
                }
            }
            else{
                shouldReloadNewData = YES;
            }
            
            if (shouldReloadNewData) {
                task = [manager GET:requestString parameters:nil success:responseSuccessBlock failure:responseFailureBlock autoRetry:self.autoRetryTimes];
            }
        }
            break;
    }
    
    if (processBlock) {
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
            processBlock(progress);
        }];
    }
    
    return task;
}

- (NSString *)getUrlParams {
    NSString *getParamUrl = @"";
    NSString *checkSumUrl = @"";
    NSString *checkSumMd5 = @"";
    
    // always add signature to request
    NSString *tk = (self.httpHeaders)[kBaseServiceHeaderAuthorizationKey];
    NSString *ts = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970 * 1000]; // milisecond
    
    if (tk == nil) {
        tk = @"";
    }
    
    // add signature
    [self.getParams setObject:[tk md5] forKey:@"tk"];
    [self.getParams setObject:ts forKey:@"ts"];
    
    // Set tags as a param
    if (self.tagParams.count) {
        __block NSString *tagParamUrl = @"";
        NSString *lastTagKey = (self.tagParams).allKeys.lastObject;
        [self.tagParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:lastTagKey]) {
                tagParamUrl = [tagParamUrl stringByAppendingFormat:@"%@:%@", key, obj];
            }
            else {
                tagParamUrl = [tagParamUrl stringByAppendingFormat:@"%@:%@;", key, obj];
            }
        }];
        
        [self.getParams setValue:tagParamUrl forKey:@"tags"];
    }
    
    // Sort params by key
    if (self.getParams.count) {
        NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:(self.getParams).allKeys];
        NSArray *sortedAllKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *key1 = obj1;
            NSString *key2 = obj2;
            return [key1 compare:key2];
        }];
        
        for (NSString *key in sortedAllKeys) {
            @autoreleasepool {
                if ([key isEqualToString:sortedAllKeys.lastObject]) {
                    getParamUrl = [getParamUrl stringByAppendingFormat:@"%@=%@", key, [[NSString stringWithFormat:@"%@", [self.getParams valueForKey:key]] escapeStringParameterUrl]];
                } else {
                    getParamUrl = [getParamUrl stringByAppendingFormat:@"%@=%@&", key, [[NSString stringWithFormat:@"%@", [self.getParams valueForKey:key]] escapeStringParameterUrl]];
                }
                
                checkSumUrl = [checkSumUrl stringByAppendingFormat:@"%@:%@|", key, [self.getParams valueForKey:key]];
            }
        }
    }
    
    checkSumUrl = [checkSumUrl append:@"private-key"];
    checkSumMd5 = [checkSumUrl md5];
    getParamUrl = [getParamUrl stringByAppendingFormat:@"&check_sum=%@&public_key=%@", checkSumMd5,@"public-key"];
    
    return getParamUrl;
}

+ (ResponseObject *)responseObjectWithObject:(id)responseObject error:(NSError *)error statusCode:(NSInteger)statusCode {
    return [self responseObjectWithObject:responseObject error:error statusCode:statusCode enabledLogs:YES];
}

+ (ResponseObject *)responseObjectWithObject:(id)responseObject error:(NSError *)error statusCode:(NSInteger)statusCode enabledLogs:(BOOL)enabledLogs{
    ResponseObject *response = [ResponseObject response];
    response.statusCode = statusCode;
    
    if (error) {
        BOOL serverError = [self commonServerError:error];
        if (statusCode != HTTP_STATUS_CODE_SERVER_ERROR && serverError) {
            statusCode = HTTP_STATUS_CODE_SERVER_ERROR;
        }
        if (error.userInfo) {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:error.userInfo];
            userInfo[@"statusCodeKey"] = @(statusCode);
            
            if (statusCode == HTTP_STATUS_CODE_SERVER_ERROR) {
                userInfo[NSLocalizedDescriptionKey] = @"error 500";
            }
            
            NSError *newErr = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            response.error = newErr;
        }
        else{
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:@{@"statusCodeKey":@(statusCode)}];
            
            if (statusCode == HTTP_STATUS_CODE_SERVER_ERROR) {
                userInfo[NSLocalizedDescriptionKey] = @"error 500";
            }
            
            response.error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
        }
    }
    else {
        response.object = responseObject;
        if ([responseObject isKindOfClass:[NSDictionary class]]
            && responseObject[@"Code"] != nil
            && [responseObject[@"Code"] integerValue] != 1){
            
            if (statusCode == HTTP_STATUS_CODE_SUCCESS || statusCode == HTTP_STATUS_CODE_CREATED) {
                statusCode = HTTP_STATUS_CODE_SERVICE_ERROR;
            }
            
            response.error = [NSError errorWithDomain:@"S-ErrorDomain" code:[responseObject[@"Code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:(responseObject[@"Message"]  != nil ? responseObject[@"Message"] : @"network failed"), @"statusCodeKey":@(statusCode)}];
        }
    }
    
#ifdef DEBUG
    if (enabledLogs) {
        if ([responseObject isKindOfClass:[NSDictionary class]]
            || [responseObject isKindOfClass:[NSArray class]]) {
            NSLog(@"%@", responseObject);
        }
        
        if ([responseObject isKindOfClass:[NSNull class]]) {
            NSLog(@"response is null...");
        }
    }
#endif
    
    return response;
}

- (void)setTaskDidSendBodyData:(NSURLSessionTask *)sendBodyDataTask onProcess:(void (^)(CGFloat progress))processBlock {
    [[[self class] sessionManager] setTaskDidSendBodyDataBlock:^void(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (task.taskIdentifier  == sendBodyDataTask.taskIdentifier) {
            float progress = (float)totalBytesSent / (float)totalBytesExpectedToSend;
            if(processBlock) {
                processBlock(progress);
            }
        }
    }];
}

#pragma mark - Send Request Header Page Classs

- (NSString *)getCallerControllerName {
    if (kBaseServiceHeaderPageEnable) {
        NSArray *callStackSymbols = [[NSThread callStackSymbols] copy];
        for (NSString *sourceString in callStackSymbols) {
            @autoreleasepool {
                NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
                NSArray *components = [sourceString componentsSeparatedByCharactersInSet:separatorSet];
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:components];
                [array removeObject:@""];
                
                NSInteger i = 3;
                if (array.count > i) {
                    NSString *classCaller = array[i];
                    while (classCaller && [classCaller hasPrefix:@"__"]) {
                        i++;
                        if (array.count > i) {
                            classCaller = array[i];
                        }
                    }
                    Class a = NSClassFromString(classCaller);
                    if ([a isSubclassOfClass:[UIViewController class]]
                        || [a isKindOfClass:[UIViewController class]]) {
                        return [classCaller copy];
                    }
                }
            }
        }
    }
    return nil;
}

+ (BOOL)commonServerError:(NSError *)error {
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

@end
