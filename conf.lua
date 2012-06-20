function love.conf(t)
	-- Standard settings
	t.title = 'Another Kind of World'
	t.author = 'Markus Kothe (Daandruff)'
	
	-- Screen
	t.screen.width = 768
    t.screen.height = 480

	-- Other settings
	t.modules.joystick = false
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.physics = false
end
