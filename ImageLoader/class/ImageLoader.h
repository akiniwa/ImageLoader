


#import <Foundation/Foundation.h>
#import "md5.h"

@protocol ImageLoaderDelegate

@optional

-(void)imageLoadedForIndex:(NSInteger)pIndex:(NSData *)pImageData;

@end

@interface ImageLoader : UIImageView<NSURLConnectionDelegate> {
	
	UIActivityIndicatorView *mActivityIndicator;
	NSString *mUrl;
	NSMutableData *mData;
	NSURLConnection *mConnection;
	BOOL mLoadable;
	NSInteger mIndex;
	NSArray *dirArray;
	NSString *path;
	NSString *imgPath;
	id <ImageLoaderDelegate>mDelegate;
	
	
}

@property(nonatomic,retain) id <ImageLoaderDelegate> mDelegate;
@property(readwrite) NSInteger mIndex;
@property(nonatomic,retain) NSURLConnection *mConnection;
@property(nonatomic,retain) NSMutableData *mData;
@property(nonatomic,retain) UIActivityIndicatorView *mActivityIndicator;
@property(nonatomic,retain) NSString *mUrl;
@property(readwrite) BOOL mLoadable;
@property(nonatomic, retain) NSString *imgPath;
-(id)initWithUrl:(NSString*)pUrl andFrame:(CGRect)pFrame;
-(void) setCaption:(NSString*)caption withFont:(UIFont *)font;

-(void)loadWithUrl:(NSString*)pUrl;
-(void)startConnection;
+(NSString *) getCachedPathForUrl:(NSString*)pUrl;
+(void) cleanupCache;
@end

