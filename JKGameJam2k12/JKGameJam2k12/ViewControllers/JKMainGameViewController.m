//
//  JKMainGameViewController.m
//  JKGameJam2k12
//
//  Created by Karl Becker on 9/11/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "JKMainGameViewController.h"
#import "JKGameManager.h"
#import "JKCow.h"
#import "JKTree.h"
#import "JKFactory.h"

#define ANIMATION_DURATION 0.3

@interface JKMainGameViewController ()
{
	CGPoint startDragPoint;
}
-(int)indexOfPlotViewAtPoint:(CGPoint)point;
-(void)moveView:(UIView*)view toTopOfPlot:(int)index;
-(BOOL)dropView:(UIView*)view withGrowthType:(JKGrowthType*)growthType atPoint:(CGPoint)point;

@end

@implementation JKMainGameViewController
@synthesize treeStartView;
@synthesize cowStartView;
@synthesize factoryStartView;
@synthesize plotViews;
@synthesize gameManager;
@synthesize pollutionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyGameStateUpdate:) name:NOTIFY_GAME_STATE_UPDATE object:nil];
	self.gameManager = [[JKGameManager alloc] init];
	
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startViewDragged:)];
	panGestureRecognizer.delegate = self;
	panGestureRecognizer.maximumNumberOfTouches = 1;
	[treeStartView addGestureRecognizer:panGestureRecognizer];
	
	panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startViewDragged:)];
	panGestureRecognizer.delegate = self;
	panGestureRecognizer.maximumNumberOfTouches = 1;
	[cowStartView addGestureRecognizer:panGestureRecognizer];
	
	panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startViewDragged:)];
	panGestureRecognizer.delegate = self;
	panGestureRecognizer.maximumNumberOfTouches = 1;
	[factoryStartView addGestureRecognizer:panGestureRecognizer];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTreeStartView:nil];
    [self setCowStartView:nil];
    [self setFactoryStartView:nil];
    [self setPlotViews:nil];
	
	self.gameManager = nil;
	
	[self setPollutionView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


-(void)notifyGameStateUpdate:(NSNotification*)note {
	// TODO NOTIFY_GAME_STATE_UPDATE
}

-(int)indexOfPlotViewAtPoint:(CGPoint)point {
	for (int i = 0; i < self.plotViews.count; i++) {
		UIView* view = [self.plotViews objectAtIndex:i];
		if (point.x >= view.frame.origin.x && point.x < view.frame.origin.x + view.frame.size.width)
			return i;
		else
			continue;
	}
	return -1;
}

-(void)moveView:(UIView*)view toTopOfPlot:(int)index {
	UIView* plotView = [self.plotViews objectAtIndex:index];
	
	[UIView animateWithDuration:ANIMATION_DURATION animations:^{
		CGRect frame = plotView.frame;
		float heightOfGrowthImage = view.frame.size.height;
		frame.origin.y -= [self.gameManager heightAtPlotIndex:index] * heightOfGrowthImage;
		frame.size.height = view.frame.size.height ;
		view.frame = frame;
	} completion:nil];
}

-(BOOL)dropView:(UIView*)view withGrowthType:(JKGrowthType*)growthType atPoint:(CGPoint)point {
	int index = [self indexOfPlotViewAtPoint:point];
	if (index != -1) {
		if ([self.gameManager addGrowthType:growthType toPlotIndex:index]) {
			[self moveView:view toTopOfPlot:index];
			return YES;
		}
	}
	
	return NO;
}


- (JKGrowthType *)growthTypeOf:(UIView *)view
{
	if( view == treeStartView )
		return [JKTree new];
	else if( view == cowStartView )
		return [JKCow new];
	else
		return [JKFactory new];
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
		if( [self indexOfPlotViewAtPoint:dragView.center] >= 0 )
		{
			UIImageView *newSprite = [[UIImageView alloc] initWithImage:dragView.image];
			newSprite.frame = dragView.frame;
			[self.view addSubview:newSprite];
			
			if( [self dropView:newSprite withGrowthType:[self growthTypeOf:dragView] atPoint:dragView.center] )
			{
				dragView.center = CGPointMake(startDragPoint.x - dragView.frame.size.width, startDragPoint.y);
				[UIImageView animateWithDuration:ANIMATION_DURATION animations:^(){
					dragView.center = startDragPoint;
				}];
				return;
			}
			else
			{
				[newSprite removeFromSuperview];
			}
		}
		[UIImageView animateWithDuration:ANIMATION_DURATION animations:^(){
			dragView.center = startDragPoint;
		}];
	}
}

@end
