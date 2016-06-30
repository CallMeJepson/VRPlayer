/**
AFN 主要功能: 就是发送网络请求.封装了一句话的网络请求代码.

AFHTTPRequestOperationManager:内部封装的是 NSUrlConnection,网络请求管理类,用来负责发送网络请求,是使用最多的一个类.

AFHTTPSessionManager :内部封装的是 NSUrlSession,网络请求管理类,用来负责发送网络请求,是使用做多的一个类.

两个网络请求管理类定义的 API 完全相同.

[[AFHTTPRequestOperationManager manager] GET:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
}];

[[AFHTTPSessionManager manager] GET:nil parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    //
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    //
}];

AFNetworkReachabilityManager.h :实时监测网络状态改变的管理类.

AFSecurityPolicy.h :HTTPS 需要使用.

AFURLRequestSerialization: 数据解析的时候会使用.
AFHTTPRequestSerializer:   万能解析器/对服务器返回的数据不做任务处理.
AFJSONResponseSerializer:  JSON解析器
AFXMLParserResponseSerializer:  XML解析器

详细说明:
一、大管理对象
1.AFHTTPRequestOperationManager
* 对NSURLConnection的封装

2.AFHTTPSessionManager
* 对NSURLSession的封装

二、AFHTTPSessionManager的具体使用
1.创建管理者
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

2.设置管理者的数据解析类型，默认为 json 格式的解析，可手动修改为其他类型，如 XML:
manager.responseSerializer = [AFXMLParserResponseSerializer serializer];

3.发送网络请求
NSDictionary *dict = @{@"username":@"zhangsan",@"password":@"zhang"};

[[AFHTTPSessionManager manager] POST:@"http://localhost/login/login.php" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    //
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    NSLog(@"responseObject:%@",responseObject);
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    NSLog(@"error:%@",error);
}];

[[AFHTTPSessionManager manager] GET:@"http://localhost/login/login.php" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
    
    NSLog(@"下载进度:%@",downloadProgress);
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSLog(@"responseObject:%@",responseObject);
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    NSLog(@"error:%@",error);
}];

 3.1 首先要明确发送的是什么类型的请求(GET/POST/HEAD...)

 3.2 AFN 3.0之后的网络接口相比之前的网络接口多了一个参数:网络进度.
 参数:
     1. urlString: 网络接口地址.
     2. parameters: 参数字典.key:服务器接收普通参数的key值,value就是参数内容.
     3. progress: 网络进度
     4. success: 成功回调
     5. failure: 失败回调

 3.3 AFN根据 response.MIMEType 来判断服务器返回数据的类型. 如果类型不匹配,但是又是JSON数据,解决方案:

     1.改变解析器类型为:万能解析器 ---> 手动解析JSON
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

     2.改变判断条件的类型,以使类型匹配,acceptableContentTypes默认情况下无 text/plain 类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];

     注： 如果没有使用第三方框架(CocoaPods)来管理第三方框架,可以直接修改第三方框架的源代码.
     一般在开发中,不要随意修改第三方源码.

三、AFHTTPRequestOperationManager的具体使用
1.创建管理者
AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

2.封装请求参数
NSMutableDictionary *params = [NSMutableDictionary dictionary];
params[@"username"] = @"哈哈哈";
params[@"pwd"] = @"123";

3.发送请求
NSString *url = @"http://localhost:8080/Server/login";
[mgr POST:url parameters:params
  success:^(AFHTTPRequestOperation *operation, id responseObject) {
      // 请求成功的时候调用这个block
      NSLog(@"请求成功---%@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      // 请求失败的时候调用调用这个block
      NSLog(@"请求失败");
  }];
// GET请求
[mgr GET:url parameters:params
  success:^(AFHTTPRequestOperation *operation, id responseObject) {
      // 请求成功的时候调用这个block
      NSLog(@"请求成功---%@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      // 请求失败的时候调用调用这个block
      NSLog(@"请求失败");
  }];

四、对服务器返回数据的解析
1.AFN可以自动对服务器返回的数据进行解析
* 默认将服务器返回的数据当做JSON来解析

2.设置对服务器返回数据的解析方式
1> 当做是JSON来解析（默认做法）
* mgr.responseSerializer = [AFJSONResponseSerializer serializer];
* responseObject的类型是NSDictionary或者NSArray

2> 当做是XML来解析
* mgr.responseSerializer = [AFXMLParserResponseSerializer serializer];
* responseObject的类型是NSXMLParser

3> 直接返回data
* 意思是：告诉AFN不要去解析服务器返回的数据，保持原来的data即可
* mgr.responseSerializer = [AFHTTPResponseSerializer serializer];

3.注意
* 服务器返回的数据一定要跟responseSerializer对得上
1> 服务器返回的是JSON数据
* AFJSONResponseSerializer
* AFHTTPResponseSerializer

2> 服务器返回的是XML数据
* AFXMLParserResponseSerializer
* AFHTTPResponseSerializer

3> 服务器返回的是其他数据
* AFHTTPResponseSerializer

五、实时监测网络状态

可利用 AFN 实时监测网络状态.
AFNetworkReachabilityManager 实时检测网络状态改变的类

AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

// 设置网络状态改变之后的操作
[manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    // status :当前的网络状态.
    //        AFNetworkReachabilityStatusUnknown
    //        AFNetworkReachabilityStatusNotReachable
    //        AFNetworkReachabilityStatusReachableViaWWAN
    //        AFNetworkReachabilityStatusReachableViaWiFi
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            
            NSLog(@"未知的网络状态");
            
            break;
            
        case AFNetworkReachabilityStatusNotReachable:
            
            NSLog(@"没有网络");
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            
            NSLog(@"蜂窝移动网络");
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            
            NSLog(@"WIFI网络");
            
            break;
            
        default:
            break;
    }
    
}];
// 开始检测网络状态
[manager startMonitoring];

六、支持 HTTPS 网络安全传输协议下的访问

HTTPS = HTTP(超文本传输协议) + SSL (安全连接层) HTTP 的安全版本.

HTTPS 会专门建立一个 安全的数据传输通道来传输数据,外界拿不到任何数据,现阶段最安全的协议，目前在 http 模式下三大运营商发送的恶意广告泛滥，并且可以获得用户的个人信息，知乎有专门文章讲解如何到工信部投诉的内容。

HTTPS 需要数字验证,目前很多大公司使用的数字验证都是默认支持的.

[manager GET:@"https://mail.itcast.cn" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    //
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSData *data = responseObject;
    //
    NSLog(@"成功:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    NSLog(@"失败:%@",error);
}];

AFN 默认情况下就是支持 HTTPS 访问的，但是如果用 HTTPS 的方式访问未受信任的网站便会报错，解决方案:
修改对 SSL 的检测:
AFN3.0之前:
manager.securityPolicy.allowInvalidCertificates = YES;
AFN3.0之后:
manager.securityPolicy.validatesDomainName = NO;

*/