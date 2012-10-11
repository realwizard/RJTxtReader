//
//  RJBookList.h
//  RJTxtReader
//
//  Created by Zeng Qingrong on 12-8-23.
//
//

#import <UIKit/UIKit.h>
#import "RJCommentView.h"
#import "RJBookData.h"


@interface RJBookList : UIScrollView <UITableViewDelegate,UITableViewDataSource>

{
    UIScrollView* FirstView;
    RJCommentView* SecondView;
    RJBookData* bookData;
    UITableView* bookTableView;
    BOOL isTableViewShow;
    UINavigationController* nc;
}

@property(nonatomic,assign) UINavigationController* nc;
-(void) initView;
-(void) doReadBook:(id)sender;
-(void) readBook:(NSInteger)i;
-(void) doTableViewShowOrHide;

@end
