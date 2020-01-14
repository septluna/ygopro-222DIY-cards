--星月转夜 谜香之灵
function c65050230.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2,2)
	--lv up
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c65050230.cost)
	e1:SetTarget(c65050230.tg)
	e1:SetOperation(c65050230.op)
	c:RegisterEffect(e1)
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,65050230)
	e2:SetCondition(c65050230.spcon)
	e2:SetTarget(c65050230.sptg)
	e2:SetOperation(c65050230.spop)
	c:RegisterEffect(e2)
end
function c65050230.gfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_EXTRA and c:IsSetCard(0x5da9) and not c:IsType(TYPE_LINK)
end
function c65050230.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050230.gfilter,1,nil,tp)
end
function c65050230.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65050230.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c65050230.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65050230.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c65050230.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65050230.filter(chkc) and chkc~=e:GetHandler() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050230.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65050230.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c65050230.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end