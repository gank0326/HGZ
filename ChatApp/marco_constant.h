//应用常量导入
#define APPID @"955363827"
//调度日志开关
#define DEBUG_LOG
//聊天系统密码
#define CHAT_PASSWORD @"123"
//友盟
#define UmengAppkey @"5459914dfd98c576b80020b3"
#define USERDEFAULT_TOKEN @"appToken"
#define UID @"uid"
#define USERNAME @"username"
#define USERPHOTO @"userphoto"
#define REQESUT_CODE @"requestCode"
#define USERMOBILE @"usermobile"
#define ThemeDefaultFontColor  [UIColor orangeColor]
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define tagNavgitionItem   1001
#define TOAST_TOP [NSValue valueWithCGPoint:CGPointMake(160, 130)]
#define kCurrentVersion [CommonUtils getAppVersion]
//红点
#define kMaxCycId @"maxcyc" // 最大创友圈提醒id
#define kMaxRMId @"maxrm" // 最大人脉提醒id
#define kMaxGroupId @"maxqz" // 最大群组提醒id
#define kMaxActivityId @"maxhd" // 最大活动提醒id
#define kMaxNewFriendId @"maxjhy" // 最大加好友提醒id

//#if DEBUG
////#define APPLICATION_HOST [NSString stringWithFormat:@"http://apptest.joychuang.cn/interface.php?devicetype=ios&v=%@&m=gateway&f=",kCurrentVersion]
//#define APPLICATION_HOST [NSString stringWithFormat:@"http://jcapp.joychuang.cn/interface.php?devicetype=ios&v=%@&m=gateway&f=",kCurrentVersion]
//#else
//#define APPLICATION_HOST [NSString stringWithFormat:@"http://jcapp.joychuang.cn/interface.php?devicetype=ios&v=%@&m=gateway&f=",kCurrentVersion]
//#endif

#define APPLICATION_HOST [NSString stringWithFormat:@"http://apptest.joychuang.cn/interface.php?devicetype=ios&v=%@&m=gateway&f=",kCurrentVersion]

#define kREQESUT_FEEDBACK @"005"//意见反馈
#define kREQESUT_GETCITY @"010"//获取城市
#define kREQESUT_MODIFYCITY @"012"//修改地区
#define kREQESUT_REPORT_USER @"013"//举报
#define kREQESUT_GETTOKEN @"100"//获取token
#define kREQESUT_GETCODE @"101"//获取验证码
#define kREQESUT_GETTAG @"102"//获取标签
#define kREQESUT_REGISTER @"104"//注册
#define kREQESUT_REGISTER_EXTEND @"105"//完善资料
#define kREQESUT_LOGIN @"106"//登录
#define kREQESUT_FORGETPASSWORD @"107" //忘记密码
#define kREQESUT_MODIFYPASSWORD @"108"//修改登录密码
#define kREQEUST_MESSAGECODE_VALIDATE @"109" //验证手机验证码
#define kREQESUT_GETPROFILE @"110"//获取个人信息
#define kREQESUT_MODIFYNICKNAME @"112"//修改呢称
#define kREQESUT_MODIFYSEX @"113"//修改性别
#define KREQESUT_MODIFYTAG @"114"//修改标签
#define kREQESUT_MODIFYCUSTOMTAG @"115"//修改自定义标签
#define kREQESUT_UPLOADPHOTO @"116"//更换头像
#define kREQESUT_GETMYCARD @"117"//获取二维码
#define kREQESUT_GETMYPAGE @"119"//个人主页
#define kREQESUT_GETMYPOSTTOPIC @"120"//我发布过的话题
#define kREQEST_GETMYGOOD @"121"//我点过的赞
#define kREQESUT_MODIFYINTRODUCE @"122"// 修改个人简介
#define kREQESUT_MODIFYIJOBINFO @"123"// 修改公司和职位
#define kREQESUT_GETHOMEPAGE @"200"//聚创首页
#define kREQESUT_GETTOPILIST @"202"//获取话题列表
#define kREQESUT_TOPICDETAIL @"203"//话题详情
#define kREQESUT_POSTTOPIC @"204"//发布话题
#define kREQESUT_DELETETOPIC @"206"//删除话题
#define kREQESUT_TOPICDETAILGOOD @"207" //好评（点赞）
#define kREQESUT_TOPICDETAILBAD @"208" //差评
#define kREQESUT_GETTOPICCOMMENTDETAIL @"210" //评论祥情

#define kREQESUT_GETTOPICCOMMENT @"211" //发表评论
#define kREQESUT_GETTOPICSHARE @"213"//分享到创友圈
#define kREQESUT_POSTPARTY @"214" //添加聚会
#define kREQESUT_PARTYDETAIL @"215" //聚会详情
#define kREQESUT_PARTYSIGN @"217"//报名聚会
#define kREQESUT_GETTOPICVOTE @"218" //提交辩论（支持正方/反方）
#define kREQESUT_POSTVOTE @"219"//提交投票
#define kREQESUT_REPLYCOMMENT @"220" //对评论回复
#define kREQESUT_AGREECOMMENT @"221" //给评论点赞
#define kREQESUT_SUBCOMMENT @"222"// 子评论
#define kREQESUT_GETACTIVITYLIST @"223"//获取活动列表
#define kREQESUT_DELETEVERIFYMESSAGE @"301" //好友验证
#define kREQESUT_MYFRIENDS @"303"//我的创友列表
#define kREQESUT_FOLLOW @"304"//添加关注
#define kREQESUT_CANCELFOLLOW @"305"//取消关注
#define kREQESUT_ADDBLACKLIST @"306"//加入黑名单
#define kREQESUT_REMARKNAME @"307"//设置备注名
#define kREQESUT_GETFRIENDSBYKEYWORDS @"308"// 发现人脉/搜索创友
#define kREQESUT_GETSTRANGER @"309"//可能认识的人
#define kREQESUT_GETGEEK @"310"//极客大咖
#define kREQESUT_GETCIRCLE @"311"//群组首页
#define kREQESUT_GETSUBCIRCLE @"312"//群组二级例表
#define kREQESUT_GETCIRCLEDETAIL @"313"//群组详情
#define kREQESUT_GETCIRCLEMEMBER @"314"//群组成员例表
#define kREQESUT_GETCIRCLEJOIN @"315"//申请加群
#define kREQESUT_PULLPEOPLEINTOGROUP @"318" //拉人进群
#define kREQESUT_MAKEFRIENDSCIRCLE @"319"//我的创友圈
#define kREQESUT_GETKEYWORDS @"320"//人脉搜索热门标签
#define kREQESUT_GETMYFOLLOWNEW @"322" //最新关注(最新关注的10个好友)
#define kREQESUT_GETFOLLOWEDGEEK @"323" //极客大咖(已关注)
#define kREQESUT_GETMYJOINGROUP @"324" //我的群组(已经加入的群组)
#define kREQESUT_GETOTHERSPROFILE @"325"//获取他人信息
#define kREQESUT_CREATEGROUP @"326" //创建群租
#define kREQESUT_QUITGROUP @"328" //退出群租
#define kREQESUT_NEWFRIENDREDPOINT @"329" //新朋友红点提醒
#define kREQESUT_GETVERIFYFRIEND @"330" //好友验证
#define kREQESUT_GETMYVERIFYNEW @"331" //新的朋友验证列表
#define kREQESUT_KICKPERSON @"332" //群租踢人
#define kREQESUT_MODIFYGROUPNAME @"333" //群组改名


