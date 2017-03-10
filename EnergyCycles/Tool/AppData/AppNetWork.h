//
//  AppNetWork.h
//
//

#ifndef PinCang_InterfaceParStr_h
#define PinCang_InterfaceParStr_h

//屏幕大小
#define Screen_Height CGRectGetHeight([UIScreen mainScreen].bounds)
#define Screen_width CGRectGetWidth([UIScreen mainScreen].bounds)

//获取StoryBoard中指定的VC
#define StoryBoardVC(boardName,boardID) [[UIStoryboard storyboardWithName:(boardName) bundle:nil]instantiateViewControllerWithIdentifier:(boardID)]
#define MainStoryBoard(boardID) StoryBoardVC(@"Main",(boardID))

//部分用户信息
#define User_ID [[AppHelpManager sharedInstance] readUserId]
#define User_TOKEN [[AppHelpManager sharedInstance] readToken]
#define User_PHONE [[AppHelpManager sharedInstance] readPhone]
#define User_ROLE [[AppHelpManager sharedInstance] readRole]
#define User_NAME [[AppHelpManager sharedInstance] readUserName]

#define MYJYAppId @"1079791492"

#define Html(id) [NSString stringWithFormat:@"%@/html/Study/html/StudyDetail.aspx?Id=%@",INTERFACE_URL,id]

#define HtmlUser(id,user) [NSString stringWithFormat:@"%@/html/Study/html/StudyDetail.aspx?Id=%@&userId=%@",INTERFACE_URL,id,user]

#define HtmlShare(id,user) [NSString stringWithFormat:@"%@/html/Study/html/StudyDetail.aspx?Id=%@&userId=%@&is_Share=1",INTERFACE_URL,id,user]


#define EC_ARTICLE_PLACEHOLDER [UIImage imageNamed:@"ec_article_placeholder"]

#define EC_AVATAR_PLACEHOLDER [UIImage imageNamed:@"ec_avatar_placeholder"]

#define EC_RECOMMEND_PLACEHOLDER [UIImage imageNamed:@"ec_comment_placeholder"]

#define LEARN_BANNER_PLACEHOLDER [UIImage imageNamed:@"learn_banner_placeholder"]

#define LEARN_PLACEHOLDER [UIImage imageNamed:@"learn_placeholder"]


//本地-习进
//#define INTERFACE_URL @"http://10.40.200.170:8082"
//本地-李雷-
//#define INTERFACE_URL @"http://10.40.200.186:8089/"

//测试环境
<<<<<<< HEAD

//#define INTERFACE_URL @"http://192.168.1.111:8888/"
=======
#define INTERFACE_URL @"http://192.168.1.111:8888/"
>>>>>>> 314a1b007d3090b03a8391f584a21d2d5e79799e

//#define INTERFACE_URL @"https://www.woodybear.cn/Power/"


//测试公网环境
//#define INTERFACE_URL @"http://120.26.218.68:8888/"

//正式环境
//#define INTERFACE_URL @"http://120.26.218.68:8038/"

//阿里云
#define INTERFACE_URL @"http://120.26.218.68:8038/"


#define CCTalk @"http://www.cctalk.com/org/525/?from=singlemessage&isappinstalled=0"

//1.发送短信验证码
#define GetCode                    @"user/GetCode"

//2.注册基本资料
#define Register                   @"user/Register"

//3.登录
#define Login                      @"user/Login"

//4.添加大图像
#define AddImg                     @"user/AddImg"

//5.查询基本资料
#define GetInfoByUserid            @"user/GetInfoByUserid"

//6.根据手机号查询个人信息
#define GetUserInfoByPhone         @"user/GetUserInfoByPhone"

//7.完善基本资料
#define FinishRegister             @"user/FinishRegister"

//8.申请老学员认证
#define OldPeopleVerify            @"user/OldPeopleVerify"

//9.我的消息或者通知
#define GetMessage                 @"user/GetMessage"

//9-1.我的消息或者通知
#define GetMessageDetail           @"user/GetMessageDetail"

//10.我的消息或者通知（待定）
//#define GetMessage      @"user/GetMessage"

//11.我的好友
#define BothHeart                  @"user/BothHeart"

//12.我的粉丝
#define HeartMe                    @"user/HeartMe"

//13.删除粉丝（取消关注）
#define DeleteHeartMe              @"user/DeleteHeartMe"

//13-1.删除粉丝（取消关注我的人）
#define DeleteMeHeart              @"user/DeleteMeHeart"

//14.我关注的人的列表
#define MyHeart                    @"user/MyHeart"

//15.获取积分列表
#define GetJiFenList               @"user/GetJiFenList"

//15-1.根据userid获取积分列表
#define GetJiFenListByUserid       @"user/GetJiFenListByUserid"

//16.获取商城商品列表
#define GetMerchantList            @"user/GetMerchantList"

//17.兑换记录列表
#define GetExchangeRecordList      @"user/GetExchangeRecordList"

//18.兑换记录详情
#define GetExchangeRecordDetail    @"user/GetExchangeRecordDetail"

//19.我的建议
#define MySuggestion               @"user/MySuggestion"

//20.商品兑换
#define doExchange                 @"user/doExchange"

//21.商品抽奖
#define doChouJiang                @"user/doChouJiang"

//21-1.商品抽奖成功，填写收货人信息 调用的接口
#define doChouJiangRecord          @"user/doChouJiangRecord"

//22.积分赠送
#define SendJifen                  @"user/SendJifen"

//23.找回密码
#define FindPwd                    @"user/FindPwd"

//24.找回密码发送验证码
#define SendPwdCode                @"user/SendPwdCode"

//25.添加发送私信
#define AddMessage                 @"user/AddMessage"

//26.获取2个人的对话列表
#define GetTalkList                @"user/GetTalkList"

//27.获取私信列表
#define GetTopOnePeople            @"user/MyMessage_get"

//28.查询我的积分排名
#define GetJinfenCount             @"user/GetJinfenCount"

//28-1.查询我的学习值排名
#define GetMyStudyValCount         @"user/GetMyStudyValCount"

//29.我的粉丝
#define GetfensiCount              @"user/GetfensiCount"

//30.我关注的人的数量
#define GetGuanzhuCount            @"user/GetGuanzhuCount"

//30-1.其他人信息界面
#define GetPeopleDataInfo          @"user/GetPeopleDataInfo"

//30-2.获取我的推荐的人列表
#define GetMyTuiJianList           @"user/GetMyTuiJianList"



//31.学习文章列表 最新 最热 精选 课程 4 个
#define GetStudyListByTab          @"Study/GetStudyListByTab"

//32.学习文章列表 最新 最热 精选 课程 4 个
#define GetStudyDetailById         @"Study/GetStudyDetailById"

//33.学霸榜列表
#define GetStudyGoodList           @"Study/GetStudyGoodList"

//34.课程详情里面的相关推荐 3条
#define GetAboutCourseList         @"Study/GetAboutCourseList"

//35.课程报名
#define GetAddStudyInfo            @"Study/AddStudyInfo"

//36.学习版块搜索
#define Search                     @"Study/Search"

//37.学霸点赞
#define SendGood                   @"Study/SendGood"

//38.学习版块搜索分类
#define GetStudyType               @"Study/getStudyType"

//39.课程时间列表
#define GetcourseTimeById          @"Study/GetcourseTimeById"

//40.增值服务列表
#define GetcourseServerById        @"Study/GetcourseServerById"

//41.获取学习模块tab项
#define GetStudyTabList            @"Study/GetStudyTabList"

//42.学习模块点赞和踩
#define StudyAddLikeOrNoLike       @"Study/AddLikeOrNoLike/"

//43.获取热门搜索关键词列表
#define GetHotSearch               @"Study/GetHotSearch"

//45.获取商品详细的页面
#define MerchantDetailAspx         @"html/MerchantDetail.aspx"

//46.获取学习版本的新闻 详情页面
#define StudyDetailAspx            @"html/Study/html/StudyDetail.aspx"

//47.添加学习版块的评论
#define AddCommnet                 @"Study/AddCommnet"

//48.根据学习版块的文章id 获取此文章的评论列表
#define GetStudyCommentList        @"Study/GetStudyCommentList"

//49.获取活动详细的 h5 页面
#define ActiveDetailAspx           @"html/ActiveDetail.aspx"

//49-1.获取文章的点赞的条数和评论的条数，以及是否赞和踩
#define GetStudyInfoById           @"Study/GetStudyInfoById"




//50.获取能量圈列表
#define GetArticleList             @"Article/Article_List/"

//51.获取某个能量圈的详情
#define GetArticleInfoById         @"Article/GetArticleInfoById"

//52.添加能量圈评论回复
#define AddCommentOfArticle        @"Article/AddCommentOfArticle"

//53.发布能量圈
#define AddArticle                 @"Article/AddArticle"

//54.能量圈点赞和踩
#define AddLikeOrNoLike            @"Article/AddLikeOrNoLike"

//55.能量圈签到
#define ArticleSign                @"Article/ArticleSign"

//56.获取本月已签到数据
#define GetSignInfo                @"Article/GetSignInfo"

//57.获取能量圈tab顺序
#define GetTabOfArticle            @"Article/GetTabOfArticle"

//58.获取pk广告
#define GetADV                     @"pk/GetADV"

//59.每日pk-获取下拉项目
#define GetProject                 @"pk/GetProject"

//60.每日pk-项目汇报
#define AddReport                  @"pk/AddReport"

//61.每日pk-获取排名列表
#define GetReportList              @"pk/GetReportList"

//62.每日pk-点赞
#define ZanReportItem              @"pk/ZanReportItem"

//63.每日pk-获取某个人的当天汇报项目情况
#define GetReportByUser            @"pk/GetReportByUser"

//64.每日pk-添加/取消关注
#define AddOrCancelFriend          @"pk/AddOrCancelFriend"

//65.进阶pk-获取tab顺序
#define GetTabOfPost               @"pk/GetTabOfPost"

//66.进阶pk-发布进阶pk时获取分类
#define GetPostType                @"pk/GetPostType"

//67.进阶pk-发布进阶pk帖子
#define AddPost                    @"pk/AddPost"

//68.进阶pk-获取进阶pk列表，包括本月奖品
#define GetPostList                @"pk/GetPostList"

//69.进阶pk-查看帖子详情
#define GetPostInfoById            @"pk/GetPostInfoById"

//70.进阶pk-对帖子点赞
#define PKAddLikeOrNoLike          @"pk/AddLikeOrNoLike"

//71.进阶pk-添加帖子评论
#define AddCommentOfPost           @"pk/AddCommentOfPost"

//72.进阶pk-查看奖品详情
#define GetAwardInfo               @"pk/GetAwardInfo"

//73.上传图片
#define PostFile                   @"Other/PostFile"

//74.判断是否已签到
#define IsHasSign                  @"article/IsHasSign"

//75.个人中心-我的每日pk中更换背景图
#define ChangeMyPkImg              @"Member/ChangeMyPkImg/"

//76.个人中心获取我的每日pk汇报的历史项目
#define GetMyPkHistoryProject      @"Member/GetMyPkHistoryProject/"

//77.个人中心获取我的每日pk项目的历史记录
#define GetMyPkProjectInfo         @"Member/GetMyPkProjectInfo/"

//78.获取推荐用户列表
#define GetRecommendUser           @"Member/RecommendUser_List"

//79.进阶pk-获取某个人发布的进阶pk列表
#define GetPostListByUser          @"pk/GetPostListByUser/"

//80.获取某个人发布的能量圈列表
#define GetArticleListByUser       @"article/GetArticleListByUser/"

//81.第三方登录
#define OtherLogin                 @"Other/OtherLogin/"

//81.获取进阶pk奖品详情h5页面
#define AwardDetailAspx            @"html/AwardDetail.aspx"

//82.获取能量圈详情h5页面
//#define ArticleDetailAspx          @"html/ArticleDetail.aspx"

#define ArticleDetailAspx          @"html/Article/ArticleDetail.aspx"

//83.获取进阶pk帖子详情h5页面
#define PostDetailAspx             @"html/PostDetail.aspx"

//84.获取通讯录手机号与当前用户的关系
#define JudgeCommunicationRelation @"Member/JudgeCommunicationRelation/"

//85.邀请-发送短信
#define SendSmsFromInvite          @"Member/SendSmsFromInvite/"

//86.好友模糊搜索
#define GetLikeUser                @"Member/GetLikeUser/"

//87.添加好友备注名
#define AddNoteName                @"User/AddNoteName/"

//88.删除能量圈或者进阶pk帖子
#define DeleteArticle              @"Member/DeleteArticle/"

//90.获取用户关注/粉丝列表
#define GetFriendsList             @"Member/GetFriendsList/"

//91.分享成功获得积分
#define Share                      @"Member/Share/"

//92.更换、绑定手机号
#define ChangePhoneNumber          @"user/User_Phone_Upd"

//93.更换手机号时发送验证码
#define GetVerificationCode        @"user/ChangePhoneNoSendCode"

//94.修改密码
#define ChangePassword             @"user/User_Pwd_Upd"

//95.修改个人简介
#define ChangeBrief                @"/user/App_User_Brief_Upd"

//96.获取用户粉丝/关注/能连贴等数量
#define UserInfo_Get               @"/user/UserInfo_Get"

//97.修改个人主页背景图片
#define ChangeBackgroundImg        @"/user/App_User_BackgroundImg_Upd"



//98.获取能量圈列表(查看其他人的能量圈)
#define GetOtherArticleList        @"Article/Article_List"

//99.获取用户点赞/评论消息
#define Message_Get                @"/user/Message_Get"

//100.将消息置为已读
#define Message_Readed             @"/user/Message_Readed"

//101. 未读消息
#define MyMessage                  @"/user/MyMessageNum_Get"

//102. 获取通知列表
#define APP_Notify_Get             @"user/APP_Notify_Get"

//103.修改个人资料中的手机号发送验证码
#define GetTelCode                 @"/user/GetTelCode"

//104. 修改个人资料中的手机号
#define AppUserTelUpdate           @"/user/AppUser_Tel_Upd"

//105.电台列表
#define AppRadioList               @"/Study/APP_Radio_LIst"

//106.获取用户每日PK统计
#define PkStatistics               @"/pk/PK_Statistics_Get"

//107.监测第三方是否是第一次登录
#define IsFirstLogin               @"other/IsFirstLogin"

//108.为第三方用户添加能量源
#define PowerSourceRelevance       @"other/PowerSourceRelevance"

//109.获得个人徽章数据
#define GetMyBedge                 @"user/MyBedge_Get"

//110.学习模块Banner列表
#define BannerList                 @"/Study/Banner_List"

//111.获赞排名
#define Good_Order                 @"pk/APP_REPORTITEM_Goods_Order"

//112.上传图片有水印
#define Article_PostFile           @"Other/Article_PostFile"


//113.早起签到排行榜
#define Early_Sign_Ranking         @"article/Early_Sign_Ranking"

//114.置顶帖子
#define SticklyArticle            @"Article/ArticleChoice_Set"

//115.添加承诺
#define Target_ADD                 @"Target/Target_ADD"

//116.承诺列表
//#define 



#endif
