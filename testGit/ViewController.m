//
//  ViewController.m
//  testGit
//
//  Created by 张冲 on 2017/8/15.
//  Copyright © 2017年 张冲. All rights reserved.
//

#import "ViewController.h"
#import <Realm.h>
#import <RLMRealmConfiguration.h>
#import <Crashlytics/Crashlytics.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import <MBProgressHUD.h>
#import <CJSegmentControl.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSObjectDelegate <JSExport>
- (void)callCamera;
- (void)share:(NSArray *)shareString;
@end

 @interface ViewController ()<CJSegmentControlDelegate,WKNavigationDelegate,WKUIDelegate>
{
    
    NSMutableDictionary *_dic ;
}
@property (nonatomic,strong)NSString *strongString;
@property (nonatomic,copy)NSString *copString;
@property (weak, nonatomic)JSContext *jsContent;
@property (nonatomic, strong)WKWebView *webview ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    NSURL *trl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    
    
   
  //  [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
  
   
    
    /*
    NSLog(@"这是一个新的分支，我要测试");
    NSLog(@"这是第二个分支");
    NSLog(@"重新测试一下分支合并");
   
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"让你等一会儿。。。。";
    
    NSArray * array = @[@"wiwiiw"];

    @try {
        array[2];

    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        NSLog(@"这是什么");
    }
    
    
    CJSegmentControl * cj = [[CJSegmentControl alloc]initWithFrame:CGRectMake(20, 100, 320, 30) titles:@[@"zhangcc",@"zhangyuhan",@"yanyaman",@"贾诗雨",@"jiashiyue"] selectionWidth:100];
    cj.cjDelegate = self;

    [self.view addSubview:cj];
    
    
    */
    
    
    FirstViewController * fistVc = [[FirstViewController alloc]init];
    [self.view addSubview:fistVc.view];
    
    
//    SecondViewController *svc = [[SecondViewController alloc]init];
//    svc.view.frame = CGRectMake(0, 0, 200, 400);
    
//    [self addChildViewController:svc];
    //[self.view addSubview:svc.view];

    //[self creatDataBaseWithName:@"db/db.realm"];
    
//    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"打开了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alerView show];
//    _dic = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary * newdic = [[NSMutableDictionary alloc]init];
//    newdic = _dic;
//    [newdic setObject:@"1" forKey:@"1"];
//    [newdic setObject:@"2" forKey:@"2"];
//    NSLog(@"_dic = %@",_dic);
// 
//    [self addsegment];
//    
//    [self test];
//    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(20, 50, 100, 30);
//    [button setTitle:@"Crash" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//
//    
//    NSArray * errorArray = @[@"123"];
 //   id item = errorArray[2];
    
     
    // Do any additional setup after loading the view, typically from a nib.
}

//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
    
    WKFrameInfo *info = [[WKFrameInfo alloc]init];
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"网页加载完成");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"网页加载失败");
    
}

//- (void)webview 

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.jsContent = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContent[@"Toyun"] = self;
    self.jsContent.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        context.exception = exception;
        NSLog(@"异常信息:/%@",exception);
    };
}
#pragma mark - JSObjcDelegate

- (void)callCamera {
    NSLog(@"callCamera");
    // 获取到照片之后在回调js的方法picCallback把图片传出去
    JSValue *picCallback = self.jsContent[@"picCallback"];
    [picCallback callWithArguments:@[@"photos"]];
}

- (void)share:(NSString *)shareString {
    NSLog(@"share:%@", shareString);
    // 分享成功回调js的方法shareCallback
    JSValue *shareCallback = self.jsContent[@"shareCallback"];
    [shareCallback callWithArguments:nil];
}
- (WKWebView *)webview{
    
    if (_webview == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.minimumFontSize = 18;
        
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        
        [self.view addSubview:_webview];
    }
    return _webview;

}
- (void)segmentControlSelected:(NSInteger)tag{
    
    NSLog(@"tag = %ld",(long)tag);
    CGFloat floati = tag*50/255.0;
    self.view.backgroundColor = [UIColor colorWithRed:floati green:floati*2 blue:floati*3 alpha:1.];

}



- (IBAction)crashButtonTapped:(id)sender {
//    [[Crashlytics sharedInstance] crash];
    
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"pageCurl";
    animation.type = kCATransitionFromBottom;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    
    SecondViewController *svc = [[SecondViewController alloc]init];
   // [svc setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:svc animated:YES completion:^{
        
    }];
}

- (void)addsegment{

    NSArray *array = [NSArray arrayWithObjects:@" 我的 ",@" 处理 ", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    [segment setFrame:CGRectMake(0, 0, 120, 60)];
    segment.center = self.view.center;
    //根据内容定分段宽度
    segment.apportionsSegmentWidthsByContent = YES;
    //开始时默认选中下标(第一个下标默认是0)
    segment.selectedSegmentIndex = 0;
    //控件渲染色(也就是外观字体颜色)
    segment.tintColor = [UIColor blackColor];
    // 设置指定索引选项的宽度(设置下标为2的分段宽度)
    [segment setWidth:60.0 forSegmentAtIndex:0];
    [segment setWidth:60.0 forSegmentAtIndex:1];
    //添加事件
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    //添加到视图
    [self.view addSubview:segment];
}

- (void)test{
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"这是一个测试"];
    self.strongString = string;
    self.copString = string;
    NSLog(@"测试文字 string:%p,%p ",string,&string);
    NSLog(@"strong 属性 Strongstring = %@ ,%p , %p",self.strongString,self.strongString,&_strongString);
    NSLog(@"copString 属性 copStringstring = %@, %p , %p",self.copString,self.copString,&_copString);
    [string appendString:@"123456"];
    
    NSLog(@"测试文字 string:%p,%p ",string,&string);
    NSLog(@"strong 属性 Strongstring = %@ ,%p , %p",self.strongString,self.strongString,&_strongString);
    NSLog(@"copString 属性 copStringstring = %@, %p , %p",self.copString,self.copString,&_copString);
    
    
    
    
    

    
}

- (void)change:(UISegmentedControl *)segment{
    
    
    NSLog(@"点击了某个按钮=%ld",(long)segment.selectedSegmentIndex);
    
}
#pragma mark - 摇一摇开始
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{

#ifdef DEBUG
    NSLog(@"要开始摇一摇");
    
#endif
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"让我告诉你" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"就是取消");
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - realm创建数据库
- (void)creatDataBaseWithName:(NSString *)databaseName{

    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
                                                           YES);
    NSLog(@"docpath = %@",docPath);
    
    NSString *path = [docPath objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:databaseName];
    NSLog(@"数据库目录: = %@",filePath);
    
    
   // RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:filePath]];
    
 
//    //创建数据库 使用这个类
//    /*
//     *如果需要一种灵活的数据读写但又不想存储数据的方式的话 那么可以选择用内存数据库
//     *
//     */
//    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
//    config.fileURL = [NSURL URLWithString:filePath];
//   // config.objectClasses = @[self.class];
//    config.readOnly = NO;
//    int currentVersion = 1.0;
//    config.schemaVersion = currentVersion;
//    config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
//        
//        if (oldSchemaVersion < currentVersion) { //版本升级
//            
//        }
//        
//    };
//    RLUser * user = [[RLUser alloc]init];
//    user.userName = @"zhangchong";
//    user.age = 20;
//
//    [RLMRealmConfiguration setDefaultConfiguration:config];
//    RLMRealm * realm = [RLMRealm defaultRealm];
//    [realm addObject:user];
//    [realm beginWriteTransaction];
//    
//    
//    
//    [realm commitWriteTransaction];
    
    
    
    
    
    
    
    
}
 #pragma mark - 摇一摇结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
#ifdef DEBUG
    NSLog(@"结束摇一摇");
    [MBProgressHUD hideHUDForView:self.view animated:YES];

#endif
}
#pragma mark - 摇一摇取消
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
#ifdef DEBUG
    NSLog(@"取消摇一摇");
#endif
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
