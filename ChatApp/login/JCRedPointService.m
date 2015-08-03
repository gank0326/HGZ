//
//  JCRedPointService.m
//  ChatApp
//
//  Created by joychuang on 15/3/24.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCRedPointService.h"

@implementation JCRedPointService

+ (id)shared {
    static JCRedPointService *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    return __singletion;
}

- (void)fetchRed {
    WEAKSELF
    [[NetWorkManager shareInstance] loadData:@{[AppUtils getUserId]:@"uid"} requestCode:kREQESUT_NEWFRIENDREDPOINT success:^(id responseDic) {
        [weakSelf loadRedPointSuccess:responseDic];
    } fail:^(id errorString) {
        
    }];
}

- (void)loadRedPointSuccess:(NSDictionary *)responseDic {
    long long int currentCycId = [[UserDefaultsUtils valueWithKey:kMaxCycId] longLongValue];
    long long int currentRMId = [[UserDefaultsUtils valueWithKey:kMaxRMId] longLongValue];
    long long int currentActivityId = [[UserDefaultsUtils valueWithKey:kMaxActivityId] longLongValue];
    long long int currentGroupId = [[UserDefaultsUtils valueWithKey:kMaxGroupId] longLongValue];
    long long int currentNewFriendId = [[UserDefaultsUtils valueWithKey:kMaxNewFriendId] longLongValue];
    NSDictionary *dic = [[responseDic objectForKey:@"data"] objectForKey:@"data"];
    _isCycRed = [dic[@"maxcyc"] longLongValue]>currentCycId;
    _isActivityRed = [dic[@"maxhd"] longLongValue]>currentActivityId;
    _isNewFriendRed = [dic[@"maxjhy"] longLongValue]>currentNewFriendId;
    _isGroupRed = [dic[@"maxqz"] longLongValue]>currentGroupId;
    _isRMRed = [dic[@"maxrm"] longLongValue]>currentRMId;
    [UserDefaultsUtils saveValue:dic[@"maxcyc"] forKey:kMaxCycId];
    [UserDefaultsUtils saveValue:dic[@"maxhd"] forKey:kMaxActivityId];
    [UserDefaultsUtils saveValue:dic[@"maxjhy"] forKey:kMaxNewFriendId];
    [UserDefaultsUtils saveValue:dic[@"maxqz"] forKey:kMaxGroupId];
    [UserDefaultsUtils saveValue:dic[@"maxrm"] forKey:kMaxRMId];
    [[EventBus shared] emit:@selector(refreshRedPoint) withArguments:[NSArray array]];
}

@end
