# Install/update tidyverse and spotifyr (one time)

# Load libraries (every time)

library(tidyverse)
library(spotifyr)
library(dplyr)
library(ggplot2)

# Set Spotify access variables (every time)

load("spotify_env.RData")
set_spotify_ID()

# Work with spotifyr. Note that playlists also require a username.
rush <- get_artist_audio_features('rush')
rush_artist <- get_artist('2Hkut4rAAyrQxRdof7FVJq')
rush_studioalbum_idx <- c(1, 2, 3, 4, 6, 7, 8, 9, 12, 13, 14, 15, 17, 19, 20, 21, 24, 25, 27, 30)

# Helper functions
const = function(x){x[1]}
func = mean

# Genre analysis
genre_rock_seventiesrock <- get_playlist_audio_features('spotify', '37i9dQZF1DWWwzidNQX6jx')
genre_rock_eightiesrock <- get_playlist_audio_features('spotify', '37i9dQZF1DX1spT6G94GFC')
genre_rock_ninetiesrock <- get_playlist_audio_features('spotify', '37i9dQZF1DX1rVvRgjX59F')
genre_rock_zeroesrock <- get_playlist_audio_features('spotify', '37i9dQZF1DX3oM43CtKnRV')

genre_reggae <- get_playlist_audio_features('spotify', '37i9dQZF1DXbSbnqxMTGx9')   #Reggae Classics
genre_progrock <- get_playlist_audio_features('Geraldo Adami', '00diRu0wMKH2YpTHLQjJ7F') #Progressive Rock user playlist
genre_poprock <- get_playlist_audio_features('spotify', '37i9dQZF1DX6W1iI3ggF1N') #Pop Rock Shot
genre_newwave <- get_playlist_audio_features('spotify', '37i9dQZF1DX3Gj7nguS95W') #Is It New Wave?
genre_jazz <- get_playlist_audio_features('spotify', '37i9dQZF1DXbITWG1ZJKYt') #Jazz Classics
genre_metal <- get_playlist_audio_features('spotify', '37i9dQZF1DWWOaP4H0w5b0') #Metal Essentials
genre_symphmetal <- get_playlist_audio_features('Diron Donadel', '1JnMmes2yEHNvS6AaHFBt7') #Symphonic Metal user playlist

# Audio features analysis
  rush_features_by_album <- rush %>% 
    filter(album_id != "3U6vR85uJOAT08DLnJhZhH") %>% 
    group_by(album_name) %>%
    summarise(
      release=const(album_release_date),
      danceability_sd=sd(danceability),
      energy_sd=sd(energy),
      speechiness_sd=sd(speechiness),
      acousticness_sd=sd(acousticness),
      liveness_sd=sd(liveness),
      valence_sd=sd(valence),
      instrumentalness_sd=sd(instrumentalness),
      instrumentalness=func(instrumentalness),
      danceability=func(danceability),
      energy=func(energy),
      speechiness=func(speechiness),
      acousticness=func(acousticness),
      liveness=func(liveness),
      valence=func(valence),
      loudness = func(loudness),
      
    ) %>% 
    arrange(release)
  
  rush_features_by_album$album_no <- c(1:nrow(rush_features_by_album))
  
  rush_features_by_studioalbum <- rush_features_by_album[rush_studioalbum_idx,]
  rush_features_by_studioalbum$album_no <- c(1:nrow(rush_features_by_studioalbum))
  
  plot_studioalbum_features <- ggplot(rush_features_by_studioalbum, aes(x=album_no)) +
    geom_line(aes(x=album_no, y=danceability, colour="danceability")) + 
    geom_line(aes(x=album_no, y=energy, colour="energy")) + 
    geom_line(aes(x=album_no, y=speechiness, colour="speechiness")) + 
    geom_line(aes(x=album_no, y=acousticness, colour="acousticness")) + 
    geom_line(aes(x=album_no, y=instrumentalness, colour="instrumentalness")) + 
    geom_line(aes(x=album_no, y=liveness, colour="liveness")) + 
    geom_line(aes(x=album_no, y=valence, colour="valence")) + 
    scale_x_continuous(
      name="Studio album idx",
      breaks=c(1:nrow(rush_features_by_studioalbum)), 
      labels=c(1:nrow(rush_features_by_studioalbum)),
      limits=c(1,20)) +
    scale_y_continuous(
      name="Value",
      breaks=c(0:10)/10, 
      labels=c(0:10)/10,
      limits=c(0,1)) +
    ggtitle("Mean of music features per studio album") +
    labs(color="Property")


# In the end
save.image("Corpus.RData")