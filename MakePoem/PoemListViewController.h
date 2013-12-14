//
//  PoemListViewController.h
//  MakePoem
//
//  Created by yang shengchao on 13-4-21.
//  Copyright (c) 2013年 txtws.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PagePhotosView.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface PoemListViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,PagePhotosDataSource>{
    NSArray *poemList;
    PagePhotosView *ppv;
}
- (IBAction)doSharing:(id)sender;
@end
