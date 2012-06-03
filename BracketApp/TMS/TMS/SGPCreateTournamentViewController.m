//
//  SGPCreateTournamentViewController.m
//  TMS
//
//  Created by Jeff Morris on 5/16/12.
//  Copyright (c) 2012 SaciOSDev.com. All rights reserved.
//

#import "SGPCreateTournamentViewController.h"
#import "SGPSportTypeViewController.h"
#import "SGPTeamListViewController.h"
#import "Tournament.h"
#import "SportType.h"
#import "NSString+WhiteSpacing.h"

@interface SGPCreateTournamentViewController ()
@property (strong, nonatomic) Tournament *tournament;
@end

@implementation SGPCreateTournamentViewController

@synthesize tournNameTextField = _tournNameTextField;
@synthesize sportTypeTextField = _sportTypeTextField;
@synthesize tournament = _tournament;

#pragma mark - Private Methods

- (void)cancelModalView:(id)sender
{
    [[self managedObjectContext] deleteObject:[self tournament]];
    [Tournament saveAll:[self managedObjectContext]];
    [super cancelModalView:sender];
}

#pragma mark - Public Methods

- (IBAction)nextView:(id)sender {
    // First check to see if the user has entered a Tournament name...
    [[self tournNameTextField] setText:[[[self tournNameTextField] text] stringByTrimmingLeadingAndTailingWhitespace]];
    if ([[self tournNameTextField] text]!=nil && [[[self tournNameTextField] text] length]>0) {
        [[self tournament] setDisplayName:[[self tournNameTextField] text]];
        SGPTeamListViewController *vc = [[SGPTeamListViewController alloc] initWithNibName:@"SGPTeamListViewController" bundle:nil];
        [vc setManagedObjectContext:[self managedObjectContext]];
        [vc setTournament:[self tournament]];
        [[self navigationController] pushViewController:vc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tournament Name", @"Tournament Name")
                                                        message:NSLocalizedString(@"Please enter a tournament name before you process.", 
                                                                                  @"Please enter a tournament name before you process.") 
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)selectSportType:(id)sender {
    SGPSportTypeViewController *vc = [[SGPSportTypeViewController alloc] initWithNibName:@"SGPSportTypeViewController" bundle:nil];
    [vc setManagedObjectContext:[self managedObjectContext]];
    [vc setTournament:[self tournament]];
    [[self navigationController] pushViewController:vc animated:YES];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTournament:[Tournament createObject:[self managedObjectContext]]];
    [[self tournament] setCreateDate:[NSDate date]];
    
    [self setTitle:NSLocalizedString(@"Add Tournament", @"Add Tournament")];
    [[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
    
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancelModalView:)]];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", @"Next")
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(nextView:)]];
}

- (void)viewDidUnload
{
    [self setTournNameTextField:nil];
    [self setSportTypeTextField:nil];
    [self setTournament:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self sportTypeTextField] setText:[[[self tournament] sportType] displayName]];
}

@end
