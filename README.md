# ios-gemini-chat
### Updated to support streaming responses !

Documents(txt, pdf), Text & Image(multimodal) chat demo using the `gemini-1.5-flash` model!

![Gemini1 5YT](https://github.com/user-attachments/assets/bea6d5e0-520a-4d53-90d3-c57573b35c55)


Star the repo if you found this useful. ⭐️

# Note:
I've observed API errors with error code 500 when uploading videos only, regardless of video size. This is an [existing issue with the API](https://discuss.ai.google.dev/t/video-content-supplied-inline-causes-server-fault/2431) & not something that's fixable at client side. Unlike the Vertex AI for Firebase SDK & the Firebase Gemini API Extension, the native SDK relies on passing video data as `inline data` which is causing this issue.

As indicated by the Google dev team, there is currently no timeline to [add video support](https://github.com/google-gemini/generative-ai-swift/issues/203) natively.
If you need to provide video support, consider using the [Vertex AI for Firebase SDK](https://github.com/anupdsouza/ios-vertex-firebase-swiftui) solution.
<!--<img width="300" alt="Screenshot 2024-01-03 at 5 07 56 PM" src="https://github.com/anupdsouza/ios-gemini-chat/assets/103429618/a49714c7-30d5-4741-a2dc-d7792d30d089">-->

<!--<img width="300" alt="Screenshot 2024-01-03 at 5 09 12 PM" src="https://github.com/anupdsouza/ios-gemini-chat/assets/103429618/d8d47f0c-2c89-444d-a763-e7935062d854">-->
