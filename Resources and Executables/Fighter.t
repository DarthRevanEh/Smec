% April 23 2017
% ICS3UI-01
% Mr. J-D
% A single figter in our game. Each fighter will be its own object.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
class Fighter
    
    export handleChars,initialize,onHit,player_x,player_y, percentage, lives, jump_key_released,can_double_jump % exported procedures and variables
    
    
    % Local variable
    var other_player:^Fighter %stores a reference to the other fighter
    var other_player_x, other_player_y:int % position of the other player on the screen
    var max_right_velocity,max_left_velocity:int % maximum speed a character can go on their own
    
    const pic_width:=60
    const pic_height:=80 % height and width of the picture
    const screen_width:=1208
    const screen_height:=1024 % width and height of the screen
    
   
    const pic_pose_run:=1
    const pic_pose_jump1:=2
    const pic_pose_jump2:=3
    const pic_pose_hit:=4
    const pic_pose_ground_hit:=5
    const pic_pose_air_forward_hit:=6
    const pic_pose_air_down_hit:=7
    const pic_pose_air_up_hit:=8
    const pic_pose_air_back_hit:=9
    const pic_pose_air_neutral_hit:=10
    
    var right, left:array 1..10 of int
    
    
    
    
    var player_colour:int % player colour
    var current_image:int % current image being displayed
    var current_attack:int % current attack of the player
    var lives:int % how many lives the player has
    var left_key, right_key, up_key, down_key, jump_key, attack_key:char
    var player_x, player_y:int
    var velocity_x:int 
    var velocity_y:real
    var percentage:int % adds to the velocity and increases every time a player is hit, meaning that over time players take more knockback
    
    
    var jump_key_released, can_double_jump:boolean % stores the state of whether or not the player has a mid-air jump
    var stage_x_left, stage_x_right, stage_y:int
    
    var facing_right:boolean % keeps track of the direction of the character
    var in_air:boolean % stores if they are in the air
    var moveable:boolean % stores if they can move
    
    var got_hit_timer:int % stores how long they have until they can move after being hit (pass in from hitter)
    var got_hit_counter:int % counts up. when equal to got_hit_timer, they can move
    var can_hit:boolean % stores whether or not the character can do an attack
    var got_hit:boolean % true if the user was hit and cannot move because of it
    var is_hitting:boolean % true if the character is in the process of hitting
    
    var attack_hitbox_x, attack_hitbox_y:int % pixel positions of the hitbox of the character's current move
    var attack_velocity_x,attack_velocity_y:int % velocity that a move will send the player it hits
    var attack_velo_x_multiplier, attack_velo_y_multiplier:real % works with percentage to increase knockback as the character is hit more
    var attack_hit_stun:int % time that the move will stun for (passed out when the character hits someone else)
    var attack_hit_stun_multiplier:real % works with percentage to increase hitstun as the character is hit more
    var is_hitting_timer:int % stores how long they have until they can move after hitting (each move has a different duration)
    var is_hitting_counter:int % counts up. when equal to is_hitting_timer, their move is done and they can move
    
    var in_cooldown:boolean % tests if they are in cooldown or not
    var hit_cooldown_timer:int % stores how long it is until they can hit again after the move is used
    var hit_cooldown_counter:int % when equal to hit_cooldown_timer, they can hit again
    
    var is_dead_counter:int
    const is_dead_timer:int:=8 % timer and counter for how long it had been scince a person died
    var is_dead:boolean
    
    % procedures and functions
    deferred procedure initialize (left_key_, right_key_, up_key_, down_key_, attack_key_:char, stage_x_left_, stage_x_right_, stage_y_, player_number, lives_, player_colour_:int, other_player_:^Fighter) % sets up each player object with the correct movement keys. Also, takes the stage coordinated, the lives, the colour, and a reference to the other player (for getting hitboxes)
    
    % called when the jump key is pressed. Only executes when the jump key had not previously been pressed in (to prevent immediate double jumping) and when the fighter is on the ground, or for one jump in the air. Also initiates air velocity: if the player presses forward or backward while jumping, the ball will continue in the air after the direction has been released. It tests if is the person is going less than that max_x_velocity of the other direction, so that they cannot just jump out of hard hitting moves in the other diretion if they are going faster than the max_x_velocity
    deferred procedure jump(chars:array char of boolean) % makes the player jump. Also, makes them go left or right if those are being pressed
    
    deferred procedure moveLeft % called when the left key is pressed. Makes the user go left if able. Also slows them down if already travelling right in the air
    
    deferred procedure moveRight % called when the right key is pressed. Makes the user go right if able. Also slows them down if already travelling left in the air
    
    deferred procedure doGroundForwardHit % their attack on the ground
    
    deferred procedure doAirForwardHit % their attack in the air, forward
    
    deferred procedure doAirDownHit % their attack in the air, down
    
    deferred procedure doAirUpHit % their attack in the air, up
    
    deferred procedure doAirBackHit % their attack in the air, back
     
    deferred procedure doAirNeutralHit % their attack in the air, when do other keys are pressed
    
    
    % called by the other player object when this player is in the other player's hitbox
    % set the velocities to be the strength of the move and add the percentage of the player (scaled by the x/v_multipliers, so each move will have its own trajectories: eg some moves will always hit more horizontal, others vertical, some diagonal, even at high percents)
    deferred procedure onHit(velo_x, velo_y,  hit_stun:int, velo_x_multiplier, velo_y_multiplier, hitstun_multiplier:real) 
    
    deferred procedure hasDied % called when the fighter is off the screen to far

    deferred procedure respawnPlayer % called when the player needs to respawn again
    
    deferred procedure updateAirMoveHitboxes % updates the user's hitboxes when they are doing an aireal move, to keep the hitbox moving with the player


    deferred procedure updateFighter % Updates the fighters values. Accounts for gravity, attacking, getting hit, etc. Most of the important stuff happends here


    deferred procedure drawFighter % draws the fighter. Sometimes, depending on the move, will draw the fighter -15 or so in the x direction. This is to keep the fighter centered if a specific move has larger dimensions than 60x80 (the default size).


    deferred procedure handleChars(chars:array char of boolean) % when the game is running, every key on the keyboard is passed into each fighter. This method takes all the keys and does things based on which keys are being pressed, specific to each fighter (eg move left, hit, etc)    



end Fighter

