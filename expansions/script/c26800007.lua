--时空岔路·大崎甜花
function c26800007.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c26800007.sprcon)
	e2:SetOperation(c26800007.sprop)
	c:RegisterEffect(e2)
	--name change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26800007,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26800007.nametg)
	e3:SetOperation(c26800007.nameop)
	c:RegisterEffect(e3)
	--declare card
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26800007,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c26800007.dectg)
	e4:SetOperation(c26800007.decop)
	c:RegisterEffect(e4)
end
function c26800007.sprfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsAbleToGraveAsCost()
end
function c26800007.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c26800007.sprfilter2,1,c,tp,c,sc,lv)
end
function c26800007.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c26800007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c26800007.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c26800007.sprfilter1,1,nil,tp,g,c)
end
function c26800007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c26800007.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c26800007.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c26800007.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c26800007.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	getmetatable(e:GetHandler()).announce_filter={ATTRIBUTE_WIND,OPCODE_ISATTRIBUTE,TYPE_NORMAL,OPCODE_ISTYPE,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c26800007.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c26800007.dectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c26800007.decop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	local ct=nil
	if opt==0 then
		ct=TYPE_MONSTER
	elseif opt==1 then
		ct=TYPE_SPELL
	else
		ct=TYPE_TRAP
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetLabel(ct)
	e1:SetCondition(c26800007.actcon)
	e1:SetValue(c26800007.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c26800007.actlimit(e,re,tp)
	local ct=e:GetLabel()
	return re:IsActiveType(ct) and (ct==TYPE_MONSTER or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c26800007.actcon(e)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc:IsType(TYPE_NORMAL) and tc:IsAttribute(ATTRIBUTE_WIND)
end
