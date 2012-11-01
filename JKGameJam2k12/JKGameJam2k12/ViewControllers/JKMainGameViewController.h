//
//  JKMainGameViewController.h
//  JKGameJam2k12
//
//  Created by Karl Becker on 9/11/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKGameManager.h"
#import "JKSlideImageView.h"


@interface JKMainGameViewController : UIViewController <UIGestureRecognizerDelegate, JKSlideImageViewDelegate>
@property (weak, nonatomic) IBOutlet JKSlideImageView *treeStartView;
@property (weak, nonatomic) IBOutlet JKSlideImageView *cowStartView;
@property (weak, nonatomic) IBOutlet JKSlideImageView *factoryStartView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *groundView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *plotViews;
@property (weak, nonatomic) IBOutlet UILabel *factoryCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *cowCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *treeCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *factoryProfitLabel;
@property (strong, nonatomic) IBOutlet UILabel *cowProfitLabel;
@property (strong, nonatomic) IBOutlet UILabel *treeProfitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *skyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pollutionImageView;

@property (retain, nonatomic) JKGameManager *gameManager;
@property (weak, nonatomic) IBOutlet UIView *pollutionView;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UILabel *finalScoreLabel;
- (IBAction)restartButtonTapped:(id)sender;

- (IBAction)configButtonTapped:(id)sender;
@property (retain, nonatomic) NSMutableArray *viewsToClearOnNewGame;

@end
