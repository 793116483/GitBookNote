//
//  ViewController.m
//  QJTableView
//
//  Created by 瞿杰 on 2019/9/23.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "QJTableView.h"
#import "QJBaseTableViewCell.h"
#import "QJSwitchCellModel.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()<UITableViewDelegate,NSURLConnectionDataDelegate,NSURLSessionDataDelegate>

@property (nonatomic,strong)QJTableView * tableView ;
@property (nonatomic,strong)NSThread * subThread ;

@end

@implementation ViewController
//+(instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    NSLog(@"创建对象");
//
//   return [super allocWithZone:zone];
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    QJTableView * tableView = [[QJTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.delegate = self ;
    tableView.rowHeight = 60 ;
    [self.view addSubview:tableView];
    self.tableView = tableView ;
    
    [self data];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ];
//    [self startNetwork];
    [self sessionDataTask];
//    NSThread * thread = [[NSThread alloc] initWithBlock:^{
//        [self tap:nil];
//    }];
//    [thread start];
}


-(void)data
{
    // secction 1
    QJBaseGroupCellModel  * group1 = [[QJBaseGroupCellModel alloc] init];
    [self.tableView.groupArr addObject:group1];
    group1.sectionHeaderTitle = @"section 1";
    QJBaseCellModel * cellModel = [QJBaseCellModel baseCellModelWithCellClass:[QJBaseTableViewCell class] reuseIdentifier:nil];
    cellModel.text = @"secction 1";
    cellModel.detailText = @"row 1";
    cellModel.image = [UIImage addImage];
    [group1.modelArr addObject:cellModel];
    
    // secction 2
    QJBaseGroupCellModel  * group2 = [[QJBaseGroupCellModel alloc] init];
    group2.sectionHeaderTitle = @"section 2";
    [self.tableView.groupArr addObject:group2];

    cellModel = [QJBaseCellModel baseCellModelWithCellClass:[QJBaseTableViewCell class] reuseIdentifier:nil];
    cellModel.text = @"secction 2";
    cellModel.detailText = @"row 1";
    cellModel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [group2.modelArr addObject:cellModel];
    
    
    cellModel = [QJBaseCellModel baseCellModelWithCellClass:[QJBaseTableViewCell class] reuseIdentifier:nil];
    cellModel.text = @"secction 2";
    cellModel.detailText = @"row 2";
    [group2.modelArr addObject:cellModel];
    
    
    cellModel = [QJSwitchCellModel baseCellModelWithCellClass:[QJBaseTableViewCell class] reuseIdentifier:nil];
    ((QJSwitchCellModel *)cellModel).on = YES ;
    cellModel.text = @"secction 2";
    cellModel.detailText = @"row 3";
   
    cellModel.updateCellSubviewWhenSetCellModelBlock = ^(QJBaseTableViewCell * _Nonnull cell, QJBaseCellModel * _Nonnull cellModel) {
        
        cell.detailTextLabel.text = @"dfsfds";
    };
    [group2.modelArr addObject:cellModel];
    
    NSLog(@"%@",self.tableView.groupArr);
    
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
}

- (void)subThreadTask
{
    NSLog(@"%@ , runLoop = %@",[NSThread currentThread],[NSRunLoop currentRunLoop]);
}

-(void)tap:(UITapGestureRecognizer*)tap
{
    NSLog(@"current thread = %@",[NSThread currentThread]);
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSLog(@"只执行一次 ， 在线程 =  %@",[NSThread currentThread]);
//    });
   
    
//    CGPoint point = [tap locationInView:self.view];
//    NSLog(@"%@",[NSValue valueWithCGPoint:point]);

//    dispatch_get_main_queue();
//    dispatch_get_current_queue();
//    NSThread * thread = [NSThread mainThread];
//    thread = [NSThread currentThread];
    
//    [self performSelectorOnMainThread:<#(nonnull SEL)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>]
//    // 锁：必须是唯一的全局变量,objc 是被加锁的对象
//    // 1. 注意加锁的前提条件，多线程共享一块资源
//    // 2. 加锁是需要耗性能
//    // 3. 加锁的结果，多个线程是同步的，只有加锁的对象在加锁的代码块中用完后才被解锁，然后才轮到下一下线程用
//    @synchronized (objc) {
//        // 需要锁定的代码
//    }
    
//    dispatch_queue_create(const char * _Nullable UILabel, dispatch_queue_attr_t  _Nullable attr)
//    dispatch_queue_t queue = dispatch_queue_create("xxxQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_sync(queue, ^{
//        NSLog(@"%@====1",[NSThread currentThread]);
//
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"%@====2",[NSThread currentThread]);
//
//        for (int i = 0; i< 1000000; i++) {
//
//        }
//        NSLog(@"%@====2.1 ",[NSThread currentThread]);
//
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"%@====3",[NSThread currentThread]);
//    });
//
//    dispatch_block_create(<#dispatch_block_flags_t flags#>, <#^(void)block#>)
//    // 栅栏: 拦截 或 控制 队列中的 栅栏前任务组 和 栅栏后任务组 的 执行顺序，前任务组必须完全执行完后，才能接着执行后面的任务组
//    // 注意：栅栏 不能使用 全局并发队列 ， 不然就没有 控制前后任务执行的 先后顺序
//    dispatch_barrier_sync(queue, ^{
//        NSLog(@"%@====栅栏 任务",[NSThread currentThread]);
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"%@====4",[NSThread currentThread]);
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"%@====5",[NSThread currentThread]);
//    });
//    NSOperationQueue
//    NSOperation
//    // 迭代
//    // 参数1 iterations ： 迭代次数
//    // 参数2 queue      : 将任务放入队列  ，传入并发队列才有意，效率高 ，不然与 for 无差别
//    // 参数3 block      : 被线程执行的任务 , 如果加入到 并发队列就会是异步任务 ；如果加入到 串行队列就会是同步任务
//    dispatch_apply(10, dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT), ^(size_t index) {
//        NSLog(@"indx = %ld , thread = %@",index,[NSThread currentThread]);
//    });
//    dispatch_async_and_wait(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, queue, ^{
//        // 异步任务
//        NSLog(@"1== %@",[NSThread currentThread]);
//    });
//    dispatch_group_async(group, queue, ^{
//        // 异步任务
//        NSLog(@"2== %@",[NSThread currentThread]);
//    });
//    dispatch_group_async(group, queue, ^{
//        // 异步任务
//        NSLog(@"3== %@",[NSThread currentThread]);
//    });
//    dispatch_group_async(group, queue, ^{
//        // 异步任务
//        NSLog(@"4== %@",[NSThread currentThread]);
//    });
//    dispatch_group_async(group, queue, ^{
//        // 异步任务
//        NSLog(@"5== %@",[NSThread currentThread]);
//    });
//    dispatch_group_async(group, queue, ^{
//        // 异步任务
//        NSLog(@"6== %@",[NSThread currentThread]);
//    });
//    dispatch_group_notify(group, queue, ^{
//        // 通知队列组 中的 queue 队列 的任务已经完全执行完
//        // 当前线程 是最后一个执行完任务的线程
//        NSLog(@"group 的 queue 队列 中的任务已经完成执行 === %@",[NSThread currentThread]);
//
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"当前是在子线程中并发执行的，所以现在主线程是空闲的，所以不会造成死锁");
//        });
//    });
//
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    NSLog(@"founction 完结=======");
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"在主线程中执行，现在主线程中没有空闲");
//        });
//    });
//    NSCache
//    dispatch_write(<#dispatch_fd_t fd#>, <#dispatch_data_t  _Nonnull data#>, <#dispatch_queue_t  _Nonnull queue#>, <#^(dispatch_data_t  _Nullable data, int error)handler#>)
    
    // sources 用法
    if (self.subThread) {
        // 长驻子线程 执行方法
        [self performSelector:@selector(subThreadTask) onThread:self.subThread withObject:nil waitUntilDone:YES];
        // waitUntilDone = YES : 表示当 subThreadTask 方法执行完后才执行下面代码
        return ;
    }
    __weak typeof(self) weakSelf = self ;
    dispatch_async(dispatch_queue_create("xxxxQueue", DISPATCH_QUEUE_SERIAL), ^{
        
        NSLog(@"current thread = %@",[NSThread currentThread]);

        // 当前线程
        weakSelf.subThread = [NSThread currentThread];
        
        // 1. 当前子线程长驻(添加 )
        NSRunLoop * runLoop = [NSRunLoop currentRunLoop];
        
        // 2. 添加 默认Mode 的 sources1 端口
        NSPort * port = [NSPort port];
        [runLoop addPort:port forMode:NSDefaultRunLoopMode];
        
        // 3.添加 runLoop 通知(一定要在 运行前添加)
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            // 当 runLoop退出时
            if (activity == kCFRunLoopExit) {
                NSLog(@"当前线程的 runLoop 已经退出了");
                self.subThread = nil ;
            }
        });
        CFRunLoopAddObserver(runLoop.getCFRunLoop, observer, kCFRunLoopDefaultMode);
        
        // 3. 运行 runLoop , 5秒后就结束 runLoop （即5秒后当前线程就不能处理事件了，线程和runLoop结束）
        [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5] ];
        
    });
        
        // 如果是子线程，创建子线程的 runLoop , 如果当前线程是主线程，那么就是mainRunLoop
//        CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//        // 获取主线程的 RunLoop
//        CFRunLoopRef mainLoop = CFRunLoopGetMain();
     
    //    kCFRunLoopDefaultMode : App默认的模式; 通常主线程是在这种模式下运行
    //    UITrackingRunLoopMode : 界面跟踪mode ; 当ScrollView 追踪触摸滑动时，自动切换到这种模式下工作，保证界面滑动时不受其他Mode 影响
    //    kCFRunLoopCommonModes : 这是一个占位用的 Mode , 不是一种正真的 Mode
    
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        NSLog(@"RunLoop 当前的状态 = %ld",activity);
//    });
//    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    
//    CFRunLoopSourceCreate(kCFAllocatorDefault, <#CFIndex order#>, <#CFRunLoopSourceContext *context#>)
//    CFRunLoopAddSource(<#CFRunLoopRef rl#>, CFRunLoopSourceRef source, <#CFRunLoopMode mode#>)
//    [[NSRunLoop currentRunLoop] addPort:<#(nonnull NSPort *)#> forMode:<#(nonnull NSRunLoopMode)#>]
    
    // 1、定时器
    
//    CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent(), 2, 0, 0 , ^(CFRunLoopTimerRef timer) {
//        NSLog(@"runLoop timer thread = %@",[NSThread currentThread]);
//    });
//    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
//    CFRunLoopRun();
    
    
//    // timer 只有添加到 runLoop 才可以正常启动
//    NSTimer * timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        // 重复调用的 block
//    }];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    // 定时器需要强引用，不然局部定时器会被释放 , 使用
//    static dispatch_source_t timer = NULL;
//    if (timer != NULL) {
//        // 暂停定时器
//        dispatch_suspend(timer);
//        return ;
//    }
//    /// d dfd
//    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create("xxxx", DISPATCH_QUEUE_SERIAL));
//    // leewayInSeconds : 误差时间，0表示时间精确
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(timer, ^{
//        // 每一次都在子线程执行，由 非主队列决定 dispatch_queue_create("xxxx", DISPATCH_QUEUE_SERIAL)
//        NSLog(@"%@",[NSThread currentThread]);
//    });
//    // 启动定时器
//    dispatch_resume(timer);
    static NSInteger flage = 0 ;
    if (flage == 0) {
        [self cancelNetwork];
        flage = 1 ;
    }
    else{
        [self startNetwork];
        flage = 0 ;
    }
}

-(NSString *)MIMETypeWithFilePath:(NSString *)filePath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return @"";
    }
    CFStringRef UTT = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)([filePath pathExtension]), NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTT, kUTTagClassMIMEType);
    CFRelease(UTT);
    if (!MIMEType) {
        // 支持所有的二进制 的 MIMEType
        return @"application/octet-stream";
    }
    return (__bridge NSString *)MIMEType ;
}

NSURLConnection * connection = nil;
NSFileHandle * fileHandle = nil ;
NSInteger totleLength = 0 ;
NSInteger currentLength = 0 ;
NSString * filePath = @"";
-(void)startNetwork
{
    
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b-ssl.duitang.com/uploads/blog/201410/19/20141019173244_PU8eT.jpeg"]];

    // 注意：断点下载，重新开始(被取消的下载又接着后面下载)，接着 currentLength 字节后面未下载的接着下
    NSString * range = [NSString stringWithFormat:@"bytes=%zd-",currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 需要实现 delegete (NSURLConnectionDataDelegate 且也可以实现其他代理)
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
// 取消下载
-(void) cancelNetwork
{
    [connection cancel];
}
#pragma mark - NSURLConnectionDataDelegate
// 开始下载
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (currentLength > 0) { // 属于断点下载
        NSLog(@"继续下载");
        return ;
    }
    NSLog(@"开始下载");
    // 文件第一次下载 初始化
    filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"name.jpg"];
    // 1. 创建文件
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    // 2. 创建文件句丙，用于沙盒拼接数据
    fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    // 本次下载文件大小(单位：bytes)，用于计算下载进度
    totleLength = response.expectedContentLength;
}
// 正在下载的拿到文件的一部分数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 把句丙指针移到沙盒内文件末尾
    [fileHandle seekToEndOfFile];
    
    // 把当前下载好的部分文件拼接到沙盒文中去
    [fileHandle writeData:data];
    
    // 下载进度
    currentLength += data.length;
    CGFloat progress = 1.0 * currentLength / totleLength ;
    NSLog(@"正在下载到 %f",progress);
}
// 下载失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // 关闭文件句丙
    [fileHandle closeFile];
    fileHandle = nil ;
    totleLength = 0 ;
    currentLength = 0 ;
    
    // 删除已经下载的数据
    if (filePath.length) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSLog(@"下载失败");
}
// 下载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 关闭文件句丙
    [fileHandle closeFile];
    fileHandle = nil ;
    
    // 把下载好的数据读出来
//    NSData * jpgImageData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSLog(@"下载完成 存储在 %@",filePath);
}

#pragma mark - NSURLSession 网络请求
-(void)sessionDataTask
{
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1 ;
    
    // delegate : NSURLSessionDelegate 是一个父协议，还有很多协议遵守了该父协议，如 NSURLSessionDataDelegate
    // delegateQueue : 如果是非主队列，那就是在子线程调用 代理方法
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
    // 创建 task
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/AFNetworking/AFNetworking"]];
    /* 第一种方式，不需要 delegate ，直接收到 data请求体数据，小数据适用
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 在子线程调用
        NSLog(@"%@",[NSThread currentThread]);
    }];
     */
    
    // 大数据下载用 delegate 回调方法
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request];
    
    // 断续 task
    [dataTask resume];
    
   //bootstrap
//    UIWebView
}
#pragma mark - NSURLSessionDelegate
/// 请求 https 时调用代理方法，询问收到服务器返回的证书处理方案（安装 or 不安装）
/// @param session 会话连接
/// @param challenge 授权询问
/// @param completionHandler 授权的处理方案
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    // 受保护的空间:
        // serverTrust : 服务器证书信任状态,
        //               取值：只有当 authenticationMethod = NSURLAuthenticationMethodServerTrust 才不为 nil
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // 调用 completionHandler block 告诉系统处理方案
        
        // NSURLSessionAuthChallengeDisposition 枚举方案
        /*
         NSURLSessionAuthChallengeUseCredential = 0,   安装使用当前指定的证书
         NSURLSessionAuthChallengePerformDefaultHandling = 1,   忽略安装当前证书，默认的处理方案
         NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,  忽略安装当前证书，并且 关闭所有请求
         NSURLSessionAuthChallengeRejectProtectionSpace = 3,    拒绝，忽略安装当前证书，下一次的询问处理方案还可以等
         */
        
        // 告诉系统 证书处理方案
        completionHandler(NSURLSessionAuthChallengeUseCredential , challenge.proposedCredential);
    }
}
#pragma mark - NSURLSessionDataDelegate

NSMutableData * taskData ;
// 下载前得到的请求
// 注意 completionHandler block 调用告诉系统是否继续下载，默认是不继续下载
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    /*
     NSURLSessionResponseCancel = 0,    // 取消下载，与 -[task cancel] 方法一样功能
     NSURLSessionResponseAllow = 1,     // 继续下载
     NSURLSessionResponseBecomeDownload = 2,    // 转成 Download
     NSURLSessionResponseBecomeStream           // 转成 Stream
     */
    // 告诉系统需要继续,否则系统默认直接取消下载
    completionHandler(NSURLSessionResponseAllow);
    
    taskData = [NSMutableData data];
    NSLog(@"1 %@",[NSThread currentThread]);
}
// 下载的数据,拼接
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"2 %@",[NSThread currentThread]);
    [taskData appendData:data];
}
// 完成下载
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"task = %@, currentThread = %@ , data = %@",task,[NSThread currentThread],[NSJSONSerialization JSONObjectWithData:taskData options:NSJSONReadingMutableContainers error:nil]);
    
    NSLog(@"json string = %@",[[NSString alloc] initWithData:taskData encoding:NSUTF8StringEncoding]);
}

-(void)update
{
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"xxxx"]];
    request.HTTPMethod = @"POST";
    NSDictionary * paramters = @{@"name":@"121" , @"pwd":@"dsad"};
    // 按格式拼接，这个只是一个参数拼接，请求不会成功，先用这个代表 body
    request.HTTPBody =[NSJSONSerialization dataWithJSONObject:paramters options:NSJSONWritingFragmentsAllowed error:nil];
    // 上传文件数据,拿 image举例
    NSData * fileData = UIImagePNGRepresentation([UIImage imageNamed:@""]);
    [session uploadTaskWithRequest:request fromData:fileData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }].resume;
    
//    [session uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:@"xxxx"]];
    
}
@end
