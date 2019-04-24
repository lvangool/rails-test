class RatRaceController < ApplicationController
  def results
    unless Rat.exists?
      Rat.create(name:'Squeakers', speed: 1 + Random.rand(10))
      Rat.create(name:'Squeak', speed: 1 + Random.rand(10))
      Rat.create(name:'Ratatat', speed: 1 + Random.rand(10))
      Rat.create(name:'Scamper', speed: 1 + Random.rand(10))
      Rat.create(name:'Scritch', speed: 1 + Random.rand(10))
    end
    @rats = Rat.order(speed: :desc)
  end

  def run
    Rat.all.each do |rat|
      rat.speed = 1 + Random.rand(10)
      rat.save!
    end
    redirect_to action: "results"
  end
end
