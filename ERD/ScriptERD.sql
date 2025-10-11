-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS music_streaming_db;
USE music_streaming_db;

-- 1. User
CREATE TABLE Users (
    UserID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE, -- Ràng buộc UNIQUE cho Email
    PasswordHash VARCHAR(255),
    Role ENUM('user', 'admin') DEFAULT 'user',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('active', 'inactive', 'banned') DEFAULT 'active'
);

-- 5. Genre
CREATE TABLE Genres (
    GenreID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);

-- 2. Artist
CREATE TABLE Artists (
    ArtistID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(255),
    Bio TEXT,
    Country VARCHAR(100),
    DebutYear INT,
    AvatarURL VARCHAR(255),
    Status ENUM('active', 'inactive') DEFAULT 'active',
    INDEX idx_artist_name (Name) -- Chỉ mục cho tìm kiếm
);

-- 3. Album
CREATE TABLE Albums (
    AlbumID VARCHAR(36) PRIMARY KEY,
    ArtistID VARCHAR(36),
    Title VARCHAR(255),
    ReleaseDate DATE,
    CoverURL VARCHAR(255),
    Status ENUM('published', 'draft') DEFAULT 'published',
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID) ON DELETE CASCADE
);

-- 4. Track
CREATE TABLE Tracks (
    TrackID VARCHAR(36) PRIMARY KEY,
    AlbumID VARCHAR(36),
    Title VARCHAR(255),
    Duration INT CHECK (Duration > 0), -- Ràng buộc CHECK
    AudioURL VARCHAR(255),
    Lyrics TEXT,
    GenreID VARCHAR(36),
    Explicit BOOLEAN,
    PublishStatus ENUM('published', 'draft') DEFAULT 'published',
    FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID) ON DELETE SET NULL, -- SET NULL nếu album bị xóa
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID) ON DELETE SET NULL,
    INDEX idx_track_title (Title) -- Chỉ mục cho tìm kiếm
);

-- 6. Playlist
CREATE TABLE Playlists (
    PlaylistID VARCHAR(36) PRIMARY KEY,
    OwnerUserID VARCHAR(36),
    Title VARCHAR(255),
    Description TEXT,
    Visibility ENUM('public', 'private') DEFAULT 'private',
    CoverURL VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OwnerUserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 7. PlaylistTrack (Bảng nối)
CREATE TABLE PlaylistTrack (
    PlaylistID VARCHAR(36),
    TrackID VARCHAR(36),
    SortOrder INT,
    AddedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (PlaylistID, TrackID), -- Khóa tổng hợp
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID) ON DELETE CASCADE, -- Ràng buộc ON DELETE CASCADE
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID) ON DELETE CASCADE
);

-- 8. Like (Bảng nối)
CREATE TABLE Likes (
    UserID VARCHAR(36),
    TrackID VARCHAR(36),
    LikedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, TrackID), -- Khóa tổng hợp
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE, -- Ràng buộc ON DELETE CASCADE
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID) ON DELETE CASCADE
);

-- 9. Follow (Bảng nối)
CREATE TABLE Follows (
    UserID VARCHAR(36),
    ArtistID VARCHAR(36),
    FollowedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, ArtistID), -- Khóa tổng hợp
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE, -- Ràng buộc ON DELETE CASCADE
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID) ON DELETE CASCADE
);

-- 10. PlayHistory
CREATE TABLE PlayHistory (
    HistoryID VARCHAR(36) PRIMARY KEY,
    UserID VARCHAR(36),
    TrackID VARCHAR(36),
    PlayedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Device VARCHAR(255),
    PositionSec INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID) ON DELETE SET NULL
);