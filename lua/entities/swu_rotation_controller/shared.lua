ENT.Type        = "anim"
ENT.PrintName   = "[SWU] Rotation Controller"
ENT.Author      = "The Coding Ducks"
ENT.Information = ""
ENT.Category    = "[SWU] Universe"

ENT.Spawnable	= false

ENT.SWU_Interactable = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "CurrentRotation")
end

function ENT:SetupUsedKeys()
    self.SWU_UsedKeys = {
        [KEY_PAD_0] = SWU.Util:InteractableServer(self.AddInput, 0),
        [KEY_PAD_1] = SWU.Util:InteractableServer(self.AddInput, 1),
        [KEY_PAD_2] = SWU.Util:InteractableServer(self.AddInput, 2),
        [KEY_PAD_3] = SWU.Util:InteractableServer(self.AddInput, 3),
        [KEY_PAD_4] = SWU.Util:InteractableServer(self.AddInput, 4),
        [KEY_PAD_5] = SWU.Util:InteractableServer(self.AddInput, 5),
        [KEY_PAD_6] = SWU.Util:InteractableServer(self.AddInput, 6),
        [KEY_PAD_7] = SWU.Util:InteractableServer(self.AddInput, 7),
        [KEY_PAD_8] = SWU.Util:InteractableServer(self.AddInput, 8),
        [KEY_PAD_9] = SWU.Util:InteractableServer(self.AddInput, 9),
        [KEY_PAD_ENTER] = SWU.Util:InteractableServer(self.LockIn),
        [KEY_ENTER] = SWU.Util:InteractableServer(self.LockIn),
        [KEY_DELETE] = SWU.Util:InteractableServer(self.DeleteLastDigit),
        [KEY_BACKSPACE] = SWU.Util:InteractableServer(self.DeleteLastDigit),
        [KEY_PAD_DECIMAL] = SWU.Util:InteractableServer(self.AddDecimalPoint),
        [KEY_PAD_MINUS] = SWU.Util:InteractableServer(self.ToggleNegative),
        [KEY_PAD_PLUS] = SWU.Util:InteractableServer(self.ToggleNegative),
    }
end
