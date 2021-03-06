function split(pString, pPattern)
numchanged = 0
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
          if s ~= 1 or cap ~= "" then
         table.insert(Table,cap)
numchanged = numchanged +1
          end
          last_end = e+1
          s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
          cap = pString:sub(last_end)
          table.insert(Table, cap)
          numchanged = numchanged +1
   end
   return Table
end

local function determineCost(baseCPS,amount)
        return round(baseCPS * math.pow(1.15,amount))
end

local function loadSaveData()
        --check if save data exists
        if fs.exists("CC-c") == false then
                --create save data file
                local file = fs.open("CC-c","w")
                file.writeLine("0:0:0:0:0:0:0:0:0:0:0")
                file.close()           
        end
        --import save data file
        local file = fs.open("CC-c","r")
        saveData = split(file.readLine(), ":")
        file.close()
end

loadSaveData()
purchaseMon = peripheral.wrap("back")
cookie = {}
cookie.x = {}
cookie.y = {}
buildings = {}

        for i = 1, 10 do
                buildings[i] = {}
        end
       
        -- buildings[i] = {name, cost, cps}
        buildings[1] = {"Cursor", 15, 0.1}
        buildings[2] = {"Grandma", 100, 0.5}
        buildings[3] = {"Farm", 500, 2}
        buildings[4] = {"Factory", 3000, 10}
        buildings[5] = {"Mine", 10000, 40}
        buildings[6] = {"Shipment", 40000, 100}
        buildings[7] = {"Alchemy Lab", 200000, 400}
        buildings[8] = {"Portal", 1666666, 6666}
        buildings[9] = {"Time Machine", 123456789, 98765}
        buildings[10] = {"Antimatter Condensers", 3999999999, 999999}
       
        for i = 1, 10 do
                buildings[i][4] = tonumber(saveData[i]) --Amount Owned
                buildings[i][5] = buildings[i][2] --Current Cost
                buildings[i][6] = buildings[i][3] --Current Building CPS Increase
        end
       
        --Button Variables
       
        buttonInfo = {}
        for i = 1, 11 do
                buttonInfo[i] = {}
        end
		
		term.redirect("back")
        x1,monHeight = term.getSize()
	    term.clear()
		term.setCursorPos(1,1)
	    term.redirect("right")
        --buttonInfo[i] = {x1, x2, y1, y2, text1, text2, monitor}
        buttonInfo[1] = {1, 15, monHeight - 38, monHeight - 36, "Buy Cursor", ""}
        buttonInfo[2] = {1, 15, monHeight - 34, monHeight - 32, "Buy Grandma", ""}
        buttonInfo[3] = {1, 15, monHeight - 30, monHeight - 28, "Buy Farm", ""}
        buttonInfo[4] = {1, 15, monHeight - 26, monHeight - 24, "Buy Factory", ""}
        buttonInfo[5] = {1, 15, monHeight - 22, monHeight - 20, "Buy Mine", ""}
        buttonInfo[6] = {1, 15, monHeight - 18, monHeight - 16, "Buy Shipment", ""}
        buttonInfo[7] = {1, 15, monHeight - 14, monHeight - 12, "Buy Alchemy", "Lab"}
        buttonInfo[8] = {1, 15, monHeight - 10, monHeight - 8, "Buy Portal", ""}
        buttonInfo[9] = {1, 15, monHeight - 6, monHeight - 4, "Buy Time", "Machine"}
        buttonInfo[10] = {1, 15, monHeight - 2, monHeight, "Buy Antimatter", "Condenser"}
        buttonInfo[11] = {1, 15, math.floor(monHeight/2)-1, math.floor(monHeight/2)+1, "Reset", "Game"}
cookiez= 9453452
term.clear()

local function Cclick(x,y)
    for key, value in pairs(cookie.x) do
        if value == x and cookie.y[key]== y then
		 return true
  		end
    end
    return false
end

local function drawButton(inputData)
        local x1, x2, y1, y2, text, text2 = unpack(inputData)
        purchaseMon.setBackgroundColor(colors.lightGray)
        for i=x1, x2 do
                for j=y1, y2 do
                purchaseMon.setCursorPos(i,j)
                purchaseMon.write(" ")
                end
        end
        purchaseMon.setCursorPos(math.floor(((x2+x1)/2)-(string.len(text)/2)),math.floor((y2+y1)/2))
        purchaseMon.write(text)
        purchaseMon.setCursorPos(math.floor(((x2+x1)/2)-(string.len(text2)/2)),math.floor((y2+y1)/2)+1)
        purchaseMon.write(text2)
        purchaseMon.setBackgroundColor(colors.cyan)
end


local function loadPurchases()
        purchaseMon.setBackgroundColor(colors.cyan)
        for i = 1, monWidth do
                for j = 1, monHeight do
                        purchaseMon.setCursorPos(i,j)
                        purchaseMon.write(" ")
                end
        end
        for i = 1, 10 do
                drawButton(buttonInfo[i])
                purchaseMon.setCursorPos(buttonInfo[i][2]+1,buttonInfo[i][3])
                purchaseMon.write("Cost: "..buildings[i][5])
                purchaseMon.setCursorPos(buttonInfo[i][2]+1,(buttonInfo[i][3]+buttonInfo[i][4])/2)
                purchaseMon.write("Owned: "..buildings[i][4])
                purchaseMon.setCursorPos(buttonInfo[i][2]+1,buttonInfo[i][4])
                purchaseMon.write("Cookies Per Second: "..buildings[i][6])
        end
end

local function Options(x,y)
x1,y1 = term.getSize()
x1=x1-6
if x > x1 and y1 == y then
     return true
end
end

function saveVariables(variables)
        local file = fs.open("CC-c","w")
        file.writeLine(variables)
        file.close()
end

local function cpsCalc()
        cps = 0
        local saveString = ""
        for i = 1, 10 do
                cps = cps + (buildings[i][6] * buildings[i][4])
                buildings[i][5] = determineCost(buildings[i][2],buildings[i][4])
                saveString = saveString..buildings[i][4]..":"
        end
        saveVariables(saveString..cookiez)
end

function isValidTowerBought(xClick, yClick)
        local isValid = false
        local towerBought = "none"
        for i = 1, 10 do
                if xClick > buttonInfo[i][1] and xClick < buttonInfo[i][2] and yClick > buttonInfo[i][3] and yClick < buttonInfo[i][4] then
                        isValid = true
                        towerBought = i
                end
        end
        return {isValid, towerBought}
end

local function pixel(x,y,color,what)
 term.setCursorPos(x,y)
 term.setBackgroundColor(color)
 term.write(what)
end

local function mouseclick(x,y,mon)
if mon == "back" then
 tower = isValidTowerBought(x,y)
else
 cookieC = Cclick(x,y)
 options = Options(x,y)
end
 if cookieC then
-- print("CLICKED AT COOKIE!")
  cookiez = cookiez + 1
  return true
 elseif options then
  os.queueEvent("optionsClicked")
 elseif tower then
  if tower[1] and buildings[tower[2]][5] < cookiez then
                        towerBought = tower[2]
                        buildings[towerBought][4] = buildings[towerBought][4] + 1
                        cookiez = cookiez - buildings[towerBought][5]
						loadPurchases()
                end
 end
end

if peripheral.getType("back") == "monitor" and peripheral.getType("right") == "monitor" then
else
 error()
end

--aquire cookie
local function drawCookie()
options = false
x1,y1 = term.getSize()
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

local function init()
 drawOnce = true
 drawCookie()
 loadPurchases()
end

local function options()
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
pixel(x1-6,y1,colors.red,"Cookie")
options= true
while not optionsClicked do
 local event, button, x, y = os.pullEvent()
 if x == x1-6 and y == y1 then
  optionsClicked = true
 end
end
init()
end

init()
while true do
 local event, button, x, y = os.pullEvent()
 if event == "monitor_touch" then
  mouseclick(x,y,button)
 elseif event == "timer" then
    cookiez = cookiez + cps
	os.startTimer(1)
 elseif event == "optionsClicked" then
  options()
 end
end