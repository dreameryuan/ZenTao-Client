//
//  ZTCUserSettingsViewController.m
//  ZenTao Client
//
//  Created by Puttin Wong on 3/22/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "ZTCUserSettingsViewController.h"
#import "ZTCAPIClient.h"
#import "ZTCListViewController.h"
#import "ZTCNotice.h"
#import "PDKeychainBindings.h"

enum {
	AccountSectionIndex,
    URLSectionIndex,
    ModeSectionIndex,
} UserInfoSectionIndicies;

enum {
	AccountRowIndex,
    PasswordRowIndex,
} AccountSectionRowIndicies;

enum {
	UrlRowIndex,
} UrlSectionRowIndicies;

enum {
	ModeRowIndex,
} ModeSectionRowIndicies;

enum {
    kTextFieldTag = 1000,
    kSegTag = 2000,
} TagIndicies;

@interface ZTCUserSettingsViewController ()

@property(nonatomic,strong) UITextField *accountTextFiled;
@property(nonatomic,strong) UITextField *passwordTextFiled;
@property(nonatomic,strong) UITextField *urlTextFiled;

@end

@implementation ZTCUserSettingsViewController

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        [self initAccountTextFiled];
        [self initPasswordTextFiled];
        [self initUrlTextFiled];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        _accountTextFiled.text = [defaults stringForKey:@"account"];//same key with demo.plist
        _passwordTextFiled.text = [defaults stringForKey:@"password"];
        _urlTextFiled.text = [defaults stringForKey:@"url"];
    }
    return self;
}

- (UITextField*)getBasicTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [[textField layer] setBorderWidth:2.0f];
    textField.clearsOnBeginEditing = NO;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.tag = kTextFieldTag;
    [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    return textField;
}

- (void)initAccountTextFiled {
    _accountTextFiled= [self getBasicTextField];
    
    _accountTextFiled.placeholder = @"demo";
    _accountTextFiled.keyboardType = UIKeyboardTypeDefault;
    _accountTextFiled.returnKeyType = UIReturnKeyNext;
}

- (void)initPasswordTextFiled {
    _passwordTextFiled= [self getBasicTextField];
    
    _passwordTextFiled.placeholder = @"123456";
    _passwordTextFiled.keyboardType = UIKeyboardTypeDefault;
    _passwordTextFiled.returnKeyType = UIReturnKeyNext;
}

- (void)initUrlTextFiled {
    _urlTextFiled= [self getBasicTextField];
    
    _urlTextFiled.placeholder = @"demo.zentao.net";
    _urlTextFiled.keyboardType = UIKeyboardTypeDefault;
    _urlTextFiled.returnKeyType = UIReturnKeyDone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tryLogin)];
    self.title = NSLocalizedString(@"login", nil);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
/*
- (void)loadView
{
    [super loadView];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPAD) {
        return YES;
    } else {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSInteger)supportedInterfaceOrientations{
    NSInteger mask = 0;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeRight])
        mask |= UIInterfaceOrientationMaskLandscapeRight;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeLeft])
        mask |= UIInterfaceOrientationMaskLandscapeLeft;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait])
        mask |= UIInterfaceOrientationMaskPortrait;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortraitUpsideDown])
        mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    return mask;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case AccountSectionIndex:
            sectionName = NSLocalizedString(@"login Basic Group", nil);
            break;
        case URLSectionIndex:
            sectionName = NSLocalizedString(@"login URL Group", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *sectionFooter;
    switch (section)
    {
        case AccountSectionIndex:
            sectionFooter = NSLocalizedString(@"login Basic Group Desc", nil);
            break;
        case URLSectionIndex:
            sectionFooter = NSLocalizedString(@"login URL Group Desc", nil);
            break;
        default:
            sectionFooter = @"";
            break;
    }
    return sectionFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case AccountSectionIndex:
            return 2;
            break;
        case URLSectionIndex:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case AccountSectionIndex:
        case URLSectionIndex:
        {
            CellIdentifier = @"TextFieldCell";
            cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            for(UIView *subview in [cell subviews]) {
                if([subview isKindOfClass:[UITextField class]]) {
                    [subview removeFromSuperview];
                }
            }
            switch (indexPath.section) {
                case AccountSectionIndex:
                    switch (indexPath.row) {
                        case AccountRowIndex:
                        {
                            [cell.contentView addSubview:self.accountTextFiled];
                            cell.textLabel.text = NSLocalizedString(@"login Account", nil);
                        }
                            break;
                        case PasswordRowIndex:
                        {
                            [cell.contentView addSubview:self.passwordTextFiled];
                            cell.textLabel.text = NSLocalizedString(@"login Password", nil);
                        }
                            break;
                        default:
                            break;
                    }
                    break;
                case URLSectionIndex:
                    switch (indexPath.row) {
                        case UrlRowIndex:
                        {
                            [cell.contentView addSubview:self.urlTextFiled];
                            cell.textLabel.text = NSLocalizedString(@"login URL", nil);
                        }
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - TextField delegate

- (void)textFieldDone:(UITextField*)textField
{
    UITextField *nextField = nil;
    NSIndexPath *newPath = nil;
    if (textField == self.accountTextFiled) {
        newPath = [NSIndexPath indexPathForRow:PasswordRowIndex inSection:AccountSectionIndex];
        nextField = self.passwordTextFiled;
    } else if (textField == self.passwordTextFiled) {
        newPath = [NSIndexPath indexPathForRow:UrlRowIndex inSection:URLSectionIndex];
        nextField = self.urlTextFiled;
    } else {
        //
    }
    if (newPath) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView scrollToRowAtIndexPath:newPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        } completion:^(BOOL finished){
            [nextField becomeFirstResponder];
        }];
    } else {
        [textField resignFirstResponder];
    }
}

#pragma mark - login

- (void)tryLogin
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        });
        if ([ZTCAPIClient loginWithAccount:self.accountTextFiled.text Password:self.passwordTextFiled.text BaseURL:self.urlTextFiled.text]) {
            PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
            [bindings setObject:self.accountTextFiled.text forKey:kZTCKeychainAccount];
            [bindings setObject:self.passwordTextFiled.text forKey:kZTCKeychainPassword];
            [bindings setObject:self.urlTextFiled.text forKey:kZTCKeychainUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
                [ZTCAPIClient showMainView];
                [ZTCNotice showSuccessNoticeInView:[[[[UIApplication sharedApplication] delegate] window] rootViewController].view title:NSLocalizedString(@"login success title", nil)];
            });
        } else {
            //login fail;
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZTCNotice showErrorNoticeInView:self.view title:NSLocalizedString(@"login fail title", nil) message:NSLocalizedString(@"login fail message", nil)];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem.enabled = YES;
        });
    });
}

@end