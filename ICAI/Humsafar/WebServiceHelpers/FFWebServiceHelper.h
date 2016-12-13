//
//  WebserviceHelper.h



#import "AFNetworking.h"

@interface FFWebServiceHelper : NSObject

@property(nonatomic,strong) AFHTTPRequestOperation *reqOperation;
@property(nonatomic,strong) NSString *dynamicBaseUrl;

#pragma mark- Singleton
+(FFWebServiceHelper*)sharedManager;


- (void)callWebServiceWithUrl:(NSURL *)serviceUrl withParameter:(NSDictionary *)dictionary onCompletion:(void(^)(eResponseType responseType, id response))completionBlock;

- (void)uploadImageWithUrl:(NSString*)serviceUrl withParameters:(NSDictionary*)parameters onCompletion:(void(^)(eResponseType responseType, id response))completionBlock;


//+ (NSMutableURLRequest*)appendCommonHeaderFieldsToRequest:(NSMutableURLRequest*)request;

+ (NSURL *)phpServerUrlWithString:(NSString *)serviceURL;
- (NSURL *)javaServerUrlWithString:(NSString *)serviceURL;

@end


