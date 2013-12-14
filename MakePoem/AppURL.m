//
//  AppURL.m
//  MakePoem
//
//  Created by jian zhang on 12-5-23.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import "AppURL.h"
#import "NSString+Encoding.h"

#define WebSite @"http://labs.soso.com/app.q?app=makepoem"

@implementation AppURL

@synthesize type;
@synthesize words;
@synthesize w;
@synthesize style;
@synthesize of;


static NSArray * arrCreateType;
static NSArray * arrWordsType;
static NSArray * arrStyleType;
static NSArray * arrOfType;

-(AppURL*)init
{
    self=[super init];
    if (self) {
        arrCreateType=[NSArray arrayWithObjects:@"1",@"2", nil];
        arrWordsType=[NSArray arrayWithObjects:@"five",@"seven", nil];
        arrStyleType=[NSArray arrayWithObjects:@"lover",@"friend", nil];
        arrOfType=[NSArray arrayWithObjects:@"auto",@"assist", nil];
    }
    
    return self;
}

+(AppURL*)sharedAppURL
{
    return [[[AppURL alloc] init] autorelease];
}


-(NSURL*)getAppURL
{
    NSString* type_=[arrCreateType objectAtIndex:(int)type];
    NSString* words_=[arrWordsType objectAtIndex:(int)words];
    NSString* style_=[arrStyleType objectAtIndex:(int)style];
    NSString* of_=[arrOfType objectAtIndex:(int)of];

    NSString* w_= [NSString EncodeGB2312Str:w];
    NSString *sUrl=[NSString stringWithFormat:@"%@&type=%@&words=%@&w=%@&style=%@&of=%@",WebSite,type_,words_,w_,style_,of_];
    return [NSURL URLWithString:sUrl];
}

+(NSURL*)getAppURL:(AppURLCreateType)type Words:(AppURLWordsType)words Content:(NSString*)w Style:(AppURLStyleType)style Of:(AppURLOfType)of
{
    AppURL* appUrl=[AppURL sharedAppURL];
    appUrl.type=type;
    appUrl.words=words;
    appUrl.w=w;
    appUrl.style=style;
    appUrl.of=of;
    return [appUrl getAppURL];
}

-(void)dealloc
{
    [w release];
    
    [super dealloc];
}

@end
