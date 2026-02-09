-- Source Code: https://github.com/wyozi-gmod/netdata

local Entity = FindMetaTable("Entity")

if SERVER then
    function Entity:NetDataUpdate()
        net.Start("netdata")
        net.WriteEntity(self)
        net.WriteUInt(self.NetDataHash and tonumber(util.CRC(self:NetDataHash())) or 0, 32)
        self:NetDataWrite()
        net.SendPVS(self:LocalToWorld(self:OBBCenter()))
    end

    util.AddNetworkString("netdata")

    net.Receive("netdata", function(len, cl)
        local ent = net.ReadEntity()
        local prevHash = net.ReadUInt(32)

        if not IsValid(ent) then return end

        local tb = ent:GetTable()

        if not tb.NetDataWrite then return end

        local curHash = tb.NetDataHash and tonumber(util.CRC(ent:NetDataHash())) or 0

        if curHash == 0 or prevHash == 0 or curHash ~= prevHash then
            net.Start("netdata")
            net.WriteEntity(ent)
            net.WriteUInt(curHash, 32)
            ent:NetDataWrite()
            net.Send(cl)
        end
    end)
end

if CLIENT then
    hook.Add("NotifyShouldTransmit", "NetDataRequest", function(e, should)
        if not should then return end

        local tb = e:GetTable()

        if not tb.NetDataRead then return end

        local prevHash = tb._NetDataPrevHash or 0
        net.Start("netdata")
        net.WriteEntity(e)
        net.WriteUInt(prevHash, 32)
        net.SendToServer()

        if cvars.Number("developer") > 0 then
            print("[NetData] Asking for netdata due to PVS for " .. tostring(e) .. " using hash " .. prevHash)
        end
    end)

    hook.Add("NetworkEntityCreated", "NetDataRequest", function(e)
        local sent = scripted_ents.GetStored(e:GetClass())

        if e:GetTable().NetDataRead or (sent and sent.t and sent.t.NetDataRead) then
            net.Start("netdata")
            net.WriteEntity(e)
            net.WriteUInt(0, 32)
            net.SendToServer()

            if cvars.Number("developer") > 0 then
                print("[NetData] Asking for netdata due to NEC for " .. tostring(e))
            end
        end
    end)

    net.Receive("netdata", function(len, cl)
        local ent = net.ReadEntity()
        local hash = net.ReadUInt(32)

        if IsValid(ent) then
            if cvars.Number("developer") > 0 then
                print("[NetData] Received netdata for " .. tostring(ent) .. " with hash " .. hash)
            end

            ent:NetDataRead()
            ent:GetTable()._NetDataPrevHash = hash
        end
    end)
end

if SERVER then
    util.AddNetworkString("entaction")

    net.Receive("entaction", function(len, cl)
        local ent = net.ReadEntity()

        if IsValid(ent) and ent:GetTable().ReceiveNetAction then
            ent:ReceiveNetAction(cl)
        end
    end)
end

if CLIENT then
    function Entity:StartNetAction(unreliable)
        net.Start("entaction", unreliable)
        net.WriteEntity(self)
    end
end
