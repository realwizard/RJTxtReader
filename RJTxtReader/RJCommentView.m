//
//  RJCommentView.m
//  RJTxtReader
//
//  Created by Zeng Qingrong on 12-8-23.
//
//

#import "RJCommentView.h"
#import "TouchXML.h"
#import "ASIHTTPRequest.h"
#import "Reachability.h"
#import <CFNetwork/CFNetwork.h>
#import "netinet/in.h"
#import"SDWebImageManager.h"

#define  XML_URL  @"http://www.floodad.com/book_comment.xml"
#define  XML_FILE @"book_comment.xml"

@implementation RJCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self checkNetworkStatus])
        {
            [self downloadxml ];
        }

        [self loadxml];
        [self loadTableView];
    }
    return self;
}

-(BOOL) checkNetworkStatus
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress,sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
	Reachability* reachability = [Reachability reachabilityWithAddress:&zeroAddress];
	
	if([reachability currentReachabilityStatus] == NotReachable)
		return NO;
	else
		return YES;
}

-(void) downloadxml
{
    NSString * path=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0];
    
    path=[path stringByAppendingPathComponent : XML_FILE ];
    
    NSURL *url = [NSURL URLWithString:XML_URL];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    
    [request setDownloadDestinationPath :path];
    
    [request startSynchronous];
}

-(void) loadxml
{
    NSString * path=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0];
    
    path=[path stringByAppendingPathComponent : XML_FILE ];
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if([file_manager fileExistsAtPath:path])
    {
        name = [[NSMutableArray alloc] initWithCapacity:1];
        icon = [[NSMutableArray alloc] initWithCapacity:1];
        url = [[NSMutableArray alloc]initWithCapacity:1];
        NSData *XMLData = [NSData dataWithContentsOfFile:path];
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:XMLData
                                                            options:0
                                                              error:nil
                                  ];
        
        NSArray* itemData = NULL;
        itemData = [document nodesForXPath:@"//item" error:nil];
        for (CXMLElement *element in itemData)
        {
            if ([element isKindOfClass:[CXMLElement class]])
            {
                CXMLNode* nameNode = [element nodeForXPath:@"//name" error:nil];
                [name addObject: [nameNode stringValue]];
                NSLog(@"%@",[nameNode stringValue]);
                
                CXMLNode* iconNode = [element nodeForXPath:@"//icon" error:nil];
                [icon addObject: [iconNode stringValue]];
                NSLog(@"%@",[iconNode stringValue]);
                
                CXMLNode* urlNode = [element nodeForXPath:@"//url" error:nil];
                [url addObject: [urlNode stringValue]];
                NSLog(@"%@",[urlNode stringValue]);
            }
        }
        [document release];
    }
}

-(void) loadTableView
{
    //加上背景
    CGRect rect = CGRectMake(0, 0, 320, 480-45);
    UIImageView* backView = [[UIImageView alloc]initWithFrame:rect];
    backView.image = [UIImage imageNamed:@"background.jpg"];
    //显示推荐列表
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-45)];
    [dataTable setDelegate:self];
    [dataTable setDataSource:self];
    [dataTable setBackgroundView:backView];
    [self addSubview:dataTable];
    [backView release];
    [dataTable release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [name count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: SimpleTableIdentifier] autorelease];
    }
    [cell.imageView setImageWithURL:[NSURL URLWithString:[icon objectAtIndex:indexPath.row]]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.text=[name objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

//选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url objectAtIndex:indexPath.row]]];
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
