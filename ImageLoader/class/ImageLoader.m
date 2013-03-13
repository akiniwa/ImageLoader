
#import "ImageLoader.h"
@implementation ImageLoader
@synthesize mUrl,mActivityIndicator,mData,mConnection,mIndex,mDelegate,mLoadable,imgPath;

-(id)init
{
    self=[super init];
	if(self)
	{
		//self.backgroundColor=[UIColor whiteColor];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame          // default initializer
{
    self=[super initWithFrame:frame];
	if (self) {
		
		//self.backgroundColor=[UIColor whiteColor];
		
		if (mActivityIndicator&&mLoadable) 
		{
			
			mActivityIndicator.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		}
	}
	return self;
}

-(id)initWithUrl:(NSString*)pUrl andFrame:(CGRect)pFrame
{
    self=[super initWithFrame:pFrame];
	if (self) {
		mUrl=[[NSString alloc] initWithString:pUrl];
		[self loadWithUrl:mUrl];
		
	}
	return self;
}

-(void)setFrame:(CGRect)pFrame
{
	[super setFrame:pFrame];
	
	if (mActivityIndicator&&mLoadable) 
	{				
		mActivityIndicator.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);		
	}
}

-(void) setCaption:(NSString*)caption withFont:(UIFont *)font
{
    //make a UIlabel and show it
    //caption height
    CGSize size = [caption sizeWithFont:font constrainedToSize:
                   CGSizeMake(self.frame.size.width, self.frame.size.height/2)];
    UILabel *captionLabel = (UILabel*)[self viewWithTag:1212];
    if (! captionLabel) {
        captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-size.height, 
                                                  self.frame.size.width, size.height)];
        [self addSubview:captionLabel];
        [captionLabel release];
    }
    captionLabel.frame = CGRectMake(0, self.frame.size.height-size.height, 
                                    self.frame.size.width, size.height);
    captionLabel.numberOfLines = 2;
    captionLabel.tag = 1212;
    captionLabel.backgroundColor = [UIColor blackColor];
    captionLabel.font = font;
    captionLabel.textAlignment = UITextAlignmentCenter;
    captionLabel.textColor = [UIColor whiteColor];
    captionLabel.text = caption;
    
}

-(void)loadWithUrl:(NSString*)pUrl 
{
    if ([pUrl isKindOfClass:[NSNull class]]) {
        
        self.image=[UIImage imageNamed:@"imageloader-default.jpeg"];
        
        return;
    }
	self.mUrl=pUrl;
	NSString* dir = [NSSearchPathForDirectoriesInDomains(
                                    NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	
	path = [NSString stringWithFormat:@"%@/Caches/imagecache", dir];
	NSFileManager *mgr = [NSFileManager defaultManager];
		
	if (! [mgr fileExistsAtPath:path]) {
		
		[mgr createDirectoryAtPath:path
				withIntermediateDirectories:NO
				attributes:nil
				error:nil];
    }
	
	self.imgPath = [path stringByAppendingPathComponent:[pUrl MD5Hash]];

		if ([mgr fileExistsAtPath:self.imgPath]) {
            self.alpha = 0;
            [UIView setAnimationsEnabled:YES];
            UIImage *cachedImg = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:self.imgPath]];
            
            self.alpha = 0;
            [UIView beginAnimations:@"FadeIn" context:nil];
            [UIView setAnimationDuration:1];
            self.alpha = 1;
            [UIView commitAnimations];
            
            self.image = cachedImg;
            [cachedImg release];
        }else {
        
		[self startConnection];
	}
}


+(NSString *) getCachedPathForUrl:(NSString*)pUrl 
{
	NSString* dir = [NSSearchPathForDirectoriesInDomains(
                                    NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	
	NSString *dirpath = [NSString stringWithFormat:@"%@/Caches/imagecache", dir];
	NSString *cachePath = [dirpath stringByAppendingPathComponent:[pUrl MD5Hash]];
	
	NSFileManager *mgr = [NSFileManager defaultManager];
	
		
	if ([mgr fileExistsAtPath:cachePath]) {
		return cachePath;
	}else {
		return nil;
	}
	
}


+(void) cleanupCache
{
    NSString* dir = [NSSearchPathForDirectoriesInDomains(
                                    NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];

	
	NSString *dirpath = [NSString stringWithFormat:@"%@/Caches/imagecache", dir];
    
    //scan this dir and remove old files
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSArray *cachedfiles = [mgr contentsOfDirectoryAtPath:dirpath error:nil];
    
    NSDictionary *attrs;
    NSDate *modDate;
    NSString *filePath;
    for (NSString *file in cachedfiles) {
        filePath = [dirpath stringByAppendingPathComponent:file];
        attrs = [mgr attributesOfItemAtPath:filePath error:nil];
        modDate = [attrs fileCreationDate];
        //remove files 3 or more days older 
        if ([modDate timeIntervalSinceNow] < -3600*72) {
            [mgr removeItemAtPath:filePath error:nil];
        }
    }
}


-(void)startConnection
{	
	mLoadable = YES;
	self.image = nil;
	if ((!self.mActivityIndicator)) 
	{
		
		UIActivityIndicatorView *temp=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		self.mActivityIndicator=temp;
		[temp release];
		mActivityIndicator.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		mActivityIndicator.hidden=YES;
		mActivityIndicator.hidesWhenStopped=TRUE;
		//self.backgroundColor=[UIColor whiteColor];
		[self addSubview:mActivityIndicator];
	}
	
	NSMutableData *tempData=[[NSMutableData alloc] init];
	
	self.mData=tempData;
	
	[tempData release];	
	if(mLoadable)
	{
		[mActivityIndicator startAnimating];
	}
	
	[mConnection cancel];
	
	NSMutableURLRequest *tempUrlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:mUrl]];
	
	NSURLConnection *temp=[[NSURLConnection alloc] initWithRequest:tempUrlRequest delegate:self];
	self.mConnection=temp;
	[temp release];
	
	
}

#pragma mark -
#pragma mark Connection Delegate Functions

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //check for error status codes
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if (statusCode >= 400)
        {
            [connection cancel];  // stop connecting; no more delegate messages
            NSDictionary *errorInfo
            = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                  NSLocalizedString(@"Server returned status code %d",@""),
                                                  statusCode]
                                          forKey:NSLocalizedDescriptionKey];
            NSError *statusError
            = [NSError errorWithDomain:@"Error"
                                  code:statusCode
                              userInfo:errorInfo];
            [self connection:connection didFailWithError:statusError];
        }
    }

    
}	

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)tempData 
{ 
	[mData appendData:tempData];
} 


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if(mLoadable)
	{
		[mActivityIndicator stopAnimating];
    }
    NSLog(@"loading default image %@", mUrl);
    //load a default image if exists
    self.image = [UIImage imageNamed:@"imageloader-default.jpeg"];
    //self.alpha = 1.0;
}

/*
 * This method invokes by the class when network finished with the loading of the request.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{ 	
	if(mLoadable)
	{
		[mActivityIndicator stopAnimating];
	}
	
	NSFileManager *mgr = [NSFileManager defaultManager];
	if (! [mgr fileExistsAtPath:self.imgPath]) {
		[mgr createFileAtPath: self.imgPath contents:mData attributes:nil];
	}
	
	UIImage *tempImage=[[UIImage alloc] initWithData:mData];
	
	if (tempImage.size.width > 2) {
		self.alpha = 0;
		[UIView beginAnimations:@"FadeIn" context:nil];
		[UIView setAnimationDuration:1];
		self.alpha = 1;
		[UIView commitAnimations];
		
		self.image=tempImage;
	}
	
	[tempImage release];
	
	[self.mDelegate imageLoadedForIndex:mIndex :mData];
	
	self.mData=nil;
}


-(void)dealloc
{
	[self.mConnection cancel];
	self.mDelegate=nil;
	self.mConnection=nil;
	self.mData=nil;
	self.mActivityIndicator=nil;
	self.mUrl=nil;
	self.image=nil;
	[super dealloc];
}
@end
