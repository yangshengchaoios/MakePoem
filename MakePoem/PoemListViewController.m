//
//  PoemListViewController.m
//  MakePoem
//
//  Created by yang shengchao on 13-4-21.
//  Copyright (c) 2013年 txtws.com. All rights reserved.
//

#import "PoemListViewController.h"
#import <QuartzCore/QuartzCore.h>  
#import <ShareSDK/ShareSDK.h>

@interface PoemListViewController ()

@end

@implementation PoemListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [ppv release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    poemList = (NSArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"poems"]; 
    
    ppv = [[PagePhotosView alloc] initWithFrame: CGRectMake(0, 0, 320, 436) withDataSource: self];
	[self.view addSubview:ppv];
	// Do any additional setup after loading the view.
}

#pragma mark - pagephotodatasource
- (int)numberOfPages {
	return poemList.count;
} 
- (UIImage *)imageAtIndex:(int)index {
	NSString *imageName = [NSString stringWithFormat:@"bkg_%d.jpg", GetRandomNumber(index,19)];
	return [UIImage imageNamed:imageName];
}
- (NSString *)labelTextAtIndex:(int)index{
    NSMutableString *temp = [NSMutableString new];
    NSArray *poemLines = [poemList objectAtIndex:index];
    for (NSString *line in poemLines) {
        [temp appendFormat:@"%@\r\n",line];
    }
    return [NSString stringWithString:temp];
}
#pragma mark - 分享功能
- (IBAction)doSharing:(id)sender {
    UIImage *viewImage = [self getFullImageFrom:ppv];
    CGRect imageRect = CGRectMake(0, 0, 320, 400);
    viewImage = [self getSubImageFrom:viewImage WithRect:imageRect];
    id<ISSPublishContent> publishContent = [ShareSDK publishContent:[NSString stringWithFormat:@"这是机器作的诗，大家觉得怎样？"]
                                                     defaultContent:@""
                                                              image:viewImage
                                                       imageQuality:0.8
                                                          mediaType:SSPublishContentMediaTypeNews
                                                              title:@"ShareSDK"
                                                                url:@"http://www.sharesdk.cn"
                                                       musicFileUrl:nil
                                                            extInfo:nil
                                                           fileData:nil];
    [ShareSDK showShareActionSheet:self
                         shareList:ShareList
                           content:publishContent
                     statusBarTips:NO
                        convertUrl:YES      //委托转换链接标识，YES：对分享链接进行转换，NO：对分享链接不进行转换，为此值时不进行回流统计。
                       authOptions:nil
                  shareViewOptions:[ShareSDK defaultShareViewOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:nil//[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:NO]
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                    [alert show];
                                    [alert release];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                                                  message:[NSString stringWithFormat:@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"确定"
                                                                        otherButtonTitles: nil];
                                    [alert show];
                                    [alert release];
                                }
                            }];
}

//返回UIView全屏截图
- (UIImage *)getFullImageFrom:(UIView *) aView{
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL){
        UIGraphicsBeginImageContextWithOptions(aView.frame.size, NO, 0.0);
    }else {
        UIGraphicsBeginImageContext(aView.frame.size);
    }
    //获取全屏图像
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return fullImage;
}
//返回UIImage部分截图
- (UIImage *)getSubImageFrom:(UIImage*) img WithRect: (CGRect) rect {
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL){
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    }else {
        UIGraphicsBeginImageContext(rect.size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    // draw image
    [img drawInRect:drawRect];
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

@end
