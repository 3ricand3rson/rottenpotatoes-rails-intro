class Movie < ActiveRecord::Base
    
    def self.with_ratings
        %w(G PG PG-13 R)
    end 
end
