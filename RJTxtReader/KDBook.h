

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "RJBookData.h"
@protocol KDBookDelegate

- (void)firstPage:(NSString *)pageString;
//遍历完文档后
- (void)bookDidRead:(NSUInteger)size;
@end


@interface KDBook : NSObject {
	CGSize     pageSize; //页面大小（与分页有关）
	UIFont    *textFont; //字体大小（与分页有关）
    NSInteger bookIndex;
    NSInteger bookPageIndex;
    NSString  *bookName; //需要把所有文件合并在一起
	NSMutableArray   *pageIndexArray; //保存每页的下标（文件的偏移量-分页）
	NSThread  *thread;
	
	unsigned long long bookSize;
	
	id<KDBookDelegate>  delegate;
}

@property (nonatomic, readwrite) NSInteger  bookIndex;
@property (nonatomic, retain) UIFont    *textFont;
@property (nonatomic, assign) CGSize     pageSize;
@property (nonatomic, assign) id<KDBookDelegate>  delegate;
@property (nonatomic, readonly) unsigned long long bookSize;
//返回指定页的字符串；
- (NSString *)stringWithPage:(NSUInteger)pageIndex;
- (unsigned long long)offsetWithPage:(NSUInteger)pageIndex;
- (id)initWithBook:(NSInteger) newBookIndex;
- (void) createBook;

@end
