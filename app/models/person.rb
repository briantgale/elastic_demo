class Person < ApplicationRecord
  require 'ffaker'
  require 'csv'
  
  has_many :profiles, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthdate, presence: true
  validates :email, presence: true

  after_commit :index!, on: [:create, :update]

  accepts_nested_attributes_for :profiles

  def index!
    e = Elastic::Data.new
    data = attributes
    data[:profile] = profiles.try(:first).try(:attributes)
    e.index_data(id: id, index: "people", body: data)
  end

  def self.db_report_rows
    Enumerator.new do |y|
      Person.find_each do |p|
        y << CSV.generate_line(p.slice(:first_name, :last_name, :birthdate, :email).values)
      end
    end
  end

  def self.es_report_rows
    e = Elastic::Data.new
    q = {
      query: {
        bool: {
          must: { match_all: {} },
          filter: []
        }
      },
      size: 10000
    }

    Enumerator.new do |y|
      results = e.search(index: "people", body: q, scroll: "1m")
      results["hits"]["hits"].each {|r| y << CSV.generate_line(r["_source"].slice("first_name", "last_name", "birthdate", "email").values) }
      scroll_id = results["_scroll_id"]

      while(true)
        r = e.scroll(body: { scroll_id: scroll_id, scroll: "1m" })
        break unless r["hits"]["hits"].any?

        r["hits"]["hits"].each {|r| y << CSV.generate_line(r.slice(:first_name, :last_name, :birthdate, :email, :profile).values) }
        scroll_id = r["_scroll_id"]
      end
    end
  end

  def self.generate_people(count: 10)
    count.times do
      Person.create(
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        birthdate: Time.new(rand(1930..2018), rand(1..12), rand(1..28)),
        email: FFaker::Internet.email,
        profiles_attributes: [{
          stuff: FFaker::Lorem.sentence(rand(4..15))
        }]
      )
    end
  end

  def self.create_index!
    e = Elastic::Indices.new
    e.create_index(name: "people")
  end

  def self.index_all!
    Person.find_each(&:index!)
  end
end
