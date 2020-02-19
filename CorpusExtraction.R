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
rush <- get_artist_audio_features('rush') %>% arrange(album_release_date)
rush_artist <- get_artist('2Hkut4rAAyrQxRdof7FVJq')
rush_studioalbum_idx <- c(1, 2, 3, 4, 6, 7, 8, 9, 12, 13, 14, 15, 17, 19, 20, 21, 23, 24, 27, 30)

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
      loudness_sd = sd(loudness),
      tempo = func(tempo),
      tempo_sd = sd(tempo),
      album_id = const(album_id)
    ) %>% 
    arrange(release)
  
  #Getting boolean if studio album in main dataset
  rush$is_studio <- rush$album_id %in% rush_features_by_album[rush_studioalbum_idx,]$album_id
  
  #Getting album index in features by album
  rush_features_by_album$album_idx <- c(1:nrow(rush_features_by_album))
  
  #Getting studio album index in ^^
  rush_features_by_album$studioalbum_idx <- -1
  rush_features_by_album[rush_studioalbum_idx,]$studioalbum_idx <- c(1:nrow(rush_features_by_album[rush_studioalbum_idx,]))
  
  #Getting boolean if studio album in ^^
  rush_features_by_album$is_studio <- FALSE
  rush_features_by_album[rush_studioalbum_idx,]$is_studio <- TRUE
  
  #Getting rush features
  rush_features <- (rush %>% filter(album_id != "3U6vR85uJOAT08DLnJhZhH"))[,c(9,10,14,15,16,17,18,19)]


# In the end
save.image("Corpus.RData")
