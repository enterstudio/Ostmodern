# Ostmodern

Ostmodern iOS Code Test
Goal of this exercise is to show that you know the iOS platform and to test how good you are at prototyping.
The idea is to create simple app driven by an instance of the Skylark API filled with sample data. Skylark is our video platform that enables our clients to curate their video content. Skylark has API endpoints for Sets and TV Episodes (explained more in the appendices). Your solution’s interface should be presentable, but think more about data and layout than putting lots of effort into styling and effects.
Must haves
● Create a page that lists the contents of the ‘Home’ set. ○ Example:
■ http://player.bfi.org.uk/
■ http://alchemiya.com/
● Create a page that displays info for each TV Episode in the set.
○ Example:
■ http://player.bfi.org.uk/film/watch-shaun-the-sheep-movie-2014/ ■ https://www.alchemiya.com/#/programme/skateistan
Nice to haves
● If you’re solution handles API errors (like timeouts or 500s)
Don’t need
● Navigation
● Login
● Video playback, just show the episode image and we’ll pretend the video works
Submission
Save your code as a private github repo and give access to the user maracuja when you are finished. The repo should include a README containing instructions on how to build the project.
    
Appendices
What is Skylark I’m getting worried here!!
Calm down it’ll be ok! It’s actually very simple.
Skylark is our video on demand platform. It allows our clients to organise their video content (ie TV Episodes/Films/Programmes) into sets (eg Sci-fi, Horror). Skylark’s data is then exposed via an API and when we build sites and apps for our clients they are driven by this API.
API Documentation
Sets
http://docs.skylarkpublic.apiary.io/#reference/sets
Think of a set as a page of content. It has information about itself like URL and a title and it also has a list of content. This content can be TV Episodes, other sets or content components like dividers/headers.
Episodes
http://docs.skylarkpublic.apiary.io/#reference/content/episodes
Episodes are actually part of a larger data structure (ie Programmes, Seasons, Episodes) but for now you only need to consider Episodes as an object by itself.
Example Skylark Endpoint
Use this as the base URL for connecting to the API. You won’t need to use any Auth tokens for this code test and the API should respond. http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/
i.e. GET all sets is available here: -
http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/api/sets/
