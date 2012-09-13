//
//  JKSlideImageView.m
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-13.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "JKSlideImageView.h"

@interface JKSlideImageView ()

@end

@implementation JKSlideImageView
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
		self.homePoint = self.center;
		
		UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startViewDragged:)];
		panGestureRecognizer.delegate = self;
		panGestureRecognizer.maximumNumberOfTouches = 1;
		[self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

#pragma mark - Gesture Recognizer responses

- (void)startViewDragged:(UIPanGestureRecognizer *)recognizer
{
	UIImageView *dragView = (UIImageView *)recognizer.view;
	
	if( recognizer.state == UIGestureRecognizerStateBegan )
	{
		[recognizer setTranslation:CGPointMake(0.0, 0.0) inView:dragView.superview ];
	}
	else if( recognizer.state == UIGestureRecognizerStateChanged )
	{
		CGPoint translation = [recognizer translationInView:dragView.superview];
		dragView.center = CGPointMake(dragView.center.x + translation.x, dragView.center.y + translation.y);
		[recognizer setTranslation:CGPointMake(0.0, 0.0) inView:dragView.superview];
	}
	else if( (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled ) )
	{
		if (self.delegate && [self.delegate slidImageView:self])			
			self.center = CGPointMake(self.homePoint.x - self.frame.size.width, self.homePoint.y);
		
		[self reseatDraggedView:dragView animated:YES];
	}
}

- (void)reseatDraggedView:(UIView *)view animated:(BOOL)isAnimated
{
	float duration = ANIMATION_DURATION;
	if( !isAnimated )
	{
		duration = 0.0;
	}
	[UIImageView animateWithDuration:duration animations:^(){
		view.center = self.homePoint;
	}];
}

@end
