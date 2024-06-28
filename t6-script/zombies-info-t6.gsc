#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;

init()
{
    iprintlnbold("  Zombies Info Initialized Successfully  ");
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for( ;; )
    {
        level waittill( "connecting", player );
        player thread onplayerspawned();
        player thread healthCounter();
    }
}

healthCounter(){
    self endon ("disconnect");
    level endon( "end_game" );
    common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    self.healthText = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.5);
    self.healthText maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", 50, 200);
    self.healthText.label = &"Health: ^2";
    while ( 1 ) {
        if (self.health > 75) {
            self.healthText setText("^2" + self.health + "%"); // Green
        } else if (self.health > 50) {
            self.healthText setText("^3" + self.health + "%"); // Yellow
        } else if (self.health > 25) {
            self.healthText setText("^6" + self.health + "%"); // Orange
        } else {
            self.healthText setText("^1" + self.health + "%"); // Red
        }
        wait 0.25;
    }
}

onplayerspawned(){
    self endon("disconnect");
    self thread zombie_counter();
    for(;;){
        self waittill("spawned_player");
    }
}

zombie_counter(){
    level endon( "game_ended" );
    self endon("disconnect");
    flag_wait( "initial_blackscreen_passed" );
    self.zombiecounter = createfontstring( "Objective", 1.7 );
    self.zombiecounter setpoint( "CENTER", "CENTER", -50, 200 );
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
