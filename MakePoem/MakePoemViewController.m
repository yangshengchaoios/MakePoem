//
//  MakePoemViewController.m
//  MakePoem
//
//  Created by jian zhang on 12-5-23.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import "MakePoemViewController.h"
#import "TFHpple.h"
#import "XPathQuery.h"
#import "AppURL.h"
#import "PoemListViewController.h"

@implementation MakePoemViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad]; 
}
- (void)dealloc {
    [pickerCondition release];
    [super dealloc];
}
- (void)viewDidUnload {
    pickerCondition = nil;
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputText resignFirstResponder];
}

#pragma mark - makePoem 
-(IBAction)makePoemButtonClicked:(UIButton*)sender {    
    [_inputText resignFirstResponder];
    //方式一
    [MBProgressHUD showHUDAddedTo:self.view animated:NO title:@"思考中..."];//只能放在主线程
    [NSThread detachNewThreadSelector:@selector(makingPoem) toTarget:self withObject:nil];
    
    //方式二
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"思考中...";
//    [HUD showWhileExecuting:@selector(makingPoem) onTarget:self withObject:nil animated:NO];
}
-(void)makingPoem {
    NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
    NSURL *url=[AppURL getAppURL:[pickerCondition selectedRowInComponent:0] Words:[pickerCondition selectedRowInComponent:1] Content:_inputText.text Style:[pickerCondition selectedRowInComponent:2] Of:AppURLOfTypeAuto];
    NSData*siteData = [[[NSData alloc] initWithContentsOfURL:url] autorelease];
    NSMutableArray *poemList = [[NSMutableArray new] autorelease];
    if (siteData) {
        TFHpple *xpathParser = [[[TFHpple alloc] initWithHTMLData:siteData] autorelease];
        NSString *xpathstr0 = @"//div[@class='conter']/span[@class='other']";
        NSArray *nodelist = [xpathParser searchWithXPathQuery:xpathstr0]; 
        for (TFHppleElement *elem in nodelist) {
            NSMutableString *poemStr = [[NSMutableString new] autorelease];
            for (TFHppleElement *elemc in elem.children) {
                for (TFHppleElement *elemcc in elemc.children) {
                    if (elemcc.content) {
                        [poemStr appendString:elemcc.content];
                    }
                }
                if (elemc.content) {
                    [poemStr appendString:elemc.content];
                }            
            }
            int words = [pickerCondition selectedRowInComponent:1]==0?5:7;
            int lines = poemStr.length/words;
            NSMutableArray *poemLineList = [[NSMutableArray new] autorelease];
            for (int i=0; i<lines; i++) {
                [poemLineList addObject:[poemStr substringWithRange:NSMakeRange(i*words, words)]];
            } 
            [poemList addObject:poemLineList];
        }
        [[NSUserDefaults standardUserDefaults] setValue:poemList forKey:@"poems"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [MBProgressHUD hideHUDForView:self.view animated:NO];//采用方式一,必须执行该行代码
    if (poemList.count>0) {
        //pushNextViewController
        UIStoryboard * board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        PoemListViewController *list=[board instantiateViewControllerWithIdentifier:@"PoemList_Identifier"];
        [self.navigationController pushViewController:list animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到相关诗句！" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    [pool release];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component==0) {
        if (row==0) {
            return @"藏头";
        }else{
            return @"递进";
        }
    }else if(component==1){
        if (row==0) {
            return @"五言";
        }else{
            return @"七言";
        }
    }else{
        if (row==0) {
            return @"送爱人";
        }else{
            return @"送朋友";
        }
    }
}
@end
