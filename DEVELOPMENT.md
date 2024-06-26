# firstGameEverLove2d

Dev goal before start:
Make something that proves I've learnt how to use love2d.

Idea:
a survivor game. those similar are: Vampire Survivors, Brotato, etc.

Key Concepts to achieve:
- a main character that moves. Always stays at screen center.
- randomly spawned enemies
  - routing is easy, always move towards player.
- firing bullets to eliminate enemies. Basic collision detection.

Total dev time:
- 5.5 hours in 3 days.
  - 2 hrs at Day 1
    - draw main character
      - draw with image
    - move main character
    - listen to mouse click, firing bullets
    - thanks a lot to: https://simplegametutorials.github.io/love/asteroids/
    - how to debug
      - `print()` to console
      - `debug.debug()` and [setting up a trigger for it](https://love2d.org/wiki/Debug)
  - 1.5 hr at Day 2
    - [camera](https://ebens.me/posts/cameras-in-love2d-part-1-the-basics) (always center at main character)
    - generating monster
      - random spawn
      - spawn rate adjustments
      - moving towards main character
    - collision
  - 2 hrs at Day 3
    - (for each) 2D image rotation around custom center point
      - support tank Hull rotation during movement
      - support tank Gun rotation
    - bullets firing at tip of gun
    - monster color blink when hit
  - Bonus TODOs
    - screen shaking when hit

Assets:
https://craftpix.net/freebies/free-2d-battle-tank-game-assets/

References:
- https://simplegametutorials.github.io/love/asteroids/, also detailed examples for other types of games.
- https://ebens.me/posts/cameras-in-love2d-part-1-the-basics

## Tips

The reason that I'm sharing dev history with actual time spent, is that the time it takes to finish my first game ever way supercedes my expectations. I never imagine to play a game (even if it's not that exciting to play with) that was made by myself in practically one day.

And this states several things:

1. Have a clear goal about what you're about to make.
- Anything that aparts from the goal, drop it. Or write it down and return back for it after the goal is achieved.
- Find an working examples and pick those suitable for your goal to make things work.
  - IMPORTANT: watch out for LICENS of course
  - IMPORTANT: I've already know the underlying math and principles that support the design. And I won't waste time to verify or re-learn or refresh them during development.

2. Anything more than your initial goal, drop it. Or make it bonus after your intended milestones.

Aim for your goal, no more, no less. And iterate your new thoughts along the way with the next and following goals.

PS:
- If you are an experienced and determined developer, these says little.
- If you are an enthusiastic developer, these probably also says little.
- But if you are just learning how to write some small 250-lines game, or if you are the confusd me in the future, may this help you a bit.
