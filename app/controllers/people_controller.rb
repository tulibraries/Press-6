# frozen_string_literal: true

class PeopleController < ApplicationController
  def index
    @people = Person.all.group_by { |t| t.department }
  end
end
