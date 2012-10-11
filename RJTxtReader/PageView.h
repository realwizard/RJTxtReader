

#import <UIKit/UIKit.h>


@interface PageView : UIView {
	NSString *text;
	UILabel *pageL;
    BOOL isWhiteColor;
}
@property (nonatomic,retain) NSString *text;

-(void) changeColor;

@end
