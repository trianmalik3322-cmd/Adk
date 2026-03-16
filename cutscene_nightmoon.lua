-- ╔══════════════════════════════════════════════════════════════╗
-- ║       DEX++ CINEMATIC CUTSCENE - NIGHT MOON EDITION 🌔      ║
-- ║  Dark Navy Sky, Silver Moon, Stars, Moonbeams,             ║
-- ║  Crescent Glow, Moonlit Mist, Constellation Rings          ║
-- ╚══════════════════════════════════════════════════════════════╝
local function PlayDexCutscene(onFinish)
	local Players      = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local RunService   = game:GetService("RunService")
	local lp           = Players.LocalPlayer
	local camera       = workspace.CurrentCamera
	local playerGui    = lp:WaitForChild("PlayerGui")

	-- ── Night Moon Color Palette ───────────────────────────────────
	local MIDNIGHT   = Color3.fromRGB(5, 8, 25)       -- langit malam
	local NAVY       = Color3.fromRGB(10, 15, 45)      -- biru gelap
	local MOONWHITE  = Color3.fromRGB(220, 235, 255)   -- cahaya bulan
	local MOONSILVER = Color3.fromRGB(180, 200, 240)   -- silver bulan
	local MOONGLOW   = Color3.fromRGB(140, 170, 255)   -- glow bulan
	local STARYELLOW = Color3.fromRGB(255, 250, 200)   -- bintang
	local STARCOLD   = Color3.fromRGB(200, 220, 255)   -- bintang biru dingin
	local NEBULA     = Color3.fromRGB(80, 60, 160)     -- nebula ungu
	local AURORA1    = Color3.fromRGB(60, 200, 180)    -- aurora teal
	local AURORA2    = Color3.fromRGB(100, 80, 220)    -- aurora purple
	local BLACK      = Color3.fromRGB(0, 0, 5)
	local WHITE      = Color3.fromRGB(255, 255, 255)

	local origCamType = camera.CameraType
	local origCamCF   = camera.CFrame

	local function fw(s)
		local t = tick()
		repeat RunService.RenderStepped:Wait() until tick()-t >= (s or 0)
	end

	local cutsceneParts = {}
	local function makePart(props)
		local p = Instance.new("Part")
		p.Anchored   = true
		p.CanCollide = false
		p.CastShadow = false
		p.Locked     = true
		p.Size       = Vector3.new(1,1,1)
		p.Material   = Enum.Material.Neon
		p.Color      = MOONWHITE
		for k,v in pairs(props or {}) do p[k] = v end
		p.Parent = workspace
		table.insert(cutsceneParts, p)
		return p
	end

	local function tw(obj, ti, goal)
		local t = TweenService:Create(obj, ti, goal)
		t:Play()
		return t
	end

	-- ── GUI Setup ─────────────────────────────────────────────────
	local cutsceneGui = Instance.new("ScreenGui")
	cutsceneGui.Name           = "DexCutscene"
	cutsceneGui.IgnoreGuiInset = true
	cutsceneGui.ResetOnSpawn   = false
	cutsceneGui.DisplayOrder   = 999
	cutsceneGui.Parent         = playerGui

	-- Deep midnight background
	local blackFrame = Instance.new("Frame", cutsceneGui)
	blackFrame.Size             = UDim2.new(1,0,1,0)
	blackFrame.BackgroundColor3 = BLACK
	blackFrame.BorderSizePixel  = 0
	blackFrame.ZIndex           = 1

	-- Letterbox
	local barTop = Instance.new("Frame", cutsceneGui)
	barTop.Size             = UDim2.new(1,0,0,0)
	barTop.BackgroundColor3 = BLACK
	barTop.BorderSizePixel  = 0
	barTop.ZIndex           = 10

	local barBot = Instance.new("Frame", cutsceneGui)
	barBot.Size             = UDim2.new(1,0,0,0)
	barBot.AnchorPoint      = Vector2.new(0,1)
	barBot.Position         = UDim2.new(0,0,1,0)
	barBot.BackgroundColor3 = BLACK
	barBot.BorderSizePixel  = 0
	barBot.ZIndex           = 10

	-- Vignette (dark edges)
	local vignette = Instance.new("ImageLabel", cutsceneGui)
	vignette.Size = UDim2.new(1,0,1,0)
	vignette.BackgroundTransparency = 1
	vignette.Image = "rbxassetid://1428546737"
	vignette.ImageColor3 = Color3.fromRGB(2,4,15)
	vignette.ImageTransparency = 0.25
	vignette.ZIndex = 6

	-- Starfield background (gradient)
	local skyBg = Instance.new("Frame", cutsceneGui)
	skyBg.Size = UDim2.new(1,0,1,0)
	skyBg.BackgroundColor3 = Color3.fromRGB(3,6,20)
	skyBg.BorderSizePixel  = 0
	skyBg.BackgroundTransparency = 1
	skyBg.ZIndex = 2
	local skyGrad = Instance.new("UIGradient", skyBg)
	skyGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(2,4,18)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(5,8,30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8,5,25))
	})
	skyGrad.Rotation = 270

	-- Twinkling stars (random dots)
	local starLabels = {}
	math.randomseed(77777)
	for i = 1, 40 do
		local star = Instance.new("Frame", cutsceneGui)
		local size = math.random(1,3)
		star.Size = UDim2.new(0, size, 0, size)
		star.Position = UDim2.new(math.random()*0.9+0.05, 0, math.random()*0.7+0.05, 0)
		star.BackgroundColor3 = i % 3 == 0 and STARYELLOW or STARCOLD
		star.BackgroundTransparency = 0.3 + math.random()*0.4
		star.BorderSizePixel = 0
		star.ZIndex = 3
		local sc = Instance.new("UICorner", star)
		sc.CornerRadius = UDim.new(1,0)
		table.insert(starLabels, star)
	end

	-- Moon glow (big soft circle behind moon)
	local moonGlow = Instance.new("Frame", cutsceneGui)
	moonGlow.Size = UDim2.new(0,160,0,160)
	moonGlow.AnchorPoint = Vector2.new(0.5,0.5)
	moonGlow.Position = UDim2.new(0.72, 0, 0.28, 0)
	moonGlow.BackgroundColor3 = MOONGLOW
	moonGlow.BackgroundTransparency = 1
	moonGlow.BorderSizePixel = 0
	moonGlow.ZIndex = 3
	local moonGlowCorner = Instance.new("UICorner", moonGlow)
	moonGlowCorner.CornerRadius = UDim.new(1,0)

	-- Moon (crescent-ish using circle)
	local moon = Instance.new("Frame", cutsceneGui)
	moon.Size = UDim2.new(0,80,0,80)
	moon.AnchorPoint = Vector2.new(0.5,0.5)
	moon.Position = UDim2.new(0.72, 0, 0.28, 0)
	moon.BackgroundColor3 = MOONWHITE
	moon.BackgroundTransparency = 1
	moon.BorderSizePixel = 0
	moon.ZIndex = 4
	local moonCorner = Instance.new("UICorner", moon)
	moonCorner.CornerRadius = UDim.new(1,0)

	-- Moon shadow (to make crescent effect)
	local moonShadow = Instance.new("Frame", cutsceneGui)
	moonShadow.Size = UDim2.new(0,70,0,70)
	moonShadow.AnchorPoint = Vector2.new(0.5,0.5)
	moonShadow.Position = UDim2.new(0.72, 15, 0.28, -8)
	moonShadow.BackgroundColor3 = BLACK
	moonShadow.BackgroundTransparency = 1
	moonShadow.BorderSizePixel = 0
	moonShadow.ZIndex = 5
	local moonShadowCorner = Instance.new("UICorner", moonShadow)
	moonShadowCorner.CornerRadius = UDim.new(1,0)

	-- Moonbeam rays
	local rays = {}
	for i = 1, 8 do
		local angle = (i/8) * 360
		local ray = Instance.new("Frame", cutsceneGui)
		ray.Size = UDim2.new(0,2,0,0)
		ray.AnchorPoint = Vector2.new(0.5,1)
		ray.Position = UDim2.new(0.72,0,0.28,0)
		ray.BackgroundColor3 = MOONSILVER
		ray.BackgroundTransparency = 0.7
		ray.BorderSizePixel = 0
		ray.ZIndex = 3
		ray.Rotation = angle
		table.insert(rays, ray)
	end

	-- Title
	local titleLabel = Instance.new("TextLabel", cutsceneGui)
	titleLabel.Size = UDim2.new(0,600,0,90)
	titleLabel.AnchorPoint = Vector2.new(0.5,0.5)
	titleLabel.Position = UDim2.new(0.5,0,0.5,0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = ""
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 72
	titleLabel.TextColor3 = MOONWHITE
	titleLabel.TextTransparency = 1
	titleLabel.ZIndex = 8
	titleLabel.RichText = true

	local titleStroke = Instance.new("UIStroke", titleLabel)
	titleStroke.Color = MOONGLOW
	titleStroke.Thickness = 2
	titleStroke.Transparency = 1

	-- Subtitle
	local subLabel = Instance.new("TextLabel", cutsceneGui)
	subLabel.Size = UDim2.new(0,500,0,28)
	subLabel.AnchorPoint = Vector2.new(0.5,0.5)
	subLabel.Position = UDim2.new(0.5,0,0.5,68)
	subLabel.BackgroundTransparency = 1
	subLabel.Text = ""
	subLabel.Font = Enum.Font.Gotham
	subLabel.TextSize = 16
	subLabel.TextColor3 = MOONSILVER
	subLabel.TextTransparency = 1
	subLabel.ZIndex = 8

	-- "by Chillz"
	local byLabel = Instance.new("TextLabel", cutsceneGui)
	byLabel.Size = UDim2.new(0,300,0,18)
	byLabel.AnchorPoint = Vector2.new(0.5,1)
	byLabel.Position = UDim2.new(0.5,0,1,-40)
	byLabel.BackgroundTransparency = 1
	byLabel.Text = "Developed by Chillz.  🌔"
	byLabel.Font = Enum.Font.Gotham
	byLabel.TextSize = 13
	byLabel.TextColor3 = MOONGLOW
	byLabel.TextTransparency = 1
	byLabel.ZIndex = 8

	-- Silver line top
	local lineTop = Instance.new("Frame", cutsceneGui)
	lineTop.Size = UDim2.new(0,0,0,1)
	lineTop.AnchorPoint = Vector2.new(0.5,0.5)
	lineTop.Position = UDim2.new(0.5,0,0.5,-58)
	lineTop.BackgroundColor3 = MOONSILVER
	lineTop.BorderSizePixel = 0
	lineTop.BackgroundTransparency = 1
	lineTop.ZIndex = 8
	local lineTopGrad = Instance.new("UIGradient", lineTop)
	lineTopGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, MIDNIGHT),
		ColorSequenceKeypoint.new(0.3, MOONSILVER),
		ColorSequenceKeypoint.new(0.7, MOONWHITE),
		ColorSequenceKeypoint.new(1, MIDNIGHT)
	})

	-- Silver line bottom
	local lineBot = Instance.new("Frame", cutsceneGui)
	lineBot.Size = UDim2.new(0,0,0,1)
	lineBot.AnchorPoint = Vector2.new(0.5,0.5)
	lineBot.Position = UDim2.new(0.5,0,0.5,60)
	lineBot.BackgroundColor3 = MOONSILVER
	lineBot.BorderSizePixel = 0
	lineBot.BackgroundTransparency = 1
	lineBot.ZIndex = 8
	local lineBotGrad = Instance.new("UIGradient", lineBot)
	lineBotGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, MIDNIGHT),
		ColorSequenceKeypoint.new(0.3, MOONGLOW),
		ColorSequenceKeypoint.new(0.7, MOONSILVER),
		ColorSequenceKeypoint.new(1, MIDNIGHT)
	})

	-- ── Camera override ───────────────────────────────────────────
	camera.CameraType = Enum.CameraType.Scriptable

	-- ── PARTS SETUP: Night Scene ──────────────────────────────────
	-- Dark ground platform
	makePart({
		Size = Vector3.new(100,1,100),
		Color = Color3.fromRGB(3,5,18),
		Material = Enum.Material.SmoothPlastic,
		CFrame = CFrame.new(0,-4,0)
	})

	-- Moonlit ground glow (flat neon layer)
	makePart({
		Size = Vector3.new(80,0.1,80),
		Color = Color3.fromRGB(30,40,90),
		Material = Enum.Material.Neon,
		CFrame = CFrame.new(0,-3.4,0),
	}).Transparency = 0.85

	-- Moonbeam floor streaks
	for i = 1, 6 do
		local streak = makePart({
			Size = Vector3.new(0.15, 0.05, 35 + i*3),
			Color = MOONSILVER,
			CFrame = CFrame.new((i-3)*3.5, -3.38, 0)
		})
		streak.Transparency = 0.7 + i*0.04
	end

	-- Central MOON sphere (big floating)
	local moonSphere = makePart({
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(5,5,5),
		Color = MOONWHITE,
		CFrame = CFrame.new(0,8,0)
	})
	moonSphere.Transparency = 0.05

	-- Moon inner glow (slightly smaller)
	local moonInner = makePart({
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(3.5,3.5,3.5),
		Color = Color3.fromRGB(240,248,255),
		CFrame = CFrame.new(0,8,0)
	})
	moonInner.Transparency = 0.3

	-- Moon outer aura (large transparent)
	local moonAura = makePart({
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(9,9,9),
		Color = MOONGLOW,
		CFrame = CFrame.new(0,8,0)
	})
	moonAura.Transparency = 0.85

	-- Moon second aura (even larger)
	local moonAura2 = makePart({
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(13,13,13),
		Color = Color3.fromRGB(60,80,180),
		CFrame = CFrame.new(0,8,0)
	})
	moonAura2.Transparency = 0.92

	-- Star ring 1 (constellation orbit) - silver/white dots
	local starRing1 = {}
	for i = 1, 20 do
		local s = makePart({
			Shape = Enum.PartType.Ball,
			Size = Vector3.new(0.2,0.2,0.2),
			Color = i % 4 == 0 and STARYELLOW or STARCOLD,
			CFrame = CFrame.new(math.cos(i/20*math.pi*2)*9, 8, math.sin(i/20*math.pi*2)*9)
		})
		s.Transparency = 0.1
		table.insert(starRing1, s)
	end

	-- Star ring 2 (tilted orbit) - moonlit blue
	local starRing2 = {}
	for i = 1, 14 do
		local s = makePart({
			Shape = Enum.PartType.Ball,
			Size = Vector3.new(0.15,0.15,0.15),
			Color = MOONGLOW,
			CFrame = CFrame.new(math.cos(i/14*math.pi*2)*7, 8 + math.sin(i/14*math.pi*2)*3.5, math.sin(i/14*math.pi*2)*7)
		})
		s.Transparency = 0.15
		table.insert(starRing2, s)
	end

	-- Floating stars/sparkles (random field)
	local sparkles = {}
	math.randomseed(55555)
	for i = 1, 35 do
		local ang = math.random()*math.pi*2
		local rad = math.random(3,16)
		local ht  = math.random(2,14)
		local sp = makePart({
			Shape = Enum.PartType.Ball,
			Size = Vector3.new(0.12,0.12,0.12),
			Color = math.random(2) == 1 and STARYELLOW or STARCOLD,
			CFrame = CFrame.new(math.cos(ang)*rad, ht, math.sin(ang)*rad)
		})
		sp.Transparency = 0.1 + math.random()*0.5
		table.insert(sparkles, sp)
	end

	-- Moon pillars (8 tall dark pillars with moonlit tops)
	local pillars = {}
	for i = 1, 8 do
		local ang = (i/8)*math.pi*2
		local px = math.cos(ang)*12
		local pz = math.sin(ang)*12

		local pillar = makePart({
			Size = Vector3.new(0.4,0.1,0.4),
			Color = Color3.fromRGB(15,20,50),
			Material = Enum.Material.SmoothPlastic,
			CFrame = CFrame.new(px,-3.7,pz)
		})
		pillar.Transparency = 0.2
		table.insert(pillars, {part=pillar, px=px, pz=pz, hue=i/8})

		-- Moonlit top ball
		local topBall = makePart({
			Shape = Enum.PartType.Ball,
			Size = Vector3.new(0.5,0.5,0.5),
			Color = MOONSILVER,
			CFrame = CFrame.new(px,-3.7,pz)
		})
		topBall.Transparency = 0.15
		table.insert(pillars, {part=topBall, px=px, pz=pz, hue=i/8, isBall=true})
	end

	-- Aurora curtain (vertical flat parts)
	local auroraParts = {}
	for i = 1, 10 do
		local ap = makePart({
			Size = Vector3.new(0.15, 8 + i*0.5, 0.15),
			Color = i % 2 == 0 and AURORA1 or AURORA2,
			CFrame = CFrame.new(-18 + i*3.5, 6, -15)
		})
		ap.Transparency = 0.6 + math.random()*0.25
		table.insert(auroraParts, {part=ap, baseX=-18+i*3.5, idx=i})
	end

	-- Mist/fog strips at ground
	for i = 1, 5 do
		local mist = makePart({
			Size = Vector3.new(30+i*5, 0.5, 0.5+i*0.3),
			Color = MOONSILVER,
			Material = Enum.Material.SmoothPlastic,
			CFrame = CFrame.new(0,-3.2+i*0.1,i*2-5)
		})
		mist.Transparency = 0.88
	end

	-- ── FASE 0: Black + letterbox ─────────────────────────────────
	local barTI = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	tw(barTop, barTI, {Size = UDim2.new(1,0,0,60)})
	tw(barBot, barTI, {Size = UDim2.new(1,0,0,60)})

	camera.CFrame = CFrame.new(0, 35, 0) * CFrame.Angles(math.rad(-90), 0, 0)
	fw(0.9)

	-- ── FASE 1: Night sky fade in ─────────────────────────────────
	tw(skyBg, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 0})
	tw(blackFrame, TweenInfo.new(2.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1})
	tw(camera, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		CFrame = CFrame.new(20, 9, 20) * CFrame.Angles(math.rad(-20), math.rad(45), 0)
	})

	-- Stars twinkle in
	for i, star in ipairs(starLabels) do
		local delay = i * 0.04
		coroutine.wrap(function()
			fw(delay)
			tw(star, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2 + math.random()*0.3})
		end)()
	end

	fw(1.2)

	-- ── FASE 1b: Start main animation loop ────────────────────────
	local animRunning = true
	local moonAngle   = 0

	local mainAnim = RunService.RenderStepped:Connect(function(dt)
		moonAngle = moonAngle + dt * 30
		local t   = tick()

		-- Moon float + gentle rotation
		moonSphere.CFrame  = CFrame.new(0, 8 + math.sin(t*0.6)*0.4, 0)
		moonInner.CFrame   = CFrame.new(0, 8 + math.sin(t*0.6)*0.4, 0)
		moonAura.CFrame    = CFrame.new(0, 8 + math.sin(t*0.6)*0.4, 0)
		moonAura2.CFrame   = CFrame.new(0, 8 + math.sin(t*0.6)*0.4, 0)

		-- Moon aura pulse
		moonAura.Transparency  = 0.82 + math.abs(math.sin(t*0.8))*0.1
		moonAura2.Transparency = 0.88 + math.abs(math.sin(t*0.5))*0.08

		-- Star ring 1 orbit (slow, majestic)
		for i, s in ipairs(starRing1) do
			local a = (i/20*math.pi*2) + t*0.5
			s.CFrame = CFrame.new(math.cos(a)*9, 8 + math.sin(t*0.3)*0.3, math.sin(a)*9)
			s.Transparency = 0.05 + math.abs(math.sin(t*1.5 + i*0.3))*0.4
		end

		-- Star ring 2 orbit (tilted, opposite direction)
		for i, s in ipairs(starRing2) do
			local a = (i/14*math.pi*2) - t*0.4
			s.CFrame = CFrame.new(math.cos(a)*7, 8 + math.sin(a)*3.5, math.sin(a)*7)
			s.Transparency = 0.1 + math.abs(math.sin(t*1.2 + i*0.4))*0.45
		end

		-- Sparkles twinkle
		for i, sp in ipairs(sparkles) do
			sp.Transparency = 0.05 + math.abs(math.sin(t*2.0 + i*0.7))*0.7
			sp.CFrame = sp.CFrame + Vector3.new(0, math.sin(t*0.3 + i)*dt*0.15, 0)
		end

		-- Aurora wave
		for _, ad in ipairs(auroraParts) do
			ad.part.CFrame = CFrame.new(
				ad.baseX + math.sin(t*0.8 + ad.idx*0.4)*0.8,
				6 + math.sin(t*0.5 + ad.idx*0.3)*1.2,
				-15
			)
			ad.part.Transparency = 0.55 + math.abs(math.sin(t*0.6 + ad.idx*0.5))*0.35
		end

		-- Pillars top ball glow pulse
		for _, pd in ipairs(pillars) do
			if pd.isBall then
				pd.part.Transparency = 0.1 + math.abs(math.sin(t*1.5 + pd.hue*8))*0.5
				pd.part.Color = Color3.fromRGB(
					180 + math.floor(math.sin(t + pd.hue*6)*30),
					200 + math.floor(math.sin(t*1.2 + pd.hue*5)*25),
					255
				)
			end
		end

		-- Star twinkle on screen
		if animRunning then
			for i, star in ipairs(starLabels) do
				star.BackgroundTransparency = 0.2 + math.abs(math.sin(t*1.8 + i*0.6))*0.55
			end
			-- Moon glow pulse
			if moonGlow then
				moonGlow.BackgroundTransparency = 0.88 + math.abs(math.sin(t*0.7))*0.08
			end
		end
	end)

	fw(1.5)

	-- ── FASE 2: Pillars rise + aurora reveal ─────────────────────
	tw(camera, TweenInfo.new(3.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		CFrame = CFrame.new(-22, 5, 14) * CFrame.Angles(math.rad(-10), math.rad(-50), 0)
	})

	for i, pd in ipairs(pillars) do
		if not pd.isBall then
			tw(pd.part, TweenInfo.new(0.8 + i*0.06, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size  = Vector3.new(0.4, 10 + i*0.2, 0.4),
				CFrame = CFrame.new(pd.px, 1, pd.pz)
			})
		end
	end

	fw(1.0)

	-- Moon GUI elements fade in
	tw(moonGlow, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 0.88})
	tw(moon, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 0})
	tw(moonShadow, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 0})

	-- Moonbeam rays expand
	for i, ray in ipairs(rays) do
		tw(ray, TweenInfo.new(0.6 + i*0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 1, 0, 40 + i*8),
			BackgroundTransparency = 0.6
		})
	end

	fw(2.0)

	-- ── FASE 3: Low hero shot (moon prominent) ────────────────────
	tw(camera, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		CFrame = CFrame.new(0, 1.5, 16) * CFrame.Angles(math.rad(8), 0, 0)
	})

	fw(0.6)

	-- Silver lines reveal
	tw(lineTop, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 430, 0, 1),
		BackgroundTransparency = 0.25
	})
	tw(lineBot, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 430, 0, 1),
		BackgroundTransparency = 0.25
	})

	fw(0.45)

	-- ── FASE 3b: Title moonlit typewriter ─────────────────────────
	local fullTitle = "DEX++"
	titleLabel.TextTransparency = 0
	titleStroke.Transparency = 0.3
	titleLabel.Text = ""

	local moonColors = {MOONWHITE, MOONSILVER, MOONGLOW, MOONWHITE, MOONSILVER}
	for i = 1, #fullTitle do
		titleLabel.Text = string.sub(fullTitle, 1, i)
		titleLabel.TextColor3 = moonColors[i] or MOONWHITE
		fw(0.07)
	end
	titleLabel.TextColor3 = MOONWHITE

	tw(subLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{TextTransparency = 0})
	subLabel.Text = "Ultimate Debugging Suite"

	tw(byLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{TextTransparency = 0})

	fw(0.8)

	-- ══════════════════════════════════════════════════════════════
	-- ⚡ SHAKE + TELEPORT ─ kamera guncang, player teleport ke moon
	-- ══════════════════════════════════════════════════════════════

	-- ── Spinning Stars Overlay function ───────────────────────────
	-- Munculin bintang-bintang muter + membesar pas shake,
	-- lalu ilang smooth pas shake selesai
	local function spawnShakeStars(duration, starCount)
		starCount = starCount or 8
		local starFrames = {}
		local starData   = {}

		for i = 1, starCount do
			local starGui = Instance.new("TextLabel", cutsceneGui)
			starGui.BackgroundTransparency = 1
			starGui.Text      = "★"
			starGui.Font      = Enum.Font.GothamBold
			starGui.TextSize  = 10
			starGui.ZIndex    = 25
			starGui.AnchorPoint = Vector2.new(0.5, 0.5)
			-- Mulai dari tengah layar, posisi acak sedikit
			local startAngle = (i / starCount) * math.pi * 2
			starGui.Position = UDim2.new(0.5, 0, 0.5, 0)
			starGui.TextTransparency = 0

			-- Warna bergantian moonlit
			local starColors = {
				MOONWHITE, STARYELLOW, MOONSILVER,
				MOONGLOW, STARCOLD, AURORA1,
				Color3.fromRGB(255,255,180), MOONWHITE
			}
			starGui.TextColor3 = starColors[(i % #starColors) + 1]

			table.insert(starFrames, starGui)
			table.insert(starData, {
				angle    = startAngle,
				radius   = 0,
				size     = 10,
				rotSpeed = 180 + math.random()*120 * (i % 2 == 0 and 1 or -1),
				radSpeed = 180 + math.random()*80,
				selfRot  = 0,
				selfRotSpeed = math.random(-360, 360),
			})
		end

		local elapsed  = 0
		local phase    = "grow"   -- grow → hold → shrink
		local animConn
		animConn = RunService.RenderStepped:Connect(function(dt)
			elapsed = elapsed + dt

			-- Phase transitions
			local growTime   = duration * 0.35
			local holdTime   = duration * 0.30
			local shrinkTime = duration * 0.35

			if elapsed >= duration then
				-- Cleanup
				for _, sf in ipairs(starFrames) do
					pcall(function() sf:Destroy() end)
				end
				animConn:Disconnect()
				return
			end

			for i, sd in ipairs(starData) do
				local sf = starFrames[i]
				if sf and sf.Parent then

					-- Update angle (muter mengelilingi tengah layar)
					sd.angle   = sd.angle + math.rad(sd.rotSpeed) * dt
					sd.selfRot = sd.selfRot + sd.selfRotSpeed * dt

					-- Update radius (makin jauh dari tengah = makin besar)
					local progress = math.min(elapsed / duration, 1)

					local targetRadius
					local targetSize
					local transparency

					if elapsed < growTime then
						-- GROW: radius & size naik
						local p = elapsed / growTime
						targetRadius  = p * (200 + i * 18)
						targetSize    = 10 + p * (55 + i * 4)
						transparency  = 0
					elseif elapsed < growTime + holdTime then
						-- HOLD: tetap besar, mulai sedikit fade
						local p = (elapsed - growTime) / holdTime
						targetRadius  = 200 + i * 18
						targetSize    = 65 + i * 4
						transparency  = p * 0.3
					else
						-- SHRINK: fade out sambil makin gede (terbang keluar)
						local p = (elapsed - growTime - holdTime) / shrinkTime
						targetRadius  = (200 + i*18) + p * 120
						targetSize    = (65 + i*4) + p * 40
						transparency  = 0.3 + p * 0.7
					end

					sd.radius = targetRadius

					-- Posisi: orbit mengelilingi tengah
					local cx = 0.5 + math.cos(sd.angle) * (sd.radius / 800)
					local cy = 0.5 + math.sin(sd.angle) * (sd.radius / 500)

					sf.Position      = UDim2.new(cx, 0, cy, 0)
					sf.TextSize      = math.max(8, targetSize)
					sf.Rotation      = sd.selfRot
					sf.TextTransparency = math.min(1, transparency)

					-- Rainbow tint sambil muter
					sf.TextColor3 = Color3.fromHSV(
						(elapsed * 0.4 + i / starCount) % 1,
						0.5,
						1
					)
				end
			end
		end)

		return animConn
	end

	-- Shake helper: getar kamera dari posisi base
	local function cameraShake(baseCF, intensity, duration, speed)
		local elapsed = 0
		local shakeConn
		shakeConn = RunService.RenderStepped:Connect(function(dt)
			elapsed = elapsed + dt
			if elapsed >= duration then
				camera.CFrame = baseCF
				shakeConn:Disconnect()
				return
			end
			local decay = 1 - (elapsed / duration)
			local ox = (math.random()-0.5) * 2 * intensity * decay
			local oy = (math.random()-0.5) * 2 * intensity * decay
			local oz = (math.random()-0.5) * 2 * intensity * decay
			camera.CFrame = baseCF * CFrame.new(ox, oy, oz)
				* CFrame.Angles(
					math.rad(oy * speed),
					math.rad(ox * speed),
					0
				)
		end)
		return shakeConn
	end

	-- ── SHAKE 1: Gempa kecil saat moon muncul ─────────────────────
	local prePushCF = CFrame.new(0, 1.5, 16) * CFrame.Angles(math.rad(8), 0, 0)
	cameraShake(prePushCF, 0.18, 0.6, 0.5)
	spawnShakeStars(0.65, 6)   -- 6 bintang muter pas shake 1

	-- Ground crack flash effect
	local crackFlash = Instance.new("Frame", cutsceneGui)
	crackFlash.Size = UDim2.new(1,0,1,0)
	crackFlash.BackgroundColor3 = Color3.fromRGB(60,80,180)
	crackFlash.BackgroundTransparency = 0.5
	crackFlash.BorderSizePixel = 0
	crackFlash.ZIndex = 15
	tw(crackFlash, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1})

	fw(0.65)

	-- ── TELEPORT: Player teleport ke atas moon sphere ──────────────
	coroutine.wrap(function()
		pcall(function()
			local char = lp.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local hum = char:FindFirstChildOfClass("Humanoid")

			local tpFlash = Instance.new("Frame", cutsceneGui)
			tpFlash.Size = UDim2.new(1,0,1,0)
			tpFlash.BackgroundColor3 = MOONWHITE
			tpFlash.BackgroundTransparency = 0
			tpFlash.BorderSizePixel = 0
			tpFlash.ZIndex = 18

			hrp.CFrame = CFrame.new(0, 14, 0)

			fw(0.05)
			tw(tpFlash, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1})
			fw(0.5)
			pcall(function() tpFlash:Destroy() end)
		end)
	end)()

	fw(0.3)

	-- ── FASE 4: Push-in ke moon ────────────────────────────────────
	tw(camera, TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		CFrame = CFrame.new(0, 7, 12) * CFrame.Angles(math.rad(-8), 0, 0)
	})

	-- ── SHAKE 2: Dramatic shake saat camera push-in ────────────────
	coroutine.wrap(function()
		fw(0.5)
		local midCF = CFrame.new(0, 7, 12) * CFrame.Angles(math.rad(-8), 0, 0)
		cameraShake(midCF, 0.25, 0.8, 0.6)
		spawnShakeStars(0.85, 8)   -- 8 bintang muter pas shake 2
	end)()

	-- Moonlit glitch (silver/blue flicker)
	coroutine.wrap(function()
		fw(1.1)
		local glitchColors = {MOONGLOW, MOONSILVER, MOONWHITE, AURORA1, MOONWHITE}
		for i = 1, 5 do
			local ox = math.random(-5,5)
			local oy = math.random(-2,2)
			titleLabel.Position   = UDim2.new(0.5, ox, 0.5, oy)
			titleLabel.TextColor3 = glitchColors[i]
			titleStroke.Color     = glitchColors[#glitchColors - i + 1]
			fw(0.036)
		end
		titleLabel.Position   = UDim2.new(0.5, 0, 0.5, 0)
		titleLabel.TextColor3 = MOONWHITE
		titleStroke.Color     = MOONGLOW
	end)()

	fw(2.2)

	-- ── FASE 5: Final orbit (Moon overhead) ───────────────────────
	tw(camera, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		CFrame = CFrame.new(10, 10, -12) * CFrame.Angles(math.rad(-20), math.rad(140), 0)
	})

	fw(1.2)

	-- ── SHAKE 3: Epic shake + teleport balik sebelum end ──────────
	local finalCF = CFrame.new(10, 10, -12) * CFrame.Angles(math.rad(-20), math.rad(140), 0)
	cameraShake(finalCF, 0.45, 1.2, 0.8)
	spawnShakeStars(1.25, 12)   -- 12 bintang muter pas shake 3 (paling epik!)

	-- Teleport player balik ke spawn / posisi awal
	coroutine.wrap(function()
		fw(0.3)
		pcall(function()
			local char = lp.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			-- Flash biru bulan
			local tpFlash2 = Instance.new("Frame", cutsceneGui)
			tpFlash2.Size = UDim2.new(1,0,1,0)
			tpFlash2.BackgroundColor3 = MOONGLOW
			tpFlash2.BackgroundTransparency = 0.2
			tpFlash2.BorderSizePixel = 0
			tpFlash2.ZIndex = 18
			tw(tpFlash2, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1})

			-- Teleport balik ke ground
			hrp.CFrame = CFrame.new(0, 5, 0)
			fw(0.5)
			pcall(function() tpFlash2:Destroy() end)
		end)
	end)()

	fw(1.2)

	-- ── FASE 6: Moonlight flash → blackout ────────────────────────
	local flashFrame = Instance.new("Frame", cutsceneGui)
	flashFrame.Size = UDim2.new(1,0,1,0)
	flashFrame.BackgroundColor3 = MOONWHITE
	flashFrame.BorderSizePixel  = 0
	flashFrame.BackgroundTransparency = 1
	flashFrame.ZIndex = 20

	-- Silver → white flash
	local flashSeq = {
		Color3.fromRGB(80, 120, 220),
		Color3.fromRGB(140, 180, 255),
		Color3.fromRGB(210, 230, 255),
		Color3.fromRGB(255, 255, 255)
	}
	for _, fc in ipairs(flashSeq) do
		flashFrame.BackgroundColor3 = fc
		tw(flashFrame, TweenInfo.new(0.07, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.1})
		fw(0.07)
		tw(flashFrame, TweenInfo.new(0.07, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.65})
		fw(0.07)
	end

	-- Final moonblast
	flashFrame.BackgroundColor3 = WHITE
	tw(flashFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})
	fw(0.1)

	animRunning = false
	mainAnim:Disconnect()

	blackFrame.BackgroundTransparency = 0
	tw(flashFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1})

	tw(barTop, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Size = UDim2.new(1,0,0,0)})
	tw(barBot, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Size = UDim2.new(1,0,0,0)})

	fw(0.55)

	-- ── Cleanup ───────────────────────────────────────────────────
	for _, p in ipairs(cutsceneParts) do
		pcall(function() p:Destroy() end)
	end
	cutsceneGui:Destroy()

	camera.CameraType = origCamType
	camera.CFrame     = origCamCF

	if onFinish then
		onFinish()
	end
end

-- ── Jalankan cutscene ──────────────────────────────────────────
local ok, err = pcall(PlayDexCutscene, function()
	print("🌔 Night Moon Cutscene selesai!")
end)

if not ok then
	warn("[DEX Cutscene] Error: " .. tostring(err))
end
