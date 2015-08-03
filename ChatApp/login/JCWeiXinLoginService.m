//
//  JCWeiXinLoginService.m
//  ChatApp
//
//  Created by joychuang on 15/3/12.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCWeiXinLoginService.h"
#import "NetWorkManager.h"

@implementation JCWeiXinLoginService

+ (id)shared {
    static JCWeiXinLoginService *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    return __singletion;
}

- (void)login {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = kAppDescription;
        [WXApi sendReq:req];
    }
    else {
        [AppUtils alert:@"请先安装微信客户端" withConfirmBtnTitle:@"确定"];
    }
}

- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp
{
    if (resp.errCode == 0)
    {
        NSLog(@"用户同意");
        SendAuthResp *aresp = (SendAuthResp *)resp;
        [self getAccessTokenWithCode:aresp.code];
        
    }else if (resp.errCode == -4){
        NSLog(@"用户拒绝");
    }else if (resp.errCode == -2){
        NSLog(@"用户取消");
    }
}

- (void)getAccessTokenWithCode:(NSString *)code
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeiXinAppId,kWeiXinAppSecret,code];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //获取token错误
                }else{
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
    
    /*
     正确返回
     "access_token" = “Oez*****8Q";
     "expires_in" = 7200;
     openid = ooVLKjppt7****p5cI;
     "refresh_token" = “Oez*****smAM-g";
     scope = "snsapi_userinfo";
     */
    
    /*
     错误返回
     errcode = 40029;
     errmsg = "invalid code";
     */
}

//获取头像，名称

- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:kWeiXinRefreshToken]];
                }else{
                    //获取需要的数据
                    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    requestDic[@"regsource"] = @(2);
                    [[NetWorkManager shareInstance] loadData:requestDic requestCode:@"500" success:^(NSDictionary*dic){
                        
                        [[EventBus shared] emit:@selector(weixinLoginSuccess:) withArguments:@[[dic objectForKey:@"data"]]];
                        
                    } fail:^(id fail) {
                    }];
                    
                }
            }
        });
    });
    
    /*
     city = ****;
     country = CN;
     headimgurl = "http://wx.qlogo.cn/mmopen/q9UTH59ty0K1PRvIQkyydYMia4xN3gib2m2FGh0tiaMZrPS9t4yPJFKedOt5gDFUvM6GusdNGWOJVEqGcSsZjdQGKYm9gr60hibd/0";
     language = "zh_CN";
     nickname = “****";
     openid = oo*********;
     privilege =     (
     );
     province = *****;
     sex = 1;
     unionid = “o7VbZjg***JrExs";
     */
    
    /*
     错误代码
     errcode = 42001;
     errmsg = "access_token expired";
     */
}

- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeiXinAppId,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else{
                    //重新使用AccessToken获取信息
                }
            }
        });
    });
    
    
    /*
     "access_token" = “Oez****5tXA";
     "expires_in" = 7200;
     openid = ooV****p5cI;
     "refresh_token" = “Oez****QNFLcA";
     scope = "snsapi_userinfo,";
     */
    
    /*
     错误代码
     "errcode":40030,
     "errmsg":"invalid refresh_token"
     */
}

//分享链接
- (void)sendlinkToWX:(NSMutableDictionary *)dict {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [dict objectForKey:@"title"];
    message.description = [dict objectForKey:@"description"];
    [message setThumbImage:[dict objectForKey:@"thumbImage"]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [dict objectForKey:@"webpageUrl"];
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    switch ([dict[@"scene"] integerValue]) {
        case 1:
            req.scene = WXSceneSession;
            break;
        case 2:
            req.scene = WXSceneTimeline;
            break;
        default:
            break;
    }
    [WXApi sendReq:req];
}
@end
