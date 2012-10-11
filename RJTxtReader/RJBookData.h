//
//  RJBookData.h
//  txtReader
//
//  Created by Zeng Qingrong on 12-8-22.
//  Copyright (c) 2012年 Zeng Qingrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface RJSingleBook : NSObject
{
    
    NSString* name;
    NSString* icon;
    NSMutableArray* pages;
    NSMutableArray* pageSize;
    NSString* bookFile;
}
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* icon;
@property(nonatomic,retain) NSMutableArray* pages;
@property(nonatomic,retain) NSMutableArray* pageSize;
@property(nonatomic,retain) NSString* bookFile;

@end

@interface RJBookData : NSObject
{
    NSMutableArray* books;
}
@property(nonatomic,retain) NSMutableArray* books;

+(RJBookData *)sharedRJBookData;
-(BOOL) loadXml:(NSString*) xmlFile;
@end
