# Introduction #

There are roughly 5 branches/projects.

  * controls  < ui widgets
  * apps  < some heavier weight apps, like an asynchronous test framework, useful for working with network and statemachines.
  * dev < - the main classes, collections, utilities and framework
  * examples  <- miscellaneous things, e.g. dining philosopers from Miro, the e8 particle simulator
  * test <- unit tests

# History #

The codebase started as code I privately used frequently, then my team used frequently.  I put it on google when I went freelance (as [troyworks](http://www.troyworks.com/blog/)) , and it's helped keeping it on google, as the team and contributes to this project come from all over the world, and I'm a firm believer in open source.

The codebase covers a wide range of different things. While many parts exist in other projects on the web, some had to be recreated due to license differences (e.g. I can't use GPL in some commercial projects, and strongly prefer MIT), some due to philosophy differences (many libraries coming from AS2 linger in it's paradigm), some were inspired by wanting to just know how to do it.

This latest incarnation is a port of the Actionscript 2.0, and structured to be more maintainable as we get into Flash10, Actionscript 3.0+.   Converting the framework from AS2 to AS3 has been timeconsuming, given how different the languages are. The core is solid, some aspects like the Controls still have much work to be done.

99.9% of the code base is Pure AS3, so can be used in Flash or Flex or AIR development. Since there are no dependencies on Flex there is occasionally some overlap with features that exist in Flex, but on the brightside there is far less code in the framework.  At present there is no dependencies on Flash10 Vector, new rotations etc, but support is planned in 2009, in many cases this will maintain backwards compatibility with Flash9.

# Goals #

There are many independent overlapping goals for this project.  The first and formost is making my day to day life easier and reducing reinvention of the wheel for my team.

On one level it's a grab bag of independent parts/goals (data collections, utilities, prototyping, tweening, layout, etc) they as much any spoon or fork. The goal is to do the job necessary and be unobtrusive. Mix and match however needed.

Another higher level is a framework for building interactive projects faster, easier to skin, easier to prototype. Much of this is enabled by the [flowcontrol](http://troyworks.com/blog/2008/07/22/flash-fast-prototyping-and-sketching-ui-with-flowcontrol/) control.

Ontop of that are Controls and Applications.  Controls can be visual (e.g. buttons, autocomplete), or non-visual.  Applications and Examples being more stand alone.

The UI components tend to be small, with a focus on ease of skinning, typically by runtime binding. e.g. a UI.swf (no script) and a script.swf (no graphics), involving using ADDED to stage and instance name for binding, and faciliating iterated development, going from a wireframe to a momentum styled button /ui.

Having been the architect and interact for scores of large and simple projects, ranging from a few hours to years and millions of dollars long. The code is the embodiment of the "STOP" philosophy along the way to make successful projects. STOP stands for State and Transition Oriented Programming, it orthogonally compliments traditional OOP and MVC/UCM paradigms. It's sprinkled throughout.

The base is a statemachine library named [COGS](http://www.troyworks.com/cogs/) which supports complex event driven interactivity. It consists of
  * hierarchical statemachine
  * flat statemachine
  * composite (aka) pluggable statemachines.

Similar to Design Patterns, there are application behavior design patterns (aka. LifeCycles) a few patterns which I've codified, and try to extend, more are discovered everyday.

Some of these meta patterns:
  * Chain:  creating chains of tasks to perform in parallel or sequence. A workflow.
> > e.g. load config.xml->load all images/sounds in parallel-> present ui
  * Score:  A virtual playhead, across a multitrack sequencer, similar to that of Flash, After Fx etc. used to synchronize and schedule whatever.
  * Network:  a node and link based statemachine, useful for game maps.

There are other major inspirations
  * Java's spring Inversion of Control( IOC),
  * Prevayler for persistence and command,
  * Graph theory (I used to do work on AI/neural networks),

  * Tweening/easing equations (not just for tweening!).
  * [Dynamic Difficult Adjustment ](http://en.wikipedia.org/wiki/Dynamic_Difficulty_Adjustment)


> At the framework level is to be complimentary or competitive to other development, e.g. PureMVC, Cairgnorm.  Though they have different goals.

## CURRENT STATUS ##
It's solid enough to use in production, it's used in many games, websites, RIA, I and my team use parts of it in about every project, and we hammer on it weekly to make it better and more consistent,  though there are still major architectural changes planned.

I'm still wanting to add a few significant features before I spend time on full documentation, examples and evangelism. Sadly everything is on a backburner relative to my responsibilites at my startup, which eats up most my time.

I have gotten into presenting on parts (like Cogs and Tweeny), I'm always curious as to what people expect, like and dislike, and I'm using this feedback to improve things, again the goal is to make day to day development as easy as possible.
