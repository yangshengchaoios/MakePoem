//
//  AppURL.h
//  MakePoem
//
//  Created by jian zhang on 12-5-23.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// @"http://labs.soso.com/app.q?app=makepoem&type=1&words=five&w=%D0%C2%B4%BA%BF%EC%C0%D6&style=lover&of=auto"

typedef enum {
  AppURLCreateTypeFirstWord=0,//藏头
  AppURLCreateTypeProgressive=1//递进
}AppURLCreateType;

typedef enum {
    AppURLWordsTypeFive=0,//五言
    AppURLWordsTypeSeven=1//七言
}AppURLWordsType;

typedef enum {
    AppURLStyleTypeLover=0,//送爱人
    AppURLStyleTypeFriend=1//送朋友
}AppURLStyleType;

typedef enum {
    AppURLOfTypeAuto=0,//机器作诗
    AppURLOfTypeAssist=1//自己作诗
}AppURLOfType;


@interface AppURL : NSObject
{
    AppURLCreateType type; //1、2
    AppURLWordsType words;//five、 seven
    NSString* w;    //content
    AppURLStyleType style;//lover、friend
    AppURLOfType of;   //auto、assist
}
@property(nonatomic,assign)AppURLCreateType type;
@property(nonatomic,assign)AppURLWordsType words;
@property(nonatomic,copy)NSString* w;
@property(nonatomic,assign)AppURLStyleType style;
@property(nonatomic,assign)AppURLOfType of;

-(NSURL*)getAppURL;
+(NSURL*)getAppURL:(AppURLCreateType)type Words:(AppURLWordsType)words Content:(NSString*)w Style:(AppURLStyleType)style Of:(AppURLOfType)of;

-(AppURL*)init;
+(AppURL*)sharedAppURL;

@end
