//
//  JKGameManager.m
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-11.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "JKGameManager.h"
#import "JKPlot.h"


@interface JKGameManager ()

@property (readwrite) float pollutionPercent;	// ranges from 0-1
@property (readwrite) float cash;
@property (retain) NSMutableArray* plots;	// with JKPlot objects
@property (retain) NSTimer* timer;
@property int elapsedRounds;

// Once per second, update the pollution level and cash. Then fire a notification NOTIFY_GAME_STATE_UPDATE.
-(void)updateState:(NSTimer*)timer;
-(float)neighboringPollutionForRound:(int)round;

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
			self.cash += (plot.height * plot.growthType.profit) * SECONDS_BETWEEN_ROUNDS;
			self.pollutionPercent += (plot.height * plot.growthType.pollution) * SECONDS_BETWEEN_ROUNDS;
		}
	}
	
	self.pollutionPercent += [self neighboringPollutionForRound:self.elapsedRounds];
	if (self.pollutionPercent > 1.0)
		self.pollutionPercent = 1.0;
	
	if (self.isGameOver) {
		[self.timer invalidate];
		self.timer = nil;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GAME_STATE_UPDATE object:nil];
}

-(BOOL)isGameOver {
	return (self.pollutionPercent >= 1);
}

-(BOOL)addGrowthType:(JKGrowthType*)growthType toPlotIndex:(int)index {
	if (self.isGameOver)
		return NO;
	
	if (self.cash < growthType.cost)
		return NO;
	
	if (index >= MAXIMUM_NUMBER_OF_PLOTS || index < 0)
		return NO;
	
	JKPlot* plot = [self.plots objectAtIndex:index];
	
	if (plot.height == 0)
		plot.growthType = growthType;
	else if (![growthType isMemberOfClass:[plot.growthType class]])
		return NO;
	
	self.cash -= growthType.cost;
	plot.height++;
	
	return YES;
}

-(BOOL)remove:(int)numberToRemove fromPlotIndex:(int)index {
	if (self.isGameOver)
		return NO;
	
	if (index >= MAXIMUM_NUMBER_OF_PLOTS || index < 0)
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

-(int)heightAtPlotIndex:(int)index {
	if (index >= MAXIMUM_NUMBER_OF_PLOTS)
		return 0;
	
	JKPlot* plot = [self.plots objectAtIndex:index];
	
	return plot.height;
}

-(float)neighboringPollutionForRound:(int)round {
	float floatRound = round * SECONDS_BETWEEN_ROUNDS;
	return 0.0001 * floatRound * sqrt(floatRound);
}

@end
