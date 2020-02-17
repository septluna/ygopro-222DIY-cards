--猫耳天堂-猫啪来店
local m=4210046
local cm=_G["c"..m]
function cm.initial_effect(c)
	iFunc(c).c("RegisterEffect",iFunc(c)
		.e("SetCategory",CATEGORY_SPECIAL_SUMMON)
		.e("SetType",EFFECT_TYPE_ACTIVATE)
		.e("SetCode",EVENT_FREE_CHAIN)
		.e("SetCountLimit",1,m+EFFECT_COUNT_CODE_OATH)
		.e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.IsExistingMatchingCard(function(c) return c:IsCode(4210010) end,tp,LOCATION_ONFIELD,0,1,nil) end)
		.e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)end)
		.e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
			if not Duel.IsExistingMatchingCard(function(c) return c:IsCode(4210010) end,tp,LOCATION_ONFIELD,0,1,nil) then return end
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ft<=0 then return end
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,ft,ft,nil,e,tp)
			if g:GetCount()>0 then
				local fid=e:GetHandler():GetFieldID()
				local tc=g:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(m,1))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetCode(EFFECT_INDESTRUCTABLE)
					e1:SetValue(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
					e2:SetValue(1)
					local e3=e2:Clone()
					e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
					local e4=e2:Clone()
					e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
					local e5=e2:Clone()
					e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
					tc:RegisterEffect(e1)
					tc:RegisterEffect(e2)
					tc:RegisterEffect(e3)
					tc:RegisterEffect(e4)
					tc:RegisterEffect(e5)
					tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
					tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
					tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
					tc=g:GetNext()
				end
				Duel.SpecialSummonComplete()
			end
		end)
	.Return())
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xa2f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function iFunc(c,x)
	local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
	local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
	local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
	local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
	return func
end