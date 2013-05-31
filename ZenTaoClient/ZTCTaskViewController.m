//
//  ZTCTaskViewController.m
//  ZenTao Client
//
//  Created by Puttin Wong on 3/20/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "ZTCTaskViewController.h"
#import "ZTCAPIClient.h"
#import "ZTCNotice.h"
//#import <QuartzCore/QuartzCore.h>
#define FONT_SIZE 19.0f
#define SMALL_FONT_SIZE 15.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_CONTENT_DEFAULT_HEIGHT 44.0f
#define DEFAULT_GROUPED_HEADER_FONT_SIZE 23.0f
#define DEFAULT_GROUPED_HEADER_HEIGHT 22.0f
enum {
	TaskSectionIndex = 0,
    TaskBasicSectionIndex,
    TaskEffortSectionIndex,
    TaskLifetimeSectionIndex,
    SectionsCount,              //count
} TaskSectionIndicies;

enum {
//    TaskNameRowIndex,
	TaskDescRowIndex = 0,
    InfoRowsCount,              //count
} TaskInformationSectionRowIndicies;

enum {
    TaskProjectRowIndex = 0,
    TaskModuleRowIndex,
    TaskStoryRowIndex,
    TaskAssignedToRowIndex,
    TaskTypeRowIndex,
    TaskStatusRowIndex,
    TaskPriRowIndex,
    TaskMailToRowIndex,
    BasicInfoRowsCount,         //count
} TaskBasicInformationSectionRowIndicies;

enum {
    TaskEstimateStartRowIndex = 0,
    TaskRealRowIndex,
    TaskDeadlineRowIndex,
    TaskEstimateRowIndex,
    TaskConsumedRowIndex,
    TaskLeftRowIndex,
    EffortRowsCount,            //count
} TaskEffortSectionIndicies;

enum {
    TaskOpenedRowIndex = 0,
    TaskFinishedRowIndex,
    TaskCanceledRowIndex,
    TaskClosedRowIndex,
    TaskClosedReasonRowIndex,
    TaskEditedRowIndex,
    LifetimeRowsCount,          //count
} TaskLifetimeSectionRowIndicies;

@interface ZTCTaskViewController ()
@property (assign, nonatomic) NSUInteger taskID;
@property (strong, nonatomic) NSDictionary *projectDict;
@property (strong, nonatomic) NSDictionary *taskDict;
@property (strong, nonatomic) NSDictionary *usersDict;
@property (strong, nonatomic) NSDictionary *cellKeyDict;
@property (strong, nonatomic) NSDictionary *cellValueDict;
@end

@implementation ZTCTaskViewController

- (id)initWithID:(id) ID
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        _taskID = [ID intValue];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ZTCAPIClient* api = [ZTCAPIClient sharedClient];
    [api getPath:[ZTCAPIClient getUrlWithType:[ZTCAPIClient getRequestType] withParameters:@[@"m=task",@"f=view",[NSString stringWithFormat:@"id=%u",self.taskID]]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableDictionary *dict = [ZTCAPIClient dealWithZTStrangeJSON:JSON];
            self.projectDict = [[dict objectForKey:@"data"] objectForKey:@"project"];
            self.taskDict = [[dict objectForKey:@"data"] objectForKey:@"task"];
            self.usersDict = [[dict objectForKey:@"data"] objectForKey:@"users"];
            //DLog(@"%@",usersDict);
            //DLog(@"%@",taskDict);
            self.cellKeyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           //TaskBasicSectionIndex
                           NSLocalizedString(@"task project", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskProjectRowIndex],
                           NSLocalizedString(@"task module", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskModuleRowIndex],
                           NSLocalizedString(@"task story", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskStoryRowIndex],
                           NSLocalizedString(@"task assignedto", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskAssignedToRowIndex],
                           NSLocalizedString(@"task type", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskTypeRowIndex],
                           NSLocalizedString(@"task status", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskStatusRowIndex],
                           NSLocalizedString(@"task pri", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskPriRowIndex],
                           NSLocalizedString(@"task mailto", nil),[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskMailToRowIndex],
                           //TaskEffortSectionIndex
                           NSLocalizedString(@"task estimatestart", nil),[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskEstimateStartRowIndex],
                           NSLocalizedString(@"task real", nil),[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskRealRowIndex],
                           NSLocalizedString(@"task deadline", nil),[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskDeadlineRowIndex],
                           NSLocalizedString(@"task estimate", nil),[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskEstimateRowIndex],
                           NSLocalizedString(@"task consumed", nil),[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskConsumedRowIndex],
                           NSLocalizedString(@"task left", nil),[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskLeftRowIndex],
                           //TaskLifetimeSectionIndex
                           NSLocalizedString(@"task opened", nil),[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskOpenedRowIndex],
                           NSLocalizedString(@"task finished", nil),[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskFinishedRowIndex],
                           NSLocalizedString(@"task canceled", nil),[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskCanceledRowIndex],
                           NSLocalizedString(@"task closed", nil),[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskClosedRowIndex],
                           NSLocalizedString(@"task closedreason", nil),[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskClosedReasonRowIndex],
                           NSLocalizedString(@"task edited", nil),[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskEditedRowIndex],
                           nil];
            self.cellValueDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             //TaskBasicSectionIndex
                             [self.projectDict objectForKey:@"name"],[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskProjectRowIndex],
                             [self.taskDict objectForKey:@"module"],[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskModuleRowIndex],
                             [[self.taskDict objectForKey:@"story"] intValue]?[self.taskDict objectForKey:@"storyTitle"]:@"",[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskStoryRowIndex],
                             [NSString stringWithFormat:@"%@ %@ %@",[self.taskDict objectForKey:@"assignedToRealName"],NSLocalizedString(@"task at", nil),[self.taskDict objectForKey:@"assignedDate"]],[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskAssignedToRowIndex],
                             [[NSBundle mainBundle] localizedStringForKey:([NSString stringWithFormat:@"task type %@",[self.taskDict objectForKey:@"type"]]) value:@"" table:nil],[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskTypeRowIndex],
                             [[NSBundle mainBundle] localizedStringForKey:([NSString stringWithFormat:@"task status %@",[self.taskDict objectForKey:@"status"]]) value:@"" table:nil],[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskStatusRowIndex],
                             [self.taskDict objectForKey:@"pri"],[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskPriRowIndex],
                             [self.taskDict objectForKey:@"mailto"],[NSString stringWithFormat:@"%u:%u",TaskBasicSectionIndex,TaskMailToRowIndex],
                             //TaskEffortSectionIndex
                             [self.taskDict objectForKey:@"estStarted"],[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskEstimateStartRowIndex],
                             [self.taskDict objectForKey:@"realStarted"],[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskRealRowIndex],
                             [self.taskDict objectForKey:@"deadline"],[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskDeadlineRowIndex],
                             [NSString stringWithFormat:@"%@ %@",[self.taskDict objectForKey:@"estimate"],NSLocalizedString(@"task hour", nil)],[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskEstimateRowIndex],
                             [NSString stringWithFormat:@"%@ %@",[self.taskDict objectForKey:@"consumed"],NSLocalizedString(@"task hour", nil)],[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskConsumedRowIndex],
                             [NSString stringWithFormat:@"%@ %@",[self.taskDict objectForKey:@"left"],NSLocalizedString(@"task hour", nil)],[NSString stringWithFormat:@"%u:%u",TaskEffortSectionIndex,TaskLeftRowIndex],
                             //TaskLifetimeSectionIndex
                             [[self.taskDict objectForKey:@"openedDate"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"%@ %@ %@",[self.usersDict objectForKey:[self.taskDict objectForKey:@"openedBy"]],NSLocalizedString(@"task at", nil),[self.taskDict objectForKey:@"openedDate"]],[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskOpenedRowIndex],
                             [[self.taskDict objectForKey:@"finishedDate"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"%@ %@ %@",[self.usersDict objectForKey:[self.taskDict objectForKey:@"finishedBy"]],NSLocalizedString(@"task at", nil),[self.taskDict objectForKey:@"finishedDate"]],[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskFinishedRowIndex],
                             [[self.taskDict objectForKey:@"canceledDate"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"%@ %@ %@",[self.usersDict objectForKey:[self.taskDict objectForKey:@"canceledBy"]],NSLocalizedString(@"task at", nil),[self.taskDict objectForKey:@"canceledDate"]],[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskCanceledRowIndex],
                             [[self.taskDict objectForKey:@"closedDate"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"%@ %@ %@",[self.usersDict objectForKey:[self.taskDict objectForKey:@"closedBy"]],NSLocalizedString(@"task at", nil),[self.taskDict objectForKey:@"closedDate"]],[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskClosedRowIndex],
                             [self.taskDict objectForKey:@"closedReason"],[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskClosedReasonRowIndex],
                             [[self.taskDict objectForKey:@"lastEditedDate"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"%@ %@ %@",[self.usersDict objectForKey:[self.taskDict objectForKey:@"lastEditedBy"]],NSLocalizedString(@"task at", nil),[self.taskDict objectForKey:@"lastEditedDate"]],[NSString stringWithFormat:@"%u:%u",TaskLifetimeSectionIndex,TaskEditedRowIndex],
                             nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                self.title = [NSString stringWithFormat:@"%@ #%u",NSLocalizedString(@"task", nil),self.taskID];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@",error);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [ZTCNotice showErrorNoticeInView:self.view title:NSLocalizedString(@"error", nil) message:error.localizedDescription];
        });
    }];
    [api.operationQueue waitUntilAllOperationsAreFinished];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

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
    if (!self.taskDict) {
        return 0;
    }
    return SectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.taskDict count]) {
        switch (section) {
            case TaskSectionIndex:
                return InfoRowsCount;
                break;
            case TaskBasicSectionIndex:
                return BasicInfoRowsCount;
                break;
            case TaskEffortSectionIndex:
                return EffortRowsCount;
                break;
            case TaskLifetimeSectionIndex:
                return LifetimeRowsCount;
                break;
            default:
                break;
        }
        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case TaskSectionIndex:
            sectionName = [self.taskDict objectForKey:@"name"];
            break;
        case TaskBasicSectionIndex:
            sectionName = NSLocalizedString(@"task basic info", nil);
            break;
        case TaskEffortSectionIndex:
            sectionName = NSLocalizedString(@"task effort", nil);
            break;
        case TaskLifetimeSectionIndex:
            sectionName = NSLocalizedString(@"task lifetime", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section) {
        case TaskSectionIndex:
            switch (indexPath.row) {
                case TaskDescRowIndex:{
                    NSString *desc = [self.taskDict objectForKey:@"desc"];
                    CGSize constraint = CGSizeMake(tableView.frame.size.width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                    
                    CGSize descSize = [desc sizeWithFont:[UIFont systemFontOfSize:SMALL_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                    CGFloat height = MAX(descSize.height, 44.0f);
                    
                    return height + (CELL_CONTENT_MARGIN * 2);
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return CELL_CONTENT_DEFAULT_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
	switch (indexPath.section) {
        case TaskSectionIndex:
            switch (indexPath.row) {
                case TaskDescRowIndex:{
                    cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDescCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskDescCell"];
                    }
                    
                    NSString *desc = [self.taskDict objectForKey:@"desc"];
                    
                    [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
                    [cell.textLabel setNumberOfLines:0];
//                    [[cell.textLabel layer] setBorderWidth:2.0f];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:SMALL_FONT_SIZE]];
                    cell.textLabel.text = desc;
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        case TaskBasicSectionIndex:
        case TaskEffortSectionIndex:
        case TaskLifetimeSectionIndex:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                          reuseIdentifier:@"TaskCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskCell"];
            }
            cell.textLabel.text = [self.cellKeyDict objectForKey:[NSString stringWithFormat:@"%u:%u",indexPath.section,indexPath.row]];
            cell.detailTextLabel.text = [self.cellValueDict objectForKey:[NSString stringWithFormat:@"%u:%u",indexPath.section,indexPath.row]];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        }
            break;
        default:
            NSLog(@"ERROR: section unknown!");
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end