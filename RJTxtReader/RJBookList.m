//
//  RJBookList.m
//  RJTxtReader
//
//  Created by Zeng Qingrong on 12-8-23.
//
//

#import "RJBookList.h"
#import "KDBooKViewController.h"

@implementation RJBookList
@synthesize nc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isTableViewShow = NO;
        [self initView];
    }
    return self;
}

-(void) initView
{
    bookData = [RJBookData sharedRJBookData];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"shelf_top.png"]];
    CGRect rect = CGRectMake(0, 0, 320, 45);
    imageView.frame =rect;
    [self addSubview:imageView];
    [imageView release];

    rect = CGRectMake(0, 45, 320, 480-45);
    FirstView = [[UIScrollView alloc]initWithFrame:rect];
    
    UIImage* rowImage = [UIImage imageNamed:@"shelf_row.png"];
    rect = CGRectMake(0, 0, 320, 145);
    UIImageView * row1 = [[UIImageView alloc] initWithFrame:rect];
    row1.image = rowImage;
    [FirstView addSubview:row1];
    [row1 release];
    
    rect = CGRectMake(0, 138, 320, 145);
    UIImageView * row2 = [[UIImageView alloc] initWithFrame:rect];
    row2.image = rowImage;
    [FirstView addSubview:row2];
    [row2 release];
    
    rect = CGRectMake(0, 138*2, 320, 145);
    UIImageView * row3 = [[UIImageView alloc] initWithFrame:rect];
    row3.image = rowImage;
    [FirstView addSubview:row3];
    [row3 release];
    
    if([bookData.books count]>9)
    {
        FirstView.contentSize = CGSizeMake(320, 480-45+145);
        rect = CGRectMake(0, 138*3, 320, 145);
        UIImageView * row4 = [[UIImageView alloc] initWithFrame:rect];
        row4.image = rowImage;
        [FirstView addSubview:row4];
        [row4 release];
    }
    
    [self addSubview:FirstView];
    
    [FirstView release];
    
    for(int i=0;i<[bookData.books count];i++)
    {
        rect = CGRectMake(20+(i%3*100), 35+(i/3)*138, 65, 85);
        RJSingleBook* singleBook = [bookData.books objectAtIndex:i];
        UIButton* button= [[UIButton alloc]initWithFrame:rect];
        button.tag = i;
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:singleBook.icon ofType:nil]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doReadBook:) forControlEvents:UIControlEventTouchUpInside];

        [FirstView addSubview:button];
        [FirstView bringSubviewToFront:button];
        [button release];
    }
    
    imageView = [[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"background.jpg"]];
    rect = CGRectMake(320, 0, 320, 45);
    imageView.frame =rect;
    [self addSubview:imageView];
    [imageView release];
    
    rect = CGRectMake(320, 45, 320, 480-45);
    SecondView = [[RJCommentView alloc]initWithFrame:rect];
    [self addSubview:SecondView];

}

-(void) doReadBook:(id)sender
{
    UIButton* but = (UIButton*)sender;
    NSInteger i = but.tag;
	[self readBook:i];
}

-(void) readBook:(NSInteger)i
{
    KDBooKViewController *bookVC = [[KDBooKViewController alloc]init];
	bookVC.bookIndex = i;
	[self.nc pushViewController:bookVC animated:YES];
	[bookVC release];
}

-(void) doTableViewShowOrHide
{
    if(isTableViewShow == NO)
    {
        isTableViewShow = YES;
        if(bookTableView == nil)
        {
            bookTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, 480-45)];
            [bookTableView setDelegate:self];
            [bookTableView setDataSource:self];
            bookTableView.hidden = YES;
            [self addSubview:bookTableView];
            [bookTableView release];
        }
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        
        bookTableView.hidden = NO;
        FirstView.hidden = YES;
        [UIView commitAnimations];
        

    }
    else{
        isTableViewShow = NO;

        
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        
        bookTableView.hidden = YES;
        FirstView.hidden = NO;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [bookData.books count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: SimpleTableIdentifier] autorelease];
    }
    RJSingleBook* singleBook = [bookData.books objectAtIndex:indexPath.row];
    
    [cell.imageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:singleBook.icon ofType:nil]]];
    cell.text=singleBook.name;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

//选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self readBook:indexPath.row];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
