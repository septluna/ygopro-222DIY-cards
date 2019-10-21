--百慕 惊天动地之妹·梅娅
local m=37564432
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SEASERPENT),3,63)
	c:EnableReviveLimit()
	local function g_count(tp)
		return Duel.GetMatchingGroupCount(function(c)
			return c:IsFaceup() and c:IsCode(m)
		end,tp,LOCATION_REMOVED,0,nil)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return g_count(tp)>0
	end)
	e1:SetValue(function(e,c)
		local tp=e:GetHandlerPlayer()
		return g_count(tp)
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return g_count(tp)>0
	end)
	e1:SetValue(function(e,c)
		local tp=e:GetHandlerPlayer()
		return g_count(tp)*500
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(0,0x1c0)
	e2:SetCost(Senya.ForbiddenCost(cm.PrismRemoveExtraCost))
	local function f(c)
		return c:IsFaceup() and c:IsAbleToHand()
	end
	local function append_group(g)
		local exg=Duel.GetMatchingGroup(function(c)
			return f(c) and g:IsExists(Card.IsCode,1,nil,c:GetCode())
		end,0,LOCATION_MZONE,LOCATION_MZONE,g)
		return g+exg
	end
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local l=e:GetLabel()
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if chk==0 then return #g>0 and (l==1 or g_count(tp)>0) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g_count(tp),0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local z=c:GetLinkedZone()
		local g=Duel.GetMatchingGroup(f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local ct=g_count(tp)
		if #g>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			sg=append_group(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			local prism_count=Duel.GetOperatedGroup():FilterCount(Senya.CheckPrism,nil)
			local ft=Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_TOFIELD,z)
			local sct=math.min(prism_count,ft)
			if c:IsRelateToEffect(e) and z>0 and sct>0 then
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then sct=math.min(sct,1) end
				local spg=Duel.GetMatchingGroup(function(c)
					return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
				end,tp,LOCATION_HAND,0,nil)
				if #spg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local cg=spg:Select(tp,0,sct,nil)
					if #cg>0 then
						Duel.BreakEffect()
						Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP,z)
					end
				end
			end
		end
	end)
	c:RegisterEffect(e2)
end
function cm.PrismRemoveExtraCostFilter(c)
	return c:IsCode(m) and c:IsAbleToRemoveAsCost()
end
function cm.PrismRemoveExtraCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.PrismRemoveExtraCostFilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.PrismRemoveExtraCostFilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
