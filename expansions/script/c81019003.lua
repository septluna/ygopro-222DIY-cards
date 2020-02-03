--凛冽之冬·椎名咪玉
function c81019003.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c81019003.filter,nil,nil,c81019003.matfilter)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81019003)
	e1:SetCost(c81019003.rscost)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c81019003.reptg)
	e3:SetValue(c81019003.repval)
	e3:SetOperation(c81019003.repop)
	c:RegisterEffect(e3)
end
function c81019003.filter(c,e,tp,chk)
	return c:IsRace(RACE_WARRIOR) and (not chk or c~=e:GetHandler())
end
function c81019003.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c81019003.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c81019003.repfilter(c,tp)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81 and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c81019003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c81019003.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(c81019003.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else return false end
end
function c81019003.repval(e,c)
	return c==e:GetLabelObject()
end
function c81019003.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
