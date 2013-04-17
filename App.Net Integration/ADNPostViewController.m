//
//  ADNPostViewController.m
//  App.Net Integration
//
//  Created by Greg V on 4/13/13.
//
//

#import "ADNPostViewController.h"
#import "ADNTokenStore.h"
#import "Config.h"

#import "MBHUDView.h"
#import "ADNKit.h"

@interface ADNPostViewController ()

@end

@implementation ADNPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)doLogout {
    [ADNTokenStore deleteToken];
    [self doDismiss];
    [MBHUDView hudWithBody:@"Logged out!" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0 show:YES];
}

- (void)doDismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doPost {
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
    ANKPost *post = [[ANKPost alloc] init];
    post.text = self.bodyField.text;
    id handler = ^(id responseObject, ANKAPIResponseMeta *meta, NSError *error) {
        if (error) {
            [MBHUDView hudWithBody:[error localizedDescription] type:MBAlertViewHUDTypeExclamationMark hidesAfter:3.0 show:YES];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else {
            [self doDismiss];
            [MBHUDView hudWithBody:@"Posted!" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0 show:YES];
        }
    };
    [[ANKClient sharedClient] createPost:post completion:handler];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UITextPosition *beginning = [textField beginningOfDocument];
    [textField setSelectedTextRange:[textField textRangeFromPosition:beginning toPosition:beginning]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Top
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(doDismiss)];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(doPost)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = postButton;
    self.title = @"Post to App.net";
    
    // Body
    self.bodyField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44.0f)] autorelease];
    self.bodyField.backgroundColor = [UIColor whiteColor];
    self.bodyField.delegate = self;
    self.bodyField.text = [@" " stringByAppendingString:self.url];
    [self.view addSubview:self.bodyField];
    
    // Bottom
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleBordered target:self action:@selector(doLogout)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:spaceItem, logoutButton, nil];
    [self setToolbarItems:toolbarItems animated:NO];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.bodyField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
