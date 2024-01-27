local proximityprompt = script.Parent.ProximityPrompt
local TP = script.Parent.Parent.TP2.TeleportPart2


proximityprompt.Triggered:Connect(function(plr)
	plr.Character:MoveTo(TP.Position)
end)