//
//  JKMainGameViewController.m
//  JKGameJam2k12
//
//  Created by Karl Becker on 9/11/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "JKMainGameViewController.h"
#import "JKGameManager.h"

#define ANIMATION_DURATION 0.1

@interface JKMainGameViewController ()

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
		if (point.x < view.frame.origin.x)
			return -1;
		else if (point.x < view.frame.origin.x + view.frame.size.width)
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

#pragma mark - Gesture Recognizer responses

- (void)startViewDragged:(UIPanGestureRecognizer *)recognizer
{
	UIView *dragView = recognizer.view;
	
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
		
	}
}

@end
