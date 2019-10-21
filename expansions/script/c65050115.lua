--霓色独珠的浪漫
function c65050115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050115+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050115.target)
	e1:SetOperation(c65050115.activate)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050115,2))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65050115.rcon)
	e2:SetOperation(c65050115.rop)
	c:RegisterEffect(e2)
end
function c65050115.relfil(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0 and Duel.IsExistingMatchingCard(c65050115.spfil,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetRank())
end
function c65050115.spfil(c,e,tp,rk)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsLevel(rk)
end
function c65050115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050115.relfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65050115.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65050115.relfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if g and Duel.Release(g,REASON_EFFECT)~=0 then
		local rg=Duel.SelectMatchingCard(tp,c65050115.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp,g:GetFirst():GetRank())
		if rg then
			Duel.SpecialSummon(rg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		end
	end
end

function c65050115.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)
		and re:IsActiveType(TYPE_XYZ) and rc:IsSetCard(0x3da8) and rc:IsRankAbove(8)
		and e:GetHandler():IsAbleToRemoveAsCost()
		and ep==e:GetOwnerPlayer() and ev==1
end
function c65050115.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end