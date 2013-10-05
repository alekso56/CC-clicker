cookie = {}
cookie.x = {}
cookie.y = {}

cookiez= 9453452
term.clear()

local function click(x,y)
    for key, value in pairs(cookie.x) do
        if value == x and cookie.y[key]== y then
		 return true
  		end
    end
	x1,y1 = term.getSize()
	x1=x1-6
	if x > x1 and y1 == y then
	 options = true
	end
    return false
end

local function pixel(x,y,color,what)
 term.setCursorPos(x,y)
 term.setBackgroundColor(color)
 term.write(what)
end

local function mouseclick()
local event, button, x, y = os.pullEvent("monitor_touch")
local key = click(x,y)
 if key and not options then
-- print("CLICKED AT COOKIE!")
  cookiez = cookiez + 1
  return true
 elseif not key and options then
    wasOptions = true
	options = false 
   return false
 end
end

local function get(value) -- returns string side matching value else false
for _,v in pairs(rs.getSides()) do
if peripheral.getType(v) == value then
 return v
end
end
return false
end

--get stuff
modem = get("modem")
screen = get("monitor")

--aquire cookie
local function drawCookie()
options = false
local x1,y1 = term.getSize()
local x = math.ceil(x1/2)
local y = math.ceil(y1/2)
local r = 8
local fill = colors.orange
local color = colors.brown
  for tx=x-r,x+r do
    for ty=y-r,y+r do
      if (math.sqrt((tx-x)^2+(ty-y)^2) >= r and math.sqrt((tx-x)^2+(ty-y)^2) <= r+(r/math.sqrt((tx-x)^2+(ty-y)^2))) then -- Outside drawing
        pixel(tx,ty,color," ")
      elseif (math.sqrt((tx-x)^2+(ty-y)^2) <= r+(r/math.sqrt((tx-x)^2+(ty-y)^2))) then -- Inside drawing
       if math.random(0, 10) == 0 then
        pixel(tx,ty,color," ")
	   else 
	    pixel(tx,ty,fill," ")
	   end
	   if drawOnce then
	     table.insert(cookie.x,tx)
		 table.insert(cookie.y,ty)
	    end
      end
  end
end
if drawOnce then
 pixel(x1-6,y1,colors.red,"Options")
 pixel(x1-6,y1/5,colors.red,"CPS: 0")
 --print(math.random(0,10))
 drawOnce = false
end
pixel(x1/10,y1/5-2,colors.red,"Total Cookies:"..cookiez)
end

if modem then
modems = peripheral.wrap(modem)
print("modem found")
end

if screen then
screens = peripheral.wrap(screen)
--print("screen found")
term.redirect(screens)
end

local function init()
 drawOnce = true
 drawCookie()
end

local function options()
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
pixel(x1-6,y1,colors.red,"Cookie")
options= true
while not mouseclick() and not wasOptions do
--nothing :P
end
init()
end

init()
while true do
if mouseclick() and not options then drawCookie() 
elseif not options and wasOptions then init() wasOptions = false
elseif options then options()
end
end
