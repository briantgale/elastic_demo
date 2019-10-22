class AddPeopleJob < ApplicationJob
  queue_as :default

  def perform
    Person.generate_people(count: 10000)
  end
end
