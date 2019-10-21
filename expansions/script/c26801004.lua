--樱木真乃的卡拉OK
local m=26801004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26801004)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetCode(EFFECT_MAP_OF_HEAVEN)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetFlagEffect(m)>0
	end)
	e2:SetValue(1)
	c:RegisterEffect(e2)]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26801904)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOCATION_EXTRA,0)
		e2:SetCode(EFFECT_MAP_OF_HEAVEN)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--[[local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_TO_HAND)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)]]
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_MATERIAL_CHECK)
		e3:SetLabelObject(e2)
		e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e3:SetTargetRange(0xff,0xff)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetTarget(function(e,c)
			return bit.band(c:GetType(),0x81)==0x81 and c:IsLevelBelow(6)
		end)
		e3:SetValue(function(e,c)
			if c:GetMaterial():IsExists(function(c)
				if not c:IsLocation(LOCATION_EXTRA) then return false end
				local eset={c:IsHasEffect(EFFECT_MAP_OF_HEAVEN)}
				for _,te in ipairs(eset) do
					if te==e:GetLabelObject() then return true end
				end
				return false
			end,1,nil) then
				local ex=Effect.CreateEffect(e:GetHandler())
				ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ex:SetCode(EVENT_SPSUMMON_SUCCESS)
				ex:SetLabelObject(e:GetLabelObject())
				ex:SetReset(RESET_PHASE+PHASE_END)
				ex:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					return eg:IsContains(c)
				end)
				ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					e:GetLabelObject():Reset()
					e:Reset()
				end)
				Duel.RegisterEffect(ex,tp)
				e:Reset()
			end
		end)
		Duel.RegisterEffect(e3,tp)
	end)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c,tp)
	return c:IsLevelBelow(6) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
