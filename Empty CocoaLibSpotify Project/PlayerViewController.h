//
//  PlayerViewController.h
//  Simple Player
//
//  Created by Antonio Hung on 1/23/14.
//  Copyright (c) 2014 Spotify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
#import "SPPlaybackManager.h"




@interface PlayerViewController : UIViewController<SPSessionDelegate,SPSessionPlaybackDelegate>
{
}
@property(nonatomic,strong)NSArray *tracks;
@property(nonatomic,assign)int current_track_index;
@property(nonatomic,strong)SPArtist *arist;
@property(nonatomic,strong)SPAlbum *album;

@property(nonatomic,strong)SPTrack *currentTrack;

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *artist_name_txt;
@property (weak, nonatomic) IBOutlet UILabel *song_txt;
@property (weak, nonatomic) IBOutlet UILabel *album_txt;

@property (weak, nonatomic) IBOutlet UIButton *play_btn;
@property (weak, nonatomic) IBOutlet UIButton *fwd_btn;
@property (weak, nonatomic) IBOutlet UIButton *prev_btn;
@property (weak, nonatomic) IBOutlet UISlider *vol_slider;
@property (nonatomic, readwrite, strong) SPPlaybackManager *playbackManager;

- (IBAction)playTrack:(id)sender;
- (IBAction)playNextTrack:(id)sender;
- (IBAction)playPreviousTrack:(id)sender;
- (IBAction)volumeChanged:(id)sender;
@end
