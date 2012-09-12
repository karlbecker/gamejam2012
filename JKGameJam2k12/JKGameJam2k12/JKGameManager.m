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

@interface JKGameManager ()

@property (readwrite) float pollutionLevel;	// ranges from 0-1
@property (readwrite) unsigned int cash;
@property NSMutableArray* plots;	// with JKPlot objects

@end

@implementation JKGameManager

@synthesize pollutionLevel = _pollutionLevel;
@synthesize cash = _cash;
@synthesize plots = _plots;

-(id)init {
	self = [super init];
	if (self) {
		self.cash = 500;
		self.pollutionLevel = 0;
		self.plots = [NSMutableArray new];
		for (int i = 0; i < MAXIMUM_NUMBER_OF_PLOTS; i++) {
			[self.plots addObject:[JKPlot new]];
		}
	}
	return self;
}

-(void)updateState {
	for (JKPlot* plot in self.plots) {
		if (plot.growthType && plot.height > 0) {
			self.cash += plot.height * plot.growthType.profit;
			self.pollutionLevel += plot.height * plot.growthType.pollution;
		}
	}
	
	self.pollutionLevel += INCREASE_IN_POLLUTION_PER_ROUND;
	
	// TODO fire notification to update ViewController
}

-(BOOL)addGrowthType:(JKGrowthType*)growthType toPlotIndex:(int)index {
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
