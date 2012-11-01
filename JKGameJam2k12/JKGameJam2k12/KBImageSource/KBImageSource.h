//
//  KBImageSource.h
//  JKGameJam2k12
//
//  Created by Karl Becker on 11/1/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KBImageSourceDelegate
- (void)progressLogged:(NSString *)progressString;
@end

@interface KBImageSource : NSObject

#define NOTIFY_IMAGE_DOWNLOADED	@"notifyImageDownloaded"
#define NOTIFY_IMAGE_DOWNLOADS_COMPLETE	@"notifyImageDownloadsComplete"

- (BOOL)loadImageNames:(NSArray *)names fromURL:(NSURL *)url;
- (UIImage *)imageNamed:(NSString *)name;
- (BOOL)clearImages;
- (NSArray *)imagesAvailable;
+ (KBImageSource *)sharedSingeton;
- (NSArray *)updateImageViewsInViewController:(UIViewController *)viewController;

@property (weak, nonatomic) id<KBImageSourceDelegate> delegate;
@end
