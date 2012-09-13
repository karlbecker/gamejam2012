//
//  JKSlideImageView.h
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-13.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ANIMATION_DURATION 0.3

@class JKSlideImageView;

@protocol JKSlideImageViewDelegate <NSObject>
// The delegate should return true if the slide is successful (meaning the image disappears offscreen and slides in) or false if the slide is unsuccessful (meaning the image slides directly back to its home location.
- (BOOL)slidImageView:(JKSlideImageView*)imageView;
@end

@interface JKSlideImageView : UIImageView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <JKSlideImageViewDelegate> delegate;

// The home point is set automatically for InterfaceBuilder (in initWithCoder) but must be set manually in all other cases.
@property CGPoint homePoint;

@end
