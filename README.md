# Focused Labs Take-Home Exercise


## Prerequisites 
```bash
#what you need installed 
Ruby
Bundler 
```

## Installation


Use bundler to install the gems
```bash
#clone this repository
git@github.com:tmlane/focused-monpoke.git
#navigate into repo
bundle install 
```

## Usage

```bash
ruby monpoke.rb sample_input.txt #read from file path
ruby monpoke.rb < sample_input.txt  #read from STDin

#sample_file.txt has been included in repo for convenience
 

# Run tests
bundle exec rspec #run all tests


```





## Nomenclature

Variable| Description
:-----:|:-----:
`Game`| Obj: attrs: team_1, team_2, game_over, current_team, play_log
`Team`| Obj: attrs: id, monpokes, current_monpoke, graveyard
`Monpoke`| Obj: attrs: id, hp, ap
`monpokes`|Array of Monpoke objects belonging to a given Team




```
|    Class       |   Method             |
----------------------------------------
|  Monpoke       |    initialize        | 
|      ...       |    alive?            | 
|  Game          |    initialize        |
|      ...       |    ready_for_battle? |
|      ...       |    create_stage?     |
|      ...       |    choose_stage?     |
|      ...       |    play_turn?        |
|      ...       |    create            |
|      ...       |    opposite_team     |
|      ...       |    pass_turn         |
|      ...       |    attack            |
|      ...       |    opposite_team     |
|  Team          |    initialize        | 
|      ...       |    defeated?         | 
|      ...       |    choose            |
```

## Commands
```
CREATE <team-id> <monpoke-id> <hp> <ap>
> <monpoke-id> has been assigned to team <team-id>!

ATTACK
> <currect-monpoke-id> attacked <enemy-monpoke-id> for <curent-monpoke-id-AP> damage!

ICHOSEYOU <monpoke-id> 
> <Monpoke-id> has entered the battle!


```
## Note:
I ran in to some complications trying to stub out the ARGV / Stdin during testing. To work through this, I created the top level monpoke.rb as an implementation of the `MonpokeGame` module, so I could keep my existing tests for monpoke_game and continue coding. 
The tests in `Monpoke_game_spec.rb` were used to aid in development process, making it easy to quickly test drive and validate that the entire program is working / exiting as intended. 
If this were to be pushed to production, one would consider removing the larger tests or refactoring the tests to better match game_spec.rb.  I decided to keep these files in here in the spirit of transparency and to respect the time-box of the assignment.



Thanks for taking the time to review my submission. I'm looking forward to the opportunity to review my code with the team!

