% April 23 2017
% ICS3UI-01
% Mr. J-D
% The program that initializes and plays the game. Also listens for and handles key inputs.
% YOUR RESOLUTION MUST BE 1280 x 1024 FOR THIS GAME TO WORK PROPERLY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import GUI
include "Fighter.t"
include "Fighter_Wu.t"
include "Fighter_Dante.t"
include "Fighter_Cannon.t"

% Global variables and initalization
var zero_percent:=Pic.FileNew("0_.bmp")
var percents:array 1..11 of int
percents(1):=Pic.FileNew("1_.bmp")
percents(2):=Pic.FileNew("2_.bmp")
percents(3):=Pic.FileNew("3_.bmp")
percents(4):=Pic.FileNew("4_.bmp")
percents(5):=Pic.FileNew("5_.bmp")
percents(6):=Pic.FileNew("6_.bmp")
percents(7):=Pic.FileNew("7_.bmp")
percents(8):=Pic.FileNew("8_.bmp")
percents(9):=Pic.FileNew("9_.bmp")
percents(10):=Pic.FileNew("10_.bmp")
percents(11):=Pic.FileNew("10+_.bmp")
var heart_image:=Pic.FileNew("heart.bmp")

var background:int:=Pic.FileNew("background.jpg") 

var p1color:int:=black
var p2color:int:=black
var player_one:^Fighter
var player_two:^Fighter


var game_winner:int:=0 % winner of the last game to be played


View.Set("graphics:max;max,nobuttonbar")
var menubackground:int:=Pic.FileNew("menu background.jpg") 
var CharSel:int:=Pic.FileNew("CharSel1.jpg")
var CharSel2:int:=Pic.FileNew("CharSel2.jpg")


% Procedures and functions
function getPercentImage(percent:int):int % takes a percent , and returns the imace of the percent that matches the entered percent 
    case percent of
    label 0:    result zero_percent
    label 1:    result percents(1)
    label 2:    result percents(2)
    label 3:    result percents(3)
    label 4:    result percents(4)
    label 5:    result percents(5)
    label 6:    result percents(6)
    label 7:    result percents(7)
    label 8:    result percents(8)
    label 9:    result percents(9)
    label 10:   result percents(10)
    label:      result percents(11) % the player is over 10 percent
    end case
end getPercentImage

% playing the game
procedure playSingleGame % returns 1 or 2, depending on who wins
    % function variable
    Pic.Draw(background,0,0,picCopy)
    View.Set("offscreenonly")
    var percent_player_one_image, percent_player_two_image:int % current image of each player's percent, for drawing
    var player_one_scroll, player_two_scroll:int % background scroll images for holding the percents
    
    var player_one_lives, player_two_lives:int % keeps track of the players lives
    var winner:int % 1 or 2, depending on who wins
    
    player_one_lives:=5
    player_two_lives:=5
    
    player_one_scroll:=Pic.FileNew("player1scroll.bmp")
    player_two_scroll:=Pic.FileNew("player2scroll.bmp")
    
    
    Fighter(player_one).initialize('a','d','w','s','g',175,1035,400, 1,player_one_lives,p1color, player_two)
    Fighter(player_two).initialize(KEY_LEFT_ARROW,KEY_RIGHT_ARROW,KEY_UP_ARROW,KEY_DOWN_ARROW, '0',175,1035,400, 2,player_two_lives,p2color,player_one) % initialize fighter using stage sizes and keyboard keys
    
    var chars : array char of boolean 
    
    loop 
	Pic.Draw(background,-5,0,picCopy)
	Input.KeyDown (chars)
	
	Fighter(player_one).handleChars(chars)
	Fighter(player_two).handleChars(chars)
	
	percent_player_one_image:=getPercentImage(Fighter(player_one).percentage)
	percent_player_two_image:=getPercentImage(Fighter(player_two).percentage) % set the percent images correctly
	player_one_lives:=Fighter(player_one).lives
	player_two_lives:=Fighter(player_two).lives % get the current lives of the players
	
	if (player_two_lives=0) and (player_one_lives not=0) then % player two is dead, player one is the winner
	    game_winner:=1
	    exit
	elsif (player_one_lives=0) and (player_two_lives not=0) then % player one is dead, player two is the winner
	    game_winner:=2
	    exit
	elsif (player_one_lives=0) and (player_two_lives =0) then % player one and two are dead, they must have died at the same time
	    game_winner:=3
	    exit
	end if
	
	Pic.Draw(player_one_scroll, 3*maxx div 8 -200 , maxy div 8, picMerge)
	Pic.Draw(player_two_scroll, 5*maxx div 8, maxy div 8, picMerge) % draw the scrolls
	Pic.Draw(percent_player_one_image, 3*maxx div 8 + 50 - 200, maxy div 7, picMerge)
	Pic.Draw(percent_player_two_image, 5*maxx div 8 + 50, maxy div 7, picMerge) % draw the percents
	
	for counter: 1..player_one_lives % for each of player one's lives, draw it
	    Pic.Draw(heart_image, 3*maxx div 8 -200 + (25*(counter)) + 15, maxy div 5 + 20, picMerge)
	end for
	    for counter: 1..player_two_lives % for each of player two's lives, draw it
	    Pic.Draw(heart_image, 5*maxx div 8 + (25*(counter)) + 15, maxy div 5 + 20, picMerge)
	end for
	    
	
	
	View.Update
	delay(15)
	cls
	
    end loop
end playSingleGame

procedure SelChar
    cls
    Pic.Draw(CharSel,-5,0,picCopy)
    GUI.Quit
end SelChar

procedure p1ab
    %var player_one:^Fighter_Cannon
    new Fighter_Cannon, player_one
    p1color:=black
    GUI.Quit
    cls
    Pic.Draw(CharSel2,-5,0,picCopy)
end p1ab

procedure p1ag
    %var player_one:^Fighter_Cannon
    new Fighter_Cannon, player_one
    p1color:=green
    GUI.Quit
    cls
    Pic.Draw(CharSel2,-5,0,picCopy)
end p1ag

procedure p1db
    %var player_one:^Fighter_Dante
    new Fighter_Dante, player_one
    p1color:=black
    GUI.Quit
    cls
    Pic.Draw(CharSel2,-5,0,picCopy)
end p1db

procedure p1dr
    %var player_one:^Fighter_Dante
    new Fighter_Dante, player_one
    p1color:=red
    GUI.Quit
    cls
    View.Update
    Pic.Draw(CharSel2,-5,0,picCopy)
end p1dr

procedure p1wb
    %var player_one:^Fighter_Wu
    new Fighter_Wu, player_one
    p1color:=black
    GUI.Quit
    cls
    Pic.Draw(CharSel2,-5,0,picCopy)
end p1wb

procedure p1wp
    %var player_one:^Fighter_Wu
    new Fighter_Wu, player_one
    p1color:=purple
    GUI.Quit
    cls
    Pic.Draw(CharSel2,-5,0,picCopy)
end p1wp

procedure p2ab
    %var player_two:^Fighter_Cannon
    new Fighter_Cannon, player_two
    p2color:=black
    GUI.Quit
    %playSingleGame
end p2ab

procedure p2ag
    %var player_two:^Fighter_Cannon
    new Fighter_Cannon, player_two
    p2color:=green
    GUI.Quit
    %playSingleGame
end p2ag

procedure p2db
    %var player_two:^Fighter_Dante
    new Fighter_Dante, player_two
    p2color:=black
    GUI.Quit
    %playSingleGame
end p2db

procedure p2dr
    %var player_two:^Fighter_Dante
    new Fighter_Dante, player_two
    p2color:=red
    GUI.Quit
    %playSingleGame
end p2dr

procedure p2wb
    %var player_two:^Fighter_Wu
    View.Update
    new Fighter_Wu, player_two
    p2color:=black
    GUI.Quit
    %playSingleGame
end p2wb

procedure p2wp
    %var player_two:^Fighter_Wu
    new Fighter_Wu, player_two
    p2color:=purple
    GUI.Quit
    %playSingleGame
end p2wp

var play_button:=GUI.CreateButtonFull(maxx div 2-200,maxy div 2-275,400,"Play",SelChar,100,'p',false)

var player1astroblack:int:=GUI.CreateButtonFull(maxx div 14,maxy div 2-325,300,"Choose Black",p1ab,75,'p',false)
var player1astrogreen:int:=GUI.CreateButtonFull(maxx div 14,maxy div 2-425,300,"Choose Green",p1ag,75,'p',false)
var player1danteblack:int:=GUI.CreateButtonFull(maxx div 2.55,maxy div 2-325,300,"Choose Black",p1db,75,'p',false)
var player1dantered:int:=GUI.CreateButtonFull(maxx div 2.55,maxy div 2-425,300,"Choose Red",p1dr,75,'p',false)
var player1wublack:int:=GUI.CreateButtonFull(maxx div 1.41,maxy div 2-325,300,"Choose Black",p1wb,75,'p',false)
var player1wupurple:int:=GUI.CreateButtonFull(maxx div 1.41,maxy div 2-425,300,"Choose Purple",p1wp,75,'p',false)

    GUI.Hide(player1astroblack)
    GUI.Hide(player1astrogreen)
    GUI.Hide(player1danteblack)
    GUI.Hide(player1dantered)
    GUI.Hide(player1wublack)
    GUI.Hide(player1wupurple)

var player2astroblack:int:=GUI.CreateButtonFull(maxx div 14,maxy div 2-325,300,"Choose Black",p2ab,75,'p',false)
var player2astrogreen:int:=GUI.CreateButtonFull(maxx div 14,maxy div 2-425,300,"Choose Green",p2ag,75,'p',false)
var player2danteblack:int:=GUI.CreateButtonFull(maxx div 2.55,maxy div 2-325,300,"Choose Black",p2db,75,'p',false)
var player2dantered:int:=GUI.CreateButtonFull(maxx div 2.55,maxy div 2-425,300,"Choose Red",p2dr,75,'p',false)
var player2wublack:int:=GUI.CreateButtonFull(maxx div 1.41,maxy div 2-325,300,"Choose Black",p2wb,75,'p',false)
var player2wupurple:int:=GUI.CreateButtonFull(maxx div 1.41,maxy div 2-425,300,"Choose Purple",p2wp,75,'p',false)

    GUI.Hide(player2astroblack)
    GUI.Hide(player2astrogreen)
    GUI.Hide(player2danteblack)
    GUI.Hide(player2dantered)
    GUI.Hide(player2wublack)
    GUI.Hide(player2wupurple)

    Pic.Draw(menubackground,-5,0,picCopy)
loop
    GUI.Show(play_button)
    exit when GUI.ProcessEvent
end loop

    GUI.Hide(play_button)
    
    Pic.Draw(CharSel,-5,0,picCopy)
loop
    GUI.ResetQuit
    GUI.Show(player1astroblack)
    GUI.Show(player1astrogreen)
    GUI.Show(player1danteblack)
    GUI.Show(player1dantered)
    GUI.Show(player1wublack)
    GUI.Show(player1wupurple)
    exit when GUI.ProcessEvent
end loop

    GUI.Hide(player1astroblack)
    GUI.Hide(player1astrogreen)
    GUI.Hide(player1danteblack)
    GUI.Hide(player1dantered)
    GUI.Hide(player1wublack)
    GUI.Hide(player1wupurple)
    
    
    Pic.Draw(CharSel2,-5,0,picCopy)
loop
    GUI.ResetQuit
    GUI.Show(player2astroblack)
    GUI.Show(player2astrogreen)
    GUI.Show(player2danteblack)
    GUI.Show(player2dantered)
    GUI.Show(player2wublack)
    GUI.Show(player2wupurple)
    
    exit when GUI.ProcessEvent
    
end loop

    GUI.Hide(player2astroblack)
    GUI.Hide(player2astrogreen)
    GUI.Hide(player2danteblack)
    GUI.Hide(player2dantered)
    GUI.Hide(player2wublack)
    GUI.Hide(player2wupurple)



playSingleGame

cls
if game_winner= 1 then
    put "THE WINNER IS PLAYER ONE! :D"
elsif game_winner= 2 then
    put "CONGRATS PLAYER TWO, YOU WIN!"
elsif game_winner= 3 then
    put "SOMEHOW, YOU MANAGED TO KILL EACH OTHER AT THE SAME TIME. THAT IS ACTUALLY REALLY IMPRESSIVE!"
else 
    put "SOMETHING ISN'T RIGHT HERE"
end if


