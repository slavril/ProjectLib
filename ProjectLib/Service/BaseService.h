
#import "ResponseObject.h"
#import "AFHTTPRequestOperationManager+AutoRetry.h"
#import "AFHTTPSessionManager+AutoRetry.h"

#define kBaseServiceHeaderPageKey @"Page"
#define kBaseServiceHeaderAuthorizationKey @"Authorization"
#define HTTP_STATUS_CODE_SERVER_ERROR   500
#define HTTP_STATUS_CODE_AUTH_FAILED    401
#define HTTP_STATUS_CODE_CANNOT_AUTH    0
#define HTTP_STATUS_CODE_SUCCESS        200
#define HTTP_STATUS_CODE_CREATED        201
#define HTTP_STATUS_CODE_SERVICE_ERROR  404
#define NO_NETWORK                      1000#define ID_ERR_SYSTEM                       -1
#define ID_ERR_CONNECT_TO_SERVER            -10000
#define ID_ERR_UNKNOWN                      -10001
#define kDefaultMaximumRetryCount 2
#define kDefaultUrlRequestTimeoutInterval 90
#define kDownloadRequestTimeout 180

@class AFHTTPRequestOperation;

typedef NS_ENUM(NSInteger, MethodType) {
    kGet,
    kPost,
    kPut,
    kDelete
};

typedef NS_ENUM(NSInteger, ResponseType) {
    kJsonObject,
    kRawData
};

@interface BaseService : NSObject

@property (nonatomic, copy) NSString *urlRequest, *contentType;
@property (nonatomic, assign) MethodType methodType;
@property (nonatomic, assign) ResponseType responseType;
@property (nonatomic, assign) int timeoutInterval;
@property (nonatomic, assign) int autoRetryTimes;
@property (nonatomic, strong) NSMutableDictionary *tagParams;
@property (nonatomic, strong) NSMutableDictionary *getParams;
@property (nonatomic, strong) NSMutableDictionary *postParams;
@property (nonatomic, strong) NSMutableDictionary *httpHeaders;
@property (nonatomic, assign) BOOL needSecurityPassword;

@property (nonatomic, assign) BOOL enabledLogs;

@property (nonatomic, assign) BOOL shouldCacheResponse; // NO by default. Note: Only supports for get method
@property (nonatomic, assign) NSInteger maxResponseCacheAge; // 0 by default. It's only used if shouldCacheResponse is YES. If this value is less than zero, it will be set to zero and the response won't be cached.

- (instancetype)initWithUrlRequest:(NSString *)urlString method:(MethodType)method response:(ResponseType)response;

- (NSString *)getPostBody;
- (NSString *)getHttpMethod;
- (NSString *)getServerUrlRequest;
- (NSMutableDictionary *)httpServiceHeaders;

+ (AFHTTPSessionManager *)sessionManager;
+ (NSDictionary *)HTTPAdditionalHeaders;

// Cache response object in memory
+ (ResponseObject *)responseObjectCacheForKey:(NSString *)key expireTimeInterval:(NSTimeInterval)expireTimeInterval;
+ (void)cacheResponseObject:(ResponseObject *)responseObject forKey:(NSString *)key;
+ (void)clearAllCacheResponses;
+ (void)clearCacheResponsesForKey:(NSString *)requestKey;

// Cancel session task by id.
- (void)cancelSessionTasks:(NSArray<NSURLSessionTask *> *)tasks;

#pragma mark - Service methods

- (void)sendRequestToServerWithCompleteBlock:(void (^)(ResponseObject *response))completeBlock;
- (void)sendRequestToServerOnCompleted:(void (^)(ResponseObject *responseObject))completedBlock;
- (NSURLSessionDataTask *)sessionDataTaskWithCompleteBlock:(void (^)(ResponseObject *responseObject))completedBlock;
- (NSURLSessionDataTask *)sessionDataTaskWithProcessBlock:(void (^)(CGFloat progress))processBlock completeBlock:(void (^)(ResponseObject *responseObject))completedBlock;

+ (ResponseObject *)responseObjectWithObject:(id)responseObject error:(NSError *)error statusCode:(NSInteger)statusCode;
+ (ResponseObject *)responseObjectWithObject:(id)responseObject error:(NSError *)error statusCode:(NSInteger)statusCode enabledLogs:(BOOL)enabledLogs;

- (void)setTaskDidSendBodyData:(NSURLSessionTask *)sendBodyDataTask onProcess:(void (^)(CGFloat progress))processBlock;

@end
