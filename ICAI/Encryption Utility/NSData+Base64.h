
#import <Foundation/Foundation.h>

void *CDVNewBase64Decode(
	const char *inputBuffer,
	size_t length,
	size_t *outputLength);

char *CDVNewBase64Encode(
	const void *inputBuffer,
	size_t length,
	bool separateLines,
	size_t *outputLength);

@interface NSData (CDVBase64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

@end
