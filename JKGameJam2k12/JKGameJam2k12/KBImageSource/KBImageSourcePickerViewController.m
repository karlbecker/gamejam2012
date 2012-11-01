//
//  KBImageSourcePickerViewController.m
//  JKGameJam2k12
//
//  Created by Karl Becker on 11/1/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "KBImageSourcePickerViewController.h"

@interface KBImageSourcePickerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *baseURLTextField;
@property (weak, nonatomic) IBOutlet UITextView *namesTextView;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateOrDoneButton;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end

@implementation KBImageSourcePickerViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setNamesTextView:nil];
	[self setBaseURLTextField:nil];
	[self setLogTextView:nil];
	[self setUpdateOrDoneButton:nil];
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	if( self.baseURLString != nil )
		self.baseURLTextField.text = self.baseURLString;
	
	NSMutableString *namesString = [NSMutableString stringWithCapacity:0];
	for (NSString *name in self.fileNames)
	{
		[namesString appendString:name];
		[namesString appendString:@"\n"];
	}
	
	self.namesTextView.text = namesString;
	
	[super viewWillAppear:animated];
	
}

- (IBAction)cancelTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)doneDismissTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)doneTapped:(id)sender
{
	if (self.baseURLTextField.text.length <= 0 )
	{
		self.logTextView.text = @"Please enter a directory";
		return;
	}
		
	
	NSURL *url = [NSURL URLWithString:self.baseURLTextField.text];
	if( url != nil )
	{
		[KBImageSource sharedSingeton].delegate = self;
		[[KBImageSource sharedSingeton] loadImageNames:self.fileNames fromURL:url];
		self.logTextView.text = @"";
		//self.updateOrDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDismissTapped:)];
	}
	else
	{
		self.logTextView.text = @"Please enter a directory";
	}
}

#pragma mark - UITextFieldDelegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.baseURLTextField resignFirstResponder];
	[textField endEditing:YES];
	[textField resignFirstResponder];
	[self performSelector:@selector(doneTapped:) withObject:self.updateOrDoneButton];
	return NO;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark - KBImageSourceDelegate
- (void)progressLogged:(NSString *)progressString
{
	self.logTextView.text = [self.logTextView.text stringByAppendingFormat:@"\n%@", progressString];
}
@end
