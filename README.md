# redditNC
An open source reddit client that allows you to see the top posts from up to five subreddits of your choosing inside of iOS's notification center.

---

##Why I am making this...
Everyone gets bored in class. Don't deny it. Some people fall asleep, others take out their laptops and boot up a game of LoL, and some just straight up don't go to the class they took out an egregious amounts of student loans for. If you're like me, you open up some reddit client on your phone, scroll post the 200 memes on the frontpage that you've already had a sensible chuckle at, decide to check out some of your favorite subreddits and see if some Earth shattering event is happening, but like always, its a link that has been purple since you woke up for that 8:00am Number Theory lecture. Maybe this conundrum that has been plaguing mankind can be fixed? Well thats what I've (hoped) to do.

---

##What is this (in more detail)
Essentially, redditNC allows you to select up to five (count'em five) subreddits to have displayed in iOS's notification center as a widget. The top five (non-stickied) posts at the time of viewing are the posts that get displayed, along with how many upvotes the post has, along with how many comments the post has (originally how many downvotes but reddit hides that now). And thats pretty much it.... for now. I like to keeps things simple. No annoying push notifications, no in-app purchases. Just what you want. 

---
##What else will redditNC be able to to?
Since I'm developing this when I can't go to sleep, don't expect nightly builds or such. That being said, here is what I plan on adding in the future in no particular order (updated as of 01/09/2016):

  - Store the pulled content and only update after a user-defined about of time has passed
  - Ability to select post popularity based on recent/month/all-time
  - Ability to tap on a post and be taken to the reddit post in Safari
  - Ability to hide/show NSFW posts
  - Ability to hide/show NSFW thumbnails
  - Make the thumbnails larger (either Apple needs to drop support of the iPhone 4S or I need to figure out how to extend the widget further down on the 4S)
  - Sign in to your reddit profile and have it get your top 5 visited subreddtis (this would basically require a complete code-rewrite)
  - Color themes
  - Come up with a better icon (I really am not a super fan of this one)
  - Android version (I can devleope Android, but I won't like it...)
  - Other things I haven't thought of

---
#Techinal Stuffs

##How does this work?
Fun fact, if you add ```/.json``` to the end of a reddit subreddit URL, you get a super nice JSON page to work with! Pretty killer, eh? So essentailly, a user inputs the subreddit they want to see (i.e "apple" or "gaming"), the url ```https://www.reddit.com/r/USER_INPUT/.json``` is tested for existence, and if it does exists, the subreddit is stored to NSDefalts. This all happens in the app itself.

Onto the widget side of things...

When the widget loads, it pulls the subreddits out of NSDefualts, and it tries to pull the necessary JSON info from their ```/.json``` page. If it succeeds, it reports ```.NewData```, which tells iOS to update the widget in notification center. If it fails, it reports ```.NoData``` and it does not update the screen.

As you can see, its fairly simple, just kinda annoying at times. 

#Other
---
If you are still reading at this point, thanks! 🍻 If you have any questions, feel free to contact me on GitHub. Or you can be super cool and make some pull-requests or what not.
  
