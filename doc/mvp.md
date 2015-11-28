# [Outhaul MVP (MVP)](https://www.pivotaltracker.com/epic/show/2207162)

Write a command line Ruby script that transforms a HTML document into Pivotal Tracker Epic and Stories.

## [Epic Creation](https://www.pivotaltracker.com/story/show/109090660)

As a Product Manager,

So that I may publish Epics to Tracker from my Document,

Create Epics from the H1 elements in my Document.

**Given**

*   List item
*   A Document

**With**

*   `H1` element

**When**

*   I invoke Outhaul from the command line

**Then**

*   An Epic is created in Tracker

## [Story Creation](https://www.pivotaltracker.com/story/show/109090662)

As a Product Manager, 

So that I may publish Stories from my Document to Tracker, 

Create a Story for every `H2` element in my Document

**Given**

*   A Document
*   With a `H2` element

**When**

*   I invoke Outhaul from the command line

**Then**

*   A Story is created in Tracker*
*   The title of the Story matches the `H2` text