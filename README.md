# Gemini Multimodal Chat
* Sample app demonstrating multimodal capabilities of the iOS Gemini SDK viz. documents(txt, pdf), text & image(multimodal) using the `gemini-1.5-flash` model!
* Updated to support streaming responses

Star the Repo if you found this useful: <picture><img align="center" alt="startherepo" src="https://github.com/user-attachments/assets/88e5a2e6-7f65-4caa-bce1-8400831aff68" height="50" hspace="5"></picture><br/>
Support Me: <a href="https://www.buymeacoffee.com/adsouza"><img align="center" alt="buymeacoffee" src="https://github.com/user-attachments/assets/fa541855-cb91-4ea4-bafb-d0f9d56d0126" height="30" hspace="5"></a> <a href="https://www.youtube.com/@swiftodyssey"><img align="center" alt="youtube" src="https://github.com/user-attachments/assets/e5d34f8b-7081-4e64-bf0d-3a383a16b357" height="30" hspace="5"></a>

## Screenshots
<img align="center" width="50%" src="https://github.com/user-attachments/assets/bea6d5e0-520a-4d53-90d3-c57573b35c55">

## Note:
I've observed API errors with error code 500 when uploading videos only, regardless of video size. This is an [existing issue with the API](https://discuss.ai.google.dev/t/video-content-supplied-inline-causes-server-fault/2431) & not something that's fixable at client side. Unlike the Vertex AI for Firebase SDK & the Firebase Gemini API Extension, the native SDK relies on passing video data as `inline data` which is causing this issue.

As indicated by the Google dev team, there is currently no timeline to [add video support](https://github.com/google-gemini/generative-ai-swift/issues/203) natively.
If you need to provide video support, consider using the [Vertex AI for Firebase SDK](https://github.com/anupdsouza/ios-vertex-firebase-swiftui) solution.

## Stay Connected 🤙🏼
- <picture><img align="center" alt="star the repo" src="https://github.com/user-attachments/assets/6a84096c-7b0c-4585-b814-e1f9466d3469" height="20" hspace="5"></picture><a href="https://github.com/anupdsouza/ios-play-next-button">Star the Repo</a>
- <picture><img align="center" alt="youtube" src="https://github.com/user-attachments/assets/a6b9f4ba-96c6-4f94-ab86-ef46276e9684" height="20" hspace="5"></picture><a href="https://www.youtube.com/@swiftodyssey">Subscribe on YouTube</a>
- <picture><img align="center" alt="buymeacoffee" src="https://github.com/user-attachments/assets/a3aaa25d-66c6-49e2-b002-42738d614baa" height="20" hspace="5"></picture><a href="https://www.buymeacoffee.com/adsouza">Buy Me a Coffee</a>
- <picture><img align="center" alt="patreon" src="https://github.com/user-attachments/assets/479849e9-7b8b-463d-b840-58ad3aa79bc5" height="20" hspace="5"></picture><a href="https://patreon.com/adsouza">Become a Patron</a>
- <picture><img align="center" alt="x" src="https://github.com/user-attachments/assets/34a07357-7b49-420f-9bba-bbde5d925c03" height="20" hspace="5"></picture><a href="https://x.com/swift_odyssey">Follow me on X</a>
- <picture><img align="center" alt="github" src="https://github.com/user-attachments/assets/8bab68e4-dc8a-435f-86a8-824cdef91718" height="20" hspace="5"></picture><a href="https://github.com/anupdsouza">Follow me on GitHub</a>

Your support makes projects like this possible!
