//
//  JKSlideImageView.m
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-13.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "JKSlideImageView.h"

@interface JKSlideImageView ()
{
	CGPoint startDragPoint;
}
@property (weak, nonatomic) id <JKSlideImageViewDelegate> delegate;

@end

@implementation JKSlideImageView

-(void)setupWithDelegate:(id <JKSlideImageViewDelegate>)delegate{
	self.delegate= delegate;
	
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startViewDragged:)];
	panGestureRecognizer.delegate = self;
	panGestureRecognizer.maximumNumberOfTouches = 1;
	[self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Gesture Recognizer responses

- (void)startViewDragged:(UIPanGestureRecognizer *)recognizer
{
	UIImageView *dragView = (UIImageView *)recognizer.view;
	
	if( recognizer.state == UIGestureRecognizerStateBegan )
	{
		startDragPoint = dragView.center;
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
			self.center = CGPointMake(startDragPoint.x - self.frame.size.width, startDragPoint.y);
		
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
		view.center = startDragPoint;
	}];
}

@end
