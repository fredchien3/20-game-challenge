Learned:
- Inheritance (Log and Car inherit from LaneObject)
- 

Could improve:
- Making the log and river responsible for detecting frog collision made the follow_log and drowning states pretty buggy and brittle.
	- I think if I reversed the responsibilities and made the frog observe for river and/or log collision per frame it would be more foolproof
