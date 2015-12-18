require("StaticField")
PeopleSite = {}

PeopleSite.mobsPx = {
	{{x=360,y=400,z=4},{x=340,y=330,z=3},{x=320,y=260,z=2},},--战士
	{{x=240,y=400,z=4},{x=210,y=330,z=3},{x=190,y=260,z=2},},--盗贼
	{{x=150,y=400,z=4},{x=130,y=330,z=3},{x=100,y=260,z=2},},--法师
	{{x=60,y=400,z=4},{x=30,y=330,z=3},{x=0,y=260,z=2},}, --牧师
	{{x=480,y=330,z=6},{x=110,y=380,z=6},} --宝宝
}

PeopleSite.bossPx = {
	{{x=350,y=390,z=2},{x=310,y=340,z=3},{x=370,y=300,z=5},},--战士
	{{x=490,y=260,z=2},{x=550,y=210,z=3},{x=480,y=160,z=5},},--盗贼
	{{x=10,y=250,z=6},{x=140,y=220,z=7},{x=40,y=150,z=8},{x=180,y=100,z=9},{x=100,y=80,z=10},{x=10,y=50,z=11},{x=270,y=50,z=12}},--法师
	{{x=680,y=260,z=6},{x=740,y=180,z=7},{x=620,y=130,z=8},{x=540,y=80,z=9},{x=680,y=60,z=10},}, --牧师
	{{x=480,y=330,z=6},{x=110,y=380,z=6},}, --宝宝
}
PeopleSite.site = {x=100,y=130} --初始位置
PeopleSite.scale = {x=0.5,y=0.5} --大小
PeopleSite.bossSite = {x=480,y=330,z=2} --boss
PeopleSite.bossScale = {x=0.5,y=0.5} --大小
PeopleSite.mapScale = {x=0.45,y=0.45} --大小

function PeopleSite.RandomSite(sitePx,standId)
	local pt = sitePx[standId]
	local rd = math.random(#pt)	
	local px = pt[rd]
	for k=#pt,1,-1 do
		if k == rd then
			table.remove(pt,k)
			break
		end
	end
	return px
end

