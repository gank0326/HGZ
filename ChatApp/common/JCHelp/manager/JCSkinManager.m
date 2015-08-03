//
//  JCSkinManager.m
//  Shanliao
//
//  Created by gsw on 4/16/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "JCSkinManager.h"
#import "JCViewUtil.h"
#import "XMLDictionary.h"
#import "EventBus.h"
#import "JCViewHelper.h"
#import "AppDelegate.h"

static NSString *CURRENT_SKIN = @"currentSkinKey";

@interface JCSkinManager ()
{
	NSMutableDictionary *skin;
	NSString *currentBundle;
}

@end

@implementation JCSkinManager

+ (id)shared {
	static JCSkinManager *__singletion;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    __singletion = [[self alloc] init];
	});
	return __singletion;
}

- (id)init {
	self = [super init];
	if (self) {
		currentBundle = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_SKIN];
		if (!currentBundle) {
			currentBundle = @"wizard.bundle";
		}
	}
	return self;
}

- (NSDictionary *)getSkin:(NSString *)skinName {
	NSDictionary *result;
	if (skin) {
		result = [skin objectForKey:skinName];
	}
	if (!result) {
		result = [[NSDictionary alloc] init];
    }else {
        NSString *refDicKey = [result objectForKey:@"_ref"];
        NSDictionary *refDic = [skin objectForKey:refDicKey];
        if (!refDic) {
            return result;
        }
        NSMutableDictionary *mutableResult = [NSMutableDictionary dictionaryWithDictionary:refDic];
        [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [mutableResult setObject:obj forKey:key];
        }];
        return mutableResult;
    }
	return result;
}

- (void)changeSkin:(NSString *)skinName {
	[[NSUserDefaults standardUserDefaults] setObject:skinName forKey:CURRENT_SKIN];
	[[NSUserDefaults standardUserDefaults] synchronize];
	currentBundle = skinName;
	skin = [NSMutableDictionary dictionary];
	NSString *jsonPath = [[[[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/"] stringByAppendingString:currentBundle] stringByAppendingString:@"/"] stringByAppendingString:@"skin.xml"];
	NSData *datas = [NSData dataWithContentsOfFile:jsonPath];
	if (datas) {
		NSDictionary *currentSkin = [NSDictionary dictionaryWithXMLData:datas];
		[skin addEntriesFromDictionary:currentSkin];
	}

	jsonPath = [[NSBundle mainBundle] pathForResource:@"skin_light"
	                                           ofType:@"xml"];
	datas = [NSData dataWithContentsOfFile:jsonPath];
	if (datas) {
		NSDictionary *lightOffSkin = [NSDictionary dictionaryWithXMLData:datas];
		[skin addEntriesFromDictionary:lightOffSkin];
	}
    
	[[EventBus shared] emit:@selector(changeSkin) withArguments:@[]];
}

- (NSString *)currentSkin {
	return currentBundle;
}

@end
