class HomesController < ApplicationController

  def index
    @people_count = Person.count
    @es_count = count_es
  end

  def add_people
    AddPeopleJob.perform_later
    redirect_to root_path
  end

  private

  def count_es
    q = {
      query: {
        bool: {
          must: { match_all: {} },
          filter: []
        }
      }
    }

    e = Elastic::Data.new
    e.count(index: "people", body: q)["count"]
  end

end
