--幻世绘本-降临三页-
function c65020166.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,6)
	c:EnableReviveLimit()
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65020166.con)
	e1:SetCost(c65020166.cost)
	e1:SetTarget(c65020166.target)
	e1:SetOperation(c65020166.activate1)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c65020166.con)
	e4:SetCost(c65020166.cost)
	e4:SetTarget(c65020166.target20)
	e4:SetOperation(c65020166.activate2)
	c:RegisterEffect(e4)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c65020166.imcon)
	e2:SetValue(c65020166.actlimit)
	c:RegisterEffect(e2)
	--books
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c65020166.target2)
	e3:SetOperation(c65020166.activate)
	c:RegisterEffect(e3)
end
function c65020166.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c65020166.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c65020166.filter2(c,e,tp,mc)
	return c:IsCode(65020163) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and ((Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLocation(LOCATION_EXTRA)) or (Duel.GetMZoneCount(tp,mc,tp)>0 and c:IsLocation(LOCATION_GRAVE)))
end
function c65020166.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c65020166.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65020166,0)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local tc=e:GetHandler()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65020166.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end

function c65020166.con(e,tp,eg,ep,ev,re,r,rp)
	local xg=e:GetHandler():GetOverlayGroup()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and xg:IsExists(Card.IsSetCard,1,nil,0xcda8)
end
function c65020166.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65020166.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() 
		and ep~=tp and c:IsAbleToHand()
end
function c65020166.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c65020166.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c65020166.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c65020166.filter20(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetSummonPlayer()~=tp
		and c:IsAbleToHand()
end
function c65020166.target20(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c65020166.filter20,1,nil,tp) end
	local g=eg:Filter(c65020166.filter20,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c65020166.filter30(c,e,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c65020166.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65020166.filter30,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end


function c65020166.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
function c65020166.actlimit(e,re,tp)
	return re:GetHandler():IsOnField()
end