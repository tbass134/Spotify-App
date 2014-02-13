//
//  TracksViewController.m
//  Simple Player
//
//  Created by Antonio Hung on 1/10/14.
//  Copyright (c) 2014 Spotify. All rights reserved.
//

#import "TracksViewController.h"
#import "PlayerViewController.h"
@interface TracksViewController ()

@end

@implementation TracksViewController

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
    NSLog(@"album %@",self.album);
    [SPAsyncLoading waitUntilLoaded:[SPAlbumBrowse browseAlbum:self.album inSession:[SPSession sharedSession]] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
        SPArtistBrowse *ab = loadedItems[0];
        NSLog(@"tracks %@",ab.tracks);
        self.tracks = ab.tracks;
        [self.tableView reloadData];
    }];
       [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    SPDispatchAsync(^{
//        SPArtistBrowse *ab = [SPArtistBrowse browseArtist:self.artist inSession:[SPSession sharedSession] type:SP_ARTISTBROWSE_NO_TRACKS];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSLog(@"ab %@",ab.biography);
//        });
//    });
    SPTrack *track = self.tracks[indexPath.row];
    cell.textLabel.text = track.name;
    
    cell.imageView.image = nil;
    
    
    SPTrack *currentTrack = [self.tracks objectAtIndex:indexPath.row];
    cell.textLabel.text =currentTrack.name;
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"PlayTrack" sender:self];
    
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PlayTrack"])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        PlayerViewController *player = segue.destinationViewController;
        player.arist = self.artist;
        player.album = self.album;
        player.current_track_index = path.row;
        player.tracks = self.tracks;
        
    }
    //    DetailObject *detail = [self detailForIndexPath:path];
    //    [segue.destinationViewController setDetail:detail];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
