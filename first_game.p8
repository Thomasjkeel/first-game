pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- globals --
-- variables --
-- local player
-- local mandarins
-- local coins
local score
local mandarin_score
-- in_air=true

function _init()
 score=0
 mandarin_score=0
 player = {
  x=10,
  y=20,
  vx=0,
  vy=0,
  color=9,
  name="thomas",
  width=7,
  height=8,
  radius=4,
  in_air=true,
  move_speed=1,
  mandarin_alligned=false,
  draw=function(self)
   spr(1, self.x, self.y)
   -- circ(self.x,self.y,self.radius,12)
   local x,y,w,h=self.x,self.y,self.width,self.height

  end,
  update=function(self)
   self.vx*=0.5 -- gradual stop (friction)
   if btn(0) then
    self.vx=-self.move_speed
   end
   if btn(1) then
    self.vx=self.move_speed
   end
   -- jump button
   if btn(2) and not self.in_air then
    self.vy-=2
   end

   -- velocity
   self.vy+=0.2
   self.vy=mid(-3,self.vy,3)
   self.vx=mid(-3,self.vx,3)
   -- apply velocity
   self.x+=self.vx
   self.y+=self.vy
   self.in_air=true


  end,
   -- check hit detection
  check_collision=function(self,other)
    -- collect the other (coin or mandarin)
   -- if not other.iscollected and circ_overlapping(self.x,self.y,self.radius,other.x,other.y,other.radius) then
   if not other.iscollected and rect_overlapping(self.x,self.y,self.x+self.width,self.y+self.height,other.x,other.y,other.x+other.width,other.y+other.height) then
    other.iscollected=true
    if other.name == "coin" then
     sfx(0)
     score+=1
    else
     sfx(2)
     mandarin_score+=1
    end
   end
 end,

 check_for_block_collision=function(self, block)
  local x,y,w,h=self.x,self.y,self.width,self.height
  local top_hitbox={x=x+3,y=y,width=w-6,height=h/2}
  local bottom_hitbox={x=x+3,y=y+h/2,width=w-6,height=h/2}
  local left_hitbox={x=x,y=y+3,width=w/2,height=h-6}
  local right_hitbox={x=x+w/2,y=y+3,width=w/2,height=h-6}
  -- collisions
  if bounding_boxes_overlapping(bottom_hitbox,block) then
   self.y=block.y-self.height
   -- set in air and reset velocity
   if self.vy>0 then
    self.vy=0
   end
   self.in_air=false
  elseif bounding_boxes_overlapping(left_hitbox,block) then
   self.x=block.x+block.width
   if self.vx>0 then
    self.vx=0
   end
  elseif bounding_boxes_overlapping(right_hitbox,block) then
   self.x=block.x-self.width
   if self.vx<0 then
    self.vx=0
   end
  elseif bounding_boxes_overlapping(top_hitbox,block) then
   self.y=block.y+block.height
   if self.vy<0 then
    self.vy=0
   end
  end

 end
 }
 -- make coins, blocks and mandarins
 coins={}
 blocks={}
 mandarins={}

 local i
 for i=1,3 do
  add(coins, make_coin(25+10*i,82))
 end
 -- for i=1,2 do
 --  add(mandarins,make_mandarin(8*1,80))
 -- end
 add(mandarins, make_mandarin(80,60))
 for i=1,15 do
  add(blocks,make_block(8*i,90))
 end
 add(blocks,make_block(64,82))
 add(blocks,make_block(72,74))
 add(blocks,make_block(80,66))
 add(blocks, make_block(88,74))
 add(blocks, make_block(96,82))

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
 for block in all(blocks) do
  block:update()
  player:check_for_block_collision(block)
 end
end

function _draw()
 cls(13)
 print("score: " .. score, 5, 5, 7)
 print("mandarins: " .. mandarin_score, 75, 5, 7)
 local block
 for block in all(blocks) do
  block:draw()
 end
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


function make_coin(x,y)
 local coin={
  x=x,
  y=y,
  width=6,
  height=7,
  radius=3,
  name="coin",
  iscollected=false,
  update=function(self)
  end,
  draw=function(self)
   if not self.iscollected then
    spr(3, self.x, self.y)
    -- circ(self.x,self.y,self.radius,12)
    -- rect(self.x,self.y,self.x+self.width,self.y+self.height,12)
   end
  end
 }
 return coin
end

function make_mandarin(x,y)
 local mandarin={
  -- x=flr(rnd(40))+5,
  -- y=flr(rnd(40))+10,
  x=x,
  y=y,
  width=6,
  height=6,
  radius=3,
  name="mandarin",
  iscollected=false,
  update=function(self)
  end,
  draw=function(self)
   if not self.iscollected then
    spr(4, self.x, self.y)
    -- circ(self.x,self.y,self.radius,12)
    -- rect(self.x,self.y,self.x+self.width,self.y+self.height,12)
   end
  end
 }
 return mandarin
end

function make_block(x,y)
 block={
  x=x,
  y=y,
  width=8,
  height=8,
  update=function(self)
  end,
  draw=function(self)
   spr(2,self.x,self.y)
   -- rect(self.x,self.y,self.x+self.width,self.y+self.height, 12)
  end
 }
 return block
end

function lines_overlapping(min1,max1,min2,max2)
 return max1>min2 and max2>min1
end

function rect_overlapping(left1,top1,right1,bottom1,left2,top2,right2,bottom2)
 return lines_overlapping(left1,right1,left2,right2) and lines_overlapping(top1,bottom1,top2,bottom2)
end

function circ_overlapping(x1,y1,r1,x2,y2,r2)
 local dx=mid(-100,x2-x1,100)
 local dy=mid(-100,y2-y1,100)
 return dx*dx+dy*dy<(r1+r2)*(r1+r2)
end

function bounding_boxes_overlapping(obj1,obj2)
 return rect_overlapping(obj1.x,obj1.y,obj1.x+obj1.width,obj1.y+obj1.height,obj2.x,obj2.y,obj2.x+obj2.width,obj2.y+obj2.height)
end

__gfx__
00000000099999007777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009ccc90079cccc97009aa000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070009ccc9007c1111c709aaaa00004990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000999999907c1991c709aaaa00049999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000399999307c1991c709aaaa00049999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700099099007c1111c709aaaa00004990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009990999079cccc97009aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333033307777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000050505050512000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000050005050505050505051400050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005050505050500000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005050000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005000000051405050505000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400002d0102f02033030350503906039070390203902001000290002c0000f1000c100141001a1002010025100291003310036100151001610000000000000000000000000000000000000000000000000000
000200000755007550075500755007550105500c550145500e5501355016550035000f500045000f5000450004500000000000000000000000000000000000000000000000000000000000000000000000000000
000500001e7501a7501e750287502f750317500b700127000b7000f700117001c700300002f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000170501b0502005023050270502d00034000230002e0003b0003f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
