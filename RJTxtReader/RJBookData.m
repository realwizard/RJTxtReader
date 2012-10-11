//
//  RJBookData.m
//  txtReader
//
//  Created by Zeng Qingrong on 12-8-22.
//  Copyright (c) 2012年 Zeng Qingrong. All rights reserved.
//

#import "RJBookData.h"

@implementation RJSingleBook

@synthesize name,icon,pages,pageSize,bookFile;

@end

@implementation RJBookData
@synthesize books;


static RJBookData *shareBookData = nil;

+(RJBookData *)sharedRJBookData{
    @synchronized(self){
        if(shareBookData == nil){
            shareBookData = [[RJBookData alloc] init];
        }
    }
    return shareBookData;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if(shareBookData == nil)
		{
            shareBookData = [super allocWithZone:zone];
            return shareBookData;
        }
    }
    return nil;
}


-(id)init
{
	if (self = [super init])
	{
        self.books = [[NSMutableArray alloc]initWithCapacity:1];
	}
	return self;
}

-(BOOL) loadXml:(NSString*) xmlFile
{
    NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:xmlFile];
    NSData *XMLData = [NSData dataWithContentsOfFile:XMLPath];
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:XMLData
                                                        options:0
                                                          error:nil
                              ];
    
    CXMLNode* bookData = [document nodeForXPath:@"//books" error:nil];
    for (CXMLElement *element in bookData.children)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            RJSingleBook* singleBook = [[RJSingleBook alloc]init];
            for (int i = 0; i < [element childCount]; i++)
            {
                CXMLNode* node = [[element children] objectAtIndex:i];
                if([[node name] isEqualToString:@"name"])
                {
                    singleBook.name = [node stringValue];
                    NSLog(@"%@",singleBook.name);
                }
                
                if([[node name] isEqualToString:@"icon"])
                {
                    singleBook.icon = [node stringValue];
                    NSLog(@"%@",singleBook.icon);
                }
                
                if([[node name] isEqualToString:@"pages"])
                {
                    CXMLNode* pages = node;
                    singleBook.pages = [[NSMutableArray alloc]initWithCapacity:1];
                    singleBook.pageSize  = [[NSMutableArray alloc]initWithCapacity:1];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSError *error;
                    for (CXMLNode *pageNode in pages.children)
                    {
                        if ([pageNode isKindOfClass:[CXMLNode class]] && [[pageNode name] isEqualToString:@"page"])
                        {
                            [singleBook.pages addObject:[pageNode stringValue] ];
                            NSLog(@"%@",[pageNode stringValue] );
                            NSString *path = [[NSBundle mainBundle]pathForResource:[pageNode stringValue] ofType:nil] ;
                            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
                            NSUInteger fileSize = 0;
                            if (fileAttributes) {
                                fileSize = [[fileAttributes objectForKey:NSFileSize] unsignedIntegerValue];
                            }
                            NSLog(@"%d",[NSString stringWithFormat:@"%d",fileSize]);
                            [singleBook.pageSize addObject: [NSString stringWithFormat:@"%d",fileSize]];
                        }
                    }
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
                    NSString *path = [documentsDirectory stringByAppendingPathComponent:singleBook.name];
                    singleBook.bookFile = [path stringByAppendingPathExtension:@".txt"];
                    [fileManager createFileAtPath:singleBook.bookFile contents:nil attributes:nil];
                    NSMutableData *writer = [[NSMutableData alloc]init];
                    for(NSInteger i=0;i<[singleBook.pages count];i++)
                    {
                        NSString* file = [singleBook.pages objectAtIndex:i];
                        NSString *path = [[NSBundle mainBundle]pathForResource:file  ofType:nil] ;
                        NSData *reader = [NSData dataWithContentsOfFile:path];
                        [writer appendData:reader];
                    }
                    [writer writeToFile:singleBook.bookFile atomically:YES];
                    [writer release];
                }
            }
            [books addObject:singleBook];
            [singleBook release];
        }
    }
    [document release];
}

@end
