
#import "ResponseObject.h"
#import "BaseService.h"

NSString * const ROStatusCodeKey = @"statusCode";
NSString * const ROObjectKey = @"object";
NSString * const ROErrorKey = @"error";
NSString * const ROResponseIdKey = @"responseId";

@interface ResponseObject ()

@property (nonatomic, strong) NSArray *acceptStatusCodes;

@end

@implementation ResponseObject

+ (instancetype)response{
    return [[ResponseObject alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.acceptStatusCodes = @[@(HTTP_STATUS_CODE_SUCCESS), @(HTTP_STATUS_CODE_CREATED)];
        self.statusCode = HTTP_STATUS_CODE_SUCCESS;
    }
    return self;
}

- (NSInteger)errorCode{
    if (self.error) {
        return (self.error).code;
    }
    return ID_ERR_UNKNOWN;
}

- (BOOL)hasError{
    return self.error != nil || ![self.acceptStatusCodes containsObject:@(self.statusCode)];
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]){
        self.acceptStatusCodes = @[@(HTTP_STATUS_CODE_SUCCESS), @(HTTP_STATUS_CODE_CREATED)];
        
        _statusCode = [decoder decodeIntegerForKey:ROStatusCodeKey];
        _object = [decoder decodeObjectForKey:ROObjectKey];
        _error = [decoder decodeObjectForKey:ROErrorKey];
        _responseId = [decoder decodeObjectForKey:ROResponseIdKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:self.statusCode forKey:ROStatusCodeKey];
    if (self.object) {
        [coder encodeObject:self.object forKey:ROObjectKey];
    }
    if (self.error) {
        [coder encodeObject:self.error forKey:ROErrorKey];
    }
    if (self.responseId) {
        [coder encodeObject:self.responseId forKey:ROResponseIdKey];
    }
}

static NSString *_serviceCachePath = nil;
+ (NSString *)cacheResponseObjectPath{
    if (_serviceCachePath == nil) {
    }
    return _serviceCachePath;
}

+ (ResponseObject *)responseObjectWithFileName:(NSString *)fileName{
    NSString *filePath = [[self class] cacheResponseObjectPath];
    if (filePath == nil || fileName == nil) {
        return nil;
    }
    filePath = [filePath stringByAppendingPathComponent:fileName];
    ResponseObject *response = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return response;
}

- (BOOL)writeToFileWithName:(NSString *)fileName{
    NSString *filePath = [[self class] cacheResponseObjectPath];
    if (filePath == nil || fileName == nil || self.object == nil || self.hasError) {
        return NO;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    filePath = [filePath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    if (!success) {
        NSLog(@"write response object to disk with file name:%@ error", fileName);
    }
    return success;
}

@end
