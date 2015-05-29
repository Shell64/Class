# GunigineClass
===========

__Gunigine's Class System__ is a simple and powerful OOP Library for Lua. Initially developed for my closed project (Gunigine), is now open!

Quick Usage
===========
```lua
  require("Class")
  
  --Create a new class.
  Human = Class.New("Human") --create a new class called Human
  
  --Create the Gets and Sets
  Human.GetSet("Name", "string", "No name")
  Human.GetSet("Height", "number", 1.75)
  Human.GetSet("Weight", "number", 65)
 
 --Create Is states like, Object:IsAlive()
  Human.Is("Alive", "boolean", true)
  Human.Is("Human", "boolean", true) --this is redundant because Class.New do that already.
  
  --Create a object using Human class
  local Alex = Human.New()
  
  Alex:SetName("Alex")
  Alex:SetHeight(1.8)
  Alex:SetWeight(72)
  
  print("Name: " .. Alex:GetName())
  print("Height: " .. Alex:GetHeight() .. "m")
  print("Weight: " .. Alex:GetWeight() .. "kg")
  
  
  --Create a different class for a pet.
  Pet = Class.New("Pet")
  Pet.Inherit(Human) -- Inherit all init values, functions and stuff from Human class.
  
  --IsSetIs are state like IsAlive but you can still set the value of it like SetIsAlive(false)
  Pet.IsSetIs("Cat", "boolean", false)
  
  local Cat = Pet.New()
  Cat:SetIsCat(true)
  
  print(Cat:IsCat())
  print(Cat:Name())
```

Documentation
===========
Documentation is not avaiable yet.

License
===========
>The MIT License (MIT)
>
>Copyright (c) 2015 Leandro Teixeira da Fonseca - leandro-456@live.com - playgunlock.com
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in
>all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE SOFTWARE.
