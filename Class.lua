--[[
	This file is part of Gunigine game engine and also part of Gunlock game projects.
	
	http://playgunlock.com
	
	This code (Gunigine's Class Library) is licensed under the MIT Open Source License.
	
	The MIT License (MIT)

	Copyright (c) 2015 Leandro Teixeira da Fonseca - leandro-456@live.com - playgunlock.com

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
	SuperClass.InitTypes = {}
	
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
	function SuperClass.New(...)
		local Object = {}
		
		Object = SetMetatable(Object, SuperClass)
		Object:Init(...)
		
		if SuperClass.PostInit then
			Object:PostInit(...)
		end
		
		return Object
	end
	
	----------------------------------------------------------------------------------
	-- Inicializa os valores de um objeto. (Nota: Esta função não deve ser sobrescrita, utilize Class.PostInit ao invés, ou extend.)
	-- Initializes the values of an object. (Note: This function might not be overrided, use Class.PostInit instead, or Extend.)
	function SuperClass.Init(Object, ...)
		for Key, Value in Pairs(Object.InitValues) do
			if Object.InitTypes[Key] == "vector2" or Object.InitTypes[Key] == "color" then
				Object[Key] = Value:Copy()
			elseif Object.InitTypes[Key] == "table" then
				Object[Key] = {}
			else
				Object[Key] = Value
			end
		end
	end
	
	----------------------------------------------------------------------------------
	-- Cria um GetSet. (Os outros argumentos são utilizados pelas funções abaixo)
	-- Creates a GetSet. (The other arguments are used by the functions below)
	function SuperClass.GetSet(Name, ValueType, Value, GetOnly, SetOnly, Is, IsOnly, Property)
		if not Property then
			if not IsOnly then
				if Is then
					SuperClass["Is" .. Name] = function(c)
						return c[Name]
					end
					
					SuperClass["SetIs" .. Name] = function(c, x)
						c[Name] = x
					end
				else
					if not SetOnly then
						SuperClass["Get" .. Name] = function(c)
							return c[Name]
						end
					end
					
					if not GetOnly then
						SuperClass["Set" .. Name] = function(c, x)
							c[Name] = x
						end
					end
				end
			else
				SuperClass["Is" .. Name] = function(c)
					return c[Name]
				end
			end
		end
		
		if not ValueType then
			SuperClass.InitValues[Name] = Value or 0
			SuperClass.InitTypes[Name] = "number"
		
		elseif ValueType == "number" then
			SuperClass.InitValues[Name] = Value or 0
			SuperClass.InitTypes[Name] = ValueType
			
		elseif ValueType == "string" then
			SuperClass.InitValues[Name] = Value or ""
			SuperClass.InitTypes[Name] = ValueType
			
		elseif ValueType == "boolean" then
			if Value ~= nil then
				SuperClass.InitValues[Name] = Value
			else
				SuperClass.InitValues[Name] = false
			end
			SuperClass.InitTypes[Name] = ValueType
		
		elseif ValueType == "vector2" then
			SuperClass.InitValues[Name] = Value or Vector2.Zero()
			SuperClass.InitTypes[Name] = ValueType
		
		elseif ValueType == "color" then
			SuperClass.InitValues[Name] = Value or Color2.White()
			SuperClass.InitTypes[Name] = ValueType
			
		elseif ValueType == "table" then
			SuperClass.InitValues[Name] = Value or EmptyTable
			SuperClass.InitTypes[Name] = ValueType
		
		elseif ValueType == "function" then
			SuperClass.InitValues[Name] = Value or EmptyFunction
			SuperClass.InitTypes[Name] = ValueType
			
		elseif ValueType == "userdata" then
			SuperClass.InitValues[Name] = Value or EmptyTable
			SuperClass.InitTypes[Name] = ValueType
			
		elseif ValueType == "model" then
			SuperClass.InitValues[Name] = Value or Model.New("default/error")
			SuperClass.InitTypes[Name] = ValueType
			
		elseif ValueType == "nil" then
			SuperClass.InitValues[Name] = nil
			SuperClass.InitTypes[Name] = ValueType
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
		for Key, Value in Pairs(Class2.InitValues) do
			SuperClass.InitValues[Key] = Value
		end
		for Key, Value in Pairs(Class2) do
			SuperClass[Key] = SuperClass[Key] or Value
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
		return SuperClass.InitValues[Name]
	end
	
	----------------------------------------------------------------------------------
	-- Altera o valor inicial de uma propriedade.
	-- Set the initial value of a property.
	-- @param #string
	function SuperClass.SetDefaultValue(Name, Value)
		SuperClass.InitValues[Name] = Value
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
	
	SuperClass.Is(Name, "boolean", true)
	
	return SuperClass
end

return Class