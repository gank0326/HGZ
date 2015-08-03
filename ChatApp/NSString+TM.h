//
//  NSString+TM.h
//  FlashChat
//
//  Created by gsw on 12-10-11.
//
//

#import <Foundation/Foundation.h>

@interface NSString (TM)

- (NSString *)URLDecodedString;

- (NSString *)urlEncode;

- (NSString *)trim;

- (BOOL) isNullOrEmpty;

- (NSString*)md5Hash;

- (int) indexOf:(NSString *)text;

- (UIColor *)toColor;

- (NSData *)rc4:(NSString *)key;

- (NSString *)rc4String:(NSString *)key;

@end
