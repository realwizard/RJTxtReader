//
//  RJBookIndexViewController.h
//  RJTxtReader
//
//  Created by joey on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJBookData.h"

@protocol BookReadDelegate

- (void)gotoPage:(NSUInteger) gotoPageNum;
- (void)gotoChapter:(NSUInteger) gotoChapterNum;
- (void)willBack;

@end

@interface RJBookIndexViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    id<BookReadDelegate> delegate;
    NSUInteger bookIndex;
	NSUInteger  chapterNum;
    UITableView* bookIndexTableView;
    UITableView* bookmarkTableView;
    BOOL isShowIndex;
}

@property (nonatomic, assign) id<BookReadDelegate>  delegate;
@property (nonatomic, readwrite)NSUInteger bookIndex;
@property (nonatomic, readwrite)NSUInteger chapterNum;

-(void)back:(id)sender;
-(void)indexOrbookmark:(id)sender;
-(void)delBookmark:(id)sender;

@end
