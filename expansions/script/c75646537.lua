--失落终端 末那
function c75646537.initial_effect(c)
	c:SetUniqueOnField(1,1,75646537)
	--link summon
	aux.AddLinkProcedure(c,nil,3)
	c:EnableReviveLimit()
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646537,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c75646537.con)
	e2:SetTarget(c75646537.tg)
	e2:SetOperation(c75646537.op)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c75646537.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--extra material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75646537,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c75646537.linkcon)
	e4:SetOperation(c75646537.linkop)
	e4:SetValue(SUMMON_TYPE_LINK)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_EXTRA,0)
	e5:SetTarget(c75646537.mattg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--linkmaterial
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(75646537)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c75646537.mtg)
	c:RegisterEffect(e6)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(c75646537.etarget)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e9:SetTarget(c75646537.etg)
	e9:SetLabelObject(e7)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetLabelObject(e8)
	c:RegisterEffect(e10)
end
function c75646537.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c~=e:GetHandler()
		and c:IsLinkState() 
end
function c75646537.etg(e,c)
	return c:IsType(TYPE_EFFECT) and c~=e:GetHandler() 
		and not c:IsLinkState()
end
function c75646537.etarget(e,c)
	return c:IsCode(75646537)
end
function c75646537.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	local col=0
	if loc&LOCATION_MZONE~=0 then
		col=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 then
		if seq>4 then return false end
		col=aux.SZoneSequence(seq)
	else
		return false
	end
	if p==1-tp then col=4-col end
	return aux.GetColumn(c,tp)==col and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev)
end
function c75646537.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c75646537.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
		end
	end
end
function c75646537.mtg(e,c)
	local lg=e:GetHandler():GetLinkedGroup()
	return c:IsFaceup() and lg:IsContains(c) 
end
function c75646537.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsHasEffect(75646537,tp) and c:IsLinkType(TYPE_LINK) and c:GetLink()>=2 and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c75646537.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c75646537.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
		and Duel.GetFlagEffect(tp,75646537)==0
end
function c75646537.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c75646537.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
	Duel.RegisterFlagEffect(tp,75646537,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c75646537.mattg(e,c)
	return c:IsSetCard(0x32c2) and c:IsType(TYPE_LINK)
end