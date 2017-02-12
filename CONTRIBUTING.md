#CONTRIBUTING

##Reporting Issues

To report an issue, read the format in the text box when you create one! Be descriptive, provide images if there is something visual, and if possible test the issue yourself. An issue must be replicatable or it will be closed!

##Introduction

This is HippieStation's contributing page. You are here because you are curious or interested in contributing, or maybe you clicked on it by accident. Everyone is free to contribute to this project as long as they follow the guidelines below.

Expect blatant plagiarism and COPYPASTA from [/tg/station's contributing page](https://github.com/tgstation/tgstation/blob/master/CONTRIBUTING.md)

##Getting Started
There is no set list of goals to add, so you need to be creative and come up with your own ideas (or you can go look at the suggestions page, but most of those ideas are bad.) If you don't want to add anything new, more importantly we are constantly trying to fix the bugs found in a fourteen-year-old atmospheric simulator. If you don't know anything about byond code, make sure to check out some of these sick resources.

If you want to contribute the first thing you'll need to do is [set up Git](http://wiki.hippiestation.com/index.php?title=Setting_up_git) so you can download the source code.

We have a [list of guides on the wiki](http://wiki.hippiestation.com/index.php?title=Guides#Development_and_Contribution_Guides) which will help you get started contributing to /tg/station with git and Dream Maker. For beginners, it is recommended you work on small projects, at first. If you need help learning to program in BYOND check out this [repository of resources](http://www.byond.com/developer/articles/resources).

There are probably [a bunch of issues that you can try to fix too](https://github.com/HippieStation/HippieStation13/issues).

You can of course, as always, ask for help [on the forums](http://www.hippiestation.com)! Do not expect professional support unless you're gonna pay for it.

##Meet the Team

**Host**

Jamie is the host, and he helps with the Github.

**Coders**

Coders are official maintainers of the Github that help.

**Contributors**

There are lots of members of the playerbase and staff that also contribute, and you can be a part of this group too!

###/tg/ Coding Standards
Most of what follows is from /tg/'s coding standards. They are strict, but in general provide a very good ruleset to follow when developing for this game.

###Object Oriented code
As BYOND's Dream Maker is an object oriented language, code must be object oriented when possible in order to be more flexible when adding content to it. If you are unfamiliar with this concept, it is highly recommended you look it up.

###All Byond paths must contain the full path.
(ie: absolute pathing)

Byond will allow you nest almost any type keyword into a block, such as:

```c++
datum
	datum1
		var
			varname1 = 1
			varname2
			static
				varname3
				varname4
		proc
			proc1()
				code
			proc2()
				code

		datum2
			varname1 = 0
			proc
				proc3()
					code
			proc2()
				..()
				code
```

The use of this is not allowed in this project as it makes finding definitions via full text searching next to impossible. The only exception is the variables of an object may be nested to the object, but must not nest further.

The previous code made compliant:

```c++
/datum/datum1
		var/varname1
		var/varname2
		var/static/varname3
		var/static/varname4

/datum/datum1/proc/proc1()
	code
/datum/datum1/proc/proc2()
	code
/datum/datum1/datum2
	varname1 = 0
/datum/datum1/datum2/proc/proc3()
	code
/datum/datum1/datum2/proc2()
	..()
	code
```

###No overriding type safety checks.
The use of the : operator to override type safety checks is not allowed. You must cast the variable to the proper type.

###Type paths must began with a /
eg: `/datum/thing` not `datum/thing`

###Datum type paths must began with "datum"
In byond this is optional, but omitting it makes finding definitions harder.

###Do not use text/string based type paths
It is rarely allowed to put type paths in a text format, as there are no compile errors if the type path no longer exists. Here is an example:

```C++
//Good
var/path_type = /obj/item/weapon/baseball_bat

//Bad
var/path_type = "/obj/item/weapon/baseball_bat"
```

###Tabs not spaces
You must use tabs to indent your code, NOT SPACES.

(You may use spaces to align something, but you should tab to the block level first, then add the remaining spaces)

###No Hacky code
Hacky code, such as adding specific checks, is highly discouraged and only allowed when there is ***no*** other option. (Protip: 'I couldn't immediately think of a proper way so thus there must be no other option' is not gonna cut it here )

You can avoid hacky code by using object oriented methodologies, such as overriding a function (called procs in DM) or sectioning code into functions and then overriding them as required.

###No duplicated code.
Copying code from one place to another maybe suitable for small short time projects but /tg/station focuses on the long term and thus discourages this.

Instead you can use object orientation, or simply placing repeated code in a function, to obey this specification easily.

###Startup/Runtime tradeoffs with lists and the "hidden" init proc
First, read the comments in this byond thread, starting here:http://www.byond.com/forum/?post=2086980&page=2#comment19776775

There are two key points here:

1) Defining a list in the type definition incurs a hidden proc call - init, if you must define a list at startup, do so in New() and avoid the overhead of a second call (init() and then new())

2)Offsets list creation overhead to the point where the list is actually required (which for many objects, may be never at all). 

Remember, this tradeoff makes sense in many cases but not all, you should think carefully about your implementation before deciding if this is an appropriate thing to do

###No magic numbers or strings
Make these #defines with a name that more clearly states what it's for.

###Control statements:
(if,while,for,etc)

* All control statements must not contain code on the same line as the statement (`if (blah) return`)
* All control statements comparing a variable to a number should use the formula of `thing` `operator` `number`, not the reverse (eg: `if (count <= 10)` not `if (10 >= count)`)

###Use early return.
Do not enclose a proc in an if block when returning on a condition is more feasible
This is bad:
````
/datum/datum1/proc/proc1()
	if (thing1)
		if (!thing2)
			if (thing3 == 30)
				do stuff
````
This is good:
````
/datum/datum1/proc/proc1()
	if (!thing1)
		return
	if (thing2)
		return
	if (thing3 != 30)
		return
	do stuff
````
This prevents nesting levels from getting deeper then they need to be.

###Develop Secure Code

* Player input must always be escaped safely, we recommend you use stripped_input in all cases where you would use input. Essentially, just always treat input from players as inherently malicious and design with that use case in mind

* Calls to the database must be escaped properly - use sanitizeSQL to escape text based database entries from players or admins, and isnum() for number based database entries from players or admins.

* All calls to topics must be checked for correctness, topic href calls can be easily faked by clients, so you should ensure that the call is valid for the state the item is in. Do not rely on the UI code to provide only valid topic calls

* Information that players could use to metagame (that is to identify the round type and or the antags via information that would not be available to them in character) should be kept as administrator only

* It is recommended as well you do not expose information about the players - even something as simple as the number of people who have readied up at the start of the round can and has been used to try to identify the round type

* Where you have code that can cause large scale modification and *FUN* make sure you start it out locked behind one of the default admin roles - use common sense to determine which role fits the level of damage a function could do

###Files
* Because runtime errors do not give the full path, try to avoid having files with the same name across folders.

* File names should not be mixed case, or contain spaces or any character that would require escaping in a uri.

* Files and path accessed and referenced by code above simply being #included should be strictly lowercase to avoid issues on filesystems where case matters.

###Other Notes
* Code should be modular where possible, if you are working on a new class then it is best if you put it in a new file.

* Bloated code may be necessary to add a certain feature, which means there has to be a judgement over whether the feature is worth having or not. You can help make this decision easier by making sure your code is modular.

* You are expected to help maintain the code that you add, meaning if there is a problem then you are likely to be approached in order to fix any issues, runtimes or bugs.

* Do not divide when you can easily convert it to a multiplication. (ie `4/2` should be done as `4*0.5`)

####Enforced not enforced
The following different coding styles are not only not enforced, but it is generally frowned upon to change them over from one to the other for little reason:

* English/British spelling on var/proc names
	* Color/Colour nobody cares,
* Spaces after control statements
	* if() if () nobody cares.


####Sounds

* .ogg files are recommended!

* Compress it to 7!

* Midis are allowed

* Make the file mono if possible!

* Make the sound file AS SMALL AS POSSIBLE. Cut out parts if it is music!

* Title music doesn't have to follow the previous rule.

####Don't bother messing with config files
All of the config files are run locally on the server, so you can't change them from the Github! Talk to the host instead.


####Operators and spaces:
(this is not strictly enforced, but more a guideline for readability's sake)

* Operators that should be separated by spaces
	* Boolean and logic operators like &&, || <, >, ==, etc (but not !)
	* Argument separator operators like , (and ; when used in a forloop)
	* Assignment operators like = or += or the like
* Operators that should not be separated by spaces
	* Bitwise operators like & or |
	* Access operators like . and :
	* Parentheses ()
	* logical not !

Math operators like +, -, /, *, etc are up in the air, just choose which version looks more readable.

###Dream Maker Quirks/Tricks:
Like all languages, Dream Maker has its quirks, some of them are beneficial to us, like these

* In-To for loops: ```for(var/i = 1, i <= some_value, i++)``` is a fairly standard way to write an incremental for loop in most languages (especially those in the C family) however DM's ```for(var/i in 1 to some_value)``` syntax is oddly faster than its implementation of the former syntax; where possible it's advised to use DM's syntax. (Note, the ```to``` keyword is inclusive, so it automatically defaults to replacing ```<=```, if you want ```<``` then you should write it as ```1 to some_value-1```).
HOWEVER, if either ```some_value``` or ```i``` changes within the body of the for (underneath the ```for(...)``` header) or if you are looping over a list AND changing the length of the list then you can NOT use this type of for loop!


* Istypeless for loops: a name for a differing syntax for writing for-each style loops in DM, however it is NOT DM's standard syntax hence why this is considered a quirk. Take a look at this:
```
var/list/bag_of_items = list(sword, apple, coinpouch, sword, sword)
var/obj/item/sword/best_sword = null
for(var/obj/item/sword/S in bag_of_items)
	if(!best_sword || S.damage > best_sword.damage)
    		best_sword = S
```
The above is a simple proc for checking all swords in a container and returning the one with the highest damage, it uses DM's standard syntax for a for loop, it does this by specifying a type in the variable of the for header which byond interprets as a type to filter by, it performs this filter using ```istype()``` (or some internal-magic similar to ```istype()```, I wouldn't put it past byond), the above example is fine with the data currently contained in ```bag_of_items```, however if ```bag_of_items``` contained ONLY swords, or only SUBTYPES of swords, then the above is inefficient, for example:
```
var/list/bag_of_swords = list(sword, sword, sword, sword)
var/obj/item/sword/best_sword = null
for(var/obj/item/sword/S in bag_of_swords)
	if(!best_sword || S.damage > best_sword.damage)
    		best_sword = S
```
specifies a type for DM to filter by, with the previous example that's perfectly fine, we only want swords, but here the bag only contains swords? is DM still going to try to filter because we gave it a type to filter by? YES, and here comes the inefficiency. Whereever a list (or other container, such as an atom (in which case you're technically accessing their special contents list but I digress)) contains datums of the same datatype or subtypes of the datatype you require for your for body
you can circumvent DM's filtering and automatic ```istype()``` checks by writing the loop as such:
```
var/list/bag_of_swords = list(sword, sword, sword, sword)
var/obj/item/sword/best_sword = null
for(var/s in bag_of_swords)
	var/obj/item/sword/S = s
	if(!best_sword || S.damage > best_sword.damage)
    		best_sword = S
```
Of course, if the list contains data of a mixed type then the above optimisation is DANGEROUS, as it will blindly typecast all data in the list as the specified type, even if it isn't really that type! which will cause runtime errors.

* Dot variable: like other languages in the C family, Dream maker has a ```.``` or "Dot" operator, used for accessing variables/members/functions of an object instance.
eg:
```
var/mob/living/carbon/human/H = YOU_THE_READER
H.gib()
```
however DM also has a dot variable, accessed just as ```.``` on it's own, defaulting to a value of null, now what's special about the dot operator is that it is automatically returned (as in the ```return``` statment) at the end of a proc, provided the proc does not already manually return (```return count``` for example). Why is this special? well the ```return``` statement should ideally be free from overhead (functionally free, of course nothing's free) but DM fails to fulfill this,  DM's return statement is actually fairly costly for what it does and for what it's used for.
With ```.``` being everpresent in every proc can we use it as a temporary variable? Of course we can! However the ```.``` operator cannot replace a typecasted variable, it can hold data any other var in DM can, it just can't be accessed as one, however the ```.``` operator is compatible with a few operators that look weird but work perfectly fine, such as: ```.++``` for incrementing ```.'s``` value, or ```.[1]``` for accessing the first element of ```.``` (provided it's a list).

##Pull Request Process

There is no strict process when it comes to merging pull requests, pull requests will sometimes take a while before they are looked at by a maintainer, the bigger the change the more time it will take before they are accepted into the code. Every team member is a volunteer who is giving up their own time to help maintain and contribute, so please be nice. Here are some helpful ways to make it easier for you and for the maintainer when making a pull request.

* Make sure your pull request complies to the requirements outlined in [this guide](http://wiki.hippiestation.com/index.php?title=Getting_Your_Pull_Accepted)

* You are going to be expected to document all your changes in the pull request, failing to do so will mean delaying it as we will have to question why you made the change. On the other hand you can speed up the process by making the pull request readable and easy to understand, with diagrams or before/after data.

* We ask that you use the changelog system to document your change, this prevents our players from being caught unaware by changes - you can find more information about this here http://tgstation13.org/wiki/Guide_to_Changelogs

* If you are proposing multiple changes, which change many different aspects of the code, you are expected to section them off into different pull requests in order to make it easier to review them and to deny/accept the changes that are deemed acceptable.

* If your pull request is accepted, the code you add no longer belongs exclusively to you but to everyone; everyone is free to work on it, but you are also free to object to any changes being made, which will be noted by a Project Lead or Project Manager. It is a shame this has to be explicitly said, but there have been cases where this would've saved some trouble.

* Please explain why you are submitting the pull request, and how you think your change will be beneficial to the game. Failure to do so will be grounds for rejecting the PR.

##A word on git
Yes we know that the files have a tonne of mixed windows and linux line endings, attempts to fix this have been met with less than stellar success and as such we have decided to give up caring until such a time as it matters.

Therefore EOF settings of main repo are forbidden territory one must avoid wandering into
