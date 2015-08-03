//应用库导入

//单例
#ifndef IQ_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define IQ_INSTANCETYPE instancetype
#else
#define IQ_INSTANCETYPE id
#endif
#endif



#import "UserDefaultsUtils.h"
#import "UINavigationController+XJPush.h"
#import <AFNetworking.h>
#import "NetWorkManager.h"

#import "registerParam.h"
#import "NSData+Base64.h"
#import "MJRefresh.h"


#import "UIView+RoundedCorners.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+CustomNavigation.h"
#import "AppUtils.h"
#import <CommonFrameWork/CommonFrameWork.h>