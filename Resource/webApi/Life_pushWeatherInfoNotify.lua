

Life_pushWeatherInfoNotify = {}

--推送天气预报
function Life_pushWeatherInfoNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Life_pushWeatherInfoNotify:init()
	
	self.WeatherInfoBO_weatherInfo=nil --天气信息对象

	self.actName = "Life_pushWeatherInfo"
end

function Life_pushWeatherInfoNotify:getActName()
	return self.actName
end

--天气信息对象
function Life_pushWeatherInfoNotify:setWeatherInfoBO_weatherInfo(WeatherInfoBO_weatherInfo)
	self.WeatherInfoBO_weatherInfo = WeatherInfoBO_weatherInfo
end





function Life_pushWeatherInfoNotify:encode(outputStream)
		self.WeatherInfoBO_weatherInfo:encode(outputStream)


end

function Life_pushWeatherInfoNotify:decode(inputStream)
	    local body = {}
        local weatherInfoTemp = WeatherInfoBO:New()
        body.weatherInfo=weatherInfoTemp:decode(inputStream)

	   return body
end