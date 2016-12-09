//
//  WebserviceHelper.h



#import "AFNetworking.h"

@interface FFWebServiceHelper : NSObject

#pragma mark- Singleton
+(FFWebServiceHelper*)sharedManager;

@property(nonatomic,strong)AFHTTPRequestOperation *reqOperation;

-(void) callWebServiceWithUrl:(NSURL *)serviceUrl withParameter:(NSDictionary *)dictionary onCompletion:(void(^)(eResponseType responseType, id response))completionBlock;

-(void)uploadImageWithUrl:(NSString*)serviceUrl withParameters:(NSDictionary*)parameters onCompletion:(void(^)(eResponseType responseType, id response))completionBlock;

//-(void) updateSessionWithDictionary:(NSDictionary*)dictionary;

//+ (NSMutableURLRequest*)appendCommonHeaderFieldsToRequest:(NSMutableURLRequest*)request;

//+ (NSURL *)urlWithString:(NSString *)serviceURL;
+(NSURL *)phpServerUrlWithString:(NSString *)serviceURL;
+(NSURL *)javaServerUrlWithString:(NSString *)serviceURL;

@end


