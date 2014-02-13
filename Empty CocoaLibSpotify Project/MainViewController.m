//
//  MainViewController.m
//  Simple Player
//
//  Created by Antonio Hung on 11/12/13.
//  Copyright (c) 2013 Spotify. All rights reserved.
//

#import "MainViewController.h"
#import "ArtistViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadPlaylists) name:@"sessionLoaded" object:nil];
    
	self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
	[[SPSession sharedSession] setDelegate:self];
	//[self performSelector:@selector(showLogin) withObject:nil afterDelay:0.0];

   

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)showLogin {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"];
    NSString *credential = [[NSUserDefaults standardUserDefaults]valueForKey:@"credential"];
    
    if(username && credential)
        [[SPSession sharedSession] attemptLoginWithUserName:username existingCredential:credential];
    else
    {
        SPLoginViewController *controller = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
        controller.allowsCancel = NO;
        
        [self presentModalViewController:controller
                                animated:NO];
        
        
    }
}

-(void)loadPlaylists
{
    printf("loading playlists");
    self.songs = [[NSMutableArray alloc]init];
    [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedession, NSArray *notLoadedSession)
    {
        // The session is logged in and loaded — now wait for the userPlaylists to load.
        
        [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers)
         {
             // User playlists are loaded — wait for playlists to load their metadata.
             
             NSMutableArray *playlists = [NSMutableArray array];
             
             [playlists addObject:[SPSession sharedSession].starredPlaylist];
             [playlists addObject:[SPSession sharedSession].inboxPlaylist];
             [playlists addObjectsFromArray:[SPSession sharedSession].userPlaylists.flattenedPlaylists];
             
             [SPAsyncLoading waitUntilLoaded:playlists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists)
              {
                  
                  // All of our playlists have loaded their metadata — wait for all tracks to load their metadata.
                  self.playlists = [[NSMutableArray alloc] initWithArray:loadedPlaylists];
                  NSLog(@"arrPlaylist %@",self.playlists);
                  NSLog(@"notLoadedPlaylists %@",notLoadedPlaylists);
                  
                  for(SPPlaylist *playlist in self.playlists)
                  {
                      for(SPTrack *track in playlist.items)
                      {
                          /*
                          [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                              NSLog(@"loadedItems %@",loadedItems);
                          }];*/
                          //NSLog(@"track %@ in playlist %@",track,playlist);
                          if(track)
                          [self.songs addObject:track];
                          
                      }
                  }
                  
                //write to path
//                  //NSLog(@"self.songs %@",self.songs);
//                  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                  NSString *documentsDirectory = [paths objectAtIndex:0];
//                  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"]; NSFileManager *fileManager = [NSFileManager defaultManager];
//                  
//                  if (![fileManager fileExistsAtPath: path])
//                  {
//                      path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"plist.plist"] ];
//                  }
//                  
//                  if([self.songs writeToFile:path atomically:YES])
//                      printf("data writen");
                  
                 
                  
                  [self sortSongsByAritst];
                  
              }];
         }];
    }];
}

-(void)sortSongsByAritst
{
    NSMutableSet *temp_a =[[NSMutableSet alloc]init];
    for(SPPlaylistItem *item in self.songs)
    {
        if (item.itemClass == [SPTrack class])
        {
            SPTrack *track = item.item;
            if(track.artists.count>0)
            [temp_a addObject:[track.artists firstObject]];
        }
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];

    self.artists = [[NSMutableArray alloc]initWithArray:[temp_a sortedArrayUsingDescriptors:@[sort]]];
    [self.table_view reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SPArtist *arist = [self.artists objectAtIndex:indexPath.row];
    cell.textLabel.text =arist.name;
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Artist_Detail" sender:nil];

}

 #pragma mark - Navigation
 
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Artist_Detail"])
    {
        NSIndexPath *path = [self.table_view indexPathForSelectedRow];
        SPArtist *artist = [self.artists objectAtIndex:path.row];
        
        ArtistViewController *controller;
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navController =
            (UINavigationController *)segue.destinationViewController;
            
            controller = [navController.viewControllers objectAtIndex:0];
            
        } else {
            
            controller = segue.destinationViewController;
        }
    
        controller.artist = artist;


    }
}
- (void)dealloc {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
