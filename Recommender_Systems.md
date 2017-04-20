Discussion 11: Recommender Systems
================
Yun Mai
April 20, 2017

Recommender Systems
-------------------

Assignment:

Your task is to analyze an existing recommender system that you find interesting. You should:

Perform a Scenario Design analysis as described below. Consider whether it makes sense for your selected recommender system to perform scenario design twice, once for the organization (e.g. Amazon.com) and once for the organization's customers. Attempt to reverse engineer what you can about the site, from the site interface and any available information that you can find on the Internet or elsewhere. Include specific recommendations about how to improve the site's recommendation capabilities going forward. Create your report using an R Markdown file, and create a discussion thread with a link to the GitHub repo where your Markdown file notebook resides. You are not expected to need to write code for this discussion assignment. Here are two examples of the kinds of papers that might be helpful backgrounders for your research in \#2 above (if you had chosen amazon.com or nytimes.com as your web site):

Greg Linden, Brent Smith, and Jeremy York, "Amazon.com Recommendations: Item-to-Item Collaborative Filtering," IEEE Internet Computing, 2003(!). <https://datajobs.com/data-science-repo/Recommender-Systems-%5BAmazon%5D.pdf> Alex Spangher, "Building the Next New York Times Recommendation Engine", Aug 11, 2015. <http://open.blogs.nytimes.com/2015/08/11/building-the-next-new-york-times-recommendation-engine/>

**1. Perform a Scenario Design analysis as described below. Consider whether it makes sense for your selected recommender system to perform scenario design twice, once for the organization (e.g. Amazon.com) and once for the organization's customers.**

Playing video games is one of the best memories at graduate school. Dungeon Siege was one of my favorites. I want to know the similar games and found several game recommendation websites. I found one of them, BoardGameGeek (<https://videogamegeek.com/>), is very interesting.

BoardGameGeek is an online board gaming resource and community. It has three sections: board game, RPGs, and video games. If perform scenario design to the organization, BoardGameGeek, the target users are board game fans. The key goals of this websites are providing all sorts of gaming information for its users including reviews, ratings, live discussion forums, play-aid etc. Also it runs marketplace where registered users can trade games and do transactions.

It may make sense to perform scenario design to the organization customers, the board game fans. Game players who use the recommendation system to search for games will hope find something similar, something unknown before, something good while not having to scroll down dozens of entries. Usually one game player prefers to certain genres which is different from other players. The key goals of game recommendation system generates high quality of results will give users good experience.

**2. Attempt to reverse engineer what you can about the site, from the site interface and any available information that you can find on the Internet or elsewhere. **

First let's see how BoardGameGeek's recommending system work. By choosing the video game section, I searched "Dungeon Siege" and chose one of the results. You will see 18 tags listed about the game including info, release, description, characters, images, marketplace, linked forums, blogs, geeklists.. and even stats. On the heading, you will find average rating, comments and even stat graph. They show the total rank and the Macintosh rank and Windows rank. In the Statistics tag you will find "Similarity Rated"'. To view the similarity rated games, you have to set the minimum rating and maximum rating that users have rated for "Dungeon Siege". At the same time you can put in the minimum number of ratings(by default it is 20) and minimum average ratings(by default it is 7). Then you will see the recommendation. It is very interesting that the user can make corrections on the games in the list by putting supporting info in the Notes to Admin box(i.e. reference web links and explanatory comments). From this you can see

In the wiki of BoardGameGeek, you will see its game recommendation algorithm. <https://boardgamegeek.com/wiki/page/Game_Recommendation_Algorithm>

BoardGameGeek recommendation strength is calculated into a score based on user rating and user collections. If you want to recommend other games to user who own game A, first you will collect all the owners of game A and set the threshold of their rating for game A to remove those owners who do not like game A much. Then collect all other games rated by those owners and set the threshold of their rating for all of other games. This way, they filter out games those owners do not like and the rest will be the games the game A lover will likely buy.

To the user collections, I will cite their wiki: " Take a game, call it Game X. Say that game is owned by 1% of people. Take another game, Game Y which is owned by 300 people. You'd exopect about 3 of them to also own Game X. If many more do own Game X, that suggests that people who like Game Y enough to own it like Game X enough to own it more often than most. Now if only 4 people own it, that's not such an anomaly. If 30 people own it, that's a dramatic factor of 10. In contrast, another game, Game Z owned by 10 people, you'd expect no one (well, 0.1 people) to own Game Y. But if a single person does, that's also a factor of 10, but it isn't a genuine of an anomaly. To correct for this, the algorithm adjusts for the relative obscurity of the game. "

They combine these two processes and the obscurity correction to generate recommendation score.

**3. Include specific recommendations about how to improve the site's recommendation capabilities going forward.**

There are problems of this recommendation system. The system tends to be bias towards games coming out the same year because games come out in the same year usually have same owners and raters. Similar situation exists in games released by the same publisher. The system also tends to be bias towards new games because people usually have very high ownership and rating. To the very popular games, the system only can give very weak recommendation because there's nothing characteristically different from other games. For those games owned or liked by very small sample of people, it is hard for the system to generate recommendation too.

I think the BoardGameGeek is using Collaborative Filtering method to filter the game. To improve the game recommendation system of BoardGameGeek, I would suggest the website to test Collaborative Topic Modeling and Collaborative Poisson Factorization ask New York Times do. By comparing several methods, they will find the most efficient one. Or even they can combine two methods to get solutions to overcome the shortcoming of the same year issue and very popular game issue.
