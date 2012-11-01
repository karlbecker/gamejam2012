//
//  KBImageSource.m
//  JKGameJam2k12
//
//  Created by Karl Becker on 11/1/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "KBImageSource.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"

@interface KBImageSource ()

@property (nonatomic, retain) NSMutableDictionary *imageNamesToFileNames;
@property (nonatomic, retain) AFHTTPClient *httpClient;

@end

@implementation KBImageSource

static KBImageSource *_sharedSingleton;

+ (KBImageSource *)sharedSingeton
{
	if(!_sharedSingleton)
    {
        _sharedSingleton = [[KBImageSource alloc] init];
		_sharedSingleton.imageNamesToFileNames = [NSMutableDictionary dictionaryWithCapacity:0];
		_sharedSingleton.delegate = nil;
		
    }
	
	return _sharedSingleton;
}

+ (NSString *)directoryForImageDownloads
{
	NSString *imageDirectory = NSTemporaryDirectory();
	imageDirectory = [imageDirectory stringByAppendingPathComponent:@"downloadedImages"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if( ![fileManager fileExistsAtPath:imageDirectory] )
	{
		[fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return imageDirectory;
}


- (BOOL)loadImageNames:(NSArray *)names fromURL:(NSURL *)url
{
	if( url == nil || names.count <= 0 )
		return NO;
	
	[self clearImages];
	if( ![url.absoluteString hasSuffix:@"/"] )
	{
		url = [NSURL URLWithString:[url.absoluteString stringByAppendingString:@"/"]];
	}
	
	self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
	NSString *imageName = [names objectAtIndex:0];
	
	[self loadImageNamed:imageName fromListOfImageNames:names fromURL:url];
	return YES;
}

- (BOOL)loadImageNamed:(NSString *)imageName fromListOfImageNames:(NSArray *)names fromURL:(NSURL *)url
{
	NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:imageName parameters:nil];
	AFImageRequestOperation *operation = [AFImageRequestOperation
										  imageRequestOperationWithRequest:request
										  imageProcessingBlock:^UIImage *(UIImage *image) {
											  //nothing
											  return image;
										  }
										  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
											  NSFileManager *fileManager = [NSFileManager defaultManager];
											  NSString *imagePath = [[KBImageSource directoryForImageDownloads] stringByAppendingPathComponent:imageName];
											  [fileManager createFileAtPath:imagePath contents:UIImagePNGRepresentation(image) attributes:nil];
											  [self.delegate progressLogged:[NSString stringWithFormat:@"[%@] from [%@] success - written to [%@]", imageName, request.URL.absoluteString, imagePath]];
											  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IMAGE_DOWNLOADED object:image];
											  
											  [self.imageNamesToFileNames setObject:imagePath forKey:imageName];
											  
											  int theIndex = [names indexOfObject:imageName];
											  if( (theIndex + 1) >= names.count )
											  {
												  [self.delegate progressLogged:@"done loading images"];
												  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IMAGE_DOWNLOADS_COMPLETE object:nil];
												  return;
											  }
											  else
											  {
												  NSString *nextImageName = [names objectAtIndex:(theIndex + 1)];
												  [self loadImageNamed:nextImageName fromListOfImageNames:names fromURL:url];
											  }
										  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
											  int theIndex = [names indexOfObject:imageName];
											  
											  [self.delegate progressLogged:[NSString stringWithFormat:@"[%@] not found or failed", request.URL.absoluteString]];
																			 
											  if( (theIndex + 1) >= names.count )
											  {
												  [self.delegate progressLogged:@"done loading images"];
												  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IMAGE_DOWNLOADS_COMPLETE object:nil];
												  return;
											  }
											  else
											  {
												  NSString *nextImageName = [names objectAtIndex:(theIndex + 1)];
												  [self loadImageNamed:nextImageName fromListOfImageNames:names fromURL:url];
											  }
										  }];
	[operation start];

	return YES;
}

- (BOOL)clearImages
{
	[self.imageNamesToFileNames removeAllObjects];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	return [fileManager removeItemAtPath:[KBImageSource directoryForImageDownloads] error:&error];
}

- (NSArray *)imagesAvailable
{
	return self.imageNamesToFileNames.allKeys;
}

- (UIImage *)imageNamed:(NSString *)name
{
	NSString *filePath = [self.imageNamesToFileNames objectForKey:name];
	return [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark - View Controller refresh methods
- (NSArray *)updateImageViewsInViewController:(UIViewController *)viewController
{
	//stub
	
	//loop through each view in viewController's view, see if it's an imageView, then see if the image is from something we've already handled (either via imageNamed: or from an image we sent it)
	return nil;
}

@end
