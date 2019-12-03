local m=98600008
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,5,5,cm.lcheck)
	c:EnableReviveLimit()
	if not cm.gchk then
		cm.gchk=true
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD)
		ex:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		ex:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ex:SetValue(function(e,c,mg)
			return c:GetOriginalCode()==m
		end)
		ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.RegisterEffect(ex,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(function()
		Duel.Hint(HINT_MUSIC_OGG,0,m*16+3)
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(m*16)
	e1:SetProperty(0x14000)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsType(TYPE_LINK) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local mg=Duel.GetMatchingGroup(function(c)
			return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		end,tp,LOCATION_EXTRA,0,nil)
		local z=c:GetLinkedZone(tp)&0xff
		local ft=Duel.GetLocationCountFromEx(tp,tp,c:GetLinkedGroup())
		if ft<=0 or ft>#mg then return end
		local spg=Group.CreateGroup()
		for i=0,6 do
			if #mg<=0 then break end
			if (z&(0x1<<i))>0 then
				local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
				if not tc and i>4 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,11-i)
				end
				if tc then
					local ag=mg:Filter(function(c)
						return tc:IsCanBeXyzMaterial(c)
					end,nil)
					if #ag>0 and Duel.GetLocationCountFromEx(tp,tp,tc,c,0x1<<i)>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local sc=ag:Select(tp,1,1,nil):GetFirst()
						if sc then
							local mmg=tc:GetOverlayGroup()
							if #mmg~=0 then
								Duel.Overlay(sc,mmg)
							end
							sc:SetMaterial(Group.FromCards(tc))
							Duel.Overlay(sc,Group.FromCards(tc))
							Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP,0x1<<i)
							spg:AddCard(sc)
							mg:RemoveCard(sc)
						end
					end
				elseif Duel.GetLocationCountFromEx(tp,tp,nil,c,0x1<<i)>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=mg:Select(tp,1,1,nil):GetFirst()
					if sc then
						sc:SetMaterial(nil)
						Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP,0x1<<i)
						spg:AddCard(sc)
						mg:RemoveCard(sc)
					end
				end
			end
		end
		if #spg>0 then
			for sc in aux.Next(spg) do
				for code,value in pairs({
					[EFFECT_DISABLE]=1,
					[EFFECT_DISABLE_EFFECT]=1,
					--[EFFECT_UNRELEASABLE_SUM]=1,
					--[EFFECT_UNRELEASABLE_NONSUM]=1,
					[EFFECT_CANNOT_BE_FUSION_MATERIAL]=1,
					[EFFECT_CANNOT_BE_SYNCHRO_MATERIAL]=1,
					[EFFECT_CANNOT_BE_XYZ_MATERIAL]=1,
					[EFFECT_CANNOT_BE_LINK_MATERIAL]=1,
				}) do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(code)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(0x1fe1000)
					e1:SetValue(1)
					sc:RegisterEffect(e1,true)
				end
			end
			Duel.SpecialSummonComplete()
		end
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.SanaeCondition(1))
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(cm.SanaeCondition(2))
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.SanaeCondition(2))
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(aux.AND(cm.SanaeCondition(3),function(e,tp)
		return Duel.GetTurnPlayer()==tp
	end))
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
		local g=e:GetHandler():GetLinkedGroup()
		if chk==0 then return #g>0 and not g:IsExists(aux.NOT(Card.IsReleasable),1,nil) end
		Duel.Release(g,REASON_COST)
	end)
	local function f(c,e,tp,g,z)
		return Duel.GetLocationCountFromEx(tp,tp,g,c,z)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	end
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local l=e:GetLabel()
		local c=e:GetHandler()
		e:SetLabel(0)
		if chk==0 then
			local z=c:GetLinkedZone(tp)&0xff
			if z<=0 then return false end
			local g=Duel.GetMatchingGroup(f,tp,LOCATION_EXTRA,0,nil,e,tp,(l==1 and c:GetLinkedGroup() or nil),z)
			return g:GetClassCount(Card.GetCode)>=5
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local z=c:GetLinkedZone(tp)&0xff
		if z<=0 or not c:IsRelateToEffect(e) then return end
		local g=Duel.GetMatchingGroup(f,tp,LOCATION_EXTRA,0,nil,e,tp,nil,z)
		if g:GetClassCount(Card.GetCode)<5 then return end
		aux.GCheckAdditional=function(g)
			return g:GetClassCount(Card.GetCode)==#g
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.TRUE,false,5,5)
		aux.GCheckAdditional=nil
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local spg=sg:Select(1-tp,1,1,nil)
		Duel.SpecialSummon(spg,0,tp,tp,true,false,POS_FACEUP,z)
	end)
	c:RegisterEffect(e1)
end
function cm.SanaeCondition(ct)
	return function(e)
		return e:GetHandler():GetLinkedGroupCount()>=ct
	end
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST) end
	local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,1,REASON_COST)
	sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
