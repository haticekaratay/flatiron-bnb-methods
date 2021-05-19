class City < ActiveRecord::Base
    has_many :neighborhoods
    has_many :listings, :through => :neighborhoods
    has_many :reservations, :through => :listings

    def city_openings(start_date, end_date)
      self.listings.each do |listing|
        listing.reservations.collect do |reservation|
          checkin = reservation.checkin.to_s  # was in Date format: Fri, 25 Apr 2014
          checkout = reservation.checkout.to_s

          if is_not_in_range?(checkin, checkout, start_date, end_date)
            listing.delete
          end
        end
      end
    end

    def is_not_in_range?(checkin, checkout, start_date, end_date)
      (checkin < start_date && checkout < start_date) || (checkin > end_date && checkout > end_date) ? true : false
    end

    def self.highest_ratio_res_to_listings
      cities = City.all
      #binding.pry
      ratio_hash = Hash.new
      cities.each do |city|
        city_name = city.name
        ratio = city.reservations.count.to_f / city.listings.count # will return the float instead of a whole number
        ratio_hash[city_name] = ratio
        #binding.pry
      end
      #binding.pry
      city_name = ratio_hash.key(ratio_hash.values.max)
      #binding.pry
      city_object = City.find_by_name(city_name)
    end

    def self.most_res
      city_hash = Hash.new
      City.all.each do |city|
        city_name = city.name 
        city_hash[city_name] = city.reservations.count
      end
      city_name = city_hash.key(city_hash.values.max)
      city_object = City.find_by_name(city_name)
    end
end
