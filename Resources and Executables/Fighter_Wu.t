% April 23 2017
% ICS3UI-01
% Mr. J-D
% A single figter in our game. Each fighter will be its own object.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
class Fighter_Wu
    
    inherit Fighter

    % procedures and functions
    body procedure initialize (left_key_, right_key_, up_key_, down_key_, attack_key_:char, stage_x_left_, stage_x_right_, stage_y_, player_number, lives_, player_colour_:int, other_player_:^Fighter)
        left_key:=left_key_
        right_key:=right_key_
        up_key:=up_key_
        down_key:=down_key_
        attack_key:=attack_key_
        stage_x_left:=stage_x_left_
        stage_x_right:=stage_x_right_
        stage_y:=stage_y_
        player_colour:=player_colour_
        other_player:=other_player_
        
        %initialize pic arrays
        if player_colour=black then % player is black
            right(pic_pose_run):=Pic.FileNew("right_run.bmp")
            right(pic_pose_jump1):=Pic.FileNew("right_jump.bmp")
            right(pic_pose_hit):=Pic.FileNew("right_hit.bmp")
            right(pic_pose_ground_hit):=Pic.FileNew("right_ground_hit.bmp")
            right(pic_pose_air_forward_hit):=Pic.FileNew("right_air_forward_hit.bmp")
            right(pic_pose_air_down_hit):=Pic.FileNew("right_air_down_hit.bmp")
            right(pic_pose_air_up_hit):=Pic.FileNew("right_air_up_hit.bmp")
            right(pic_pose_air_back_hit):=Pic.FileNew("right_air_back_hit.bmp")
            right(pic_pose_air_neutral_hit):=Pic.FileNew("right_air_neutral_hit.bmp")
            
            left(pic_pose_run):=Pic.FileNew("left_run.bmp")
            left(pic_pose_jump1):=Pic.FileNew("left_jump.bmp")
            left(pic_pose_hit):=Pic.FileNew("left_hit.bmp")
            left(pic_pose_ground_hit):=Pic.FileNew("left_ground_hit.bmp")
            left(pic_pose_air_forward_hit):=Pic.FileNew("left_air_forward_hit.bmp")
            left(pic_pose_air_down_hit):=Pic.FileNew("left_air_down_hit.bmp")
            left(pic_pose_air_up_hit):=Pic.FileNew("left_air_up_hit.bmp")
            left(pic_pose_air_back_hit):=Pic.FileNew("left_air_back_hit.bmp")
            left(pic_pose_air_neutral_hit):=Pic.FileNew("left_air_neutral_hit.bmp")
            
        elsif player_colour=purple then % player is purple
            right(pic_pose_run):=Pic.FileNew("right_run_p.bmp")
            right(pic_pose_jump1):=Pic.FileNew("right_jump_p.bmp")
            right(pic_pose_hit):=Pic.FileNew("right_hit_p.bmp")
            right(pic_pose_ground_hit):=Pic.FileNew("right_ground_hit_p.bmp")
            right(pic_pose_air_forward_hit):=Pic.FileNew("right_air_forward_hit_p.bmp")
            right(pic_pose_air_down_hit):=Pic.FileNew("right_air_down_hit_p.bmp")
            right(pic_pose_air_up_hit):=Pic.FileNew("right_air_up_hit_p.bmp")
            right(pic_pose_air_back_hit):=Pic.FileNew("right_air_back_hit_p.bmp")
            right(pic_pose_air_neutral_hit):=Pic.FileNew("right_air_neutral_hit_p.bmp")
            
            
            left(pic_pose_run):=Pic.FileNew("left_run_p.bmp")
            left(pic_pose_jump1):=Pic.FileNew("left_jump_p.bmp")
            left(pic_pose_hit):=Pic.FileNew("left_hit_p.bmp")
            left(pic_pose_ground_hit):=Pic.FileNew("left_ground_hit_p.bmp")
            left(pic_pose_air_forward_hit):=Pic.FileNew("left_air_forward_hit_p.bmp")
            left(pic_pose_air_down_hit):=Pic.FileNew("left_air_down_hit_p.bmp")
            left(pic_pose_air_up_hit):=Pic.FileNew("left_air_up_hit_p.bmp")
            left(pic_pose_air_back_hit):=Pic.FileNew("left_air_back_hit_p.bmp")
            left(pic_pose_air_neutral_hit):=Pic.FileNew("left_air_neutral_hit_p.bmp")
        end if
        
        current_image:=right(pic_pose_run)
        current_attack:=0
        facing_right:=true
        
        player_x:=player_number*400 % starting positions on the stage
        player_y:=stage_y 
        max_right_velocity:=10
        max_left_velocity:=-10
        
        velocity_x:=0
        velocity_y:=0
        
        percentage:=0
        lives:=lives_
        
        moveable:=true
        in_air:=false
        can_double_jump:=true
        jump_key_released:=true
        
        got_hit_timer:=0
        got_hit_counter:=0
        can_hit:=true
        got_hit:=false
        is_hitting:=false
        
        attack_hitbox_x:=1
        attack_hitbox_y:=1
        attack_velocity_x:=0
        attack_velocity_y:=0
        attack_velo_x_multiplier:=0
        attack_velo_y_multiplier:=0
        attack_hit_stun:=0
        attack_hit_stun_multiplier:=0
        is_hitting_timer:=0
        is_hitting_counter:=0
        
        in_cooldown:=false
        hit_cooldown_timer:=0
        hit_cooldown_counter:=0
        
        is_dead_counter:=0
        is_dead:=false
        
    end initialize
    
    
    % called when the jump key is pressed. Only executes when the jump key had not previously been pressed in (to prevent immediate double jumping) and when the fighter is on the ground, or for one jump in the air. Also initiates air velocity: if the player presses forward or backward while jumping, the ball will continue in the air after the direction has been released. It tests if is the person is going less than that max_x_velocity of the other direction, so that they cannot just jump out of hard hitting moves in the other diretion if they are going faster than the max_x_velocity
    body procedure jump(chars:array char of boolean)
        if (in_air=false) and (jump_key_released=true) then % jump off the ground
            velocity_y:=25
            in_air:=true
            can_double_jump:=true
            
            is_hitting:=false
            is_hitting_counter:=0
            is_hitting_timer:=0
            moveable:=true
            in_cooldown:=true % always the same cooldown after landing
            hit_cooldown_counter:=0
            hit_cooldown_timer:=3
            current_attack:=0
            
            if chars(left_key) and (velocity_x<=max_right_velocity) then % set the air velocity
                velocity_x:=max_left_velocity
                current_image:=left(pic_pose_jump1)
                facing_right:=false
            elsif chars(right_key) and (velocity_x>=max_left_velocity) then
                velocity_x:=max_right_velocity
                current_image:=right(pic_pose_jump1)
                facing_right:=true
            end if
            
        elsif(in_air=true) and (can_double_jump=true) and (jump_key_released=true) and (is_hitting=false) then % double jump
            velocity_y:=25
            can_double_jump:=false
            if chars(left_key) and (velocity_x<=max_right_velocity) then % set the air velocity
                velocity_x:=max_left_velocity
                current_image:=left(pic_pose_jump1)
                facing_right:=false
            elsif chars(right_key) and (velocity_x>=max_left_velocity)then
                velocity_x:=max_right_velocity
                current_image:=right(pic_pose_jump1)
                facing_right:=true 
                
            else velocity_x:=0 % they did not press anything, stop them in midair
            end if
        end if
        
        jump_key_released:=false
    end jump
    
    body procedure moveLeft
        if (in_air=false) and (player_x+max_left_velocity<stage_x_left) then % test if the player will fall off the stage to the left
            velocity_x:=max_left_velocity div 1.5 % give the player velocity, he is in the air
        elsif in_air=false then % the player is just on the stage
            player_x+=max_left_velocity
            current_image:=left(pic_pose_run)
            facing_right:=false
        elsif (in_air) and (velocity_x=max_left_velocity) then % the character is already going the maximum speed, do nothing
            velocity_x:=max_left_velocity
        elsif (in_air) and (velocity_x>max_left_velocity) then % the player is trying to go faster to the left
            velocity_x-=1 % make the player start going to the left
        end if
    end moveLeft
    
    body procedure moveRight
        if (in_air=false) and (player_x+max_right_velocity>stage_x_right) then % test if the player will fall off the stage to the right
            velocity_x:=max_right_velocity div 1.5 % give the player velocity, he is in the air
        elsif in_air=false then % the player is just on the stage
            player_x+=max_right_velocity
            current_image:=right(pic_pose_run)
            facing_right:=true
        elsif (in_air) and (velocity_x=max_right_velocity) then % the character is already going the maximum speed, do nothing
            velocity_x:=max_right_velocity
        elsif (in_air) and (velocity_x<max_right_velocity) then %  the player is trying to go faster to the right
            velocity_x+=1 % make the player start going to the right
        end if
    end moveRight
    
    body procedure doGroundForwardHit
        if (can_hit=true) and (is_hitting=false) and (in_air=false) then
            is_hitting:=true
            can_hit:=false
            moveable:=false
            is_hitting_timer:=12 
            hit_cooldown_timer:=12
            attack_hit_stun:=6
            attack_velocity_y:=5
            attack_velo_x_multiplier:=2.5
            attack_velo_y_multiplier:=0.6
            attack_hit_stun_multiplier:=0.5
            current_attack:=pic_pose_ground_hit
            % which way they are attacking
            attack_hitbox_y:=player_y + (35) % % same in both directions
            if facing_right= false then
                current_image:=left(pic_pose_ground_hit)
                attack_hitbox_x:=player_x
                attack_velocity_x:=-15
            elsif facing_right=true then
                current_image:=right(pic_pose_ground_hit)
                attack_hitbox_x:=player_x + pic_width
                attack_velocity_x:=15
            end if
        end if
    end doGroundForwardHit
    
    body procedure doAirForwardHit
        if (can_hit=true) and (is_hitting=false) and (in_air=true) then
            is_hitting:=true
            can_hit:=false
            moveable:=true
            is_hitting_timer:=15 
            hit_cooldown_timer:=18
            attack_hit_stun:=4
            attack_velocity_y:=5
            attack_velo_x_multiplier:=5
            attack_velo_y_multiplier:=0.4
            attack_hit_stun_multiplier:=2
            current_attack:=pic_pose_air_forward_hit
            % which way they are attacking
            attack_hitbox_y:=player_y + (40) % same in both directions
            if facing_right= false then
                current_image:=left(pic_pose_air_forward_hit)
                attack_hitbox_x:=player_x+5
                attack_velocity_x:=-8
            elsif facing_right=true then
                current_image:=right(pic_pose_air_forward_hit)
                attack_hitbox_x:=player_x + pic_width -5
                attack_velocity_x:=8
            end if
        end if
    end doAirForwardHit
    
    body procedure doAirDownHit
        if (can_hit=true) and (is_hitting=false) and (in_air=true) then
            is_hitting:=true
            can_hit:=false
            moveable:=true
            is_hitting_timer:=15 
            hit_cooldown_timer:=9
            attack_hit_stun:=13
            attack_velocity_y:=-15
            attack_velo_x_multiplier:=0.2
            attack_velo_y_multiplier:=2
            attack_hit_stun_multiplier:=4
            current_attack:=pic_pose_air_down_hit
            % which way they are attacking
            attack_hitbox_y:=player_y % same in both directions
            if facing_right= false then
                current_image:=left(pic_pose_air_down_hit)
                attack_hitbox_x:=player_x + (pic_width div 2)
                attack_velocity_x:=-1
            elsif facing_right=true then
                current_image:=right(pic_pose_air_down_hit)
                attack_hitbox_x:=player_x + (pic_width div 2)
                attack_velocity_x:=1
            end if
        end if
    end doAirDownHit
    
    body procedure doAirUpHit
        if (can_hit=true) and (is_hitting=false) and (in_air=true) then
            is_hitting:=true
            can_hit:=false
            moveable:=true
            is_hitting_timer:=12 
            hit_cooldown_timer:=12
            attack_hit_stun:=15
            attack_velocity_y:=15
            attack_velo_x_multiplier:=0.2
            attack_velo_y_multiplier:=1
            attack_hit_stun_multiplier:=2
            current_attack:=pic_pose_air_up_hit
            % which way they are attacking
            attack_hitbox_y:=player_y + pic_height + 20% same in both directions
            if facing_right= false then
                current_image:=left(pic_pose_air_up_hit)
                attack_hitbox_x:=player_x + (pic_width div 2)
                attack_velocity_x:=-1
            elsif facing_right=true then
                current_image:=right(pic_pose_air_up_hit)
                attack_hitbox_x:=player_x + (pic_width div 2)
                attack_velocity_x:=1
            end if
        end if
    end doAirUpHit
    
    body procedure doAirBackHit
        if (can_hit=true) and (is_hitting=false) and (in_air=true) then
            is_hitting:=true
            can_hit:=false
            moveable:=true
            is_hitting_timer:=15 
            hit_cooldown_timer:=18
            attack_hit_stun:=4
            attack_velocity_y:=5
            attack_velo_x_multiplier:=5
            attack_velo_y_multiplier:=0.4
            attack_hit_stun_multiplier:=1.5
            current_attack:=pic_pose_air_back_hit
            % which way they are attacking
            attack_hitbox_y:=player_y + (35) % same in both directions
            if facing_right= false then
                current_image:=left(pic_pose_air_back_hit)
                attack_hitbox_x:=player_x + pic_width + 10
                attack_velocity_x:=8
            elsif facing_right=true then
                current_image:=right(pic_pose_air_back_hit)
                attack_hitbox_x:=player_x - 10
                attack_velocity_x:=-8
            end if
        end if
    end doAirBackHit
    
    body procedure doAirNeutralHit
        if (can_hit=true) and (is_hitting=false) and (in_air=true) then
            is_hitting:=true
            can_hit:=false
            moveable:=true
            is_hitting_timer:=12 
            hit_cooldown_timer:=3
            attack_hit_stun:=15
            attack_velocity_y:=15
            attack_velo_x_multiplier:=0
            attack_velo_y_multiplier:=0
            attack_hit_stun_multiplier:=3.5
            current_attack:=pic_pose_air_neutral_hit
            % which way they are attacking
            attack_hitbox_y:=player_y + (55) % same in both directions
            if facing_right= false then
                current_image:=left(pic_pose_air_neutral_hit)
                attack_hitbox_x:=player_x
                attack_velocity_x:=-2
            elsif facing_right=true then
                current_image:=right(pic_pose_air_neutral_hit)
                attack_hitbox_x:=player_x + pic_width
                attack_velocity_x:=2
            end if
        end if
    end doAirNeutralHit
    
    
    % called by the other player object when this player is in the other player's hitbox
    % set the velocities to be the strength of the move and add the percentage of the player (scaled by the x/v_multipliers, so each move will have its own trajectories: eg some moves will always hit more horizontal, others vertical, some diagonal, even at high percents)
    body procedure onHit(velo_x, velo_y,  hit_stun:int, velo_x_multiplier, velo_y_multiplier, hitstun_multiplier:real)
        moveable:=false
        can_hit:=false
        is_hitting:=false
        got_hit:=true
        current_attack:=0
        in_cooldown:=false
        hit_cooldown_counter:=0
        percentage+=1 % add one to the percentage
        got_hit_counter:=0
        got_hit_timer:=hit_stun+round(hitstun_multiplier*percentage)
        
        % Test the y velocity
        if velo_y>0 then % they should go up
            velocity_y:=velo_y+round(velo_y_multiplier*percentage)
        elsif velo_y<0 then % they are being hit down
            if (in_air=true) then % spike them down
                velocity_y:=velo_y-round(velo_y_multiplier*percentage)
            elsif (in_air=false) then % make them bounce upwards, they are on the ground
                velocity_y:=-1*(velo_y-round(velo_y_multiplier*percentage)) % multiply by negative one for a positive velocity
            end if
        end if
        
        % test the x velocity
        if velo_x>0 then
            velocity_x:=velo_x+round(velo_x_multiplier*percentage) 
            current_image:=left(pic_pose_hit)
            facing_right:=false % the person got hit to the right, so make them face left
        elsif velo_x<0 then
            velocity_x:=velo_x-round(velo_x_multiplier*percentage)
            current_image:=right(pic_pose_hit)
            facing_right:=true % the person got hit to the left, so make them face right
        end if
    end onHit
    
    body procedure hasDied % called when the fighter is off the screen to far
        moveable:=false
        can_hit:=false
        is_hitting:=false
        is_dead:=true
        lives-=1
        percentage:=0
    end hasDied
    
    body procedure respawnPlayer % called when the player needs to respawn again
        moveable:=true
        jump_key_released:=true
        
        got_hit_timer:=0
        got_hit_counter:=0
        can_hit:=true
        got_hit:=false
        is_hitting:=false
        is_hitting_counter:=0
        is_hitting_timer:=0
        current_attack:=0
        
        current_image:=right(pic_pose_jump1)
        in_air:=true
        can_double_jump:=true
        current_attack:=0
        facing_right:=true
        
        player_x:=maxx div 2 % starting positions in the air above the stage
        player_y:=3*maxy div 4 
        
        
        velocity_x:=0
        velocity_y:=0
        
        percentage:=0
        
        in_cooldown:=false
        hit_cooldown_timer:=0
        hit_cooldown_counter:=0
        
        is_dead_counter:=0
        is_dead:=false  
    end respawnPlayer  
    
    body procedure updateAirMoveHitboxes
    % TEST FOR THE INDIVDUAL MOVES
                if current_attack=pic_pose_ground_hit then % you don't need to update this move, the hitbox does not change
                elsif current_attack=pic_pose_air_forward_hit then % FORWARD AIR
                    attack_hitbox_y:=player_y + (40)
                    if (facing_right=false) then
                        attack_hitbox_x:=player_x + 5
                    elsif (facing_right=true) then
                        attack_hitbox_x:=player_x + pic_width - 5
                    end if
                    
                elsif current_attack=pic_pose_air_down_hit then % DOWN AIR
                    attack_hitbox_y:=player_y
                    if (facing_right=false) then
                        attack_hitbox_x:=player_x  + (pic_width div 2)
                    elsif (facing_right=true) then
                        attack_hitbox_x:=player_x  + (pic_width div 2)
                    end if
                    
                elsif current_attack=pic_pose_air_up_hit then % UP AIR
                    attack_hitbox_y:=player_y + pic_height + 20
                    if (facing_right=false) then
                        attack_hitbox_x:=player_x  + (pic_width div 2)
                    elsif (facing_right=true) then
                        attack_hitbox_x:=player_x  + (pic_width div 2)
                    end if
                    
                    
                elsif current_attack=pic_pose_air_back_hit then % BACK AIR
                    attack_hitbox_y:=player_y + (35)
                    if (facing_right=false) then
                        attack_hitbox_x:=player_x + pic_width + 10
                    elsif (facing_right=true) then
                        attack_hitbox_x:=player_x - 10
                    end if
                    
                elsif current_attack=pic_pose_air_neutral_hit then % NEUTRAL AIR
                    attack_hitbox_y:=player_y + (55)
                    if (facing_right=false) then
                        attack_hitbox_x:=player_x
                    elsif (facing_right=true) then
                        attack_hitbox_x:=player_x  + pic_width
                    end if
                    
                    
                end if 
        end updateAirMoveHitboxes
    
    body procedure updateFighter
        if (is_dead=true) then % test if the player is dead
            is_dead_counter+=1
            if (is_dead_counter=is_dead_timer) then
                respawnPlayer
            end if
        else % the rest is executed only if the player is alive
            
            % UPDATE THE X, Y, BASED ON VELOCITIES
            velocity_y-=1 % REPLACE WITH A GRAVITY VARIABLE
            player_y+=round(velocity_y)
            
            %% Test if the player can move left or right (he cannot if he is hitting a wall)
            if (velocity_x<0) and (player_y<stage_y) and (player_x>stage_x_right) and (player_x+velocity_x<=stage_x_right) then % the player is below the stage to the right trying to go left -> He will hit a "wall" , so do nothing
            elsif (velocity_x>0) and (player_y<stage_y) and (player_x<stage_x_left) and (player_x+velocity_x>=stage_x_left) then % the player is below the stage to the left trying to go right -> He will hit a "wall", so do nothing
            else
                player_x+=velocity_x
            end if
            
            % Test is the player is dead. They are dead if they are further then 3 player widths to the left or right, 2 player widths below the screen, or 3 player widths above the screen
            if (player_x+pic_width<=-1*(3*pic_width)) or (player_x>=screen_width+(3*pic_width)) or (player_y<=-1*(2*pic_height)) or (player_y+pic_height>=screen_height+(3*pic_height)) then
                hasDied
            end if
            
            
            
            % TEST IF THE PLAYER IS IN MIDAIR
            if (player_x<stage_x_left) or (player_x>stage_x_right) or (player_y>stage_y) then % the player is off stage or above stage, must be in mid-air
                in_air:=true
            end if
            
            % SET THE IMAGE TO JUMPING IMAGE IF IN THE AIR AND ABLE TO MOVE AND NOT HITTING
            if (in_air=true) and (moveable=true) and (is_hitting=false) then
                if facing_right=false then
                    current_image:=left(pic_pose_jump1) % the player is facing left
                elsif facing_right then
                    current_image:=right(pic_pose_jump1)
                end if
            end if
            
            % SET X, Y TO THE GROUND IF ON THE STAGE. IF ABLE TO MOVE, SET THE IMAGE BACK TO THE STADING IMAGE. IF THEY WERE ATTACKING AND JUST LANDED, STOP THEM FROM ATTACKING AND SET THEIR COOLDOWN TO 6.
            if (player_y <= stage_y) and (player_x>stage_x_left) and (player_x<stage_x_right) then % player is on the stage

                
                if (is_hitting=true) and (in_air=true) then % They were attacking and now they are landing on the ground
                is_hitting:=false
                is_hitting_counter:=0
                is_hitting_timer:=0
                moveable:=true
                
                in_cooldown:=true % always the same cooldown after landing
                hit_cooldown_counter:=0
                hit_cooldown_timer:=6
                
                current_attack:=0
                end if
            
                if moveable=true then
                    if facing_right=false then
                        current_image:=left(pic_pose_run)
                    else
                        current_image:=right(pic_pose_run)
                    end if
                end if
                
                player_y := stage_y
                in_air:=false
                can_double_jump:=true
                velocity_y:=0
                velocity_x:=0
            end if
            
            
            % if they have been hit, update the counter and check if they can now move
            if (got_hit=true) and (moveable=false) then
                got_hit_counter+=1
                if got_hit_counter=got_hit_timer then % they can move
                    got_hit:=false
                    got_hit_counter:=0
                    got_hit_timer:=0
                    moveable:=true
                    can_hit:=true
                    is_hitting:=false
                end if
            end if
            
            % if attacking, test if you hit the player
            if (is_hitting=true) and (can_hit=false) then
                other_player_x:=Fighter(other_player).player_x
                other_player_y:=Fighter(other_player).player_y % get the other player's postition
                is_hitting_counter+=1
                
                updateAirMoveHitboxes
                
                %drawfilloval(attack_hitbox_x, attack_hitbox_y, 2, 2, red) % draw the hitbox
                if (attack_hitbox_x >= other_player_x) and (attack_hitbox_x<=other_player_x+pic_width) and (attack_hitbox_y>=other_player_y) and (attack_hitbox_y<=other_player_y+pic_height) then % the other player is in this player's hitbox!
                %%% WU SPECIAL POWER -> ZEN -> 0.3 extra knockback based on Wu's percent!
                %%% WU HITS OTHER PLAYERS FURTHER BASED ON HOW MUCH PERCENT HE HAS *and* how much percent they have. eg if they are at 0% and Wu is at 10%, Wu will hit them further than if he was at 0%. Normal knockback also aplies: If they are at 10%, they will fly further than if they are at 0%.
                    if (attack_velocity_x >= 0) and (attack_velocity_y>=0) then % up and right
                    Fighter(other_player).onHit(attack_velocity_x + round(0.3*attack_velo_x_multiplier*percentage), attack_velocity_y + round(0.3*attack_velo_y_multiplier*percentage), attack_hit_stun, attack_velo_x_multiplier, attack_velo_y_multiplier, attack_hit_stun_multiplier) % hit the other player
                    elsif (attack_velocity_x <= 0) and (attack_velocity_y>=0) then % up and left
                    Fighter(other_player).onHit(attack_velocity_x - round(0.3*attack_velo_x_multiplier*percentage), attack_velocity_y + round(0.3*attack_velo_y_multiplier*percentage), attack_hit_stun, attack_velo_x_multiplier, attack_velo_y_multiplier, attack_hit_stun_multiplier) % hit the other player
                    elsif (attack_velocity_x >= 0) and (attack_velocity_y<=0) then % down and right
                    Fighter(other_player).onHit(attack_velocity_x + round(0.3*attack_velo_x_multiplier*percentage), attack_velocity_y - round(0.3*attack_velo_y_multiplier*percentage), attack_hit_stun, attack_velo_x_multiplier, attack_velo_y_multiplier, attack_hit_stun_multiplier) % hit the other player
                    elsif (attack_velocity_x <= 0) and (attack_velocity_y<=0) then % down and left
                    Fighter(other_player).onHit(attack_velocity_x - round(0.3*attack_velo_x_multiplier*percentage), attack_velocity_y - round(0.3*attack_velo_y_multiplier*percentage), attack_hit_stun, attack_velo_x_multiplier, attack_velo_y_multiplier, attack_hit_stun_multiplier) % hit the other player
                    
                    end if
                end if
                
                % test if they are done hitting
                if (is_hitting_counter=is_hitting_timer) then % you are done hitting
                    is_hitting:=false
                    in_cooldown:=true
                    moveable:=true
                    is_hitting_counter:=0
                    is_hitting_timer:=0
                    current_attack:=0
                end if
            end if 
            
            % test if they are in cooldown, and set their can_attack to true if they are done cooldown
            if (in_cooldown=true) then
                hit_cooldown_counter+=1
                if (hit_cooldown_counter=hit_cooldown_timer) then % the cooldown is complete
                    can_hit:=true
                    in_cooldown:=false
                    hit_cooldown_counter:=0
                end if
            end if
            
            % draw hitboxes, for testing
            %drawline(player_x, player_y, player_x, player_y+pic_height, blue)
            %drawline(player_x, player_y, player_x+pic_width, player_y, blue)
            %drawline(player_x, player_y+pic_height, player_x+pic_width, player_y+pic_height, blue)
            %drawline(player_x+pic_width, player_y, player_x+pic_width, player_y+pic_height, blue)
            
            
        end if
    end updateFighter
    
    
    body procedure drawFighter
        if (current_attack=pic_pose_air_down_hit) or (current_attack=pic_pose_air_back_hit) and (is_hitting=true) then
            Pic.Draw(current_image, player_x - (15), player_y, picMerge) % % FOR DOWN AIR, iT is 90 across, so subtract 15 from the left when drawing it
        else
            Pic.Draw(current_image, player_x, player_y, picMerge)
        end if
    end drawFighter
    
    body procedure handleChars(chars:array char of boolean)    
        
        if moveable=true then
            if chars (up_key) then
                jump(chars)
            else
                jump_key_released:=true
            end if 
            
            if chars(left_key) and (player_y<stage_y) and (player_x>stage_x_right) and (player_x+max_left_velocity<=stage_x_right) then % the player is below the stage to the right trying to go left -> He will hit a "wall" , so do nothing
            elsif chars(left_key) then % the player is ok
                moveLeft
            elsif chars (right_key) and (player_y<stage_y) and (player_x<stage_x_left) and (player_x+max_right_velocity>=stage_x_left) then % the player is below the stage to the left trying to go right -> He will hit a "wall", so do nothing
            elsif chars(right_key) then % the player is ok
                moveRight
            end if
            
            % so they can fast fall
            if (in_air) and chars(down_key) then
                velocity_y-=1
            end if
            
            
            if (in_air=false) then
                if chars(attack_key) then
                    doGroundForwardHit
                end if
                
            elsif (in_air=true) then
                if (chars(down_key)) and (chars(attack_key)) then
                    doAirDownHit
                elsif (chars(up_key)) and (chars(attack_key)) then
                    doAirUpHit
                elsif (facing_right=true) and (chars(attack_key)) and (chars(right_key)) then
                    doAirForwardHit
                elsif (facing_right=false) and (chars(attack_key)) and (chars(left_key)) then
                    doAirForwardHit
                elsif (facing_right=true) and (chars(attack_key)) and (chars(left_key)) then
                    doAirBackHit
                elsif (facing_right=false) and (chars(attack_key)) and (chars(right_key)) then
                    doAirBackHit
                elsif (chars(attack_key)) then
                    doAirNeutralHit
                    
                end if
                
                
            end if
            
            
            
        else 
        end if
        
        updateFighter
        drawFighter
        
    end handleChars
    
end Fighter_Wu

