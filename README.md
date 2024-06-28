# Zombie Info Script for BO2 Plutonium

## Description

This script is a mod for **Call of Duty: Black Ops II - Plutonium** that displays an on-screen counter for the remaining zombies and the zombies killed by each player. It utilizes several BO2 utility files to handle events and update the user interface in real-time.

## Included Files

The script includes the following utility files:

- maps\mp\_utility
- common_scripts\utility
- maps\mp\gametypes_zm\_hud_util
- maps\mp\gametypes_zm\_hud_message
- maps\mp\zombies\_zm_utility

## Script Functions

### init()

The init() function runs at the start of the script. It prints a message to the console indicating that the script has started and launches a thread that calls the onPlayerConnect() function.

```gsc
init()
{
    println("^2*** Zombie info Script started ***");
    level thread onPlayerConnect();
}
```

### onPlayerConnect()

The onPlayerConnect() function waits for a player to connect to the server. When a player connects, it calls the onplayerspawned() function in a new thread for that player.

```gsc
onPlayerConnect()
{
    for( ;; )
    {
        level waittill( "connecting", player );
        player thread onplayerspawned();
    }
}

```

### onplayerspawned()

The onplayerspawned() function runs whenever a player respawns. It starts two threads to handle the zombie counters:

- zombie_counter(): Displays the number of zombies left.
- zombie_kills_counter(): Displays the number of zombies killed by the player.

```gsc
onplayerspawned(){
    self endon("disconnect");
    self thread zombie_counter();
    self thread zombie_kills_counter();
    for(;;){
        self waittill("spawned_player");
    }
}
```

### zombie_counter()

The zombie_counter() function displays the number of zombies left on the player's screen. It updates the counter in real-time and adjusts the transparency when the player is in "afterlife" mode.

```gsc
zombie_counter(){
    level endon( "game_ended" );
    self endon("disconnect");
    flag_wait( "initial_blackscreen_passed" );
    self.zombiecounter = createfontstring( "Objective", 1.7 );
    self.zombiecounter setpoint( "CENTER", "CENTER", 0, 200 );
    self.zombiecounter.alpha = 1;
    self.zombiecounter.hidewheninmenu = 1;
    self.zombiecounter.hidewhendead = 1;
    self.zombiecounter.label = &"Zombies Left: ^1";
    for(;;){
        if(isdefined(self.afterlife) && self.afterlife){
            self.zombiecounter.alpha = 0.2;
        } else {
            self.zombiecounter.alpha = 1;
        }
        self.zombiecounter setvalue( level.zombie_total + get_current_zombie_count() );
        wait 0.05;
    }
}
```

### zombie_kills_counter()

The zombie_kills_counter() function displays the number of zombies killed by the player. It updates the counter in real-time whenever the player kills a zombie.

```gsc
zombie_kills_counter(){
    self.zombie_kills = 0;
    self.zombiekillslabel = createfontstring("hudsmall", 1.0);
    self.zombiekillslabel setpoint("CENTER", "CENTER", 0, 220);
    self.zombiekillslabel.color = (1, 1, 1);
    self.zombiekillslabel settext("Zombies Eliminated: 0");
    self.zombiekillslabel.alpha = 1;
    self.zombiekillslabel.hidewheninmenu = 1;
    self.zombiekillslabel.hidewhendead = 1;

    for(;;){
        self waittill("zombie_death");
        self.zombie_kills++;
        self.zombiekillslabel settext("Zombies Eliminated: " + self.zombie_kills);
    }
}
```

# Installation

- Download the script and place the file in the scripts folder of your BO2 Plutonium installation **C:\Users\your-user\AppData\Local\Plutonium\storage\t6\scripts\zm.**
  
- Ensure the necessary utility files are included at the beginning of the script.
- Run the game and load the script.

# Notes

- The script uses threads to handle events and update the user interface in real-time.
- Ensure the mentioned utility files are available and correctly included in your BO2 Plutonium installation.

This script is a useful tool for players who want to have a real-time view of the remaining zombies and the zombies they have killed during the game.
