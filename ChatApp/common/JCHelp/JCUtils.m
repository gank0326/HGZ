//
//  SLUtils.m
//  Shanliao
//
//  Created by gsw on 8/9/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "JCUtils.h"
#import "OpenUDID.h"
//#import "java/util/ArrayList.h"

#define DEVICE_ID @"device_id"

@implementation JCUtils

+ (NSString *)uuid {
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return (__bridge_transfer NSString *)string;
}

+ (NSString *)encodeURL:(NSString *)unencodeString {
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)unencodeString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return encodedString;
}

+ (NSString *)urlDecode:(NSString *)encodedString {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                             (__bridge CFStringRef)encodedString,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8);
    if (result) {
        return result;
    }
    return @"";
}

+ (NSString *)getOpenUDID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:DEVICE_ID]) {
        return [defaults stringForKey:DEVICE_ID];
    }
    else {
        NSString *openUDID = [OpenUDID value];
        [defaults setValue:openUDID forKey:DEVICE_ID];
        return openUDID;
    }
}


//+ (id<JavaUtilList>)appendAndMerge:(id<JavaUtilList>)source to:(id<JavaUtilList>)dest withIdentiferSelector:(SEL)selector {
//    if (!source) {
//        return dest;
//    }
//    if (!dest) {
//        return [[JavaUtilArrayList alloc] initWithJavaUtilCollection:source];
//    }
//    int sourceSize = [source size];
//    int destSize = [dest size];
//    for (int i = 0; i < sourceSize; i++) {
//        id sourceItem = [source getWithInt:i];
//        BOOL found = NO;
//        if (selector) {
//            for (int j = 0; j < destSize; j++) {
//                id destItem = [dest getWithInt:j];
//                if ([sourceItem respondsToSelector:selector] && [destItem respondsToSelector:selector]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//                    if ([sourceItem performSelector:selector] == [destItem performSelector:selector]) {
//#pragma clang diagnostic pop
//                        
//                        found = YES;
//                        break;
//                    }
//                }
//            }
//        }
//        if (!found) {
//            [dest addWithId:sourceItem];
//        }
//    }
//    return dest;
//}
//
//+ (id<JavaUtilList>)appendAndMerge:(id<JavaUtilList>)source to:(id<JavaUtilList>)dest withUsingComparator:(NSComparator)cmptr {
//    if (!source) {
//        return dest;
//    }
//    if (!dest) {
//        return [[JavaUtilArrayList alloc] initWithJavaUtilCollection:source];
//    }
//    int sourceSize = [source size];
//    int destSize = [dest size];
//    for (int i = 0; i < sourceSize; i++) {
//        id sourceItem = [source getWithInt:i];
//        BOOL found = NO;
//        if (cmptr) {
//            for (int j = 0; j < destSize; j++) {
//                id destItem = [dest getWithInt:j];
//                if (cmptr(sourceItem, destItem) == NSOrderedSame) {
//                    found = YES;
//                    break;
//                }
//            }
//        }
//        if (!found) {
//            [dest addWithId:sourceItem];
//        }
//    }
//    return dest;
//}
//

@end
