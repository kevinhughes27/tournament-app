BracketDb
=========

BracketDb is a series of templates for how to create games that follow a certain structure i.e. 2 pools of 4 followed by a bracket for 8. Its currently constructed using a top level yml file which contains all the bracket objects. Each bracket object loads a template for the structure. These templates often contain partial templates to avoid duplication and mistakes.

Most of the structures come from the [USAU Tournament Formats](http://www.usaultimate.org/assets/1/AssetManager/Format%20Manual%20Version%204.3%20_7.1.08__updated%208.25.10_.pdf)

Eventually I would like to re-write BracketDb to use a DSL (domain specific language) instead of relying so heavily on templates. This would be more powerful and less error prone. I'm currently tracking this idea in this [issue](https://github.com/kevinhughes27/ultimate-tournament/issues/717).


Updating Bracket Templates
--------------------------

When games get created they are assigned a new ID by the database. Because of this BracketDb relies on UIDs to create the links between games e.g. a game might have a prerequisite `Wa` which is linked to game with uid `a`.

If you need to update UIDs then you need to take care of how this will affect existing games and updating may be difficult since the way a game is identified is changing. I did a migration like this once and wrote some helpers, it was probably overkill but in case it is ever useful I removed the code in c22f3e5a9e633e24cafc9b4e405ad786345c7ed6.

The next major update to BracketDb should probably break backwards compatibility if need be and we'll archive any old data before hand. Its not worth the effort to update as carefully as I did last time.

If you're just adding data and the UIDs aren't changing they can be used to identify the games and add the new data.


Gotchas
-------
Rails isn't smart enough to reload frozen record objects when the yml or json files are changed

Same issue when adding or changing brackets - you need to run `rake assets:clobber` before the changes will appear in JS.
