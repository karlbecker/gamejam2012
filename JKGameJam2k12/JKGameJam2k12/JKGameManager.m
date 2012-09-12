//
//  JKGameManager.m
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-11.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "JKGameManager.h"
#import "JKPlot.h"

#define INCREASE_IN_POLLUTION_PER_ROUND 0.01
#define SECONDS_BETWEEN_ROUNDS 1

@interface JKGameManager ()

@property (readwrite) float pollutionPercent;	// ranges from 0-1
@property (readwrite) unsigned int cash;
@property (retain) NSMutableArray* plots;	// with JKPlot objects
@property (retain) NSTimer* timer;
@property int elapsedRounds;

// Once per second, update the pollution level and cash. Then fire a notification NOTIFY_GAME_STATE_UPDATE.
-(void)updateState:(NSTimer*)timer;

@end

@implementation JKGameManager

@synthesize pollutionPercent = _pollutionLevel;
@synthesize cash = _cash;
@synthesize plots = _plots;
@synthesize timer = _timer;
@synthesize elapsedRounds = _elapsedRounds;

-(id)init {
	self = [super init];
	if (self) {
		self.elapsedRounds = 0;
		self.cash = 500;
		self.pollutionPercent = 0;
		self.plots = [NSMutableArray new];
		for (int i = 0; i < MAXIMUM_NUMBER_OF_PLOTS; i++) {
			[self.plots addObject:[JKPlot new]];
		}
	}
	return self;
}

-(void)start {
	if (self.timer || self.isGameOver)
		return;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:SECONDS_BETWEEN_ROUNDS target:self selector:@selector(updateState:) userInfo:nil repeats:YES];
}

-(void)updateState:(NSTimer*)timer {
	self.elapsedRounds++;
	
	for (JKPlot* plot in self.plots) {
		if (plot.growthType && plot.height > 0) {
			self.cash += plot.height * plot.growthType.profit;
			self.pollutionPercent += plot.height * plot.growthType.pollution;
		}
	}
	
	self.pollutionPercent += INCREASE_IN_POLLUTION_PER_ROUND;
	
	// TODO fire notification to update ViewController
	
	if (self.isGameOver) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

-(BOOL)isGameOver {
	return (self.pollutionPercent >= 1);
}

-(BOOL)addGrowthType:(JKGrowthType*)growthType toPlotIndex:(int)index {
	if (self.isGameOver)
		return NO;
	
	if (self.cash < growthType.cost)
		return NO;
	
	if (index >= MAXIMUM_NUMBER_OF_PLOTS)
		return NO;
	
	JKPlot* plot = [self.plots objectAtIndex:index];
	
	if (plot.height == 0)
		plot.growthType = growthType;
	else if (![growthType isMemberOfClass:[plot class]])
		return NO;
	
	self.cash -= growthType.cost;
	plot.height++;
	
	return YES;
}

-(BOOL)remove:(int)numberToRemove fromPlotIndex:(int)index {
	if (self.isGameOver)
		return NO;
	
	if (index >= MAXIMUM_NUMBER_OF_PLOTS)
		return NO;
	
	JKPlot* plot = [self.plots objectAtIndex:index];
	
	if (numberToRemove > plot.height)
		numberToRemove = plot.height;
	
	plot.height -= numberToRemove;
	
	if (plot.height == 0) {
		plot.growthType = nil;
	}
	
	return YES;
}

@end
