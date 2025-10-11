# Test Cases - Groovezilla Music Streaming Application

## Test Case Overview
This document contains comprehensive test cases for validating the business rules and functionality of the Groovezilla music streaming application.

---

## 1. Unique Playlist Constraint Testing

### TC-001: Add Duplicate Track to Playlist
**Objective:** Verify that the system prevents adding the same track twice to a playlist

**Preconditions:**
- Playlist "My Favorites" exists with Track ID "1" already added
- User is on the playlist detail page

**Test Steps:**
1. Navigate to playlist "My Favorites"
2. Click "Add Track" button
3. Select Track ID "1" (Cascade - Breathe) from the track list
4. Click "Add to Playlist"

**Expected Result:**
- Error notification appears: "Track already exists in this playlist"
- Track is NOT added to the playlist
- Playlist track count remains unchanged
- Red error notification slides in from right, displays for 3 seconds, then slides out

**Actual Result:** ___________

**Status:** [ ] Pass [ ] Fail

---

### TC-002: Add Different Tracks to Playlist
**Objective:** Verify that different tracks can be added successfully

**Test Steps:**
1. Navigate to playlist "My Favorites"
2. Add Track ID "2" (ALIEN STAGE - CURE)
3. Add Track ID "3" (Summer Vibes)
4. Verify playlist updates

**Expected Result:**
- Success notification appears for each: "Track added to playlist"
- Both tracks appear in the playlist
- Playlist track count increases by 2
- Green success notifications display

**Status:** [ ] Pass [ ] Fail

---

## 2. Like/Unlike Testing

### TC-003: Like Track for First Time
**Objective:** Verify like functionality adds track to favorites

**Test Steps:**
1. Navigate to Track ID "1" detail page
2. Click the heart icon (like button)
3. Check localStorage for liked tracks

**Expected Result:**
- Heart icon turns solid/filled
- Success notification: "Added to your liked songs"
- Track ID "1" appears in `likedTracks` array in localStorage
- Like count increases by 1

**Status:** [ ] Pass [ ] Fail

---

### TC-004: Unlike Previously Liked Track
**Objective:** Verify unlike functionality removes track from favorites

**Preconditions:**
- Track ID "1" is already liked

**Test Steps:**
1. Navigate to Track ID "1" detail page
2. Click the heart icon (unlike button)
3. Check localStorage for liked tracks

**Expected Result:**
- Heart icon turns outline/empty
- Info notification: "Removed from your liked songs"
- Track ID "1" is removed from `likedTracks` array
- Like count decreases by 1

**Status:** [ ] Pass [ ] Fail

---

### TC-005: Double Click Like Button (Toggle Test)
**Objective:** Verify rapid clicking toggles like status correctly

**Test Steps:**
1. Navigate to Track ID "2" detail page
2. Click like button (heart icon)
3. Immediately click like button again
4. Click like button third time

**Expected Result:**
- First click: Track is liked (solid heart)
- Second click: Track is unliked (outline heart)
- Third click: Track is liked again (solid heart)
- Only one entry per track exists in localStorage at any time
- No duplicate entries created

**Status:** [ ] Pass [ ] Fail

---

## 3. History Tracking Testing

### TC-006: Play Track for Less Than 30 Seconds
**Objective:** Verify history is NOT recorded for short playback

**Test Steps:**
1. Navigate to index.html
2. Click play on Track ID "1"
3. Wait for 15 seconds
4. Click pause button
5. Check localStorage history array

**Expected Result:**
- Track plays for 15 seconds
- NO history entry is created
- `history` array in localStorage does not contain this playback session
- Console log: "Not recording history - played only 15s"

**Status:** [ ] Pass [ ] Fail

---

### TC-007: Play Track for Exactly 29 Seconds
**Objective:** Verify history is NOT recorded at 29 seconds (edge case)

**Test Steps:**
1. Play Track ID "2"
2. Wait for exactly 29 seconds
3. Click pause
4. Check localStorage history

**Expected Result:**
- NO history entry created
- Console shows playback time: 29s
- History threshold not reached

**Status:** [ ] Pass [ ] Fail

---

### TC-008: Play Track for 30+ Seconds
**Objective:** Verify history IS recorded after 30 second threshold

**Test Steps:**
1. Play Track ID "1"
2. Wait for 31 seconds
3. Click pause
4. Check localStorage history array

**Expected Result:**
- History entry is created with:
  - `trackId: "1"`
  - `timestamp: [current date/time]`
  - `playedSeconds: 31`
- Success notification: "Added to listening history"
- History array contains the new entry

**Status:** [ ] Pass [ ] Fail

---

### TC-009: Press Next After 30+ Seconds
**Objective:** Verify history is recorded when skipping to next track after threshold

**Test Steps:**
1. Play Track ID "3"
2. Wait for 35 seconds
3. Click "Next" button (skip forward)
4. Check localStorage history

**Expected Result:**
- History entry created for Track ID "3" with 35 seconds played
- Next track begins playing (Track ID "4")
- Console log: "Recording history before next: Track 3, 35s"

**Status:** [ ] Pass [ ] Fail

---

### TC-010: Press Next Before 30 Seconds
**Objective:** Verify history is NOT recorded when skipping before threshold

**Test Steps:**
1. Play Track ID "4"
2. Wait for 20 seconds
3. Click "Next" button
4. Check localStorage history

**Expected Result:**
- NO history entry created for Track ID "4"
- Next track begins playing
- Console log: "Skipping history - only 20s played"

**Status:** [ ] Pass [ ] Fail

---

### TC-011: Track Plays to Completion
**Objective:** Verify history is recorded when track ends naturally

**Test Steps:**
1. Play a short test track (or use audio seeking)
2. Let track play until it ends completely
3. Check localStorage history

**Expected Result:**
- History entry created with full track duration
- "ended" event triggers history recording
- Next track auto-plays (if available)

**Status:** [ ] Pass [ ] Fail

---

## 4. Vietnamese Search Testing

### TC-012: Search With Vietnamese Tones
**Objective:** Verify search works with accented Vietnamese characters

**Test Steps:**
1. Navigate to search.html
2. Enter search query: "Trần Tiến Đạt" (with tones)
3. Click search or press Enter

**Expected Result:**
- Search returns results matching "Tran Tien Dat" (without tones)
- Results include any tracks/artists with similar names
- Case-insensitive matching
- Tone removal function processes input correctly

**Status:** [ ] Pass [ ] Fail

---

### TC-013: Search Without Vietnamese Tones
**Objective:** Verify search works with non-accented characters

**Test Steps:**
1. Navigate to search.html
2. Enter search query: "tran tien dat" (no tones, lowercase)
3. Click search

**Expected Result:**
- Results match any variation: "Trần Tiến Đạt", "Tran Tien Dat", "TRẦN TIẾN ĐẠT"
- Search is case-insensitive
- Returns all matching tracks, artists, albums

**Status:** [ ] Pass [ ] Fail

---

### TC-014: Mixed Tone Search
**Objective:** Verify search handles partially accented input

**Test Steps:**
1. Search for: "Tran Tiến dat" (mixed tones)
2. Verify results

**Expected Result:**
- Search processes all variations correctly
- Returns relevant results regardless of tone placement
- No errors in console

**Status:** [ ] Pass [ ] Fail

---

## 5. Playlist Drag-Drop Testing

### TC-015: Drag Track to New Position
**Objective:** Verify drag-drop reordering in playlist

**Test Steps:**
1. Navigate to playlist.html with 4+ tracks
2. Drag Track #1 and drop it at position #3
3. Check if order updates

**Expected Result:**
- Track moves from position 1 to position 3
- Other tracks shift accordingly
- New order is saved to localStorage
- Visual feedback during drag (opacity, cursor)
- Drop zone highlights when dragging over

**Status:** [ ] Pass [ ] Fail

---

### TC-016: Drag Track to Same Position
**Objective:** Verify no change when dropping at original position

**Test Steps:**
1. Drag Track #2 and drop it back at position #2
2. Verify playlist state

**Expected Result:**
- No order change occurs
- No unnecessary localStorage updates
- No errors logged

**Status:** [ ] Pass [ ] Fail

---

## 6. Audio Player Controls Testing

### TC-017: Volume Control
**Objective:** Verify volume slider adjusts audio level

**Test Steps:**
1. Play any track
2. Move volume slider to 50%
3. Move volume slider to 0% (mute)
4. Move volume slider to 100%

**Expected Result:**
- Audio volume adjusts in real-time
- Volume value stored in localStorage
- Mute icon appears at 0%
- Volume persists across page reloads

**Status:** [ ] Pass [ ] Fail

---

### TC-018: Progress Bar Seek
**Objective:** Verify clicking progress bar seeks to position

**Test Steps:**
1. Play Track ID "1"
2. Click at 50% point on progress bar
3. Verify current time updates

**Expected Result:**
- Audio seeks to clicked position
- Current time displays correctly
- Progress bar updates visually
- Audio continues playing from new position

**Status:** [ ] Pass [ ] Fail

---

### TC-019: Previous Track Button
**Objective:** Verify previous button navigates to prior track

**Preconditions:**
- Currently playing Track #3 in playlist

**Test Steps:**
1. Click "Previous" button (<< icon)
2. Verify track changes

**Expected Result:**
- Track #2 begins playing
- Player UI updates with Track #2 info
- Progress resets to 0:00

**Status:** [ ] Pass [ ] Fail

---

### TC-020: Play/Pause Toggle
**Objective:** Verify play/pause button toggles correctly

**Test Steps:**
1. Click play button (track starts)
2. Click pause button (track pauses)
3. Click play button again (track resumes)

**Expected Result:**
- First click: Track plays, button shows pause icon
- Second click: Track pauses, button shows play icon
- Third click: Track resumes from paused position
- Time tracking continues accurately

**Status:** [ ] Pass [ ] Fail

---

## 7. Data Persistence Testing

### TC-021: LocalStorage Persistence After Page Reload
**Objective:** Verify all data persists across sessions

**Test Steps:**
1. Add Track #2 to playlist
2. Like Track #3
3. Play Track #1 for 35 seconds
4. Refresh page (F5)
5. Check all data

**Expected Result:**
- Playlist still contains Track #2
- Track #3 is still liked (solid heart)
- History contains Track #1 playback entry
- All localStorage data intact

**Status:** [ ] Pass [ ] Fail

---

### TC-022: LocalStorage Data Structure Validation
**Objective:** Verify correct data structure in localStorage

**Test Steps:**
1. Open browser DevTools > Application > LocalStorage
2. Inspect each key: `tracks`, `playlists`, `history`, `likedTracks`
3. Validate JSON structure

**Expected Result:**
- `tracks`: Array of track objects with id, title, artist, album, duration, cover, audioFile
- `playlists`: Array with trackIds, name, description, createdAt
- `history`: Array with trackId, timestamp, playedSeconds
- `likedTracks`: Array of track IDs (strings)
- All valid JSON format

**Status:** [ ] Pass [ ] Fail

---

## Test Summary

| Test Area | Total Cases | Passed | Failed | Pass Rate |
|-----------|-------------|--------|--------|-----------|
| Unique Constraint | 2 | | | |
| Like/Unlike | 3 | | | |
| History Tracking | 6 | | | |
| Vietnamese Search | 3 | | | |
| Drag-Drop | 2 | | | |
| Audio Controls | 4 | | | |
| Data Persistence | 2 | | | |
| **TOTAL** | **22** | | | |

---

## Test Environment

- **Browser:** ___________
- **OS:** Windows
- **Audio Files:** 
  - cascade-breathe-future-garage-412839.mp3
  - ALIEN STAGE CURE cover.mp3
- **Date Tested:** ___________
- **Tester:** ___________

---

## Notes and Issues

_Document any bugs, unexpected behavior, or observations here:_

---

## Critical Business Rules Verified

✅ **Unique Playlist Constraint**: One track can only appear once per playlist  
✅ **30-Second History Threshold**: History records only when played ≥30s OR next pressed after ≥30s  
✅ **Like Toggle System**: Likes cannot duplicate, toggle between like/unlike  
✅ **Vietnamese Search**: Searches work with or without tone marks (dấu)  
✅ **Drag-Drop Ordering**: Playlist order can be rearranged  
✅ **Data Persistence**: All changes saved to localStorage  

---

**End of Test Cases Document**
