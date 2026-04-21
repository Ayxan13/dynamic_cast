import QtQuick
import DynamicCast

Item {
    PodcastPage {
        anchors.fill: parent

        podcastName: "Stuff You Should Know"
        author: "iHeartPodcasts"
        genre: "Education"
        rating: 4.8
        ratingCount: 1420000
        following: true
        notificationsEnabled: false
        description: "If you've ever wanted to know about champagne, satanism, the Stonewall Uprising, " +
                     "chaos theory, LSD, El Nino, true crime and Rosa Parks, then look no further. " +
                     "Josh and Chuck have you covered. Twice a week, every week."

        episodes: [
            {
                episodeNumber: 1847,
                releaseDate: "Apr 21",
                title: "How Sunscreen Works",
                durationMinutes: 52,
                progress: 0.0,
                playing: false,
                archived: false
            },
            {
                episodeNumber: 1846,
                releaseDate: "Apr 18",
                title: "The Short, Absurd History of Putting Things in Space",
                durationMinutes: 48,
                progress: 0.61,
                playing: true,
                archived: false
            },
            {
                episodeNumber: 1845,
                releaseDate: "Apr 14",
                title: "A Brief Overview of Tides",
                durationMinutes: 44,
                progress: 1.0,
                playing: false,
                archived: false
            },
            {
                episodeNumber: 1844,
                releaseDate: "Apr 11",
                title: "Selects: How Stained Glass Works",
                durationMinutes: 39,
                progress: 0.22,
                playing: false,
                archived: false
            },
            {
                episodeNumber: 1843,
                releaseDate: "Apr 7",
                title: "Remembering Mistakes: Three Mile Island Revisited",
                durationMinutes: 67,
                progress: 0.0,
                playing: false,
                archived: false
            },
            {
                episodeNumber: 1842,
                releaseDate: "Apr 4",
                title: "Could You Actually Live on Mars?",
                durationMinutes: 55,
                progress: 0.0,
                playing: false,
                archived: false
            },
            {
                episodeNumber: -1,
                releaseDate: "Apr 2",
                title: "Bonus: Live Listener Q&A (No Episode Number)",
                durationMinutes: 31,
                progress: 1.0,
                playing: false,
                archived: false
            },
            {
                episodeNumber: 1840,
                releaseDate: "",
                title: "The Hidden Architecture of Sound (No Date)",
                durationMinutes: -1,
                progress: 0.0,
                playing: false,
                archived: false
            },
            {
                episodeNumber: 1835,
                releaseDate: "Mar 3",
                title: "Old Archived Episode You Don't Need",
                durationMinutes: 43,
                progress: 1.0,
                playing: false,
                archived: true
            },
            {
                episodeNumber: 1834,
                releaseDate: "Feb 28",
                title: "Another Archived Deep Cut",
                durationMinutes: 58,
                progress: 0.0,
                playing: false,
                archived: true
            }
        ]

        onBackClicked:  console.log("back clicked")
        onCastClicked:  console.log("cast clicked")
        onShareClicked: console.log("share clicked")
        onEpisodePlayPauseClicked: (i) => console.log("play/pause episode", i)
        onFollowClicked:           console.log("follow clicked")
        onUnfollowClicked:         console.log("unfollow clicked")
        onNotificationsToggled:    console.log("notifications toggled")
        onWebsiteClicked:          console.log("website clicked")
    }
}
