# Who-s-Listening
Hypothetical iphone app for security when apps like TikTok turn on your microphone in the background. 

The code gives multiple implementations trying to solve the following problem: How do you keep your conversations safe when apps with access to your mic can listen in at any time.

It is possible for apps that have access to your microphone to start a background task and use your microphone. This can happen when you are not not using the app, or while the app is currently running on your phone.

You can easily try this out with TikTok. If you loudly talk about something unrelated to your feed while scrolling on the app, the subject you talked about will appear the next time you open TikTok.

To remedy this, I attempted to design an app that would send you a notification when your microphone was turned on at unexpected times (i.e. when scrolling tiktok or phone is locked).

The Who's Listening files, from 1.0 - 3.0 (And Storyboard which is another Xcode interface) all have multiple implementations that try to solve this problem. Currently, the problems that I am experiencing are: 
background task of microphone monitor being suspended when running too frequently (if this function can't check mic status every few seconds, then there is no point)
App can't use observer to monitor microphone if it is terminated
Basically no consistent way to monitor mic usage while the app is suspended
Cannot access data on what apps are using the mic and in what context due to apple IOS restrictions.


This app is currently a work in progress. Something with this functionality could increase security as a whole for all netizens.


