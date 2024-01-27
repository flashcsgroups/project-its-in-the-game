local proximityprompt = script.Parent.ProximityPrompt
local TP = script.Parent.Parent.TP1.TeleportPart1


proximityprompt.Triggered:Connect(function(plr)
plr.Character:MoveTo(TP.Position)
end)