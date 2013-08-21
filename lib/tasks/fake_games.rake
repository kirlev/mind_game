namespace :db do 
	desc "Fill database with fake games"
	task games: :environment do
		
		Game.create(developer: "Nir Levi", name: "Memory puzzle")
		Game.create(developer: "Nir Levi", name: "Find the ball")
		Game.create(developer: "Nir Levi", name: "Sokoban")
		Game.create(developer: "Nir Levi", name: "Win the prize")
	end
end
