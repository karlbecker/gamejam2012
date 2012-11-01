//
//  KBImageSourcePickerViewController.h
//  JKGameJam2k12
//
//  Created by Karl Becker on 11/1/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBImageSource.h"

@interface KBImageSourcePickerViewController : UIViewController <KBImageSourceDelegate>

@property (nonatomic, retain) NSString *baseURLString;
@property (nonatomic, retain) NSArray *fileNames;

@end
