local m=37564353
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(0x14000+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetLabel()>0 and eg:IsExists(function(c)
			return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and (c:IsReason(REASON_BATTLE) or rp==1-tp)
		end,1,nil)
	end)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tc=eg:Filter(function(c)
			return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and (c:IsReason(REASON_BATTLE) or rp==1-tp) and c:IsAbleToRemoveAsCost()
		end,nil):GetFirst()
		if chk==0 then return tc end
		Duel.Remove(tc,POS_FACEDOWN,REASON_COST)
	end)
	e2:SetTarget(cm.SelfSpsummonTarget)
	e2:SetOperation(cm.SelfSpsummonOperation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetLabelObject(e2)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
		e:GetLabelObject():SetLabel(eg:Filter(function(c)
			return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
		end,nil):Equal(g) and #g==1 and 1 or 0)
		return false
	end)
	e3:SetValue(function(e,c)
		return c:IsLocation(LOCATION_MZONE) and c:IsControler(e:GetHandlerPlayer())
	end)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(Senya.ForbiddenCost())
	local function tf(tc,ty)
		return tc:IsFaceup() and tc:IsType(ty&0x7) and tc:IsCanTurnSet() and not (tc:IsLocation(LOCATION_SZONE) and tc:IsType(TYPE_PENDULUM))
	end
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local l=e:GetLabel()
		local function f(c)
			return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(tf,tp,0,LOCATION_ONFIELD,1,c,c:GetType())
		end
		if chk==0 then return l==1 and Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		local tc=g:GetFirst()
		local ty=tc:GetType()&0x7
		Duel.SendtoGrave(tc,REASON_COST)
		Duel.SetTargetParam(ty)
		local tg=Duel.GetMatchingGroup(tf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),ty)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,tg:GetCount(),0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ty=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local tg=Duel.GetMatchingGroup(tf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),ty)
		local ot={}
		local evg=Group.CreateGroup()
		for tc in aux.Next(tg) do
			local code=tc:GetOriginalCode()
			if tc:IsType(TYPE_MONSTER) then
				if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 then
					table.insert(ot,code)
				end
			else
				tc:CancelToGrave()
				if Duel.ChangePosition(tc,POS_FACEDOWN)>0 then
					table.insert(ot,code)
					evg:AddCard(tc)
				end
			end
		end
		if #evg>0 then
			Duel.RaiseEvent(evg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
		if #ot>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,1)
			e1:SetValue(function(e,re,tp)
				for _,code in ipairs(ot) do
					if code==re:GetHandler():GetOriginalCode() then return true end
				end
				return false
			end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		--Debug.Message(c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousSequence()>4 and 1 or 0)
		return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousSequence()>4
	end)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
		if chk==0 then return #g>0 and #g==g:FilterCount(Card.IsAbleToRemoveAsCost,nil) end
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end)
	local function sf(c,e,tp)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(37564765)
	end
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetMZoneCount(tp)>1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.IsExistingMatchingCard(sf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not (Duel.GetMZoneCount(tp)>1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(sf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and e:GetHandler():IsRelateToEffect(e)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,sf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
		g:AddCard(e:GetHandler())
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end)
	c:RegisterEffect(e2)
	--[[if not cm.gchk then
		cm.gchk=true
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_LEAVE_FIELD_P)
		ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			for p=0,1 do
				if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==1 then
					local g=eg:Filter(function(c)
						return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
					end,nil)
					for tc in aux.Next(g) do
						--Debug.Message(tc:GetControler())
						tc:RegisterFlagEffect(m,0x17e1000,0,1)
					end
				end
			end
		end)
		Duel.RegisterEffect(ex,0)
	end]]
end
function cm.SelfSpsummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return cm.CheckSummonLocation(c,tp,nil)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.SelfSpsummonOperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
		e:GetHandler():CompleteProcedure()
	end
end
