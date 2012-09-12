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

@end

@implementation JKMainGameViewController
@synthesize treeStartView;
@synthesize cowStartView;
@synthesize factoryStartView;
@synthesize plotViews;
@synthesize gameManager;

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
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTreeStartView:nil];
    [self setCowStartView:nil];
    [self setFactoryStartView:nil];
    [self setPlotViews:nil];
	
	self.gameManager = nil;
	
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

@end
