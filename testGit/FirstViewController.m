//
//  FirstViewController.m
//  testGit
//
//  Created by 张冲 on 2017/8/21.
//  Copyright © 2017年 张冲. All rights reserved.
//

#import "FirstViewController.h"
#import <WebKit/WebKit.h>

@interface FirstViewController ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webview;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self addWebview];
    
    // Do any additional setup after loading the view.
}

- (void)addWebview{
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    WKPreferences *preference = [[WKPreferences alloc]init];
    preference.minimumFontSize = 12;
    preference.javaScriptEnabled = YES;
    configuration.preferences = preference;
    
    
    //通过js与webview内容交互配置
    WKUserContentController *contentController = [[WKUserContentController alloc]init];
    configuration.userContentController = contentController;
    
    //加载时注入js
    /* 参数一：需要注入的js语句 参数二：注入时间。参数三：只添加到mianframe 中为yes*/
    WKUserScript * script = [[WKUserScript alloc]initWithSource:@"function showAlert() {'在载入webview时通过object-c 注入的js方法'}" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    self.webview = [[WKWebView alloc]initWithFrame:self.view.frame configuration:configuration];
    self.webview.navigationDelegate = self;
    self.webview.UIDelegate = self;
    
   // NSURL *url = [[NSBundle mainBundle]URLForResource:@"index" withExtension:@"html"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.view addSubview:self.webview];
    self.webview.backgroundColor = [UIColor yellowColor];
      //对于WKWebView，有三个属性支持KVO，因此我们可以监听其值的变化，分别是：loading,title,estimatedProgress，对应功能表示为：是否正在加载中，页面的标题，页面内容加载的进度（值为0.0~1.0）
//    [self.webview addObserver:self forKeyPath:@"load" options:NSKeyValueObservingOptionNew context:nil];
//    [self.webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
   //r [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
                                               
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(50,100 , 100, 20)];
    [button1 setTitle:@"后退" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside ];
    [self.webview addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake( 300 ,100 , 100, 20)];
    [button2 setTitle:@"前进" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside ];
    [self.webview addSubview:button2];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    }else if ( [keyPath isEqualToString:@"title"]){
        
        self.title = self.webview.title;
    }
    
    
    if (!self.webview.loading) {
        NSString *js = @"callJsAlert()";
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable js, NSError * _Nullable error) {
            NSLog(@"call js  alert");
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
    }
    
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"tips" message:message preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        //必须回调completionHandler!!!!!!!!
        completionHandler();
    }];
    
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *controller = [UIAlertController  alertControllerWithTitle:@"tips"message:@"有个东西出不来啊"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"NO"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }];
    
    
    [controller addAction:action1];
    [controller addAction:action2];
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - WKScriptMessageHandler
//通过这个代理方法,就可以得到html文件中js的部分回调给Objective-C的数据

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@", message.body);
}
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"%s",__FUNCTION__);
    
    NSString *string = navigationAction.request.URL.host.lowercaseString;
    NSLog(@"%@", string);
    
    if (navigationAction.navigationType ==WKNavigationTypeLinkActivated &&  [string containsString:@".baidu.com"]) {
        
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
