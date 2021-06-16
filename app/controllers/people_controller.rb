# frozen_string_literal: true

class PeopleController < ApplicationController
  def index
    @people = Person.order(:name)
    @departments = @people.group_by(&:department)

    @departments.each do |department, people|
      head =  @people.select { |person| person.department == department && person.head }
      people.delete_if(&:head)
      head.sort_by(&:name).reverse.each do |person|
        people.insert(0,person)
      end
    end
  end
end
