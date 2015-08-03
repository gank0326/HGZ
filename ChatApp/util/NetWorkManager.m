//
//  NewWorkManager.m
//  ChatApp
//
//  Created by howard on 14/12/24.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "NetWorkManager.h"
#import <AFNetworking.h>
@interface NetWorkManager()
{
}
@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;
@end
@implementation NetWorkManager
static  NetWorkManager *shareNetWorkManager =nil;
+ (NetWorkManager *) shareInstance;
{
    @synchronized(self) {
        if (shareNetWorkManager == nil)
        {
            
            // assignment not done here
            shareNetWorkManager =[[self alloc] init];
            
        }
        
    }
    
    return shareNetWorkManager;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (shareNetWorkManager == nil) {
            
            shareNetWorkManager = [super allocWithZone:zone];
            
            return shareNetWorkManager; // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts
}
- (id) init
{
    return self;
}

-(void)loadData:(NSDictionary *)paramDic requestCode:(NSString*)requestCode success:(void (^)(id responseDic))_success
           fail:(void (^)(id errorString))_fail
{
    NSString *url = [APPLICATION_HOST stringByAppendingString:requestCode];
    self.manager= [AFHTTPRequestOperationManager manager];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *requstDic = [[NSMutableDictionary alloc] initWithDictionary:paramDic];
    if(![CommonUtils isEmpty:[AppUtils getToken]]) {
        requstDic[@"apptoken"] = [AppUtils getToken];
    }
    [_manager POST:url parameters:requstDic success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *str =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result========%@",str);
        NSMutableDictionary *dic =[[CommonUtils getJsonDiction:str] mutableCopy];
        [dic setObject:requestCode forKey:@"requestCode"];
        if(_success) {
            _success(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
        [dic setObject:requestCode forKey:@"requestCode"];
        if (_fail) {
            _fail(dic);
        }
    }];
}

-(void)cancelReqesut
{
    [self.manager.operationQueue cancelAllOperations];
}
@end
