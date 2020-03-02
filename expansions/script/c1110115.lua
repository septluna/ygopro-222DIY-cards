---庄生梦蝶-
function c1110115.initial_effect(c)
--
	aux.AddCodeList(c,1110196)
--
	c1110115.Fusion_Muxu(c,
		aux.OR(c1110115.FusFilter1,c1110115.FusFilter2),
		c1110115.f(c1110115.FusFilter1,c1110115.FusFilter2),
		2,2,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110115,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCost(c1110115.cost1)
	e1:SetTarget(c1110115.tg1)
	e1:SetOperation(c1110115.op1)
	c:RegisterEffect(e1)
--
end
--
function c1110115.FusFilter1(c)
	return c:IsFusionCode(1110196) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
end
function c1110115.FusFilter2(c)
	return c:IsFusionType(TYPE_EFFECT)
end
--
function c1110115.Fusion_Muxu(c,mf,f,min,max,myon,sub)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c1110115.FusionCondition1(mf,f,min,max,myon,sub))
	e1:SetOperation(c1110115.FusionOperation1(mf,f,min,max,myon,sub))
	c:RegisterEffect(e1)
end
--
function c1110115.MyonCheckFilter(c,ec,myon)
	return myon and c:IsFaceup() and c:IsCanBeFusionMaterial(ec)
end
function c1110115.FusFilterALL(c,fc,mf,sub)
	return c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579) and ((not mf or mf(c,fc,sub)))
end
function c1110115.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function c1110115.FusionCheckALL(g,min,tp,fc,f,chkf,sub)
	if g:IsExists(aux.TuneMagicianCheckX,nil,g,EFFECT_TUNE_MAGICIAN_F) then return false end
	if chkf~=PLAYER_NONE and Duel.GetLocationCountFromEx(chkf,tp,g,fc)<1 then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,g,fc) then return false end
	return #g>=min and (not f or f(g,fc,sub))
end
function c1110115.FusionCondition1(mf,f,min,max,myon,sub)
	return function(e,g,gc,chkfnf)
		if g==nil then return true end
		local c=e:GetHandler()
		local chkf=(chkfnf & 0xff)
		local mg=g:Filter(c1110115.FusFilterALL,nil,e:GetHandler(),mf,sub)
		local tp=e:GetHandlerPlayer()
		local exg=Duel.GetMatchingGroup(c1110115.MyonCheckFilter,tp,0,LOCATION_MZONE,nil,c,myon)
		mg:Merge(exg)
		local sg=Group.CreateGroup()
		if gc then
			if not c1110115.FusFilterALL(gc,fc,mf,sub) then return false end
			sg:AddCard(gc)
		end
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_FMATERIAL)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			if not mg:IsContains(tc) then return false end
			sg:AddCard(tc)
		end
		return c1110115.CheckGroup(mg,c1110115.FusionCheckALL,sg,1,max,min,tp,c,f,chkfnf,sub)
	end
end
function c1110115.SelectGroup(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function c1110115.FusionOperation1(mf,f,min,max,myon,sub)
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
		local c=e:GetHandler()
		local chkf=(chkfnf & 0xff)
		local mg=eg:Filter(c1110115.FusFilterALL,nil,e:GetHandler(),mf,sub)
		local exg=Duel.GetMatchingGroup(c1110115.MyonCheckFilter,tp,0,LOCATION_MZONE,nil,c,myon)
		mg:Merge(exg)
		local sg=Group.CreateGroup()
		if gc then
			sg:AddCard(gc)
		end
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_FMATERIAL)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			sg:AddCard(tc)
		end
		local g=c1110115.SelectGroup(tp,HINTMSG_FMATERIAL,false,mg,c1110115.FusionCheckALL,sg,1,max,min,tp,c,f,chkf,sub)
		Duel.SetFusionMaterial(g)
	end
end
--
function c1110115.f(...)
	local list={...}
	return function(g,fc,sub)
		return g:IsExists(c1110115.cf,1,nil,g,list,1,fc,sub)
	end
end
function c1110115.cf(c,g,list,ct,fc,sub)
	local f=list[ct]
	if not f(c,fc,sub) then return false end
	if ct==#list then return true end
	local res=false
	g:RemoveCard(c)
	if sub and f(c,fc,false) then
		res=g:IsExists(c1110115.cf,1,nil,g,list,ct+1,fc,true)
	else
		res=g:IsExists(c1110115.cf,1,nil,g,list,ct+1,fc,false)
	end
	g:AddCard(c)
	return res
end
--
function c1110115.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c1110115.tfilter1(c,e,tp,fusc,mg)
	return c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end
function c1110115.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	local sumtype=c:GetSummonType()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return bit.band(sumtype,SUMMON_TYPE_FUSION)~=0
			and ct>0 and ct<=Duel.GetMZoneCount(tp)
			and mg:FilterCount(aux.NecroValleyFilter(c1110115.tfilter1),nil,e,tp,c,mg)==ct
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and c:IsReleasable()
	end
	mg:KeepAlive()
	e:SetLabelObject(mg)
	local tc=mg:GetFirst()
	while tc do
		tc:CreateEffectRelation(e)
		tc=mg:GetNext()
	end
	Duel.Release(c,REASON_COST)
end
--
function c1110115.ofilter1(c,e)
	return c:IsRelateToEffect(e)
end
function c1110115.ofilter2(c,tp)
	return c:GetOwner()~=tp
end
function c1110115.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject()
	local ct=mg:GetCount()
	if ct>0 and ct<=Duel.GetMZoneCount(tp)
		and mg:FilterCount(c1110115.ofilter1,nil,e)==mg:GetCount()
		and mg:FilterCount(aux.NecroValleyFilter(c1110115.tfilter1),nil,e,tp,c,mg)==ct
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)>0 then
			local lg=mg:Filter(c1110115.ofilter2,nil,tp)
			if lg:GetCount()<1 then return end
			local lc=lg:GetFirst()
			while lc do
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e3:SetValue(1)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e3,true)
				lc=lg:GetNext()
			end
		end
	end
end
--
