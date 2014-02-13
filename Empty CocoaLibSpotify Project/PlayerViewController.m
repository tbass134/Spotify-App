//
//  PlayerViewController.m
//  Simple Player
//
//  Created by Antonio Hung on 1/23/14.
//  Copyright (c) 2014 Spotify. All rights reserved.
//

#import "PlayerViewController.h"
#import "CocoaLibSpotify.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

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
    self.playbackManager.isPlaying = NO;
    
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
	[[SPSession sharedSession] setDelegate:self];
    
    SPTrack *track =self.tracks[self.current_track_index];
    [self playTrack:track];
   

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark Playback

-(void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager {
}

-(void)playTrack:(SPTrack *)track
{
    NSLog(@"track %@",track);
    [[SPSession sharedSession] trackForURL:track.spotifyURL callback:^(SPTrack *track) {
        
        if (track != nil) {
            
            [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
                [self.playbackManager playTrack:track callback:^(NSError *error) {
                    
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
                                                                        message:[error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    } else {
                        self.currentTrack = track;
//                        
//                        self.artist_name_txt.text = self.currentTrack.artists[0];
//                        self.song_txt.text = self.currentTrack.name;
//                        self.album_txt.text = self.currentTrack.album.name;
                        
                    }
                    
                }];
            }];
        }
    }];

}

-(IBAction)setTrackPlaying:(id)sender
{
    if(!self.playbackManager.isPlaying)
    {
        if(self.currentTrack)
        {
            [self.playbackManager playTrack:self.currentTrack callback:^(NSError *error) {
                if(!error)
                    self.playbackManager.isPlaying = YES;
            }];
        }
        
    }
    else
    {
    }
}
- (IBAction)playNextTrack:(id)sender
{
    if(self.current_track_index <self.tracks.count);
    {
        self.current_track_index++;
        SPTrack *track =self.tracks[self.current_track_index];
        [self playTrack:track];
    }

}
- (IBAction)playPreviousTrack:(id)sender
{
    if(self.current_track_index-1 >0);
    {
        self.current_track_index--;
        SPTrack *track =self.tracks[self.current_track_index];
        [self playTrack:track];
    }

}
- (IBAction)volumeChanged:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
