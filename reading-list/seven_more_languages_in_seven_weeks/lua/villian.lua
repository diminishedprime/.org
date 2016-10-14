Villian = {
  health = 100,

  new = function(self, name)
    local obj = {
      name = name,
      health = self.health,
    }

    setmetatable(obj, self)
    self.__index = self

    return obj
  end,

  take_hit = function(self)
    self.health = self.health - 10
  end
}


dietrich = Villian.new(Villian, "Dietrich")
dietrich.take_hit(dietrich)
print(dietrich.health)


SuperVillian = Villian.new(Villian)

function SuperVillian.take_hit(self)

  self.health = self.health - 5
end

toht = SuperVillian.new(SuperVillian, "Toht")
toht.take_hit(toht)
print(toht.health)
