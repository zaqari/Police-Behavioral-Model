# PoliceReform-BehavioralModel
## Project Description
The following is the R code and JAGS scripts for a Bayesian Cognitve model analyzing the rate of use of force, or incarcerations made by police officers within communities. Note: the data used is just toy, fabricated data to show how the model might work. If you intend to use this model legitimately, you'll need to supply your own data--I'll walk through how the data should be structured to seemlessly use these scripts in the first section below.  

I've included five different models that one can apply to this question, that people can try out. I'll describe each model below so that you can make a decision about how you'd want to proceed with using it if it interests you to do so.

Last note: all of these are 100% free to use! If you want to take these scripts, play with them, apply them to other problems, you by all means can do so! If you want any help in implementing these models, feel free to reach out to me at zrosen@uci.edu.

## Data Structure
Let's say you want to swap out my made up data with real data. How would you do that? So the models all assume that you have a known number of officers, with a known number of complaints levied against them per each of the communities that they have been on patrol in to start. This is represented in how the data is structured. What you would need to do to swap in your own data would be to assign a data.frame() that has one row per each officer, with one column for as many communities as you're interested in. So, for example . . . 

| Officer #   | Community 1 | Community 2 | Community 3 | . . . | Community Z |
|-------------|-------------|-------------|-------------|-------|-------------|
| 001         | 0           | 1           | 5           | . . . | 3           |
| 002         | 2           | 3           | 6           | . . . | 2           |
| 003         | 1           | 1           | 3           | . . . | 2           |
| . . .       | . . .       |  . . .      | . . .       | . . . | . . .       |
| 100         | 4           | 1           | 10          | . . . | 4           |
