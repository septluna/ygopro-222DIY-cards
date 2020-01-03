--最初回忆·贵志凉介
require("expansions/script/c81000000")
function c81019024.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81019024.mfilter,1,1)
	c:EnableReviveLimit()
	Tenka.KoikakeLink(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81019024)
	e1:SetCondition(c81019024.spcon)
	e1:SetTarget(c81019024.sptg)
	e1:SetOperation(c81019024.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c81019024.reptg)
	e2:SetValue(c81019024.repval)
	e2:SetOperation(c81019024.repop)
	c:RegisterEffect(e2)
end
function c81019024.mfilter(c)
	return c:IsAttack(1550) and c:IsDefense(1050)
end
function c81019024.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSequence()>4 and c:GetLinkedGroupCount()==0
end
function c81019024.spfilter(c,e,tp)
	return c:IsAttack(1550) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c81019024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81019024.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81019024.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81019024.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c81019024.repfilter(c,tp)
	return c:IsFaceup() and c:GetBaseAttack()==1550
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c81019024.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c81019024.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81019024.repval(e,c)
	return c81019024.repfilter(c,e:GetHandlerPlayer())
end
function c81019024.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
