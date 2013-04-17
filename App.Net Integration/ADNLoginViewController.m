//
//  ADNLoginViewController.m
//  App.Net Integration
//
//  Created by Greg V on 4/17/13.
//
//

#import "ADNLoginViewController.h"
#import "ADNTokenStore.h"
#import "Config.h"

#import "MBHUDView.h"
#import "ADNKit.h"
#import "ANKTextFieldCell.h"

typedef NS_ENUM(NSInteger, ADNCellType) {
	ADNCellTypeUsername = 0,
	ADNCellTypePassword,
	ADNTotalCellsCount
};

@interface ADNLoginViewController ()

@end

@implementation ADNLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(doDismiss)];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Log in" style:UIBarButtonItemStyleDone target:self action:@selector(doLogin)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = postButton;
    self.title = @"Log in to App.net";
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	ANKTextFieldCell *usernameField = (ANKTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[usernameField.textField becomeFirstResponder];
}

- (void)doDismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doLogin {
	ANKTextFieldCell *usernameField = (ANKTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	ANKTextFieldCell *passwordField = (ANKTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	usernameField.textField.enabled = NO;
	passwordField.textField.enabled = NO;
    ANKAuthScope authScopes = ANKAuthScopeBasic | ANKAuthScopeWritePost;
    ANKClient *client = [ANKClient sharedClient];

	[client authenticateUsername:usernameField.textField.text password:passwordField.textField.text clientID:CLIENT_ID passwordGrantSecret:PASSWORD_SECRET authScopes:authScopes completionHandler:^(BOOL success, NSError *error) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
		if (success) {
            [ADNTokenStore setToken:client.accessToken];
            [self doDismiss];
            [MBHUDView hudWithBody:@"Logged in!" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0 show:YES];
		} else {
            [[[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			usernameField.textField.enabled = YES;
			passwordField.textField.enabled = YES;
		}
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ADNTotalCellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"Cell";
	ANKTextFieldCell *cell = (ANKTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[ANKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.textField.delegate = self;
	}
	
	if (indexPath.row == ADNCellTypeUsername) {
		cell.textField.placeholder = @"Username";
		cell.textField.returnKeyType = UIReturnKeyNext;
	} else if (indexPath.row == ADNCellTypePassword) {
		cell.textField.placeholder = @"Password";
		cell.textField.secureTextEntry = YES;
		cell.textField.returnKeyType = UIReturnKeyGo;
	}
	
	return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	ANKTextFieldCell *usernameField = (ANKTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ADNCellTypeUsername inSection:0]];
	ANKTextFieldCell *passwordField = (ANKTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ADNCellTypePassword inSection:0]];
	
	if (textField == usernameField.textField) {
		[passwordField.textField becomeFirstResponder];
	} else if (textField == passwordField.textField) {
		[self doLogin];
	}
	
	return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	BOOL shouldChange = textField.isSecureTextEntry;
	
	if (!shouldChange) {
		NSMutableString *mutableString = [textField.text mutableCopy];
		[mutableString replaceCharactersInRange:range withString:string];
		shouldChange = ![mutableString hasPrefix:@"@"] && ([mutableString rangeOfString:@" "].location == NSNotFound);
	}
	
	return shouldChange;
}
@end
