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
#import "KBImageSource.h"
#import "KBImageSourcePickerViewController.h"


@interface JKMainGameViewController ()
{
	id imageNotification;
}

-(int)indexOfPlotViewAtPoint:(CGPoint)point;
-(void)moveView:(UIView*)view toTopOfPlot:(int)index;
-(BOOL)dropView:(UIView*)view withGrowthType:(JKGrowthType*)growthType atPoint:(CGPoint)point;

@end

@implementation JKMainGameViewController
@synthesize treeStartView;
@synthesize cowStartView;
@synthesize factoryStartView;
@synthesize moneyLabel;
@synthesize groundView;
@synthesize plotViews;
@synthesize factoryCostLabel;
@synthesize cowCostLabel;
@synthesize treeCostLabel;
@synthesize factoryProfitLabel;
@synthesize cowProfitLabel;
@synthesize treeProfitLabel;
@synthesize gameManager;
@synthesize pollutionView;
@synthesize restartButton;
@synthesize finalScoreLabel;
@synthesize viewsToClearOnNewGame;

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
	
	self.factoryStartView.delegate = self;
	self.cowStartView.delegate = self;
	self.treeStartView.delegate = self;
	
	JKGrowthType* growthType;
	growthType = [JKFactory new];
	self.factoryCostLabel.text = [NSString stringWithFormat:@"$%d", growthType.cost];
	self.factoryProfitLabel.text = [NSString stringWithFormat:@"$%.0f", growthType.profit];
	growthType = [JKCow new];
	self.cowCostLabel.text = [NSString stringWithFormat:@"$%d", growthType.cost];
	self.cowProfitLabel.text = [NSString stringWithFormat:@"$%.0f", growthType.profit];
	growthType = [JKTree new];
	self.treeCostLabel.text = [NSString stringWithFormat:@"$%d", growthType.cost];
	self.treeProfitLabel.text = [NSString stringWithFormat:@"$%.0f", growthType.profit];
	
	self.viewsToClearOnNewGame = [NSMutableArray arrayWithCapacity:0];
	
	imageNotification = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_IMAGE_DOWNLOADS_COMPLETE
																		  object:nil queue:nil
																	  usingBlock:^(NSNotification *note){
																		  if( nil != [[KBImageSource sharedSingeton] imageNamed:@"tree1.png"] )
																			  self.treeStartView.image = [[KBImageSource sharedSingeton] imageNamed:@"tree1.png"];
																		  
																		  if( nil != [[KBImageSource sharedSingeton] imageNamed:@"cow1.png"] )
																			  self.cowStartView.image = [[KBImageSource sharedSingeton] imageNamed:@"cow1.png"];
																		  
																		  if( nil != [[KBImageSource sharedSingeton] imageNamed:@"factory1.png"] )
																			  self.factoryStartView.image = [[KBImageSource sharedSingeton] imageNamed:@"factory1.png"];
																		  
																		  if( nil != [[KBImageSource sharedSingeton] imageNamed:@"ground1.png"] )
																			  self.groundImageView.image = [[KBImageSource sharedSingeton] imageNamed:@"ground1.png"];
																		  
																		  if( nil != [[KBImageSource sharedSingeton] imageNamed:@"sky1.png"] )
																			  self.skyImageView.image = [[KBImageSource sharedSingeton] imageNamed:@"sky1.png"];
																		  
																		  if( nil != [[KBImageSource sharedSingeton] imageNamed:@"pollution1.png"] )
																			  self.pollutionImageView.image = [[KBImageSource sharedSingeton] imageNamed:@"pollution1.png"];
																	  }];
	[self.view bringSubviewToFront:pollutionView];
	
	[self restartGame];
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
	[self setMoneyLabel:nil];
	[self setGroundView:nil];
	[self setRestartButton:nil];
	[self setFinalScoreLabel:nil];
	[self setFactoryCostLabel:nil];
	[self setCowCostLabel:nil];
	[self setTreeCostLabel:nil];
    [self setFactoryProfitLabel:nil];
    [self setCowProfitLabel:nil];
    [self setTreeProfitLabel:nil];
	[self setGroundImageView:nil];
	[self setSkyImageView:nil];
	[self setPollutionImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


-(void)notifyGameStateUpdate:(NSNotification*)note {
	self.moneyLabel.text = [NSString stringWithFormat:@"$%d", (int)self.gameManager.cash];
	[UIView animateWithDuration:SECONDS_BETWEEN_ROUNDS animations:^(){
		self.pollutionView.frame = CGRectMake(self.pollutionView.frame.origin.x, fmaxf(self.pollutionView.frame.origin.y, 0.0) , self.pollutionView.frame.size.width, (self.groundView.frame.origin.y - fmaxf(self.pollutionView.frame.origin.y, 0.0)) * self.gameManager.pollutionPercent);
	}];
	[NSTimer scheduledTimerWithTimeInterval:SECONDS_BETWEEN_ROUNDS*0.99 target:self selector:@selector(gameEnded:) userInfo:nil repeats:NO];
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
	
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView animateWithDuration:ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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

- (JKGrowthType *)growthTypeOf:(JKSlideImageView *)view
{
	if( view == treeStartView )
		return [JKTree new];
	else if( view == cowStartView )
		return [JKCow new];
	else
		return [JKFactory new];
}

- (void)restartGame
{
	restartButton.hidden = YES;
	finalScoreLabel.hidden = YES;
	
	[self.viewsToClearOnNewGame makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self.viewsToClearOnNewGame removeAllObjects];
	
	self.gameManager = [JKGameManager new];
	[self.gameManager start];
}

- (IBAction)restartButtonTapped:(id)sender
{
	[self restartGame];
}

- (IBAction)configButtonTapped:(id)sender
{
	KBImageSourcePickerViewController *pickerVC = [[KBImageSourcePickerViewController alloc] init];
	pickerVC.fileNames = [NSArray arrayWithObjects:@"cow1.png", @"tree1.png", @"factory1.png", @"pollution1.png", @"ground1.png", @"sky1.png", nil];
	pickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:pickerVC animated:YES];
	
}

-(void)gameEnded:(NSTimer*)timer
{
	if( self.gameManager.isGameOver )
	{
		restartButton.hidden = NO;
		float years = self.gameManager.elapsedRounds;
		years /= 10;
		finalScoreLabel.text = [NSString stringWithFormat:@"You lasted %.1f years!", years];
		finalScoreLabel.hidden = NO;
		[self.view bringSubviewToFront:restartButton];
		[self.view bringSubviewToFront:finalScoreLabel];
	}
}

#pragma mark - SlideImageView

- (BOOL)slidImageView:(JKSlideImageView*)imageView {
	if( [self indexOfPlotViewAtPoint:imageView.center] >= 0 )
	{
		UIImageView *newSprite = [[UIImageView alloc] initWithImage:imageView.image];
		newSprite.frame = imageView.frame;
		[self.viewsToClearOnNewGame addObject:newSprite];
		[self.view addSubview:newSprite];
		[self.view bringSubviewToFront:pollutionView];
		
		if( [self dropView:newSprite withGrowthType:[self growthTypeOf:imageView] atPoint:imageView.center] )
		{
			return YES;
		}
		else
		{
			[newSprite removeFromSuperview];
		}
	}
	
	return NO;
}

@end
