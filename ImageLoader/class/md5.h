// Required library.
#import <CommonCrypto/CommonDigest.h>

// Category interface. This allows you to use the MD5Hash:-method on every existing NSString object.
@interface NSString (MD5)

- (NSString *)MD5Hash;

@end

// Category implementation
@implementation NSString (MD5)

- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    // Create lowercase NSString
    NSString *format = @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X";
    NSString *hashedString = [[NSString stringWithFormat:format, result[0], result[1], result[2], result[3], result[4],
							   result[5], result[6], result[7],
							   result[8], result[9], result[10], result[11], result[12],
							   result[13], result[14], result[15]] lowercaseString];
	
    return hashedString;
}

@end
