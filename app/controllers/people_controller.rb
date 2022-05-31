# frozen_string_literal: true

class PeopleController < ApplicationController
  def index
    @people = Person.where.not(department: "Sales Reps").order(:title)
    @departments = @people.group_by(&:department).sort

    @departments.each do |department, people|
      head = @people.select { |person| person.department == department && person.head }
      people.delete_if(&:head)
      head.sort_by(&:name).reverse.each do |person|
        people.insert(0, person)
      end
    end
  end

  def sales_reps
    @people = Person.where(department: "Sales Reps").group_by(&:region)
  end
end
