# Outhaul :sailboat:
A Document format for your Pivotal Tracker Projects.

Outhaul is a Ruby script that maps a HTML document to a Pivotal Tracker project.   

It allows you to create Epics and outline Stories through your editor of choice.   Once saved as HTML, 
Outhaul will translate HTML file into Epics and Stories in Tracker.  It's actually quite simple. 

## Document Outline

`H1` elements represent Epics.   
`H2` elements represent Stories. 

### Epic and Story Names

```html
<h1>Outhaul MVP</h1>
<h2>Export H1 as a Epic</h2>
<h2>Export H2 as a Story</h2>
```

The above HTML document run through Outhaul will create one Epic named *Outhaul MVP*, 
and two stories presented by by the two `h2` tags.  The two Stories will be tagged with the
*Outhaul MVP* epic label.

### Descriptions

Descriptions are created from HTML represented between the Outline tags.   In this example,
we provide descriptions for the Epic and Stories.
```html
<h1>Outhaul MVP</h1>
<p>Create a Ruby script that maps a HTML Document to Tracker Epics and Stories</p>
<h2>Export H1 as a Epic</h2>
<p>Any H1 in the Document should create a Tracker Epic.</p> 
<h2>Export H2 as a Story</h2>
<p>Any H2 in the Document should create a Tracker Epic.</p> 
```

The above would create one Epic and two Stories, each would include the description text paragraph.

### Epic and Story Links

Epic and Story headers can be mapped to existing Tracker resources by encapsulating the headers with
the link to the Tracker resource.

```html
<h1><a href="https://www.pivotaltracker.com/epic/show/0000000">Outhaul MVP</a></h1>
```

The above would map the *Outhaul MVP* Epic to a the Tracker Epic with the id `0000000`.   With the link established
our Epics will be updated rather than created when Outhauled.
