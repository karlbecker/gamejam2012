//
//  JKMainGameViewController.h
//  JKGameJam2k12
//
//  Created by Karl Becker on 9/11/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKGameManager.h"



@interface JKMainGameViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *treeStartView;
@property (weak, nonatomic) IBOutlet UIImageView *cowStartView;
@property (weak, nonatomic) IBOutlet UIImageView *factoryStartView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *groundView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *plotViews;

@property (retain, nonatomic) JKGameManager *gameManager;
@property (weak, nonatomic) IBOutlet UIView *pollutionView;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UILabel *finalScoreLabel;
- (IBAction)restartButtonTapped:(id)sender;


@end
