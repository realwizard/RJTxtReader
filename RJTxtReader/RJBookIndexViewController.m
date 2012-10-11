//
//  RJBookIndexViewController.m
//  RJTxtReader
//
//  Created by joey on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RJBookIndexViewController.h"

@interface RJBookIndexViewController ()

@end

@implementation RJBookIndexViewController

@synthesize delegate,bookIndex,chapterNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back:(id)sender{
    [self.delegate willBack];
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [self.navigationController setToolbarHidden:YES animated:TRUE];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)indexOrbookmark:(id)sender
{
    [UIView beginAnimations:@"animation_indexOrbookmark" context:nil];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];

    if(isShowIndex)
    {
        isShowIndex = NO;
        [self.navigationItem.rightBarButtonItem setTitle:@"目录"];
        bookIndexTableView.hidden = YES;
        bookmarkTableView.hidden = NO;
        
    }
    else {
        isShowIndex = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"书签"];
        bookIndexTableView.hidden = NO;
        bookmarkTableView.hidden = YES;
    }
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barStyle = UIBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    [self.navigationController setToolbarHidden:YES animated:TRUE];
    isShowIndex = YES;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] init];
    leftBarButtonItem.title = @"返回";
    leftBarButtonItem.target = self;
    leftBarButtonItem.action = @selector(back:);
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [leftBarButtonItem release];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] init];
    rightItem.title = @"书签";
    rightItem.target = self;
    rightItem.action = @selector(indexOrbookmark:);
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];

    
	// Do any additional setup after loading the view.
    bookIndexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-45)];
    [bookIndexTableView setDelegate:self];
    [bookIndexTableView setDataSource:self];
    bookIndexTableView.hidden = NO;
    [self.view addSubview:bookIndexTableView];
    [bookIndexTableView release];
    
    bookmarkTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-45)];
    [bookmarkTableView setDelegate:self];
    [bookmarkTableView setDataSource:self];
    bookmarkTableView.hidden = YES;

    [self.view addSubview:bookmarkTableView];
    [bookmarkTableView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if(tableView == bookIndexTableView)
    {
        return [singleBook.pages count];
    }
    //读取书签
    NSMutableArray *ChatperArray = nil;

    if([[NSFileManager defaultManager] fileExistsAtPath:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]])
    {
        ChatperArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]];

        return [ChatperArray count];
    }
    else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        if(tableView == bookIndexTableView)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: SimpleTableIdentifier] autorelease];
        }
        else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier: SimpleTableIdentifier] autorelease];
        }
    }
    if(tableView == bookIndexTableView)
    {
        RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
        NSString *text = [[singleBook.pages objectAtIndex:indexPath.row] substringFromIndex:9];
        cell.text = [text substringWithRange:NSMakeRange(0, text.length-4)];
        if(chapterNum == indexPath.row )
        {
            [bookIndexTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewRowAnimationNone];
        }
    }
    else {
        RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSMutableArray *ChatperArray = nil;
        NSMutableArray *PageNumArray = nil;
        NSMutableArray *BookTimeArray = nil;
        if([[NSFileManager defaultManager] fileExistsAtPath:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]])
        {
            ChatperArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]];
            PageNumArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]];
            BookTimeArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_booktime.plist"]]];
        }
        NSString *text = [[ChatperArray objectAtIndex:indexPath.row] substringFromIndex:9];
        cell.text = [text substringWithRange:NSMakeRange(0, text.length-4)];
        
        NSString *booktime = @"书签时间：";
        NSString *detailText = [NSString stringWithFormat:@"第%@页  ",[PageNumArray objectAtIndex:indexPath.row]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.text = [detailText stringByAppendingString:[booktime stringByAppendingString:[BookTimeArray objectAtIndex:indexPath.row]]];
        
        CGRect frame_1= CGRectMake(290, 5, 30, 30);
        UIButton* delButton= [[UIButton alloc] initWithFrame:frame_1];
        [delButton setImage:[UIImage imageNamed:@"edit_delete.png"] forState:UIControlStateNormal];
        delButton.tag = indexPath.row;
        [delButton addTarget:self action:@selector(delBookmark:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:delButton];
        [delButton release];
        
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)delBookmark:(id)sender
{
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSMutableArray *ChatperArray = nil;
    NSMutableArray *PageNumArray = nil;
    NSMutableArray *BookTimeArray = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]])
    {
        ChatperArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]];
        PageNumArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]];
        BookTimeArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_booktime.plist"]]];
    }
    else {
        return;
    }
    UIButton* delButton = (UIButton*)sender;
    [ChatperArray removeObjectAtIndex:delButton.tag];
    [PageNumArray removeObjectAtIndex:delButton.tag];
    [BookTimeArray removeObjectAtIndex:delButton.tag];
    //保存书签
    [ChatperArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]  atomically:YES];
    [PageNumArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]  atomically:YES];
    [BookTimeArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_booktime.plist"]]  atomically:YES];
    //刷新tableview
    [bookmarkTableView reloadData];
}

//选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == bookIndexTableView)
    {
        [self.delegate gotoChapter:indexPath.row];
    }
    else {
        RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSMutableArray *ChatperArray = nil;
        NSMutableArray *PageNumArray = nil;
        NSMutableArray *BookTimeArray = nil;
        if([[NSFileManager defaultManager] fileExistsAtPath:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]])
        {
            ChatperArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]];
            PageNumArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]];
            BookTimeArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_booktime.plist"]]];
        }
        [delegate gotoPage:[[PageNumArray objectAtIndex:indexPath.row] integerValue]];
    }
    [self back:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
