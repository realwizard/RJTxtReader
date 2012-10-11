//
//  RJBookListViewController.h
//  RJTxtReader
//
//  Created by joey on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJBookList.h"

@interface RJBookListViewController : UIViewController <UIScrollViewDelegate>
{
    RJBookList* listView;
    UIPageControl* pageControl;
}
- (IBAction)changePage:(id)sender;
- (IBAction)doComment:(id)sender;
- (IBAction)doList:(id)sender;
- (void) gotoPage:(int) pageNum;

@end
