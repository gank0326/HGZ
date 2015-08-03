//
//  NSString+TM.m
//  FlashChat
//
//  Created by gsw on 12-10-11.
//
//
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSString+TM.h"

@implementation NSString (TM)

- (NSString*)URLDecodedString{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (__bridge CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);

    return result;
}

- (NSString *)urlEncode {
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
	return encodedString;
}

-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(BOOL) isNullOrEmpty
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([@"" isEqualToString:[self trim]]) {
        return YES;
    }
    return NO;
}

- (int) indexOf:(NSString *)text {
    NSRange range = [self rangeOfString:text];
    if ( range.length > 0 ) {
        return range.location;
    } else {
        return -1;
    }
}

//MD5
- (NSString*)md5Hash {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (UIColor *)toColor{
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
	// String should be 6 or 8 characters
	if ([cString length] < 6) return [UIColor grayColor];
    
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
	if ([cString length] != 6) return [UIColor grayColor];
    
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
    
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
    
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
    
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
    
	return [UIColor colorWithRed:((float)r / 255.0f)
	                       green:((float)g / 255.0f)
	                        blue:((float)b / 255.0f)
	                       alpha:1];
}


#define swap(a,b) a=a^b; \
b=a^b; \
a=b^a;

- (NSData *)rc4:(NSString *)key {
    int j = 0;
    unichar res[self.length];
    const unichar* buffer = res;
    unsigned char s[256];
    for (int i = 0; i < 256; i++)
    {
        s[i] = i;
    }
    for (int i = 0; i < 256; i++)
    {
        j = (j + s[i] + [key characterAtIndex:(i % key.length)]) % 256;
        
        swap(s[i], s[j]);
    }
    
    int i = j = 0;
    
    for (int y = 0; y < self.length; y++)
    {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        swap(s[i], s[j]);
        
        unsigned char f = [self characterAtIndex:y] ^ s[ (s[i] + s[j]) % 256];
        res[y] = f;
    }
    
    return [[NSData alloc] initWithBytes:buffer length:self.length];
}

- (NSString *)rc4String:(NSString *)key {
    int j = 0;
    unichar res[self.length];
    const unichar* buffer = res;
    unsigned char s[256];
    for (int i = 0; i < 256; i++)
    {
        s[i] = i;
    }
    for (int i = 0; i < 256; i++)
    {
        j = (j + s[i] + [key characterAtIndex:(i % key.length)]) % 256;
        
        swap(s[i], s[j]);
    }
    
    int i = j = 0;
    
    for (int y = 0; y < self.length; y++)
    {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        swap(s[i], s[j]);
        
        unsigned char f = [self characterAtIndex:y] ^ s[ (s[i] + s[j]) % 256];
        res[y] = f;
    }
    
    return [NSString stringWithCharacters:buffer length:self.length];
}


@end
