pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- globals --
-- variables --
local player
local mandarins
local coins
local score
local mandarin_score

function _init()
 score=0
 mandarin_score=0
 player = {
  x=64,
  y=64,
  color=9,
  name="thomas",
  radius=4,
  move_speed=1,
  mandarin_alligned=false,
  draw=function(self)
   spr(1, self.x-3, self.y-4)
   -- circ(self.x,self.y,self.radius,12)
  end,
  update=function(self)
   if btn(0) then
    self.x-=self.move_speed
   end
   if btn(1) then
    self.x+=self.move_speed
   end
   if btn(2) then
    self.y-=self.move_speed
   end
   if btn(3) then
    self.y+=self.move_speed
   end
  end,
   -- check hit detection
  check_collision=function(self,other)
    -- collect the other (coin or mandarin)
   if not other.iscollected and circ_overlapping(self.x,self.y,self.radius,other.x,other.y,other.radius) then
    other.iscollected=true
    if other.name == "coin" then
     sfx(0)
     score+=1
    else
     sfx(2)
     mandarin_score+=1
    end
   end
 end
 }
 -- coin
 coins={
  make_coin(),
  make_coin(),
  make_coin()
 }

 -- mandarins
 mandarins={
  make_mandarin(),
  make_mandarin()
 }
end

function _update()
 player:update()
 for coin in all(coins) do
  coin:update()
  player:check_collision(coin)
 end
 for mandarin in all(mandarins) do
  mandarin:update()
  player:check_collision(mandarin)
 end
end

function _draw()
 cls(13)
 print("score: " .. score, 5, 5, 7)
 print("mandarins: " .. mandarin_score, 75, 5, 7)
 player:draw()

 local coin
 for coin in all(coins) do
  coin:draw()
 end
 local mandarin
 for mandarin in all(mandarins) do
  mandarin:draw()
 end
end


function make_coin()
 local coin={
  x=flr(rnd(40))+64,
  y=flr(rnd(40))+64,
  radius=3,
  name="coin",
  iscollected=false,
  update=function(self)
  end,
  draw=function(self)
   if not self.iscollected then
    spr(3, self.x-3, self.y-4)
    -- circ(self.x,self.y,self.radius,12)
   end
  end
 }
 return coin
end

function make_mandarin()
 local mandarin={
  x=flr(rnd(40))+5,
  y=flr(rnd(40))+10,
  radius=3,
  name="mandarin",
  iscollected=false,
  update=function(self)
  end,
  draw=function(self)
   if not self.iscollected then
    spr(4, self.x-3, self.y-3)
    -- circ(self.x,self.y,self.radius,12)
   end
  end
 }
 return mandarin
end

function circ_overlapping(x1,y1,r1,x2,y2,r2)
 local dx=x2-x1
 local dy=y2-y1
 local dist=sqrt(dx*dx+dy*dy)
 return dist<r1+r2
end

__gfx__
00000000099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009ccc90000000000009aa000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070009ccc9000000000009aaaa00004990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000999999900000000009aaaa00049999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700099999990000d000009aaaa00049999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700099099000000000009aaaa00004990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009990999000000000009aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000001412000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000020000000000020000001400020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000040000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000000001400020004000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400002d0102f02033030350503906039070390203902001000290002c0000f1000c100141001a1002010025100291003310036100151001610000000000000000000000000000000000000000000000000000
000200000755007550075500755007550105500c550145500e5501355016550035000f500045000f5000450004500000000000000000000000000000000000000000000000000000000000000000000000000000
000500001e7501a7501e750287502f750317500b700127000b7000f700117001c700300002f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
