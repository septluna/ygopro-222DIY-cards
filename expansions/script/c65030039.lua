--祸摆线奏者 乌儿
function c65030039.initial_effect(c)
   --control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c65030039.pdop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0)
   --extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65030039,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65030039.sprcon)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_HAND)
	e3:SetTarget(c65030039.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--pandolum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,65030039)
	e4:SetRange(LOCATION_HAND)  
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c65030039.con)
	e4:SetTarget(c65030039.tg)
	e4:SetOperation(c65030039.op)
	c:RegisterEffect(e4)
end
function c65030039.confil(c)
	return c:IsSetCard(0x3da9) and c:IsPreviousLocation(LOCATION_MZONE) and (c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) or c:IsPreviousPosition(POS_FACEUP))
end
function c65030039.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65030039.confil,1,nil)
end
function c65030039.tgfil(c)
	return c:IsAbleToDeck() and Duel.IsPlayerCanDraw(c:GetControler())
end
function c65030039.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030039.tgfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,0,1)
end
function c65030039.op(e,tp,eg,ep,ev,re,r,rp)
	local num=eg:FilterCount(c65030039.confil,nil)
	local g=Duel.SelectMatchingCard(tp,c65030039.tgfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,num,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
			local xg=Duel.GetOperatedGroup()
			if xg:IsExists(Card.IsControler,1,nil,tp) then 
				Duel.ShuffleDeck(tp)
				Duel.Draw(tp,1,REASON_EFFECT) 
			end
			if xg:IsExists(Card.IsControler,1,nil,1-tp) then 
				Duel.ShuffleDeck(1-tp)
				Duel.Draw(1-tp,1,REASON_EFFECT) 
			end
			if Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(65030039,1)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function c65030039.pdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.GetControl(e:GetHandler(),1-tp)
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
end
function c65030039.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65030039.mattg(e,c)
	return c:IsSetCard(0x3da9) 
end