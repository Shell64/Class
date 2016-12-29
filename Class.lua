--[[
	This file is part of Gunigine game engine and also part of Gunlock game projects.
	
	http://playgunlock.com
	
	This code (Gunigine's Class Library) is licensed under the MIT Open Source License.
	
	The MIT License (MIT)

	Copyright (c) 2016 Leandro Teixeira da Fonseca - leandro-456@live.com - playgunlock.com

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
]]--

local Class = {}

local Vector2 = Vector2
local Vector3 = Vector3
local Matrix44 = Matrix44
local WhiteColor = {R = 1, G = 1, B = 1, A = 1}

local Type = type or Type
local IteratePairs = ipairs or IteratePairs
local Pairs = pairs or Pairs
local ToString = tostring or ToString
local SetMetatable = setmetatable or SetMetatable

--Padrões | Defaults
local EmptyTable = {}
local EmptyFunction = function() end

----------------------------------------------------------------------------------
-- Cria uma nova classe.
-- Creates a new class.
-- @param #string
-- @return #table
function Class.New(Name)

	local SuperClass = {}
	SuperClass.__index = SuperClass
	
	SuperClass.ClassName = Name
	
	function SuperClass.__type()
		return SuperClass.ClassName
	end
	
	SuperClass.InitValues = {}
	SuperClass.InitValuesByName = {}
	
	----------------------------------------------------------------------------------
	-- Retorna o objeto classe do objeto
	-- Return the class object from an object
	function SuperClass.GetClass(Object)
		return SuperClass
	end
	
	----------------------------------------------------------------------------------
	-- Altera a classe de um objeto
	-- Set the class for an object
	function SuperClass.SetClass(Object, Class)
		SetMetatable(Object, Class)
	end
	
	----------------------------------------------------------------------------------
	-- Cria um novo objeto utilizando a classe.
	-- Create a new object using a following class.
	function SuperClass.New(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
		local Object = {}
		
		Object = SetMetatable(Object, SuperClass)
		
		for Key = 1, #Object.InitValues do
			local Value = Object.InitValues[Key]
			
			if Value[2] == "vector2" or Value[2] == "vector3" then
				Object[Value[1]] = Value[3]:Copy()
			elseif Value[2] == "table" then
				Object[Value[1]] = {}
				
				if Value[3] ~= EmptyTable then
					local Tbl = Object[Value[1]]
					
					for Key2, Value2 in Pairs(Value[3]) do
						if Type(Value2) == "table" then
							Tbl[Key2] = {}
						else
							Tbl[Key2] = Value2
						end
						
						Tbl[Key2] = Value2
					end
				end
			elseif Value[2] == "color" then
				Object[Value[1]] = {Value[3].R, Value[3].G, Value[3].B, Value[3].A}
			else
				Object[Value[1]] = Value[3]
			end
		end
		
		Object:PostInit(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
		
		return Object
	end
	
	----------------------------------------------------------------------------------
	-- Cria um GetSet. (Os outros argumentos são utilizados pelas funções abaixo)
	-- Creates a GetSet. (The other arguments are used by the functions below)
	function SuperClass.GetSet(Name, ValueType, Value, GetOnly, SetOnly, Is, IsOnly, Property)
		if not Property then
			if not IsOnly then
				if Is then
					SuperClass["Is" .. Name] = function(Object)
						return Object[Name]
					end
					
					SuperClass["SetIs" .. Name] = function(Object, x)
						Object[Name] = x
					end
				else
					if not SetOnly then
						SuperClass["Get" .. Name] = function(Object)
							return Object[Name]
						end
					end
					
					if not GetOnly then
						SuperClass["Set" .. Name] = function(Object, x)
							Object[Name] = x
						end
					end
				end
			else
				SuperClass["Is" .. Name] = function(Object)
					return Object[Name]
				end
			end
		end
		
		local InitValue
		
		if not ValueType then
			InitValue =  {Name, "number", Value or 0}
			
		elseif ValueType == "number" then
			InitValue =  {Name, ValueType, Value or 0}
			
		elseif ValueType == "string" then
			InitValue =  {Name, ValueType, Value or ""}
			
		elseif ValueType == "boolean" then
			if Value ~= nil then
				InitValue =  {Name, ValueType, Value}
			else
				InitValue =  {Name, ValueType, false}
			end
		
		elseif ValueType == "vector2" then
			InitValue =  {Name, ValueType, Value or Vector2.Zero()}
			
		elseif ValueType == "vector3" then
			InitValue =  {Name, ValueType, Value or Value3.Zero()}
			
		elseif ValueType == "matrix44" then
			InitValue =  {Name, ValueType, Value or Matrix44.New()}
			
		elseif ValueType == "color" then
			InitValue =  {Name, ValueType, Value or WhiteColor}
			
		elseif ValueType == "table" then
			InitValue =  {Name, ValueType, Value or EmptyTable}
		
		elseif ValueType == "function" then
			InitValue =  {Name, ValueType, Value or EmptyFunction}
			
		elseif ValueType == "userdata" then
			InitValue =  {Name, ValueType, Value or EmptyTable}
			
		elseif ValueType == "model" then
			InitValue =  {Name, ValueType, Value or Model.New("default/error")}
			
		elseif ValueType == "font" then
			InitValue =  {Name, ValueType, Value or Font.NewCached(Font.GetDefaultFontName(), 18, true)}
			
		elseif ValueType == "nil" then
			InitValue =  {Name, ValueType, nil}
		end
		
		if InitValue then
			SuperClass.InitValues[#SuperClass.InitValues + 1] = InitValue
			SuperClass.InitValuesByName[Name] = InitValue
		end
	end
	
	----------------------------------------------------------------------------------
	-- Cria um Get
	-- Creates a Get
	function SuperClass.Get(Name, ValueType, Value)
		SuperClass.GetSet(Name, ValueType, Value, true, false, false, false)
	end
	
	----------------------------------------------------------------------------------
	-- Cria um Set
	-- Creates a Set
	function SuperClass.Set(Name, ValueType, Value)
		SuperClass.GetSet(Name, ValueType, Value, false, true, false, false)
	end
	
	----------------------------------------------------------------------------------
	-- Cria um IsSetIs
	-- Creates a IsSetIs
	function SuperClass.IsSetIs(Name, ValueType, Value)
		SuperClass.GetSet(Name, ValueType, Value, false, false, true, false)
	end
	
	----------------------------------------------------------------------------------
	-- Cria um Is
	-- Creates a Is
	function SuperClass.Is(Name, ValueType, Value)
		SuperClass.GetSet(Name, ValueType, Value, false, false, true, true)
	end
	
	----------------------------------------------------------------------------------
	-- Cria um propriedade GetSet
	-- Creates a GetSet property
	function SuperClass.Property(Name, ValueType, Value)
		SuperClass.GetSet(Name, ValueType, Value, false, false, false, false, true)
	end
	
	----------------------------------------------------------------------------------
	-- Hera as funções e propriedades de uma outra classe. 
	-- Inherits the functions and properties from a different class.
	function SuperClass.Inherit(Class2)
		for Key = 1, #Class2.InitValues do
			local Value = Class2.InitValues[Key]
			local InitValue = {Value[1], Value[2], Value[3]}
			SuperClass.InitValues[#SuperClass.InitValues + 1] = InitValue
			SuperClass.InitValuesByName[Value[1]] = InitValue
		end
		
		for Key, Value in Pairs(Class2) do
			if Type(Key) == "string" and Key:sub(1, 2) ~= "__" then
				SuperClass[Key] = SuperClass[Key] or Value
			end
		end
	end
	
	----------------------------------------------------------------------------------
	-- Retorna o nome da classe
	-- Returns the class name.
	-- @return #string
	function SuperClass.GetClassName()
		return SuperClass.ClassName
	end
	
	----------------------------------------------------------------------------------
	-- Altera o nome da classe
	-- Alters the class name.
	-- @param #string
	function SuperClass.SetClassName(Name)
		SuperClass.ClassName = SuperClass.ClassName or ToString(Name)
	end
	
	----------------------------------------------------------------------------------
	-- Retorna o valor inicial de uma propriedade
	-- Returns the initial value of a property.
	-- @return #string
	function SuperClass.GetDefaultValue(Name)
		return SuperClass.InitValuesByName[Name][3]
	end
	
	----------------------------------------------------------------------------------
	-- Altera o valor inicial de uma propriedade.
	-- Set the initial value of a property.
	-- @param #string
	function SuperClass.SetDefaultValue(Name, Value)
		SuperClass.InitValuesByName[Name][3] = Value
	end
	
	----------------------------------------------------------------------------------
	-- Sobrescreve uma função da classe.
	-- Overwrites a class's function.
	-- @param #string
	-- @param #function
	function SuperClass.OverrideFunction(Name, Func)
		SuperClass[Name] = Func
	end
	
	----------------------------------------------------------------------------------
	-- Extende uma função, essa função é executada após a função antiga e repassa os mesmos argumentos que a primeira recebia. 
	-- Extends a function, this function is ran after the old function and it transfers the same arguments the first received.
	-- @param #string
	-- @param #function
	function SuperClass.ExtendFunction(Name, Func2)
		local Func = SuperClass[Name]
		SuperClass[Name] = function(...)
			Func(...)
			Func2(...)
		end
	end
	
	----------------------------------------------------------------------------------
	-- Extende uma função, essa função é executada antes da função antiga e transfere os mesmo argumentos para ambas.
	-- Extends a function, this function is ran before the old function and transfer the same arguments for both.
	-- @param #string
	-- @param #function
	function SuperClass.ExtendFunctionBefore(Name, Func2)
		local Func = SuperClass[Name]
		SuperClass[Name] = function(...)
			Func2(...)
			Func(...)
		end
	end
	
	function SuperClass.PostInit(Object, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
	
	end
	
	SuperClass.Is(Name, "boolean", true)
	
	return SuperClass
end

return Class
