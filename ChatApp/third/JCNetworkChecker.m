//
//  SLNetworkChecker.m
//  Shanliao
//
//  Created by gsw on 8/27/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "JCNetworkChecker.h"
#import "Reachability.h"

@implementation JCNetworkChecker


+ (void)checkNetwork:(void (^)(BOOL))avaliable {
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		avaliable(NO);
	}
	else {
		avaliable(YES);
	}
}

+ (Boolean)isAvailable {
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	return networkStatus != NotReachable;
}

@end
