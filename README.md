# Gemini AI Multimodal Chat
* Sample app demonstrating multimodal capabilities of the iOS Gemini SDK viz. documents(txt, pdf), text & image(multimodal) using the `gemini-1.5-flash` model!
* Updated to support streaming responses

Star the Repo if you found this useful: <picture><img align="center" alt="startherepo" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/starrepo.gif" height="50" hspace="5"></picture><br/>
Support Me: <a href="https://www.buymeacoffee.com/adsouza"><img align="center" alt="buymeacoffee" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/bmc.png" height="30" hspace="5"></a> <a href="https://www.youtube.com/@swiftodyssey"><img align="center" alt="youtube" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/subscribe.png" height="30" hspace="5"></a>

## Screenshots
<img align="center" width="50%" src="https://github.com/user-attachments/assets/bea6d5e0-520a-4d53-90d3-c57573b35c55">

## Note:
I've observed API errors with error code 500 when uploading videos only, regardless of video size. This is an [existing issue with the API](https://discuss.ai.google.dev/t/video-content-supplied-inline-causes-server-fault/2431) & not something that's fixable at client side. Unlike the Vertex AI for Firebase SDK & the Firebase Gemini API Extension, the native SDK relies on passing video data as `inline data` which is causing this issue.

As indicated by the Google dev team, there is currently no timeline to [add video support](https://github.com/google-gemini/generative-ai-swift/issues/203) natively.
If you need to provide video support, consider using the [Vertex AI for Firebase SDK](https://github.com/anupdsouza/ios-vertex-firebase-swiftui) solution.

## Stay Connected 🤙🏼
- <picture><img align="center" alt="star the repo" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/star.png" height="20" hspace="5"></picture><a href="https://github.com/anupdsouza/ios-gemini-chat">Star the Repo</a>
- <picture><img align="center" alt="youtube" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-yt.png" height="20" hspace="5"></picture><a href="https://www.youtube.com/@swiftodyssey">Subscribe on YouTube</a>
- <picture><img align="center" alt="buymeacoffee" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-bmc.png" height="20" hspace="5"></picture><a href="https://www.buymeacoffee.com/adsouza">Buy Me a Coffee</a>
- <picture><img align="center" alt="patreon" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-patreon.png" height="20" hspace="5"></picture><a href="https://patreon.com/adsouza">Become a Patron</a>
- <picture><img align="center" alt="x" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-x.png" height="20" hspace="5"></picture><a href="https://x.com/swift_odyssey">Follow me on X</a>
- <picture><img align="center" alt="github" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-gh.png" height="20" hspace="5"></picture><a href="https://github.com/anupdsouza">Follow me on GitHub</a>

Your support makes projects like this possible!
