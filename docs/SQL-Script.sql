-- Music Streaming App - Database Schema
-- Generated: 2025
-- Database: MySQL 8.0+

-- Create Database
CREATE DATABASE IF NOT EXISTS music_streaming_db 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE music_streaming_db;

-- Table: User
CREATE TABLE User (
    UserID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    FullName VARCHAR(100),
    DateOfBirth DATE,
    Gender ENUM('Male', 'Female', 'Other'),
    Role ENUM('User', 'Admin') DEFAULT 'User',
    ProfileImageURL VARCHAR(255),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_email (Email),
    INDEX idx_user_username (Username)
) ENGINE=InnoDB;

-- Table: Artist
CREATE TABLE Artist (
    ArtistID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Bio TEXT,
    ImageURL VARCHAR(255),
    Country VARCHAR(50),
    DebutYear INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_artist_name (Name)
) ENGINE=InnoDB;

-- Table: Genre
CREATE TABLE Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table: Album
CREATE TABLE Album (
    AlbumID BIGINT AUTO_INCREMENT PRIMARY KEY,
    ArtistID BIGINT NOT NULL,
    Title VARCHAR(200) NOT NULL,
    ReleaseDate DATE,
    CoverImageURL VARCHAR(255),
    TotalTracks INT DEFAULT 0,
    Type ENUM('Album', 'Single', 'EP') DEFAULT 'Album',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID) ON DELETE CASCADE,
    INDEX idx_album_artist (ArtistID),
    INDEX idx_album_title (Title)
) ENGINE=InnoDB;

-- Table: Track
CREATE TABLE Track (
    TrackID BIGINT AUTO_INCREMENT PRIMARY KEY,
    AlbumID BIGINT NULL,
    GenreID INT NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Duration INT NOT NULL COMMENT 'Duration in seconds',
    AudioURL VARCHAR(255) NOT NULL,
    Lyrics TEXT,
    ReleaseDate DATE,
    PlayCount BIGINT DEFAULT 0,
    TrackNumber INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AlbumID) REFERENCES Album(AlbumID) ON DELETE SET NULL,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID) ON DELETE RESTRICT,
    INDEX idx_track_title (Title),
    INDEX idx_track_album (AlbumID),
    INDEX idx_track_genre (GenreID)
) ENGINE=InnoDB;

-- Table: Playlist
CREATE TABLE Playlist (
    PlaylistID BIGINT AUTO_INCREMENT PRIMARY KEY,
    OwnerUserID BIGINT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    CoverImageURL VARCHAR(255),
    IsPublic BOOLEAN DEFAULT TRUE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (OwnerUserID) REFERENCES User(UserID) ON DELETE CASCADE,
    INDEX idx_playlist_owner (OwnerUserID)
) ENGINE=InnoDB;

-- Table: PlaylistTrack (Junction Table)
CREATE TABLE PlaylistTrack (
    PlaylistID BIGINT,
    TrackID BIGINT,
    SortOrder INT NOT NULL,
    AddedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (PlaylistID, TrackID),
    FOREIGN KEY (PlaylistID) REFERENCES Playlist(PlaylistID) ON DELETE CASCADE,
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Table: Like (Junction Table)
CREATE TABLE `Like` (
    UserID BIGINT,
    TrackID BIGINT,
    LikedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, TrackID),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Table: Follow (Junction Table)
CREATE TABLE Follow (
    UserID BIGINT,
    ArtistID BIGINT,
    FollowedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, ArtistID),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Table: PlayHistory
CREATE TABLE PlayHistory (
    HistoryID BIGINT AUTO_INCREMENT PRIMARY KEY,
    UserID BIGINT NOT NULL,
    TrackID BIGINT NOT NULL,
    PlayedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    Duration INT NOT NULL COMMENT 'Listened duration in seconds',
    Device VARCHAR(50),
    Position INT COMMENT 'Stop position in seconds',
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID) ON DELETE CASCADE,
    INDEX idx_history_user (UserID),
    INDEX idx_history_played (PlayedAt)
) ENGINE=InnoDB;

-- Insert sample genres
INSERT INTO Genre (Name, Description) VALUES
('Pop', 'Popular music'),
('Rock', 'Rock music'),
('Jazz', 'Jazz music'),
('Hip-Hop', 'Hip-Hop and Rap'),
('Classical', 'Classical music'),
('Electronic', 'Electronic and EDM'),
('R&B', 'Rhythm and Blues'),
('Country', 'Country music');

-- End of script
