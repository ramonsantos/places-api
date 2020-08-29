# frozen_string_literal: true

namespace :dev do
  desc 'Seed data for development'
  task seed: :environment do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user, email: 'veronica.silva@gmail.com')

    place1 = FactoryBot.create(:place, user: user2, latitude: -8.059273, longitude: -34.899916, name: 'Cinema da Fundação')
    place2 = FactoryBot.create(:place, user: user1, latitude: -8.056750, longitude: -34.908569, name: 'Museu da Abolição')
    FactoryBot.create(:place, user: user1, latitude: -8.125883, longitude: -34.924158, name: 'Aeroporto')
    FactoryBot.create(:place, user: user1, latitude: -8.061394, longitude: -34.871437, name: 'Paço do Frevo')
    FactoryBot.create(:place, user: user2, latitude: -8.063105, longitude: -34.871084, name: 'Marco Zero')
    FactoryBot.create(:place, user: user2, latitude: -8.017787, longitude: -34.949073, name: 'UFRPE')
    FactoryBot.create(:place, user: user1, latitude: -8.059941, longitude: -34.869800, name: 'Cais do Sertão')
    FactoryBot.create(:place, user: user1, latitude: -8.056229, longitude: -34.898971, name: 'Praça do Derby')
    FactoryBot.create(:place, user: user2, latitude: -8.064784, longitude: -34.873704, name: 'Paço Alfândega')
    FactoryBot.create(:place, user: user1, latitude: -8.062196, longitude: -34.881885, name: 'Cinema São Luiz')
    FactoryBot.create(:place, user: user2, latitude: -8.067929, longitude: -34.875807, name: 'Cais de Santa Rita')
    FactoryBot.create(:place, user: user1, latitude: -8.060745, longitude: -34.870795, name: 'Torre Malakoff')
    FactoryBot.create(:place, user: user1, latitude: -8.344925, longitude: -34.943857, name: 'Praia de Calhetas')
    FactoryBot.create(:place, user: user1, latitude: -8.073147, longitude: -34.895348, name: 'Joana Bezerra')
    FactoryBot.create(:place, user: user2, latitude: -8.052402, longitude: -34.886034, name: 'Senac')
    FactoryBot.create(:place, user: user1, latitude: -8.068514, longitude: -34.877620, name: 'Mercado de São José')
    FactoryBot.create(:place, user: user1, latitude: -8.064924, longitude: -34.981612, name: 'TIP')
    FactoryBot.create(:place, user: user2, latitude: -8.037018, longitude: -34.904739, name: 'Parque da Jaqueira')
    FactoryBot.create(:place, user: user1, latitude: -8.051791, longitude: -34.950723, name: 'UFPE')
    FactoryBot.create(:place, user: user1, latitude: -8.024639, longitude: -34.995402, name: 'Estação Camaragibe')
    FactoryBot.create(:place, user: user1, latitude: -8.057165, longitude: -34.881642, name: 'Parque Treze de Maio')

    FactoryBot.create(:review, place: place1, rating: 4, comment: 'Good')
    FactoryBot.create(:review, place: place2)
    FactoryBot.create(:review, place: place1)
  end
end
