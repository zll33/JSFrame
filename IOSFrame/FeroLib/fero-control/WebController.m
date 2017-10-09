//
//  WebController.m
//  p2p
//
//  Created by zhangxiuquan on 15/5/28.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "WebController.h"
#import "XHeader.h"
@interface WebController ()
{
    BOOL needShowHtml;
}
@end

@implementation WebController
@synthesize webView;
@synthesize activityIndicatorView;

-(void)getHtml:(NSString*)url{
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSString*html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidden:TRUE];
    if (response.statusCode==200) {
        NSString*urlmd5 = MD5(url);
        [SQLiteKeyValue saveKey:urlmd5 Value:html];
        if (needShowHtml) {
            [webView loadHTMLString:html baseURL:[NSURL URLWithString:getBaseUrl(url)]];
        }
    }else if(needShowHtml){
        [self showMsg:@"网络错误"];
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
         _useHTMLTitle=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    needShowHtml =false;
   
    LinearLayout*main = [LinearLayout newVertical];
    LinearLayout*menu = [LinearLayout newHorizontal];
    webView = [UIWebView new];
    webView.backgroundColor=COLOR(0xffffffff);
    webView.scalesPageToFit =YES;
    webView.delegate =self;
    
     self.allowFixInputView = false;
    
    [main addView: [[LinearLayoutCell newWithView:webView ] setUse:YES Weight:1]];
    
    //[main addView: [[LinearLayoutCell newWithView:menu ] setHeight:50]];
    [self setContentView:main];
    [self addActivity];
   
    [self.xtitleBar setTitle:[self getStringKey:@"title"]];
    NSString*url =[self getStringKey:@"url"];
    NSString*html =[self getStringKey:@"html"];
    NSString*file =[self getStringKey:@"file"];
    if ([url length]>0 ) {
        if ([self getBooleanKey:@"usecatch"]) {
            //usecatch
            NSString*urlmd5 = MD5(url);
            NSString* html = [SQLiteKeyValue getValueWithKey:urlmd5];
            if ([html length]>0) {
                [webView loadHTMLString:html baseURL:[NSURL URLWithString:getBaseUrl(url)]];
            }else{
                 needShowHtml = TRUE;
                [activityIndicatorView startAnimating] ;
                [activityIndicatorView setHidden:false];
            }
            [self performSelectorInBackground:@selector(getHtml:) withObject:url ];
            
        }else{
            [self loadWebPageWithString:url];
        }
        
    }else if ([html length]>0 ) {
        [self loadWebPageWithHtml:html];
    }else if ([file length]>0 ) {
        [self loadWebPageWithFile:file];
    }
    
}
-(void)addActivity
{
    activityIndicatorView = [UIActivityIndicatorView new];
    [activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview : activityIndicatorView] ;
    
    [activityIndicatorView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:activityIndicatorView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:32]];
    [activityIndicatorView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:activityIndicatorView
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:32]];
    [self.view addConstraint:[NSLayoutConstraint
                                   constraintWithItem:activityIndicatorView
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeCenterX
                                   multiplier:1
                                   constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                                   constraintWithItem:activityIndicatorView
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1
                                   constant:0]];
 
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
   
    
}
- (void)loadWebPageWithHtml:(NSString*)htmlString
{
    [webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}
- (void)loadWebPageWithFile:(NSString*)filePath
{
    filePath = [[NSBundle mainBundle]pathForResource:filePath ofType:nil];
    
    NSURL *url =[NSURL fileURLWithPath:filePath];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}
-(void)checkView:(UIWebView *)webView {
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([theTitle length]>0&&_useHTMLTitle) {
        [self.xtitleBar setTitle:theTitle];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSString *currentURL= myWebView.request.URL.absoluteString;
    [self checkView:webView];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
    [activityIndicatorView setHidden:false];
    //[self showWait];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    [self checkView:webView];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidden:TRUE];
    //[self hideWait];
    [self checkView:webView];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidden:TRUE];
    //[self hideWait];
}



@end
