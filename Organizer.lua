
-- Organizer Mod
radius = 10 -- Default Daytime
local times = {"SunRiseDelay", "DayTimeDelay", "SunSetDelay", "NightTimeDelay"}


function SteamDetails()

  -- Setting of Steam details

  ModBase.SetSteamWorkshopDetails("Organizer", [[
    It's Organizer! Make sure to put on sunscreen!

    You can also  make it always night or always sunset or always sunrise. 
    Change the default time of day from Main Menu -> Mods -> Options

   (Due to modding limitations, this mod actually just makes the duration of the selected time really long and the duration of the other times really short. It shouldn't really be noticable though.)

    1 = Sunrise
    2 = Day time
    3 = Sunset
    4 = Night time

    Feel free to reach out
    Discord: TruthOrLie#6974
    
  ]], {"sunny", "time"}, "sun.png")
  
end


-- I wanted to be able to press L and change the time of day in-game, but because I can only set corresponding variables once
-- in the function BeforeLoad(), this is currently not possible. Hence the registration for input presses is commented out.
function Expose()

	-- Exposed variables
  -- ModBase.RegisterForInputPress(InputCallback)
  ModBase.ExposeVariable("Search Radius", radius, RadiusCallback, 1, 20)

end


function RadiusCallback( param )

  if param == nil then
    -- ModDebug.Log("Param nil")
  else
    -- ModDebug.Log("Param not nil ", param)
    radius = math.floor(param)
  end

end


-- When the period button is pressed, change the time of day
function InputCallback( param )

  -- ModDebug.Log("Organizer - InputCallback ", param)
  if (param == "L") then 
    -- ModDebug.Log("Organizer - Update")
  end
  
end


function BeforeLoad()


end


function MoveObject()

end

function OnUpdate() 
  Search()

  UpdateItemPosition()
end

local RegisteredObjects = {}

function Search()
  -- Get random object in radius
  ModDebug.Log("Organizer - Search")
  Pos = ModPlayer.GetPlayerLocation()    
  if(Pos[1] ~= nil)
  then
        ModDebug.Log(Pos[1], Pos[2])
  end

  ObjectUIDs = ModTiles.GetObjectsOfTypeInAreaIDs("Log", Pos[1]-radius, Pos[2]-radius, Pos[1]+radius, Pos[2]+radius)
  ModDebug.Log("Organizer - Get Objects")
  
  
  -- Keep track of objects
  -- Start move
  for ObjectIndex=1, #ObjectUIDs do
    local ObjectID = ObjectUIDs[ObjectIndex]
     	
    if RegisteredObjects[ObjectID] == nil then
      ModDebug.Log("Organizer - Start Move ", ObjectID)
      RegisteredObjects[ObjectID] = false -- Not completed
      ModObject.StartMoveTo(ObjectID, Pos[1], Pos[2], 10, 0)
    elseif RegisteredObjects[ObjectID] then
      -- RegisteredObjects[ObjectID] = nil
    end
  end

end


function UpdateItemPosition()

  for ObjectID, IsComplete in pairs(RegisteredObjects) do

    ModDebug.Log("Organizer - Move ", ObjectID)
    if IsComplete ~= true then
      RegisteredObjects[ObjectID] = ModObject.UpdateMoveTo(ObjectID, false, false)
      
      -- TODO: Remove ObjectID if complete
      if RegisteredObjects[ObjectID] then
        -- RegisteredObjects[ObjectID] = nil
      end
    end
  end

end